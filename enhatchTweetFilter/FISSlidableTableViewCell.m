//
//  FISSlidableTableViewCell.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISSlidableTableViewCell.h"

@implementation FISSlidableTableViewCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self createViews];
    // Initialization code
}

- (void)createViews
{
    self.isDismissed = NO;
    CGSize scrollContentSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height);
    self.leftRightScroller = [[UIScrollView alloc]initWithFrame:self.frame];
    self.leftRightScroller.contentSize = scrollContentSize;
    //self.leftRightScroller.contentOffset = CGPointMake(self.frame.size.width, 0);
    self.leftRightScroller.layer.backgroundColor = [UIColor redColor].CGColor;
    self.leftRightScroller.pagingEnabled = YES;
    self.leftRightScroller.delegate = self;
    
    
    [self addSubview:self.leftRightScroller];
    
    CGRect contentOffset = CGRectOffset(self.frame, self.frame.size.width, 0);
    self.tweetContentView = [[UIView alloc]initWithFrame:contentOffset];
    self.tweetContentView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.leftRightScroller  addSubview:self.tweetContentView];
    
    self.profileImageView = [[UIImageView alloc] init];
    self.contentField = [[UITextView alloc]initWithFrame:self.frame];
    
    self.leftRightScroller.showsHorizontalScrollIndicator = NO;
    [self.leftRightScroller  addSubview:self.contentField];
    [self.contentView addSubview:self.contentField];
    [self createContentSubviews];
}

- (void)createContentSubviews {
    CGFloat imageWidth = 50;
    CGFloat buffer = 10;
    CGRect nameLabelRect = CGRectMake(imageWidth + buffer * 2, buffer, self.frame.size.width - imageWidth - 50, 20);
    CGRect userNameLabelRect = CGRectMake(nameLabelRect.origin.x, nameLabelRect.origin.y + nameLabelRect.size.height, nameLabelRect.size.width, 10);
    CGRect contentFieldRect = CGRectMake(imageWidth + buffer * 2, userNameLabelRect.origin.y + userNameLabelRect.size.height, self.frame.size.width - imageWidth - 50, self.frame.size.height);
    CGRect profileImageRect = CGRectMake(buffer, buffer, imageWidth, imageWidth);
    
    self.nameLabel = [[UILabel alloc]initWithFrame:nameLabelRect];
    self.nameLabel.text = @"Test Name";
    
    
    self.screenNameLabel = [[UILabel alloc]initWithFrame:userNameLabelRect];
    self.screenNameLabel.font = [UIFont systemFontOfSize:12];
    
    self.contentField = [[UITextView alloc]initWithFrame:contentFieldRect];
    self.contentField.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.contentField.editable = NO;
    
    self.profileImageView = [[UIImageView alloc] initWithFrame:profileImageRect];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.backgroundColor = [UIColor purpleColor].CGColor;
    
    [self.tweetContentView addSubview:self.contentField];
    [self.tweetContentView addSubview:self.nameLabel];
    [self.tweetContentView addSubview:self.profileImageView];
    [self.tweetContentView addSubview:self.screenNameLabel];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat xOffset = scrollView.contentOffset.x;
    if (xOffset < 30 && !self.isDismissed){        
        [self.delegate cellSlidRight:self];
        self.isDismissed = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

