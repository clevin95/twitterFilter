//
//  FISTwitterAPIClient.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISTwitterPerson.h"
#import <Foundation/Foundation.h>
#import <STTwitter.h>
#import <LVTwitterOAuthClient.h>
#import <Accounts/Accounts.h>

@interface FISTwitterAPIClient : NSObject

+ (void)createTwitterAccountWithTwitterAccount:(STTwitterAPI*)twitterAPI CompletionBlock:(void (^)(STTwitterAPI *aPITwitterAccount,NSError *error))accountBlock;
+ (void)getFeedWithBlockForAccount:(STTwitterAPI*)twitterAccount Since:(NSString *)since withBlock:(void (^)(NSArray *tweetArray, NSError *error))tweetCalback;
+ (void)getFriendsForAccount:(STTwitterAPI*)twitterAccount WithBlock:(void (^)(NSArray *friendsArray, NSError *error))friendsCalback;
+ (void)getTweetsWithAccount:(STTwitterAPI*)twitterAccount forUser:(FISTwitterPerson *)user;
+ (void)getTweetsWithAccount:(STTwitterAPI *)twitterAccount forUser:(FISTwitterPerson *)user withBlock:(void (^)(NSArray *tweetArray, NSError *error))tweetsCallback;

@end
