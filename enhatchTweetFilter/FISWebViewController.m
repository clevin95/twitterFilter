//
//  FISWebViewController.m
//  enhatchTweetFilter
//
//  Created by Leo Reubelt on 8/4/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISWebViewController.h"

@interface FISWebViewController ()


@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation FISWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // NSURL *url = [NSURL URLWithString:@"https://twitter.com/OverheardAtFlat/status/496317230712647680"];
   // NSURLRequest *tweet = [NSURLRequest requestWithURL:url];
   // [self.webView loadRequest:tweet];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://status?id=496317230712647680"]];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
