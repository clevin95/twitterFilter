//
//  FISFriendFeedTableViewController.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISFriendFeedTableViewController.h"
#import "FISDataStore.h"
#import "FISSlidableTableViewCell.h"
#import "FISTweet.h"
#import "FISAlertView.h"
#import "FISTrashBinTableViewController.h"
#import "FISWebViewController.h"


@interface FISFriendFeedTableViewController () <CellSliderDelegate>

@property (strong, nonatomic) FISDataStore *store;

@end

@implementation FISFriendFeedTableViewController

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
    [super viewDidLoad];
    [self setUpNavigationBar];
    self.navigationController.navigationBar.layer.shadowRadius = 4;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 3);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5;
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.navigationController.navigationBar.bounds];
    self.navigationController.navigationBar.layer.shadowPath = path.CGPath;
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EnhatchFullImage"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)setUpNavigationBar {
    UIToolbar *rightToolbarView = [[UIToolbar alloc]  initWithFrame:CGRectMake(0, 0, 70, 40)];
    
    [rightToolbarView setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    [rightToolbarView setBackgroundColor:[UIColor clearColor]];

    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashTapped)];
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped)];
    rightToolbarView.layer.backgroundColor = [UIColor clearColor].CGColor;
    rightToolbarView.items = @[trashButton, reloadButton];
    
    UIBarButtonItem* barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightToolbarView];
    
    // Set the navigation bar's right button item
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (void)trashTapped {
    [self performSegueWithIdentifier:@"toTrash" sender:self];
}


- (void)reloadTapped {
    [self.tableView beginUpdates];
    
    NSArray * unstoredTweetsToShow = [self.currentFriend.tweets copy];
    self.currentFriend.tweets = [self.store scoreAndSortArray:self.currentFriend.tweets forVectorSet:self.currentFriend.personalVectors];
    
    
    NSInteger sourceRow = 0;
    for (FISTweet *tweet in unstoredTweetsToShow) {
        NSInteger destRow = [self.currentFriend.tweets indexOfObject:tweet];
        
        if (destRow != sourceRow) {
            // Move the rows within the table view
            NSIndexPath *sourceIndexPath = [NSIndexPath indexPathForItem:sourceRow inSection:0];
            NSIndexPath *destIndexPath = [NSIndexPath indexPathForItem:destRow inSection:0];
            [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destIndexPath];
            
        }
        sourceRow++;
    }
    [self.tableView endUpdates];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.store = [FISDataStore sharedDataStore];
    [self loadTweets];
}

-(void)loadTweets
{
    [self.store getTweetsForFriend:self.currentFriend withCompletion:^(NSError *error)
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.currentFriend.tweets count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FISSlidableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    cell.nameLabel.text = self.currentFriend.name;
    cell.screenNameLabel.text = self.currentFriend.name;
    
    FISTweet *tweetToShow = self.currentFriend.tweets[indexPath.row];
    cell.contentField.text = tweetToShow.content;
    cell.isDismissed = NO;
    cell.leftRightScroller.contentOffset = CGPointMake(cell.frame.size.width,0);
    cell.delegate = self;
    cell.scoreLabel.text = [NSString stringWithFormat:@"%f",tweetToShow.score];
    if (self.currentFriend.profileImage){
        cell.profileImageView.image = self.currentFriend.profileImage;
    }else{
        [self.currentFriend  getImageForPersonWithBlock:^(NSError *error) {
            if (!error){
                cell.profileImageView.image = self.currentFriend.profileImage;
            }
        }];
    }
    cell.profileImageView.image = self.currentFriend.profileImage;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)cellSlidRight:(FISSlidableTableViewCell *)cell {
    FISTweet *tweetSwiped = self.currentFriend.tweets[[self.tableView indexPathForCell:cell].row];
    tweetSwiped.swipedPositive = NO;
    [self.currentFriend.personalTrash addObject:tweetSwiped];
    [self.store addTweet:cell.contentField.text forVectorSet:self.currentFriend.personalVectors toPositive:NO];
    [self.currentFriend.tweets removeObject:tweetSwiped];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)cellSlidLeft:(FISSlidableTableViewCell *)cell {
    FISTweet *tweetSwiped = self.currentFriend.tweets[[self.tableView indexPathForCell:cell].row];
    tweetSwiped.swipedPositive = YES;
    [self.currentFriend.personalTrash addObject:tweetSwiped];
    [self.store addTweet:cell.contentField.text forVectorSet:self.currentFriend.personalVectors toPositive:YES];
    [self.currentFriend.tweets removeObject:tweetSwiped];
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ( [((UIViewController *)segue.destinationViewController).restorationIdentifier isEqualToString:@"trashNavController"]){
        FISTrashBinTableViewController *trashController = ((UIViewController *)segue.destinationViewController).childViewControllers[0] ;
        trashController.trashItems = self.currentFriend.personalTrash;
    }
    else if ([segue.identifier isEqualToString:@"generalToDetail"])
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
