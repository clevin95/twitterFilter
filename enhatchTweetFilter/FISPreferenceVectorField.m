//
//  FISPreferenceVector.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISPreferenceVectorField.h"

@implementation FISPreferenceVectorField

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.vectors = [decoder decodeObjectForKey:@"vectors"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.vectors forKey:@"vectors"];
}

@end
