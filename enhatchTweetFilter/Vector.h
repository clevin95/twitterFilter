//
//  Vector.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/31/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

@interface Vector : NSManagedObject

@property (nonatomic, retain) NSString * tweeter;
@property (nonatomic, retain) NSString * sign;
@property (nonatomic, retain) NSSet *words;
@end

@interface Vector (CoreDataGeneratedAccessors)

- (void)addWordsObject:(Word *)value;
- (void)removeWordsObject:(Word *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

@end
