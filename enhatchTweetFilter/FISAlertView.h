//
//  FISAlertView.h
//  enhatchTweetFilter
//
//  Created by Leo Reubelt on 8/1/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FISAlertView : UIAlertView <UIAlertViewDelegate>

typedef void (^ErrorCompletion)(UIAlertView *alertview,NSInteger index);

@property (nonatomic, copy) ErrorCompletion errorCompletion;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles
              completionBlock:(ErrorCompletion)errorCompletion;


@end
