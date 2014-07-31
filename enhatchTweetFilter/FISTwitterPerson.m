//
//  FISTwitterFriend.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISTwitterPerson.h"
#import <AFNetworking/AFNetworking.h>

@implementation FISTwitterPerson


-(NSMutableArray *)negativeVectors{
    if (!_negativeVectors){
        _negativeVectors = [[NSMutableArray alloc]init];
    }
    return _negativeVectors;
}



-(void)getImageForPersonWithBlock:(void (^)(NSError *))finishedBlock {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.profileImageURL]];
    AFHTTPRequestOperation *imageDownload = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    imageDownload.responseSerializer = [AFImageResponseSerializer serializer];
    
    NSOperationQueue *imageDownLoadQueue = [[NSOperationQueue alloc]init];
    [imageDownload setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.profileImage = responseObject;
            finishedBlock(nil);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        finishedBlock(error);
    }];
    
    [imageDownLoadQueue addOperation:imageDownload];
}



@end
