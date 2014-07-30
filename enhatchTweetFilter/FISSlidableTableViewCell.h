//
//  FISSlidableTableViewCell.h
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FISSlidableTableViewCell;

@protocol CellSliderDelegate <NSObject>

-(void)cellSlidRight:(FISSlidableTableViewCell *)cell;

@end

@interface FISSlidableTableViewCell : UITableViewCell <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *leftRightScroller;
@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UITextView *contentField;
@property (strong, nonatomic) UIView *tweetContentView;
@property (strong, nonatomic) UILabel *screenNameLabel;
@property (nonatomic) BOOL isDismissed;
@property (weak, nonatomic) id <CellSliderDelegate> delegate;

@end



