//
//  checkAlgorithm.m
//  similarityChecker
//
//  Created by Carter Levin on 7/28/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISCompareSentences.h"

@implementation FISCompareSentences

#define SIMILAR_THRESHOLD 1.0

+ (void) compareSentance:(NSString *)sentenceOne withSentance:(NSString *)sentenceTwo
{
    [self compareWordDictionary:[self convertSentanceToVector:sentenceOne] withDictionary:[self convertSentanceToVector:sentenceTwo]];
}

+ (CGFloat) compareSentence:(NSString *)sentance withVectorSet:(NSArray *)vectorSet {
    NSDictionary *sentenceVector = [self convertSentanceToVector:sentance];
    CGFloat lowestScore = 1.57;
    for (NSDictionary *vector in vectorSet){
        CGFloat compareScore = [self compareWordDictionary:sentenceVector withDictionary:vector];
        NSLog(@"%f",compareScore);
        if (lowestScore > compareScore){
            lowestScore = compareScore;
        }
    }
    return lowestScore;
}

+ (void) addSentence:(NSString *)sentence toVectorSet:(NSMutableArray *)vectorSet
{
    
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "] invertedSet] ;
    
    
    NSString *noSpecialSentence = [[[sentence componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""] lowercaseString];
    NSLog(@"%@",vectorSet);
    
    NSDictionary *sentenceVector = [self convertSentanceToVector:noSpecialSentence];
    CGFloat closestScore = 1.57; //(pi/2)
    NSInteger closestVectorIndex = 0;
    for (NSDictionary *vector in vectorSet){
        CGFloat comparisonScore = [self compareWordDictionary:sentenceVector withDictionary:vector];
        NSLog(@"%f", comparisonScore);
        if (closestScore > comparisonScore){
            closestScore = comparisonScore;
            closestVectorIndex = [vectorSet indexOfObject:vector];
        }
    }
    if (closestScore > SIMILAR_THRESHOLD){
        [vectorSet addObject:sentenceVector];
    }else {
        vectorSet[closestVectorIndex] = [self addVector:sentenceVector toCompositeVector:vectorSet[closestVectorIndex]];
    }
    
    
}


+ (NSDictionary *) addVector:(NSDictionary *)vectorOne toCompositeVector:(NSDictionary *)compositeVector {
    
    
    NSMutableDictionary *mutableVectorOne = [[NSMutableDictionary alloc] initWithDictionary:vectorOne];
    NSMutableDictionary *mutableCompositeVector = [[NSMutableDictionary alloc]initWithDictionary:compositeVector];
    for (NSString *compositeKey in compositeVector){
        if (mutableVectorOne[compositeKey]){
            NSInteger newWordCount = [mutableCompositeVector[compositeKey] integerValue] + [mutableVectorOne[compositeKey] integerValue];
            mutableCompositeVector[compositeKey] = @(newWordCount);
            [mutableVectorOne removeObjectForKey:compositeKey];
        }
    }
    
    [mutableCompositeVector addEntriesFromDictionary:mutableVectorOne];
    compositeVector = mutableCompositeVector;
    return compositeVector;
}


+ (NSDictionary *) convertSentanceToVector:(NSString *)sentance {
    NSMutableDictionary *vectorDictionary = [[NSMutableDictionary alloc]init];
    NSArray *wordArray = [sentance componentsSeparatedByString:@" " ];
    
    for (NSString *word in wordArray) {
        if (vectorDictionary[word]){
            vectorDictionary[word] = @([vectorDictionary[word] integerValue] + 1);
        }else {
            vectorDictionary[word] = @(1);
        }
    }
    return vectorDictionary;
}

+ (CGFloat) compareWordDictionary:(NSDictionary *)dictionaryOne withDictionary:(NSDictionary *)dictionaryTwo
{
    CGFloat magnitudeOne = [self magnitudeOfVectorDictionary:dictionaryOne];
    CGFloat magnitudeTwo = [self magnitudeOfVectorDictionary:dictionaryTwo];
    CGFloat dotProduct = [self dotProductOfDictionaryOne:dictionaryOne withDictionary:dictionaryTwo];
    CGFloat magnitudeDotProductQuotient = dotProduct/(magnitudeOne * magnitudeTwo);
    return acos(magnitudeDotProductQuotient);
}



+ (CGFloat)dotProductOfDictionaryOne:(NSDictionary *)dictionaryOne withDictionary:(NSDictionary *)dictionaryTwo {
    CGFloat runningCrossProduct = 0;
    for (NSString *key in dictionaryOne.allKeys){
        if (dictionaryTwo[key]){
            runningCrossProduct += ([dictionaryOne[key] integerValue] * [dictionaryTwo[key] integerValue]);
        }
    }
    return runningCrossProduct;
}

+ (CGFloat)magnitudeOfVectorDictionary:(NSDictionary *)dictionary {
    NSInteger squaredSum = 0;
    for (NSNumber *value in dictionary.allValues){
        squaredSum += pow([value integerValue], 2);
    }
    return sqrt(squaredSum);
}



@end
