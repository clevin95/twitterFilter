//
//  FISTwitterAPIClient.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISTwitterAPIClient : NSObject
+ (void)getFriendsWithBlock:(void (^)(NSArray *friendsArray, NSError *error))tweetCalback;
+ (void)getFeedWithBlockSince:(NSString *)since withBlock:(void (^)(NSArray *tweetArray, NSError *error))tweetCalback;
@end
