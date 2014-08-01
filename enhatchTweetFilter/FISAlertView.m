//
//  FISAlertView.m
//  enhatchTweetFilter
//
//  Created by Leo Reubelt on 8/1/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISAlertView.h"

@implementation FISAlertView


-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles
             completionBlock:(ErrorCompletion)errorCompletion
{
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:otherButtonTitles, nil];
    if (self)
    {
        _errorCompletion = errorCompletion;
    }
    return self;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.errorCompletion(alertView,buttonIndex);
}


-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    
    return YES;
}

-(void)willPresentAlertView:(UIAlertView *)alertView
{
    
}

-(void)didPresentAlertView:(UIAlertView *)alertView
{
    
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
    
}


@end
