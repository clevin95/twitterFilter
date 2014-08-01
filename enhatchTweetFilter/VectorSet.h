//
//  VectorSet.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/31/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vector;

@interface VectorSet : NSManagedObject

@property (nonatomic, retain) NSString * tweeter;
@property (nonatomic, retain) NSSet *positiveVectors;
@property (nonatomic, retain) NSSet *negativeVectors;
@end

@interface VectorSet (CoreDataGeneratedAccessors)

- (void)addPositiveVectorsObject:(Vector *)value;
- (void)removePositiveVectorsObject:(Vector *)value;
- (void)addPositiveVectors:(NSSet *)values;
- (void)removePositiveVectors:(NSSet *)values;

- (void)addNegativeVectorsObject:(Vector *)value;
- (void)removeNegativeVectorsObject:(Vector *)value;
- (void)addNegativeVectors:(NSSet *)values;
- (void)removeNegativeVectors:(NSSet *)values;

@end
