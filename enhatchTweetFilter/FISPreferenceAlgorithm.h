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

+ (void) addSentence:(NSString *)sentence toVectorSubset:(VectorSet *)vectorSet withPossitive:(BOOL)positive;

+ (void) removeSentance:(NSString *)sentence fromVectorSet:(VectorSet *)vectorSet withPossitive:(BOOL)positive;

+ (Vector *) convertSentanceToVector:(NSString *)sentence forContext:(NSManagedObjectContext *)context;
@end
