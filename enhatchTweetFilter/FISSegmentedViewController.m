//
//  FISSegmentedViewController.m
//  enhatchLayoutText
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISSegmentedViewController.h"

@interface FISSegmentedViewController ()

@property (weak, nonatomic) IBOutlet UIView *globalContainer;
@property (weak, nonatomic) IBOutlet UIView *contactsContainer;
- (IBAction)segmentTapped:(id)sender;

@end

@implementation FISSegmentedViewController

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
    self.contactsContainer.hidden = YES;
    self.globalContainer.hidden = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentTapped:(id)sender {
    if (self.globalContainer.hidden){
        self.globalContainer.hidden = NO;
        self.contactsContainer.hidden = YES;
    } else {
        self.globalContainer.hidden = YES;
        self.contactsContainer.hidden = NO;
    }
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
