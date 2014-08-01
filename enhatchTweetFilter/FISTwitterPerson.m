//
//  FISTwitterFriend.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISTwitterPerson.h"
#import <AFNetworking/AFNetworking.h>
#import "FISDataStore.h"

@implementation FISTwitterPerson


-(NSMutableArray *)negativeVectors{
    if (!_negativeVectors){
        _negativeVectors = [[NSMutableArray alloc]init];
    }
    return _negativeVectors;
}



-(VectorSet *)personalVectors{
    
    
    FISDataStore *store = [FISDataStore sharedDataStore];
    if (!_personalVectors){
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"VectorSet"];
        NSSortDescriptor *tweeterSort = [NSSortDescriptor sortDescriptorWithKey:@"tweeter" ascending:YES];
        fetch.sortDescriptors = @[tweeterSort];
        fetch.predicate = [NSPredicate predicateWithFormat:@"tweeter == %@", self.name];
        NSArray *personalVectorsArray = [store.managedObjectContext executeFetchRequest:fetch error:nil];
        if ([personalVectorsArray count] > 0){
            _personalVectors = personalVectorsArray[0];
        }else {
            _personalVectors = [NSEntityDescription insertNewObjectForEntityForName:@"VectorSet" inManagedObjectContext:store.managedObjectContext];
            _personalVectors.tweeter = self.name;
        }
    }
    return _personalVectors;
}



-(void)getImageForPersonWithBlock:(void (^)(NSError *))finishedBlock
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.profileImageURL]];
    AFHTTPRequestOperation *imageDownload = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    imageDownload.responseSerializer = [AFImageResponseSerializer serializer];
    
    NSOperationQueue *imageDownLoadQueue = [[NSOperationQueue alloc]init];
    [imageDownload setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            self.profileImage = responseObject;
            finishedBlock(nil);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            UIImage *defaultImage = [UIImage imageNamed:@"default_profile_5_bigger"];
            self.profileImage = defaultImage;
            finishedBlock(error);
        }];
    
    [imageDownLoadQueue addOperation:imageDownload];
}



@end
