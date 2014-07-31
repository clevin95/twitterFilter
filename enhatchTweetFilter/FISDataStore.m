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

    
    [FISTwitterAPIClient getFeedWithBlockForAccount:self.twitterAccount Since:self.lastID withBlock:^(NSArray *tweetArray, NSError *error) {
        if ([tweetArray count] > 0){
            self.lastID = tweetArray[0][@"id_str"];
        }
        weakSelf.tweetsToShow = [self convertRawTweetsToObjects:tweetArray];
        callback();
    }];
}


- (void) updateFriendsToShow:(void (^)(void))callback {
    __weak typeof(self) weakSelf = self;
    [FISTwitterAPIClient getFriendsForAccount:self.twitterAccount WithBlock:^(NSArray *friendsArray, NSError *error) {
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

- (NSArray *) convertRawFriendsToObjects:(NSArray *)rawFriends {
    NSMutableArray *friendsTempArray = [[NSMutableArray alloc]init];
    for (NSDictionary *friend in rawFriends){
        FISTwitterPerson *newFriend = [[FISTwitterPerson alloc]init];
        newFriend.name = friend[@"name"];
        newFriend.userID = friend[@"id_str"];
        newFriend.screenName = friend[@"screen_name"];
        newFriend.profileImageURL = friend[@"profile_image_url"];
        [friendsTempArray addObject:newFriend];
    }
    return friendsTempArray;
}

- (NSMutableArray *) convertRawTweetsToObjects:(NSArray *)rawTweets {
    NSMutableArray *tweetsArray = [[NSMutableArray alloc]init];
    for (NSDictionary *tweetDictionary in [rawTweets reverseObjectEnumerator])
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
        [tweetsArray  insertObject:loadedTweet atIndex:0];
    }
    return tweetsArray;
}

- (void) createTwitterAccount:(void (^)(void))callback
{
    [FISTwitterAPIClient createTwitterAccountWithTwitterAccount:self.twitterAccount CompletionBlock:^(STTwitterAPI *aPITwitterAccount, NSError *error)
     {
         if (!error)
         {
             self.credentialAuthorized = YES;
             
             self.twitterAccount = aPITwitterAccount;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedCreatingUser" object:nil];
             callback();
         }
         else
         {
             NSLog(@"Error - %@",error.localizedDescription);
         }
     }];
}


- (void) getTweetsForFriend:(FISTwitterPerson *)friend withCompletion:(void (^)(void))callback {
    [FISTwitterAPIClient getTweetsWithAccount:self.twitterAccount forUser:friend withBlock:^(NSArray *tweetArray, NSError *error) {
        NSMutableArray *tweetsByFriend = [self convertRawTweetsToObjects:tweetArray];
        friend.tweets = tweetsByFriend;
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
