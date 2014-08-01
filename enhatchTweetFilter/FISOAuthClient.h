//
//  FISOAuthClient.h
//  enhatchTweetFilter
//
//  Created by Leo Reubelt on 8/1/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISOAuthClient : NSObject

+ (void)getOAuthWithBlock:(void (^)(NSString *oAuthToken, NSString *oAuthSecret, NSError *error))oAuthBlock;

@end
