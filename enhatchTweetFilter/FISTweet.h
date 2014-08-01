//
//  FISTweet.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISTwitterPerson.h"

@interface FISTweet : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) FISTwitterPerson *tweeter;
@property (nonatomic) CGFloat score;
@property (nonatomic) BOOL swipedPositive;
@end
