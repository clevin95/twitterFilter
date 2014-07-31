//
//  FISPreferenceAlgorithm.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/31/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"

@interface FISPreferenceAlgorithm : NSObject

+ (CGFloat) compareSentence:(NSString *)sentance withVectorSet:(NSArray *)vectorSet;

+ (Vector *) convertSentanceToVector:(NSString *)sentence;

+ (Vector *) addVector:(Vector *)vectorOne toCompositeVector:(Vector *)compositeVector;

+ (void) addSentence:(NSString *)sentence toVectorSubset:(NSMutableArray *)vectorSet;
@end
