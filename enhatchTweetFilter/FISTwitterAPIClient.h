//
//  FISTwitterAPIClient.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISTwitterAPIClient : NSObject
+ (void)getFeedWithBlockSince:(NSString *)since withBlock:(void (^)(NSMutableArray *tweetArray, NSError *error))tweetCalback;
@end
