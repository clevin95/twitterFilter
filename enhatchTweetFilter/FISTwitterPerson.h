//
//  FISTwitterFriend.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISTwitterPerson : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSMutableArray *negativeVectors;




- (void) getImageForPersonWithBlock:(void (^)(NSError *error))finishedBlock;

@end
