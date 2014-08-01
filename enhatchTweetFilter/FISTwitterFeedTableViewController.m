//
//  FISTwitterFeedTableViewController.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISTwitterFeedTableViewController.h"
#import "FISTwitterAPIClient.h"
#import "FISDataStore.h"
#import "FISSlidableTableViewCell.h"
#import "FISTweet.h"
#import "FISTwitterPerson.h"
#import "FISPreferenceAlgorithm.h"
#import "FISAlertView.h"

@interface FISTwitterFeedTableViewController () <CellSliderDelegate>

- (IBAction)refreshTapped:(id)sender;

@property (strong, nonatomic) FISDataStore *store;


@end

@implementation FISTwitterFeedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EnhatchFullImage"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.store = [FISDataStore sharedDataStore];
    
    [self.store createTwitterAccount:^(NSError *error)
    {
        if (error)
        {
            [self displayAlertWithError:error];
        }
    }];
    
    self.store.tweetsToShow =[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTweets) name:@"finishedCreatingUser" object:nil];
}

- (void)loadTweets
{
    [self.store updateTweetsToShow:^(NSError *error)
     {
         if (error)
         {
             [self displayAlertWithError:error];
         }
         [self.tableView reloadData];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.store.tweetsToShow count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    
    FISSlidableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.isDismissed = NO;
    cell.leftRightScroller.contentOffset = CGPointMake(cell.frame.size.width,0);
    FISTweet *tweetToShow = self.store.tweetsToShow[indexPath.row];
    FISTwitterPerson *tweeter = tweetToShow.tweeter;
    if (tweeter.profileImage){
        cell.profileImageView.image = tweeter.profileImage;
    }else{
        [tweeter getImageForPersonWithBlock:^(NSError *error)
        {
            cell.profileImageView.image = tweeter.profileImage;
        }];
    }
    cell.contentField.text = tweetToShow.content;
    cell.nameLabel.text = tweeter.name;
    cell.scoreLabel.text = [NSString stringWithFormat:@"%f",tweetToShow.score];
    cell.screenNameLabel.text = [@"@" stringByAppendingString:tweeter.screenName];
    cell.delegate = self;
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger lettersPerRow = 42;
//    NSInteger baseline = 80;
//    FISTweet *tweetToShow = self.store.tweetsToShow[indexPath.row];
//    NSInteger tweetrows = ([tweetToShow.content length]/42)+1;
//    NSInteger height = tweetrows*10 + baseline;
//    
//    
//    return ;
//}

- (IBAction)refreshTapped:(id)sender {
    
    [self.store updateTweetsToShow:^(NSError *error)
     {
         if (error)
         {
             [self displayAlertWithError:error];
         }
         [self.tableView reloadData];
     }];
}


-(void)cellSlidRight:(FISSlidableTableViewCell *)cell {
    
    
    
    [self.store addTweet:cell.contentField.text forVectorSet:self.store.gloabalVectors toPositive:NO];
    
    [self.store.tweetsToShow removeObjectAtIndex:([self.tableView indexPathForCell:cell]).row];
    //[self.store.scoreArray removeObjectAtIndex:([self.tableView indexPathForCell:cell]).row];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)cellSlidLeft:(FISSlidableTableViewCell *)cell {
    [self.store addTweet:cell.contentField.text forVectorSet:self.store.gloabalVectors toPositive:YES];
    
    
    [self.store.tweetsToShow removeObjectAtIndex:([self.tableView indexPathForCell:cell]).row];
    //[self.store.scoreArray removeObjectAtIndex:([self.tableView indexPathForCell:cell]).row];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)displayAlertWithError:(NSError*)error
{
    NSString *retryTitle = nil;
    if (error.code == 400)
    {
        retryTitle = @"Retry";
    }

    FISAlertView *tweetsAlertView = [[FISAlertView alloc]initWithTitle:@"Error"
                                                                     message:error.domain
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:retryTitle
                                                             completionBlock:^(UIAlertView *alertview, NSInteger index){}];
    
    tweetsAlertView.errorCompletion = ^(UIAlertView *view, NSInteger index)
    {
        if (index == 1)
        {
            [self loadTweets];
        };
    
    };
    
    NSOperationQueue *mainQ = [NSOperationQueue mainQueue];
    [mainQ addOperationWithBlock:^{
        [tweetsAlertView show];
    }];
    
}

@end
