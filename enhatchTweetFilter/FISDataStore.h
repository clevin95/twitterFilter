//
//  FISDataStore.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISPreferenceVectorField.h"
@class STTwitterAPI;

@interface FISDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *tweetsToShow;
@property (strong, nonatomic) NSMutableArray *dislikedVectors;
@property (strong, nonatomic) NSString *lastID;
@property (strong, nonatomic) FISPreferenceVectorField *negativeVectorField;
@property (strong, nonatomic) NSMutableArray *scoreArray;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (strong, nonatomic) NSArray *friendsArray;

@property (strong, nonatomic) STTwitterAPI *twitterAccount;
@property (nonatomic) BOOL credentialAuthorized;
@property (nonatomic, copy) void (^accountCompletion)(void);

+ (instancetype)sharedDataStore;
- (void) updateTweetsToShow:(void (^)(void))callback;
- (void) addDislikedTweet:(NSString *)tweet;
- (void) updateFriendsToShow:(void (^)(void))callback;
- (void) createTwitterAccount:(void (^)(void))callback;

@end


