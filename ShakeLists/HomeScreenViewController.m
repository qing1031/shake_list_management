//
//  HomeScreenViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 3/7/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "HomeScreenViewController.h"
#import <Firebase/Firebase.h>
#import "Define.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    // Check the twitter login status.
    // Save this user to twitter users of firebase.
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_KEY];
    
    // Search the following users of the current user from firebase.
    NSString *socialLoginInfo = [[NSUserDefaults standardUserDefaults] objectForKey:SOCIAL_LOGIN_KEY];
    NSObject *followingUsers = [[NSUserDefaults standardUserDefaults] objectForKey:FOLLOWING_USER_KEY];
    if ([socialLoginInfo isEqualToString:@"twitter"] && followingUsers == nil) {
        
        Firebase *twitterRef = [FB_REF childByAppendingPath:FB_TWITTER_USER_KEY];
        Firebase *userRef = [twitterRef childByAppendingPath:userName];
        Firebase *followingRef = [userRef childByAppendingPath:@"following-users"];
        
        [followingRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSArray *ary = snapshot.value;
            NSLog(@"%@", ary);
            if (ary == nil || ary == (id)[NSNull null]) {
                ary = [NSArray array];
            }
            [[NSUserDefaults standardUserDefaults] setObject:ary forKey:FOLLOWING_USER_KEY];
            NSLog(@"s %@", [[NSUserDefaults standardUserDefaults] objectForKey:FOLLOWING_USER_KEY]);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createButtonClicked:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"create" forKey:SHAKE_EDIT_KEY];
}

- (IBAction)takeButtonClicked:(id)sender {
}

- (IBAction)inviteButtonClicked:(id)sender {
}

- (IBAction)menuBarItemClicked:(id)sender {

    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

@end