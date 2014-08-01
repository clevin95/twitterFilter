//
//  FISTwitterAPIClient.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISTwitterAPIClient.h"


@implementation FISTwitterAPIClient


+ (void)getOAuthWithBlock:(void (^)(NSString *oAuthToken, NSString *oAuthSecret, NSError *error))oAuthBlock
{
    
    LVTwitterOAuthClient * client = [[LVTwitterOAuthClient alloc] initWithConsumerKey:@"EeaSWvnrfBW18u06DPi4Fmhgq" andConsumerSecret:@"arVyycwMQ9v5vsCNU8fJST5qR2r1B7yfGCVjWXWjj8vkoX4JWb"];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
    if ([twitterAccounts count]>0)
    {
        
    [accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             ACAccount *twitterAccount = [twitterAccounts firstObject];
             
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
         else
         {
             NSError *customError = [[NSError alloc]initWithDomain:@"Access Denied By User" code:300 userInfo:nil];
             oAuthBlock(nil,nil,customError);
         }
     }];
    }
}

+ (void)createTwitterAccountWithTwitterAccount:(STTwitterAPI*)twitterAPI CompletionBlock:(void (^)(STTwitterAPI *aPITwitterAccount,NSError *error))accountBlock
{
    __block STTwitterAPI *twitterAPIBlock = twitterAPI;
    
    [self getOAuthWithBlock:^(NSString *oAuthToken, NSString *oAuthSecret, NSError *error) {
        if (error)
        {
            accountBlock(nil,error);
        }
        else
        {
            twitterAPIBlock = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"EeaSWvnrfBW18u06DPi4Fmhgq"
                                                            consumerSecret:@"arVyycwMQ9v5vsCNU8fJST5qR2r1B7yfGCVjWXWjj8vkoX4JWb"
                                                                oauthToken:oAuthToken oauthTokenSecret:oAuthSecret];
            
            [twitterAPIBlock verifyCredentialsWithSuccessBlock:^(NSString *bearerToken)
             {
                 twitterAPIBlock.userName = bearerToken;
                 accountBlock(twitterAPIBlock,nil);
             } errorBlock:^(NSError *error)
             {
                 NSError *customError = [[NSError alloc]initWithDomain:@"Could Not Verify Credentials" code:300 userInfo:nil];
                 accountBlock(nil,customError);
             }];
        }
    }];
}

+ (void)getFeedWithBlockForAccount:(STTwitterAPI*)twitterAccount Since:(NSString *)since withBlock:(void (^)(NSArray *tweetArray, NSError *error))tweetCalback {
    
    [twitterAccount getHomeTimelineSinceID:since
                                     count:20
                              successBlock:^(NSArray *statuses)
     {
         tweetCalback(statuses, nil);
     }
                                errorBlock:^(NSError *error)
     {
         NSError *customError = [[NSError alloc]initWithDomain:@"Error Retreiving Data" code:400 userInfo:nil];
         tweetCalback(nil, customError);
     }];
}



+ (void)getFriendsForAccount:(STTwitterAPI*)twitterAccount WithBlock:(void (^)(NSArray *friendsArray, NSError *error))friendsCalback {
    
    [twitterAccount getFriendsForScreenName:twitterAccount.userName
                               successBlock:^(NSArray *friends)
     {
         friendsCalback(friends, nil);
     }
                                 errorBlock:^(NSError *error)
     {
         NSError *customError = [[NSError alloc]initWithDomain:@"Error Retreiving Friends" code:400 userInfo:nil];
         friendsCalback(nil, customError);
     }];
}

+ (void)getTweetsWithAccount:(STTwitterAPI *)twitterAccount forUser:(FISTwitterPerson *)user withBlock:(void (^)(NSArray *tweetArray, NSError *error))tweetsCallback{
    [twitterAccount getUserTimelineWithScreenName:user.screenName count:50 successBlock:^(NSArray *statuses) {
        tweetsCallback(statuses, nil);
    } errorBlock:^(NSError *error) {
        NSError *customError = [[NSError alloc]initWithDomain:@"Error Retreiving Data" code:400 userInfo:nil];
        tweetsCallback(nil, customError);
    }];
}


@end
