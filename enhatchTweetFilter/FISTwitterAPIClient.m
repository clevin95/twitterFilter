//
//  FISTwitterAPIClient.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISTwitterAPIClient.h"
#import "FISConstants.h"
#import "FISOAuthClient.h"

@implementation FISTwitterAPIClient

+ (void)createTwitterAccountWithTwitterAccount:(STTwitterAPI*)twitterAPI CompletionBlock:(void (^)(STTwitterAPI *aPITwitterAccount,NSError *error))accountBlock
{
    __block STTwitterAPI *twitterAPIBlock = twitterAPI;
    
    [FISOAuthClient getOAuthWithBlock:^(NSString *oAuthToken, NSString *oAuthSecret, NSError *error) {
        if (error)
        {
            accountBlock(nil,error);
        }
        else
        {
            twitterAPIBlock = [STTwitterAPI twitterAPIWithOAuthConsumerKey:CLIENT_KEY
                                                            consumerSecret:CLIENT_SECRET
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




+ (void)getFeedWithBlockForAccount:(STTwitterAPI*)twitterAccount Since:(NSString *)since withBlock:(void (^)(NSArray *tweetArray, NSError *error))tweetCalback
{    
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
