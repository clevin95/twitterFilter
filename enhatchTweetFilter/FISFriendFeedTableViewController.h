//
//  FISFriendFeedTableViewController.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISTwitterPerson.h"

@interface FISFriendFeedTableViewController : UITableViewController

@property (strong, nonatomic) FISTwitterPerson *currentFriend;

@end
