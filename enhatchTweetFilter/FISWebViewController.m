//
//  FISWebViewController.m
//  enhatchTweetFilter
//
//  Created by Leo Reubelt on 8/4/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISWebViewController.h"
#import "FISTweet.h"

@interface FISWebViewController ()


@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)twitterAppTapped:(id)sender;

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
    
    FISTwitterPerson *tweeter = self.tweet.tweeter;
    NSString *urlString = [NSString stringWithFormat:@"https://twitter.com/%@/status/%@",tweeter.screenName,self.tweet.tweetID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *tweet = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:tweet];
    
    //Right UIBarButton with Twitter logo and name
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(twitterAppTapped:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 40, 18)];
    
    UIImage *image = [UIImage imageNamed:@"TwitterLogoBlueSmall2"];
    [[button imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(2, -15, 2, 0);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
                                            
    self.navigationItem.rightBarButtonItem = barButton;

                                            
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)twitterAppTapped:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"twitter://status?id=%@",self.tweet.tweetID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    NSLog(@"test");
}
@end
