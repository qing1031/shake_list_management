//
//  MyShakeListViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 2/23/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "MyShakeListViewController.h"
#import "ShakeListTableViewCell.h"
#import <Firebase/Firebase.h>
#import "LMContainsLMComboxScrollView.h"
#import "Define.h"

@interface MyShakeListViewController ()
{
    IBOutlet LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;
}

@end

@implementation MyShakeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
//    [self.view bringSubviewToFront:self.shakeListTableView];
    self.loadingIndicator.hidden = NO;
    list_count = 0;
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_KEY];
    followingUserAry = [[[NSUserDefaults standardUserDefaults] objectForKey:FOLLOWING_USER_KEY] mutableCopy];

    self.followingListMutableArray = [NSMutableArray array];

    // Set up the sort-by combo box
    NSLog(@"sortby label position : %f", self.view.frame.size.width);
    bgScrollView = [[LMContainsLMComboxScrollView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.comboxView addSubview:bgScrollView];
    self.shakeListTableView.layer.zPosition = 0;

    [self setUpBgScrollView];

    // Display the all shakelists.
    [self displayMyShakeLists];
    
    // Refresh the MyShakeLists when following user add a new shaklist.
    [self refreshAddedShakelist];

}

// Show MyShakeLists from firebase.
- (void)displayMyShakeLists {
    
    // Get the my shakelist result.
    NSMutableArray *myShakeMutableAry = [[[NSUserDefaults standardUserDefaults] objectForKey:MY_SHAKE_LIST] mutableCopy];;
    
    if (myShakeMutableAry == NULL) {
        
        // Get the sakelist data from the firebse.
        Firebase *fb = [FB_REF childByAppendingPath:FB_SHAKE_LISTS_KEY];
        Firebase *ref = [fb childByAppendingPath:userName];
        
        [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            // do some stuff once
            NSLog(@"single result : %@", snapshot.value);
            self.listMutableArray = [NSMutableArray array];
            
            for ( FDataSnapshot *child in snapshot.children) {
                
                NSDictionary *dict = child.value; //or craft an object instead of dict
                
                [dict setValue:userName forKey:@"username"];
                [self.listMutableArray addObject:dict];
            }
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"author" ascending:YES]; //sort by date key, descending
            NSArray *arrayOfDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            [self.listMutableArray sortUsingDescriptors: arrayOfDescriptors];
            self.loadingIndicator.hidden = YES;
            
            list_count = self.listMutableArray.count;

            // Get and display the following twittereres shakelist.
            [self displayFollowingTwitterers];
            
            // Save the result list to default.
            [[NSUserDefaults standardUserDefaults] setObject:self.listMutableArray forKey:MY_SHAKE_LIST];
            
        }];
        
    } else {
        self.listMutableArray = myShakeMutableAry;
        self.loadingIndicator.hidden = YES;
        
        list_count = self.listMutableArray.count;
        
        // Get and display the following twittereres shakelist.
        [self displayFollowingTwitterers];
    }
}

// Get and display the following twitterers.
- (void)displayFollowingTwitterers {
    
    // get the saveed nsdefault following shakelist result
    NSMutableDictionary *followingUserMutableDict = [[[NSUserDefaults standardUserDefaults]
                                                      objectForKey:FOLLOWING_USER_LIST] mutableCopy];
    NSLog(@"Following users :\n %@", followingUserAry);
    
    if (followingUserAry != nil && followingUserMutableDict == nil) {       // After login, call once in the app.
        
        Firebase *fb = [FB_REF childByAppendingPath:FB_SHAKE_LISTS_KEY];
        [fb observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            // Dictionary to manage the following users.
            NSMutableDictionary *followingDict = [NSMutableDictionary dictionary];
            
            // MutableArray for display the lists of the following users.
            self.followingListMutableArray = [NSMutableArray array];
            
            for (FDataSnapshot *child in snapshot.children) {
                
                NSString *key = child.key;
                if ([followingUserAry containsObject:key]) {
                    NSLog(@"following user key : %@", key);
                    
                    NSMutableArray *userAry = [[[child.value objectEnumerator] allObjects] mutableCopy];
                    for (NSDictionary *childDict in userAry) {
                        [childDict setValue:key forKey:@"username"];
                    }
                    [followingDict setObject:userAry forKey:key];
                }
            }
            
            [self getFollowingShakelists:followingDict];
        }];
        
    } else {
        if (followingUserMutableDict == nil) {
            [self.shakeListTableView reloadData];

        } else {
            [self getFollowingShakelists:followingUserMutableDict];
        }
    }
}

