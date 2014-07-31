//
//  checkAlgorithm.m
//  similarityChecker
//
//  Created by Carter Levin on 7/28/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISCompareSentences.h"

@implementation FISCompareSentences

#define SIMILAR_THRESHOLD 1.45

+ (void) compareSentance:(NSString *)sentenceOne withSentance:(NSString *)sentenceTwo
{
    [self compareWordDictionary:[self convertSentanceToVector:sentenceOne] withDictionary:[self convertSentanceToVector:sentenceTwo]];
}

+ (CGFloat) compareSentence:(NSString *)sentance withVectorSet:(NSArray *)vectorSet {
    NSDictionary *sentenceVector = [self convertSentanceToVector:sentance];
    CGFloat lowestScore = 1.57;
    for (NSDictionary *vector in vectorSet){
        CGFloat compareScore = [self compareWordDictionary:sentenceVector withDictionary:vector];
        if (lowestScore > compareScore){
            lowestScore = compareScore;
        }
    }
    return lowestScore;
}

+ (void) addSentence:(NSString *)sentence toVectorSet:(NSMutableArray *)vectorSet
{
    NSDictionary *sentenceVector = [self convertSentanceToVector:sentence];
    CGFloat closestScore = 1.57; //(pi/2)
    NSInteger closestVectorIndex = 0;
    for (NSDictionary *vector in vectorSet){
        CGFloat comparisonScore = [self compareWordDictionary:sentenceVector withDictionary:vector];
        if (closestScore > comparisonScore){
            closestScore = comparisonScore;
            closestVectorIndex = [vectorSet indexOfObject:vector];
        }
    }
    if (closestScore > SIMILAR_THRESHOLD){
        if ([sentenceVector count] > 0){
            [vectorSet addObject:sentenceVector];
        }
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


+ (NSDictionary *) convertSentanceToVector:(NSString *)sentence {
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "] invertedSet] ;
    NSString *noSpecialSentence = [[[sentence componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""] lowercaseString];

    
    NSMutableDictionary *vectorDictionary = [[NSMutableDictionary alloc]init];
    NSArray *wordArray = [self findAllNounsInString:noSpecialSentence];
    
    
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
    
    //Checks just in case there was a slight rounding error
    if (magnitudeDotProductQuotient > 1){
        return 0.000;
    }
    CGFloat theta = acos(magnitudeDotProductQuotient);    
    return theta;
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

+ (NSArray *)findAllNounsInString:(NSString *)string {
    NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes: [NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:options];
    tagger.string = string;
    NSMutableArray *allNowns = [[NSMutableArray alloc]init];
    [tagger enumerateTagsInRange:NSMakeRange(0, [string length]) scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass options:options usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
        
        NSString *token = [string substringWithRange:tokenRange];
        if ([tag isEqualToString:@"Noun"] || [tag isEqualToString:@"PersonalName"] || [tag isEqualToString:@"PlaceName"]){
            [allNowns addObject:token];
        }
        
    }];
    return allNowns;
}


@end
