//
//  FISFriendsTableViewController.m
//  enhatchTweetFilter
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISFriendsTableViewController.h"
#import "FISDataStore.h"
#import "FISTwitterPerson.h"
#import "FISFriendTableViewCell.h"
#import "FISFriendFeedTableViewController.h"
#import "FISAlertView.h"

@interface FISFriendsTableViewController ()

@property (strong, nonatomic) FISDataStore *store;

@end

@implementation FISFriendsTableViewController

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
    self.store = [FISDataStore sharedDataStore];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFriends) name:@"finishedCreatingUser" object:nil];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) loadFriends{
    [self.store updateFriendsToShow:^(NSError *error)
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
    return [self.store.friendsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FISFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    FISTwitterPerson *friendToShow = self.store.friendsArray[indexPath.row];
    cell.nameLabel.text = friendToShow.name;
    cell.screenNameLabel.text = [@"@" stringByAppendingString:friendToShow.screenName];
    if (friendToShow.profileImage){
        cell.profileImageView.image = friendToShow.profileImage;
    }else{
        [friendToShow getImageForPersonWithBlock:^(NSError *error) {
            if (!error){
                cell.profileImageView.image = friendToShow.profileImage;
            }
        }];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedPath = [self.tableView indexPathForCell:sender];
    FISTwitterPerson *selectedPerson = self.store.friendsArray[selectedPath.row];
    FISFriendFeedTableViewController *friendFeedController = segue.destinationViewController;
    friendFeedController.currentFriend = selectedPerson;
}

-(void)displayAlertWithError:(NSError*)error
{
    NSString *retryTitle = nil;
    if (error.code == 400)
    {
        retryTitle = @"Retry";
    }
    
    FISAlertView *friendsAlertView = [[FISAlertView alloc]initWithTitle:@"Error"
                                                               message:error.domain
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:retryTitle
                                                       completionBlock:^(UIAlertView *alertview, NSInteger index){}];
    
    friendsAlertView.errorCompletion = ^(UIAlertView *view, NSInteger index)
    {
        if (index == 1)
        {
            [self loadFriends];
        };
        
    };
    [friendsAlertView show];
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
{FI
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

*/

@end
