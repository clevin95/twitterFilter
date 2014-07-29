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

@implementation FISDataStore


+ (instancetype)sharedDataStore {
    static FISDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISDataStore alloc] init];
    });
    return _sharedDataStore;
}

-(NSMutableArray *)dislikedVectors{
    if (!_dislikedVectors){
        _dislikedVectors = [[NSMutableArray alloc]init];
    }
    return _dislikedVectors;
}


-(NSMutableArray *)tweetsToShow{
    if (!_tweetsToShow){
        _tweetsToShow = [[NSMutableArray alloc] init];
    }
    return _tweetsToShow;
}

- (void) updateTweetsToShow:(void (^)(void))callback {
    __weak typeof(self) weakSelf = self;

    [FISTwitterAPIClient getFeedWithBlockSince:self.lastID withBlock:^(NSMutableArray *tweetArray, NSError *error) {
        
        if ([tweetArray count] > 0){
            self.lastID = tweetArray[0][@"id_str"];
        }
        
        
        for (NSDictionary *statusDictionary in tweetArray)
        {
            NSString *firstText = [NSString stringWithFormat:@"%@",statusDictionary[@"text"]];
            [weakSelf.tweetsToShow  insertObject:firstText atIndex:0];
        }
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
    
}


         
         

@end
