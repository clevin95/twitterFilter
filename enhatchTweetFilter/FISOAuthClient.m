//
//  FISOAuthClient.m
//  enhatchTweetFilter
//
//  Created by Leo Reubelt on 8/1/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISOAuthClient.h"
#import "FISConstants.h"
#import <LVTwitterOAuthClient.h>
#import <Accounts/Accounts.h>

@implementation FISOAuthClient

+ (void)getOAuthWithBlock:(void (^)(NSString *oAuthToken, NSString *oAuthSecret, NSError *error))oAuthBlock
{
 LVTwitterOAuthClient * client = [[LVTwitterOAuthClient alloc] initWithConsumerKey:CLIENT_KEY andConsumerSecret:CLIENT_SECRET];
 __block ACAccount *twitterAccount;
    
 [self getLocalAccountWithBlock:^(ACAccount *twitter, NSError *error)
    {
        if (error)
        {
            oAuthBlock(nil,nil,error);
        }
        else
        {
            twitterAccount = twitter;
            [client requestTokensForAccount:twitterAccount completionBlock:^(NSDictionary *oAuthResponse, NSError *error)
             {
                 if (!error)
                 {
                     NSString *oAuthToken = [oAuthResponse objectForKey: kLVOAuthAccessTokenKey];
                     NSString *oAuthSecret = [oAuthResponse objectForKey: kLVOAuthTokenSecretKey];
                     oAuthBlock(oAuthToken,oAuthSecret,error);
                 }
                 else
                 {
                     NSError *customError = [[NSError alloc]initWithDomain:@"Could Not Verify Account" code:300 userInfo:nil];
                     oAuthBlock(nil,nil,customError);
                 }
             }];
        }
    }];
}

+ (void)getLocalAccountWithBlock:(void (^)(ACAccount*, NSError*))localAccountBlock
{
    __block ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    __block ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
             if ([twitterAccounts count]==0)
             {
                 NSError *customError = [[NSError alloc]initWithDomain:@"Setup Twitter Account In Phone Settings" code:300 userInfo:nil];
                 localAccountBlock(nil,customError);
             }
             else
             {
                 ACAccount *twitterAccount = [twitterAccounts firstObject];
                 localAccountBlock(twitterAccount,nil);
             }
         }
         else
         {
             NSError *customError = [[NSError alloc]initWithDomain:@"Access Denied By User" code:300 userInfo:nil];
             localAccountBlock(nil,customError);
         }
     }];
}

@end
