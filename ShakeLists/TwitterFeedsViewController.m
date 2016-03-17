//
//  TwitterFeedsViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 3/8/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "TwitterFeedsViewController.h"
#import "LMContainsLMComboxScrollView.h"
#import "TwitterFeedsTableViewCell.h"
#import "UIView+Toast.h"
#import <Firebase/Firebase.h>
#import <TwitterKit/TwitterKit.h>
#import "Define.h"

#define search_field_tag 100

@interface TwitterFeedsViewController () {
    IBOutlet LMContainsLMComboxScrollView *bgScrollView;
}

@end

@implementation TwitterFeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    twitterUserArray = [NSMutableArray array];
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_KEY];
    
    // Sett the left image icon of searchtextfield.
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftIconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon.png"]];
    leftIconImage.frame = CGRectMake(5, 0, 15, 15);
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [paddingView addSubview:leftIconImage];
    self.searchTextField.leftView = paddingView;
    self.searchTextField.leftView.alpha = 0.7f;
    self.searchTextField.tag = search_field_tag;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    
    // Set up the sort-by combo box
    NSLog(@"sortby label position : %f", self.view.frame.size.width);
    bgScrollView = [[LMContainsLMComboxScrollView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [sortByComboBox addSubview:bgScrollView];
    feedsTableView.layer.zPosition = 0;
    
    [self setUpBgScrollView];
    
    // Search the top superball twitterers.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect) rightViewRectForBounds:(CGRect)bounds {
    
    CGRect textRect = [self rightViewRectForBounds:bounds];
    textRect.origin.x -= 10;
    return textRect;
}

//Setup background scrollview for combo box.
-(void)setUpBgScrollView {
    LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(10, -2, 80, 30)];
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

// Set the loaded status.
- (void)setLoadingStatus:(BOOL) flag {
    
    self.loadingIndicator.hidden = flag;
    self.searchTextField.enabled = flag;
    self.discoverButton.enabled = flag;
    self.friendsButton.enabled = flag;
    self.youButton.enabled = flag;
}

// Search the twitterers to match the username.
- (void)searchTwitterers:(NSString *)search_name {
    [self setLoadingStatus:NO];

    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/users/search.json";
    NSDictionary *params = @{@"q" : search_name};
    NSError *clientError;
    
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    
    if (request) {
        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [self setLoadingStatus:YES];
            
            if (data) {
                // handle the response data e.g.
                twitterUserArray = [NSMutableArray array];
                NSError *jsonError;
                NSMutableArray *json = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError] mutableCopy];
                for (NSMutableDictionary *userDict in json) {
                    NSLog(@"screen username : %@", [userDict objectForKey:@"screen_name"]);
                    
                    if ([[[userDict objectForKey:@"screen_name"] lowercaseString]
                         rangeOfString:[search_name lowercaseString]].location != NSNotFound) {
                        
                        NSDictionary *dict = [[NSDictionary dictionary] mutableCopy];
                        [dict setValue:[userDict objectForKey:@"screen_name"] forKey:@"username"];
                        [dict setValue:[userDict objectForKey:@"id_str"] forKey:@"id"];
                        [dict setValue:[userDict objectForKey:@"followers_count"] forKey:@"followers"];
                        
                        [twitterUserArray addObject:dict];
                    }
                }
                if (twitterUserArray.count == 0) {
                    [self.navigationController.view makeToast:@"No Item"];
                }
                
                // Refresh the twitter feeds tableview.
                [feedsTableView reloadData];
                
            } else {
                NSLog(@"Error: %@", connectionError);
                [self.navigationController.view makeToast:@"Network Error"];
            }
        }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
}