// Refresh the added shakelist.
- (void)refreshAddedShakelist {
    
    NSMutableDictionary *followingDict = [[[NSUserDefaults standardUserDefaults] objectForKey:FOLLOWING_USER_LIST] mutableCopy];
    
    if (followingDict == nil) {
        return;
    }
    
    Firebase *fb = [FB_REF childByAppendingPath:FB_SHAKE_LISTS_KEY];
    for (NSString *followingUser in followingUserAry) {
        
        Firebase *userRef = [fb childByAppendingPath:followingUser];
        
        // Retrieve new posts as they are added to the database
        [userRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            
            NSLog(@"%@", snapshot.key);
            NSLog(@"%@", snapshot.value[@"title"]);
            
            BOOL exit_flag = NO;

            NSMutableArray *userArray = [[followingDict objectForKey:followingUser] mutableCopy];
            if (userArray == nil) {
                exit_flag = NO;
            }
            for (NSDictionary *childDict in userArray) {
                if ([childDict objectForKey:@"created-at"] == snapshot.value[@"created-at"]) {
                    exit_flag = YES;
                }
            }

            if (!exit_flag) {
                NSDictionary *addedDict = snapshot.value;
                [addedDict setValue:followingUser forKey:@"username"];
                
                [userArray addObject:addedDict];
                [followingDict setObject:userArray forKey:followingUser];

                [self getFollowingShakelists:followingDict];
            }
        }];
    }
}

// Get the shakelists from the following userdata.
- (void)getFollowingShakelists:(NSMutableDictionary *) dict {

    // Declare NSSortDescriptor to sort by created-at.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created-at" ascending:NO];
    NSArray *arrayOfDescriptors = [NSArray arrayWithObject:sortDescriptor];

    self.followingListMutableArray = [NSMutableArray array];
    NSMutableDictionary *followingDict = [NSMutableDictionary dictionary];

    for (NSString *userStr in followingUserAry) {
        
        NSMutableDictionary *userDict = [dict objectForKey:userStr];
        NSMutableArray *userAry = [[[userDict objectEnumerator] allObjects] mutableCopy];
        [userAry sortUsingDescriptors:arrayOfDescriptors];
        
        if (userAry.count > TWITTER_FEEDS_LIMIT) {
            userAry = [[userAry subarrayWithRange:NSMakeRange(0, TWITTER_FEEDS_LIMIT)] mutableCopy];
        }
        
        [followingDict setObject:userAry forKey:userStr];
        [self.followingListMutableArray addObjectsFromArray:userAry];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:followingDict forKey:FOLLOWING_USER_LIST];

    [self.listMutableArray addObjectsFromArray:self.followingListMutableArray];
    
    NSArray *sortedArray = [self.listMutableArray sortedArrayUsingDescriptors:arrayOfDescriptors];
    NSEnumerator *enumerator = [sortedArray objectEnumerator];
    self.listMutableArray = [NSMutableArray array];
    
    for (id element in enumerator) {
        [self.listMutableArray addObject:element];
    }

    list_count = self.listMutableArray.count;
    NSLog(@"%@", self.listMutableArray);

    [self.shakeListTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set up the sort by combo box.
-(void)setUpBgScrollView {
    LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(10, 8, 80, 30)];
    comBox.backgroundColor = [UIColor whiteColor];
    comBox.arrowImgName = @"down_dark0.png";
    NSMutableArray *itemsArray = [NSMutableArray array];
    [itemsArray addObject:@"user"];
    [itemsArray addObject:@"title"];
    comBox.titlesList = itemsArray;
    comBox.delegate = self;
    comBox.supView = bgScrollView;
    [comBox defaultSettings];
    [bgScrollView addSubview:comBox];
}

#pragma mark - Phrase tabel view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list_count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ListCell";
    
    ShakeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[ShakeListTableViewCell
                 alloc] initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.shakeImageView.image = [UIImage imageNamed:@"profile_icon.png"];
    cell.shakeImageView.layer.cornerRadius = 12;
    cell.shakeImageView.clipsToBounds = YES;
    cell.titleLabel.text = [[self.listMutableArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.userNameLabel.text = [[self.listMutableArray objectAtIndex:indexPath.row] objectForKey:@"username"];
    NSMutableArray *phraseArray = [[self.listMutableArray objectAtIndex:indexPath.row] objectForKey:@"phrases"];
    NSInteger phrase_count = phraseArray.count;
    if (phraseArray == nil) {
        phrase_count = 0;
    }
    cell.phrasesCountLabel.text = [NSString stringWithFormat:@"%ld phrases", (long)phrase_count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setValue:@"update" forKey:SHAKE_EDIT_KEY];
    
    NSMutableDictionary *selectedDict = [self.listMutableArray objectAtIndex:indexPath.row];
    if ([[selectedDict objectForKey:@"username"] isEqualToString:userName]) {
        [[NSUserDefaults standardUserDefaults] setObject:selectedDict forKey:SELECTED_SHAKE_KEY];
        
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NEW_SHAKELIST_VIEWID];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 800; // or any number based on your estimation
}

#pragma mark -LMComBoxViewDelegate

-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox {
    NSLog(@"combox index : %d", index);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)menuClicked:(id)sender {
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)createNewShakeList:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"create" forKey:SHAKE_EDIT_KEY];
}

@end
