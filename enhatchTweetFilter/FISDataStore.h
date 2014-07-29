//
//  FISDataStore.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *tweetsToShow;
@property (strong, nonatomic) NSMutableArray *dislikedVectors;
@property (strong, nonatomic) NSString *lastID;

+ (instancetype)sharedDataStore;
- (void) updateTweetsToShow:(void (^)(void))callback;
- (void) addDislikedTweet:(NSString *)tweet;
- (void) startUpdatingStreem:(void (^)(NSString *newTweet))callback;



@end


