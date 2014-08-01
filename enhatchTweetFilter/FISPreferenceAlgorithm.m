//
//  FISPreferenceAlgorithm.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/31/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISPreferenceAlgorithm.h"
#import "Word.h"
#import "FISDataStore.h"

#define SIMILAR_THRESHOLD 1.45

@implementation FISPreferenceAlgorithm



//If an existing vectore in the set has an angle similar to sentence it is added to that composit vector by vector addition
//If none are close it will be added as a new composit vector
+ (void) addSentence:(NSString *)sentence toVectorSubset:(VectorSet *)vectorSet withPossitive:(BOOL)positive;
{
    FISDataStore *store = [FISDataStore sharedDataStore];
    Vector *sentenceVector = [self convertSentanceToVector:sentence forContext:store.managedObjectContext];
    CGFloat closestScore = 1.57; //(pi/2)
    Vector *closestVector = nil;
    NSArray *vectorsArray = nil;
    if (positive){
        vectorsArray = [vectorSet.positiveVectors allObjects];
    }else {
        vectorsArray = [vectorSet.negativeVectors allObjects];
    }
    
    for (Vector *vector in vectorsArray){
        CGFloat comparisonScore = [self compareVector:sentenceVector withVector:vector];
        if (closestScore > comparisonScore)
        {
            closestScore = comparisonScore;
            closestVector = vector;
        }
    }
    if (closestScore > SIMILAR_THRESHOLD){
        if ([sentenceVector.words count] > 0){
            if (positive){
                [vectorSet addPositiveVectorsObject:sentenceVector];
            }else {
                [vectorSet addNegativeVectorsObject:sentenceVector];
                
            }
        }
    }else {
        closestVector = [self addVector:sentenceVector toCompositeVector:closestVector];
    }
}

+ (CGFloat) compareSentence:(NSString *)sentance withVectorSet:(NSArray *)vectorSet {
    
    FISDataStore *store = [FISDataStore sharedDataStore];
    Vector *sentenceVector = [self convertSentanceToVector:sentance forContext:store.nonSavingContext];
    CGFloat lowestScore = 1.57;
    for (Vector *vector in vectorSet){
        CGFloat compareScore = [self compareVector:sentenceVector withVector:vector];
        if (lowestScore > compareScore){
            lowestScore = compareScore;
        }
    }
    return lowestScore;
}

+ (Vector *) addVector:(Vector *)vectorOne toCompositeVector:(Vector *)compositeVector {
    NSMutableArray *vectorOneWords =[[NSMutableArray alloc] initWithArray:[vectorOne.words allObjects]];
    NSMutableArray *compositeVectorWords = [[NSMutableArray alloc] initWithArray:[compositeVector.words allObjects]];
    for (Word *word in compositeVectorWords)
    {
        NSPredicate *wordPredicate = [NSPredicate predicateWithFormat:@"text == %@", word.text];
        NSArray *foundWords = [vectorOneWords filteredArrayUsingPredicate:wordPredicate];
        if ([foundWords count] > 0){
            Word *wordFound = foundWords[0];
            word.count = @([word.count integerValue] + [wordFound.count integerValue]);
            [vectorOneWords removeObject:wordFound];
        }
    }
    [compositeVectorWords addObjectsFromArray:vectorOneWords];
    compositeVector.words = [NSSet setWithArray:compositeVectorWords];
    return compositeVector;
}

+ (Vector *) convertSentanceToVector:(NSString *)sentence forContext:(NSManagedObjectContext *)context {
    
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "] invertedSet];
    NSString *noSpecialSentence = [[[sentence componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""] lowercaseString];
    NSArray *wordArray = [self findAllNounsInString:noSpecialSentence];
    Vector *sentenceVector = [NSEntityDescription insertNewObjectForEntityForName:@"Vector" inManagedObjectContext:context];
    NSMutableDictionary *wordsDictionary = [[NSMutableDictionary alloc]init];
    for (NSString *word in wordArray) {
        if (wordsDictionary[word]){
            Word *addToWord = wordsDictionary[word];
            addToWord.count = @([addToWord.count integerValue] + 1);
        }else{
            Word *newWordToAdd = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:context];
            newWordToAdd.text = word;
            newWordToAdd.count = @(1);
            wordsDictionary[word] = newWordToAdd;
            [sentenceVector addWordsObject:newWordToAdd];
        }
    }
    return sentenceVector;
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


//returns a value 0 to pi/2, 0 means they are identical pi/2 means they have no words in common
+ (CGFloat) compareVector:(Vector *)vectorOne withVector:(Vector *)vectorTwo
{
    CGFloat magnitudeOne = [self magnitudeOfVector:vectorOne];
    CGFloat magnitudeTwo = [self magnitudeOfVector:vectorTwo];
    CGFloat dotProduct = [self dotProductOfVectorOne:vectorOne withVectorTwo:vectorTwo];
    CGFloat magnitudeDotProductQuotient = dotProduct/(magnitudeOne * magnitudeTwo);
    //Checks just in case there was a slight rounding error
    if (magnitudeDotProductQuotient > 1){
        return 0.000;
    }
    CGFloat theta = acos(magnitudeDotProductQuotient);
    return theta;
}

+ (CGFloat)dotProductOfVectorOne:(Vector *)vectorOne withVectorTwo:(Vector *)vectorTwo {
    CGFloat runningDotProduct = 0;
    for (Word *word in vectorOne.words){
        for (Word *word2 in vectorTwo.words)
        {
            if ([word.text isEqualToString:word2.text])
            {
                runningDotProduct += ([word.count integerValue] * [word2.count integerValue]);
            }
        }
    }
    return runningDotProduct;
}

+ (CGFloat)magnitudeOfVector:(Vector *)vector {
    NSInteger squaredSum = 0;
    for (Word *word in vector.words)
    {
        squaredSum += pow([word.count integerValue], 2);
    }
    return sqrt(squaredSum);
}


@end
