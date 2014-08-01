//
//  FISDataStore.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VectorSet.h"
#import "FISTwitterPerson.h"
#import <CoreData/CoreData.h>

@class STTwitterAPI;

@interface FISDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *tweetsToShow;
@property (strong, nonatomic) VectorSet *gloabalVectors;
@property (strong, nonatomic) NSString *lastID;
@property (strong, nonatomic) NSMutableArray *scoreArray;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (strong, nonatomic) NSArray *friendsArray;

@property (strong, nonatomic) STTwitterAPI *twitterAccount;
@property (nonatomic) BOOL credentialAuthorized;
@property (nonatomic, copy) void (^accountCompletion)(void);

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *nonSavingContext;

+ (instancetype)sharedDataStore;
- (void) save;
- (void) updateTweetsToShow:(void (^)(NSError *error))callback;
- (void) addTweet:(NSString *)tweet forVectorSet:(VectorSet *)vectorSet toPositive:(BOOL)positive;
- (void) updateFriendsToShow:(void (^)(NSError *error))callback;
- (void) createTwitterAccount:(void (^)(NSError *error))callback;
- (void) getTweetsForFriend:(FISTwitterPerson *)friend withCompletion:(void (^)(NSError *error))callback;

@end


