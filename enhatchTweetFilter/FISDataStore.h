//
//  FISDataStore.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISPreferenceVectorField.h"

@interface FISDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *tweetsToShow;
@property (strong, nonatomic) NSMutableArray *dislikedVectors;
@property (strong, nonatomic) NSString *lastID;
@property (strong, nonatomic) FISPreferenceVectorField *negativeVectorField;
@property (strong, nonatomic) NSMutableArray *scoreArray;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (strong, nonatomic) NSArray *friendsArray;

+ (instancetype)sharedDataStore;
- (void) updateTweetsToShow:(void (^)(void))callback;
- (void) addDislikedTweet:(NSString *)tweet;
- (void) updateFriendsToShow:(void (^)(void))callback;

@end


