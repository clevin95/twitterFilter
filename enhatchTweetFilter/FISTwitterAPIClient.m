//
//  FISTwitterAPIClient.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISTwitterAPIClient.h"
#import <STTwitter.h>
#import <LVTwitterOAuthClient.h>
#import <Accounts/Accounts.h>

@implementation FISTwitterAPIClient


+ (void)getFeedWithBlockSince:(NSString *)since withBlock:(void (^)(NSMutableArray *tweetArray, NSError *error))tweetCalback {
    __block STTwitterAPI *twitter;
    LVTwitterOAuthClient * client = [[LVTwitterOAuthClient alloc] initWithConsumerKey:@"EeaSWvnrfBW18u06DPi4Fmhgq" andConsumerSecret:@"arVyycwMQ9v5vsCNU8fJST5qR2r1B7yfGCVjWXWjj8vkoX4JWb"];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
    //ACAccount *twitterAccount = [twitterAccounts firstObject];
    
    [accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             ACAccount *twitterAccount = [twitterAccounts firstObject];
             
             [client requestTokensForAccount:twitterAccount completionBlock:^(NSDictionary *oAuthResponse, NSError *error) {
                 NSString *oAuthToken = [oAuthResponse objectForKey: kLVOAuthAccessTokenKey];
                 NSString *oAuthSecret = [oAuthResponse objectForKey: kLVOAuthTokenSecretKey];
                 
                 twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"EeaSWvnrfBW18u06DPi4Fmhgq"
                                                         consumerSecret:@"arVyycwMQ9v5vsCNU8fJST5qR2r1B7yfGCVjWXWjj8vkoX4JWb"
                                                             oauthToken:oAuthToken oauthTokenSecret:oAuthSecret];
                 
                 [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken)
                  {
                      
                      [twitter getHomeTimelineSinceID:since count:20 successBlock:^(NSArray *statuses) {
                          
                          tweetCalback(statuses, nil);
                      } errorBlock:^(NSError *error) {
                          NSLog(@"Error");
                      }];
                  } errorBlock:^(NSError *error)
                  {
                      NSLog(@"ERROR verifying credentials: %@",error.localizedDescription);
                  }];
                 
                 
             }];
         }
     }];
    
}



@end