// follow the selected user in the twitter feeds list.
- (void)followProfile:(UIButton *)sender {
    
    NSLog(@"follow profile: %ld", (long)sender.tag);
    NSMutableDictionary *dict = [twitterUserArray objectAtIndex:sender.tag];
    NSString *curUserName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_KEY];
    NSString *selectedUserName = [dict objectForKey:@"username"];
    followingUserArray = [[[NSUserDefaults standardUserDefaults] objectForKey:FOLLOWING_USER_KEY] mutableCopy];
    
    if ([followingUserArray containsObject:selectedUserName]) {
        [self.navigationController.view makeToast:@"Already following"];
        
    } else {
        if (followingUserArray == nil) {
            followingUserArray = [NSMutableArray array];
        }
        [followingUserArray addObject:[dict objectForKey:@"followers"]];
        
        [self setLoadingStatus:NO]; //Loading
        
        Firebase *twitterRef = [FB_REF childByAppendingPath:@"twitter-users"];
        Firebase *curUserRef = [twitterRef childByAppendingPath:curUserName];
        
        Firebase *followingRef = [curUserRef childByAppendingPath:@"following-users"];
        [followingRef setValue:followingUserArray withCompletionBlock:^(NSError *error, Firebase *ref) {
            [self setLoadingStatus:YES];

            if (error) {
                [self.navigationController.view makeToast:@"could not follow this user"];
                
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:followingUserArray forKey:FOLLOWING_USER_KEY];
            }
        }];
    }
}

// Save the followed user data to NSUserDefaults when the app user follow any twitterer.
- (void)addFollowedUserData:(NSString *) followedUser {
    
    NSMutableDictionary *followingDict = [[[NSUserDefaults standardUserDefaults]
                                           objectForKey:FOLLOWING_USER_LIST] mutableCopy];
    
    Firebase *ref = [FB_REF childByAppendingPath:FB_SHAKE_LISTS_KEY];
    Firebase *userRef = [ref childByAppendingPath:followedUser];
    
    [userRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSMutableArray *userDict = [[[snapshot.value objectEnumerator] allObjects] mutableCopy];
        for (NSDictionary *childDict in userDict) {
            [childDict setValue:followedUser forKey:@"username"];
        }
        [followingDict setObject:userDict forKey:followedUser];
        
        [self.navigationController.view makeToast:@"Following Successfully!"];
        [self setLoadingStatus:YES];
        [[NSUserDefaults standardUserDefaults] setObject:followingDict forKey:FOLLOWING_USER_LIST];
    }];
}

- (IBAction)discoverButtonClicked:(id)sender {
}

- (IBAction)friendsButtonClicked:(id)sender {
}

- (IBAction)youButtonClicked:(id)sender {
}

- (IBAction)menuBarItemClicked:(id)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -LMComBoxViewDelegate

-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox {
    NSLog(@"combox index : %d", index);
}

#pragma mark - Phrase tabel view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (twitterUserArray == nil) {
        return 0;
    }
    return twitterUserArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"ListCell";
    
    TwitterFeedsTableViewCell *cell = [feedsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[TwitterFeedsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSMutableDictionary *dict = [twitterUserArray objectAtIndex:indexPath.row];

    cell.indexNumberLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.userNameLabel.text = [NSString stringWithFormat:@"@%@", [dict objectForKey:@"username"]];

    int follower_number = [[dict objectForKey:@"followers"] intValue];
    NSString *follower_str = [NSString stringWithFormat:@"%d", follower_number];
    float round_f;
    if (follower_number >= pow(10, 6)) {
        round_f = (int)(roundf(follower_number/pow(10, 4))) / 100.0;
        follower_str = [NSString stringWithFormat:@"%.2fM", round_f];
    } else if (follower_number < pow(10, 6) && follower_number >= pow(10, 3)) {
        round_f = (int)(roundf(follower_number/10)) / 100.0;
        follower_str = [NSString stringWithFormat:@"%.2fK", round_f];
    }
    cell.followerNumberLabel.text = follower_str;
    cell.followButton.tag = indexPath.row;
    [cell.followButton addTarget:self action:@selector(followProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 800; // or any number based on your estimation
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

#pragma mark Textfield delegate.

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField.tag == search_field_tag) {
        NSLog(@"Please search");
        
        if ([textField.text isEqualToString:@""]) {
            [self.navigationController.view makeToast:@"Please fill out the search field"];
            
        } else {
            // Search the twitterers.
            [self searchTwitterers:textField.text];
        }
    }
    
    return YES;
}

@end
