//
//  checkAlgorithm.h
//  similarityChecker
//
//  Created by Carter Levin on 7/28/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISCompareSentences : NSObject

+ (CGFloat) compareSentence:(NSString *)sentance withVectorSet:(NSArray *)vectorSet;
+ (void) addSentence:(NSString *)sentence toVectorSet:(NSMutableArray *)vectorSet;
+ (void) compareSentance:(NSString *)sentenceOne withSentance:(NSString *)setanceTwo;
@end
