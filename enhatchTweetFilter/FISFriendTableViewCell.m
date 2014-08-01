//
//  FISFriendTableViewCell.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISFriendTableViewCell.h"

@implementation FISFriendTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

//Creates spacing between the cells
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 5;
    frame.size.height -= 2 * 5;
    [super setFrame:frame];
}

- (void)awakeFromNib
{
    self.profileImageView.layer.cornerRadius = 8;
    self.profileImageView.clipsToBounds = YES;
    
    //Frame underneath the data and over top the shadow frame
    //self.contentView.frame = CGRectMake(0, 0, 320 , 70);
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.contentView.layer.shadowRadius = 2;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 3);
    self.contentView.layer.shadowOpacity = 0.50;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //Sets the shadow's dimensions
    CGRect shadowFrame = CGRectMake(0, -3, 330, 65);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame];
    self.contentView.layer.shadowPath = shadowPath.CGPath;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
