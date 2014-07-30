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

    self.store = [FISDataStore sharedDataStore];
    
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"negativeVectorField"];
    self.store.negativeVectorField =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.store.dislikedVectors = [self.store.negativeVectorField.vectors mutableCopy];
    self.store.tweetsToShow =[[NSMutableArray alloc]init];
    [self.store updateTweetsToShow:^{
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
        [tweeter getImageForPersonWithBlock:^(NSError *error) {
            
            
            if (!error){
                cell.profileImageView.image = tweeter.profileImage;
            }
        }];
    }
    
    
    cell.contentField.text = tweetToShow.content;
    cell.nameLabel.text = tweeter.name;
    cell.screenNameLabel.text = [@"@" stringByAppendingString:tweeter.screenName];
    cell.delegate = self;
    return cell;
}

- (IBAction)refreshTapped:(id)sender {
    
    
    [self.store updateTweetsToShow:^{
        [self.tableView reloadData];
    }];
}


-(void)cellSlidRight:(FISSlidableTableViewCell *)cell {
    
    [self.store addDislikedTweet:cell.contentField.text];
    
    [self.store.tweetsToShow removeObjectAtIndex:([self.tableView indexPathForCell:cell]).row];
    //[self.store.scoreArray removeObjectAtIndex:([self.tableView indexPathForCell:cell]).row];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
}

@end
