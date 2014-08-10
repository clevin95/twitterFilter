//
//  FISTrashBinTableViewController.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 8/1/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISTrashBinTableViewController.h"
#import "FISSlidableTableViewCell.h"
#import "FISDataStore.h"
#import "FISTweet.h"
#import "FISWebViewController.h"

@interface FISTrashBinTableViewController () <CellSliderDelegate>

@property (strong, nonatomic) FISDataStore *store;
- (IBAction)dismissButtonTapped:(id)sender;

@end

@implementation FISTrashBinTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    self.store = [FISDataStore sharedDataStore];
    [super viewDidLoad];
    [self setUpSubviews];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)setUpSubviews {
    self.navigationController.navigationBar.layer.shadowRadius = 4;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 3);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5;
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.navigationController.navigationBar.bounds];
    self.navigationController.navigationBar.layer.shadowPath = path.CGPath;
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EnhatchFullImage"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.trashItems count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)cellSlidRight:(FISSlidableTableViewCell *)cell {

    NSInteger cellIndex = [self.tableView indexPathForCell:cell].row;
    FISTweet *tweetSwiped = self.trashItems[cellIndex];
    tweetSwiped.swipedPositive = NO;
    [self.trashItems removeObject:tweetSwiped];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    [self.store removeTweet:tweetSwiped.content forVectorSet:self.vectorSet toPositive:YES];
}

-(void)cellSlidLeft:(FISSlidableTableViewCell *)cell {
    NSInteger cellIndex = [self.tableView indexPathForCell:cell].row;
    FISTweet *tweetSwiped = self.trashItems[cellIndex];
    tweetSwiped.swipedPositive = NO;
    [self.trashItems addObject:tweetSwiped];
    [self.trashItems removeObject:tweetSwiped];
    //[self.store.scoreArray removeObjectAtIndex:([self.tableView indexPathForCell:cell]).row];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    [self.store removeTweet:tweetSwiped.content forVectorSet:self.vectorSet toPositive:NO];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"trashBinCell";
    FISSlidableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.isDismissed = NO;
    cell.leftRightScroller.contentOffset = CGPointMake(cell.frame.size.width,0);
    FISTweet *tweetToShow = self.trashItems [indexPath.row];
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
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    if (tweetToShow.swipedPositive){
        cell.tweetContentView.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
    }else {
        cell.tweetContentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:0.5];
    }
    return cell;
}
     
     
     


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
    if ([segue.identifier isEqualToString:@"generalToDetail"])
     {
         FISSlidableTableViewCell *cell = sender;
         NSIndexPath *index = [self.tableView indexPathForCell:cell];
         FISTweet *tweet = self.store.tweetsToShow[index.row];
         FISWebViewController *nextVC = segue.destinationViewController;
         nextVC.tweet = tweet;
     }
 }
 

-(void)cellTapped:(FISSlidableTableViewCell *) cell
{
    [self performSegueWithIdentifier:@"generalToDetail" sender:cell];
}


- (IBAction)dismissButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
