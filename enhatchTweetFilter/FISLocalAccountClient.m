//
//  FISLocalAccountClient.m
//  enhatchTweetFilter
//
//  Created by Leo Reubelt on 8/1/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISLocalAccountClient.h"

@implementation FISLocalAccountClient

+(ACAccount*)localTwitterAccount
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
    if ([twitterAccounts count]>0)
    {
        return twitterAccounts[0];
    }
    else return nil;
}

//+(void)requestLocalAccountAccessWithBlock:(void (^)(STTwitterAPI *aPITwitterAccount,NSError *error))accountBlock
//{
//    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
//    ACAccount *localAccount = 
//    [accountStore requestAccessToAccountsWithType:account.accountType options:nil completion:^(BOOL granted, NSError *error)
//     {
//         
//     }];
//    
//}


@end
