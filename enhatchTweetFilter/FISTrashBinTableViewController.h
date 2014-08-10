//
//  FISTrashBinTableViewController.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 8/1/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VectorSet.h"
@interface FISTrashBinTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *trashItems;
@property (strong, nonatomic) VectorSet *vectorSet;

@end
