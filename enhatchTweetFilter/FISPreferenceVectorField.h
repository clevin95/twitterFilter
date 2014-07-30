//
//  FISPreferenceVector.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISPreferenceVectorField : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray *vectors;
@property (getter = isAvailable) BOOL available;

@end
