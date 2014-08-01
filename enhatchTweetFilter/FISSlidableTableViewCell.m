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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect scrollerFrame = CGRectMake(0, 10, self.frame.size.width, self.frame.size.height * 0.90);
    CGSize scrollContentSize = CGSizeMake(self.frame.size.width * 3, scrollerFrame.size.height);
    self.leftRightScroller = [[UIScrollView alloc]initWithFrame:scrollerFrame];
    self.leftRightScroller.contentSize = scrollContentSize;
    
    self.leftRightScroller.layer.backgroundColor = [UIColor redColor].CGColor;
    self.leftRightScroller.pagingEnabled = YES;
    self.leftRightScroller.delegate = self;
    
    [self addSubview:self.leftRightScroller];
    
    CGRect contentOffset = CGRectOffset(self.frame, self.frame.size.width, -5);
    self.tweetContentView = [[UIView alloc]initWithFrame:contentOffset];
    self.tweetContentView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.leftRightScroller  addSubview:self.tweetContentView];
    
    self.profileImageView = [[UIImageView alloc] init];
    
    self.leftRightScroller.showsHorizontalScrollIndicator = NO;
    [self.leftRightScroller  addSubview:self.contentField];
 
    self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.contentView.layer.shadowRadius = 0.3;
    self.contentView.layer.shadowOpacity = 0.20;
   /*
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.shadowColor = [UIColor greenColor].CGColor;
    self.contentView.layer.shadowOpacity = 0.8;
    self.contentView.layer.shadowRadius = 12;
    self.contentView.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);
    */
    CGRect shadowFrame = self.tweetContentView.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
    self.contentView.layer.shadowPath = shadowPath;
    self.contentView.layer.backgroundColor = [UIColor clearColor].CGColor;
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
    
    
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-100, 0, 100, 50)];
    [self.tweetContentView addSubview:self.scoreLabel];
    [self.tweetContentView addSubview:self.contentField];
    [self.tweetContentView addSubview:self.nameLabel];
    [self.tweetContentView addSubview:self.profileImageView];
    [self.tweetContentView addSubview:self.screenNameLabel];
    self.backgroundColor = [UIColor clearColor];
    //self.tweetContentView.backgroundColor = [UIColor clearColor];
    self.hasRedBackground = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat xOffset = scrollView.contentOffset.x;
    //self.leftRightScroller.alpha = xOffset/600;
    if (xOffset > 320 && self.hasRedBackground){
        self.hasRedBackground = false;
        self.leftRightScroller.layer.backgroundColor = [UIColor greenColor].CGColor;
        
    }else if (xOffset < 320 && !self.hasRedBackground){
        self.hasRedBackground = true;
        self.leftRightScroller.layer.backgroundColor = [UIColor redColor].CGColor;
    }
    if (xOffset < 30 && !self.isDismissed){
        [self.delegate cellSlidRight:self];
        self.isDismissed = YES;
    }
    if (xOffset > 560 && !self.isDismissed){
        [self.delegate cellSlidLeft:self];
        self.isDismissed = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end


