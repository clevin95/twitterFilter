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
#import "FISTwitterFriend.h"

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
        for (NSDictionary *statusDictionary in [tweetArray reverseObjectEnumerator])
        {
            NSString *firstText = [NSString stringWithFormat:@"%@",statusDictionary[@"text"]];
            CGFloat textScore = [FISCompareSentences compareSentence:firstText withVectorSet:self.dislikedVectors];
            if (textScore < 1){
                [self.filteredArray addObject:firstText];
            }
            [self.scoreArray insertObject:[NSString stringWithFormat:@"%f",textScore] atIndex:0];
            [weakSelf.tweetsToShow  insertObject:firstText atIndex:0];
        }
        callback();
    }];
}


- (void) updateFriendsToShow:(void (^)(void))callback {
    __weak typeof(self) weakSelf = self;
    [FISTwitterAPIClient getFriendsWithBlock:^(NSArray *friendsArray, NSError *error) {
        NSMutableArray *friendsTempArray = [[NSMutableArray alloc]init];
        for (NSDictionary *friend in friendsArray){
            FISTwitterFriend *newFriend = [[FISTwitterFriend alloc]init];
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
