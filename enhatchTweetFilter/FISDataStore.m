//
//  FISDataStore.m
//
//
//  Created by Carter Levin on 7/29/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

#import "FISDataStore.h"
#import "FISTwitterAPIClient.h"
#import "FISPreferenceAlgorithm.h"
#import "FISTweet.h"

@implementation FISDataStore


@synthesize managedObjectContext = _managedObjectContext;
@synthesize nonSavingContext = _nonSavingContext;

+ (instancetype)sharedDataStore {
    static FISDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISDataStore alloc] init];
    });
    return _sharedDataStore;
}

-(NSMutableArray *)scoreArray{
    if (!_scoreArray){
        _scoreArray = [[NSMutableArray alloc]init];
    }
    return _scoreArray;
}


-(VectorSet *)gloabalVectors{
    if (!_gloabalVectors){
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"VectorSet"];
        NSSortDescriptor *tweeterSort = [NSSortDescriptor sortDescriptorWithKey:@"tweeter" ascending:YES];
        fetch.sortDescriptors = @[tweeterSort];
        fetch.predicate = [NSPredicate predicateWithFormat:@"tweeter == 'global'"];
        NSArray *gloabalVectorsArray = [self.managedObjectContext executeFetchRequest:fetch error:nil];
        if ([gloabalVectorsArray count] > 0){
            _gloabalVectors = gloabalVectorsArray[0];
        }else {
            _gloabalVectors = [NSEntityDescription insertNewObjectForEntityForName:@"VectorSet" inManagedObjectContext:self.managedObjectContext];
            _gloabalVectors.tweeter = @"global";
        }
    }
    return _gloabalVectors;
}


-(NSMutableArray *)tweetsToShow{
    if (!_tweetsToShow){
        _tweetsToShow = [[NSMutableArray alloc] init];
    }
    return _tweetsToShow;
}

- (void) updateTweetsToShow:(void (^)(NSError*))callback {
    __weak typeof(self) weakSelf = self;

    
    [FISTwitterAPIClient getFeedWithBlockForAccount:self.twitterAccount Since:self.lastID withBlock:^(NSArray *tweetArray, NSError *error)
    {
        if (!error)
        {
            if ([tweetArray count] > 0)
            {
                self.lastID = tweetArray[0][@"id_str"];
            }
            weakSelf.tweetsToShow = [self convertRawTweetsToObjects:tweetArray forTweeter:nil];
        }
        callback(error);
    }];
}


- (void) updateFriendsToShow:(void (^)(NSError*))callback
{
    __weak typeof(self) weakSelf = self;
    
    [FISTwitterAPIClient getFriendsForAccount:self.twitterAccount WithBlock:^(NSArray *friendsArray, NSError *error)
    {
        if (!error)
        {
            NSMutableArray *friendsTempArray = [[NSMutableArray alloc]init];
            for (NSDictionary *friend in friendsArray)
            {
                FISTwitterPerson *newFriend = [[FISTwitterPerson alloc]init];
                newFriend.name = friend[@"name"];
                newFriend.userID = friend[@"id_str"];
                newFriend.screenName = friend[@"screen_name"];
                newFriend.profileImageURL = friend[@"profile_image_url"];
                [friendsTempArray addObject:newFriend];
            }
            weakSelf.friendsArray = friendsTempArray;
        }
        callback(error);
    }];

    
    
}

- (NSArray *) convertRawFriendsToObjects:(NSArray *)rawFriends {
    NSMutableArray *friendsTempArray = [[NSMutableArray alloc]init];
    for (NSDictionary *friend in rawFriends){
        FISTwitterPerson *newFriend = [[FISTwitterPerson alloc]init];
        newFriend.name = friend[@"name"];
        newFriend.userID = friend[@"id_str"];
        newFriend.screenName = friend[@"screen_name"];
        newFriend.profileImageURL = friend[@"profile_image_url"];
        [friendsTempArray addObject:newFriend];
    }
    return friendsTempArray;
}

