//
//  FISDataStore.m
//
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISDataStore.h"
#import "FISTwitterAPIClient.h"
#import "FISCompareSentences.h"
#import "FISTwitterPerson.h"
#import "FISTweet.h"

@implementation FISDataStore


+ (instancetype)sharedDataStore {
    static FISDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISDataStore alloc] init];
    });
    return _sharedDataStore;
}

-(NSMutableArray *)scoreArray{
    if (!_scoreArray){
        _scoreArray = [[NSMutableArray alloc]init];
    }
    return _scoreArray;
}

-(NSMutableArray *)dislikedVectors{
    if (!_dislikedVectors){
        _dislikedVectors = [[NSMutableArray alloc]init];
    }
    return _dislikedVectors;
}

-(FISPreferenceVectorField *)negativeVectorField{
    if (!_negativeVectorField){
        _negativeVectorField = [[FISPreferenceVectorField alloc]init];
    }
    return _negativeVectorField;
}


-(NSMutableArray *)tweetsToShow{
    if (!_tweetsToShow){
        _tweetsToShow = [[NSMutableArray alloc] init];
    }
    return _tweetsToShow;
}

- (void) updateTweetsToShow:(void (^)(void))callback {
    __weak typeof(self) weakSelf = self;

    
    
    [FISTwitterAPIClient getFeedWithBlockSince:self.lastID withBlock:^(NSArray *tweetArray, NSError *error) {
        
        if ([tweetArray count] > 0){
            self.lastID = tweetArray[0][@"id_str"];
        }
        for (NSDictionary *tweetDictionary in [tweetArray reverseObjectEnumerator])
        {
            FISTwitterPerson *tweeter = [[FISTwitterPerson alloc]init];
            FISTweet *loadedTweet = [[FISTweet alloc]init];
            tweeter.name = tweetDictionary[@"user"][@"name"];
            tweeter.screenName = tweetDictionary[@"user"][@"screen_name"];
            tweeter.profileImageURL = tweetDictionary[@"user"][@"profile_image_url"];
            
            NSString *tweetText = [NSString stringWithFormat:@"%@",tweetDictionary[@"text"]];
            CGFloat textScore = [FISCompareSentences compareSentence:tweetText withVectorSet:self.dislikedVectors];
            if (textScore < 1){
                [self.filteredArray addObject:tweetText];
            }
            loadedTweet.tweeter = tweeter;
            loadedTweet.content = tweetText;
            [self.scoreArray insertObject:[NSString stringWithFormat:@"%f",textScore] atIndex:0];
            [weakSelf.tweetsToShow  insertObject:loadedTweet atIndex:0];
        }
        callback();
    }];
}


- (void) updateFriendsToShow:(void (^)(void))callback {
    __weak typeof(self) weakSelf = self;
    [FISTwitterAPIClient getFriendsWithBlock:^(NSArray *friendsArray, NSError *error) {
        NSMutableArray *friendsTempArray = [[NSMutableArray alloc]init];
        for (NSDictionary *friend in friendsArray){
            FISTwitterPerson *newFriend = [[FISTwitterPerson alloc]init];
            newFriend.name = friend[@"name"];
            newFriend.userID = friend[@"id_str"];
            newFriend.screenName = friend[@"screen_name"];
            newFriend.profileImageURL = friend[@"profile_image_url"];
            [friendsTempArray addObject:newFriend];
        }
        weakSelf.friendsArray = friendsTempArray;
        callback();
    }];
}




- (void) filterTweetArray:(NSArray *)tweetArray {
    for (NSString *tweet in tweetArray){
        [FISCompareSentences compareSentence:tweet withVectorSet:self.dislikedVectors];
    }
}


- (void) addDislikedTweet:(NSString *)tweet  {
    
    
    [FISCompareSentences addSentence:tweet toVectorSet:self.dislikedVectors];
    
    NSLog(@"%@", self.dislikedVectors);
    self.negativeVectorField.vectors = self.dislikedVectors;
}

@end