//Method asigns score from the global vectors if tweeter is nil/
- (NSMutableArray *) convertRawTweetsToObjects:(NSArray *)rawTweets forTweeter:(FISTwitterPerson *)person {
    NSMutableArray *tweetsArray = [[NSMutableArray alloc]init];
    for (NSDictionary *tweetDictionary in [rawTweets reverseObjectEnumerator])
    {
        FISTwitterPerson *tweeter = [[FISTwitterPerson alloc]init];
        FISTweet *loadedTweet = [[FISTweet alloc]init];
        tweeter.name = tweetDictionary[@"user"][@"name"];
        tweeter.screenName = tweetDictionary[@"user"][@"screen_name"];
        tweeter.profileImageURL = tweetDictionary[@"user"][@"profile_image_url"];
        NSString *tweetText = [NSString stringWithFormat:@"%@",tweetDictionary[@"text"]];
        

        NSArray *dislikedVectors = nil;
        NSArray *likedVectors = nil;
        if (!person){
            dislikedVectors = [self.gloabalVectors.negativeVectors allObjects];
            likedVectors = [self.gloabalVectors.positiveVectors allObjects];
        }
        else {
            dislikedVectors = [person.personalVectors.negativeVectors allObjects];
            likedVectors = [person.personalVectors.positiveVectors allObjects];
        }
        
        
        CGFloat negativeScore = [FISPreferenceAlgorithm compareSentence:tweetText withVectorSet:dislikedVectors];
        CGFloat positiveScore = (1.57 - [FISPreferenceAlgorithm compareSentence:tweetText withVectorSet:likedVectors]);
        loadedTweet.score = positiveScore + negativeScore;
        loadedTweet.tweeter = tweeter;
        loadedTweet.content = tweetText;
        [tweetsArray  insertObject:loadedTweet atIndex:0];
    }
    return tweetsArray;
}

- (void) createTwitterAccount:(void (^)(NSError*))callback
{
    [FISTwitterAPIClient createTwitterAccountWithTwitterAccount:self.twitterAccount CompletionBlock:^(STTwitterAPI *aPITwitterAccount, NSError *error)
     {
         if (!error)
         {
             self.credentialAuthorized = YES;
             self.twitterAccount = aPITwitterAccount;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedCreatingUser" object:nil];
         }
        callback(error);
     }];
}


- (void) getTweetsForFriend:(FISTwitterPerson *)friend withCompletion:(void (^)(NSError*))callback
{
    [FISTwitterAPIClient getTweetsWithAccount:self.twitterAccount forUser:friend withBlock:^(NSArray *tweetArray, NSError *error)
    {
        if (!error) {
            NSMutableArray *tweetsByFriend = [self convertRawTweetsToObjects:tweetArray forTweeter:friend];
            friend.tweets = tweetsByFriend;
        }
        callback(error);
    }];
}




- (void) filterTweetArray:(NSArray *)tweetArray {
    NSMutableArray *dislikedVectors = [[NSMutableArray alloc]initWithArray:[self.gloabalVectors.negativeVectors allObjects]];
    for (NSString *tweet in tweetArray){
        
        [FISPreferenceAlgorithm compareSentence:tweet withVectorSet:dislikedVectors];
    }
}


- (void) addTweet:(NSString *)tweet forVectorSet:(VectorSet *)vectorSet toPositive:(BOOL)positive {
   // NSMutableArray *dislikedVectors = [[NSMutableArray alloc]initWithArray:[self.gloabalVectors.negativeVectors allObjects]];
    [FISPreferenceAlgorithm addSentence:tweet toVectorSubset:vectorSet withPossitive:positive];
}



- (void)save
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"enhatchTweetFilter.sqlite"];
    NSError *error = nil;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectContext *)nonSavingContext
{
    if (_nonSavingContext != nil) {
        return _nonSavingContext;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"enhatchTweetFilter.sqlite"];
    
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _nonSavingContext = [[NSManagedObjectContext alloc] init];
        [_nonSavingContext setPersistentStoreCoordinator:coordinator];
    }
    return _nonSavingContext;
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSArray*) fetchRequestWithEntityName:(NSString *)entityName SortDescriptor:(NSSortDescriptor*)sortDescriptor andPredicate:(NSPredicate*)predicate
{
    
    NSFetchRequest *genericRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    genericRequest.sortDescriptors = @[sortDescriptor];
    genericRequest.predicate = predicate;
    
    NSArray *dataArray = [self.managedObjectContext executeFetchRequest:genericRequest error:nil];
    
    return dataArray;
}

-(void) updateManagedObject:(NSManagedObject*)currentObject WithNewObject:(NSManagedObject*)newObject InContext:(NSManagedObjectContext*)context
{
    [self.managedObjectContext insertObject:newObject];
    [self.managedObjectContext deleteObject:currentObject];
    [self save];
}

@end
