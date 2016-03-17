//
//  AccountSettingViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 3/9/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "AccountSettingTableViewCell.h"
#import <Firebase/Firebase.h>
#import <TwitterKit/TwitterKit.h>
#import "UIView+Toast.h"
#import "Define.h"

@interface AccountSettingViewController ()

@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.accountImageView.clipsToBounds = YES;
    self.accountImageView.layer.cornerRadius = 50;
    
    socialLoginInfo = [[NSUserDefaults standardUserDefaults] objectForKey:SOCIAL_LOGIN_KEY];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginTwitterOAuth {

    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            NSLog(@"signed twitter user id : %@", [session userID]);
            
            [self.navigationController.view makeToast:@"Logged in successfully!"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"twitter" forKey:SOCIAL_LOGIN_KEY];
            [self.profileTableView reloadData];
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
            [self.navigationController.view makeToast:@"Twitter Login Error"];
        }
    }];
}

- (IBAction)backbarItemClicked:(id)sender {
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:HOME_SCREEN_VIEWID];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Phrase tabel view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"ListCell";
    
    AccountSettingTableViewCell *cell = [self.profileTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[AccountSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_KEY];
    emailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_ADDRESS_KEY];
    if (emailAddress == nil) {
        emailAddress = [NSString stringWithFormat:@"%@@gmail.com", userName];
    }
    
    cell.titleLabel.text = ACCOUNT_SETTING_ARRAY[indexPath.row];
    cell.confirmFlagImageView.hidden = YES;
    cell.titleValueLabel.text = emailAddress;
    cell.titleValueLabel.hidden = NO;
    
    if (indexPath.row == 0) {
        cell.titleValueLabel.text = userName;
    }
    if (indexPath.row >= 2) {
        cell.titleValueLabel.hidden = YES;
    }
    
    socialLoginInfo = [[NSUserDefaults standardUserDefaults] objectForKey:SOCIAL_LOGIN_KEY];
    if (indexPath.row == 4 && [socialLoginInfo isEqualToString:@"twitter"]) {
        cell.confirmFlagImageView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"ListCell";
    
    AccountSettingTableViewCell *cell = [self.profileTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[AccountSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case 3:
            // Create facebook login.
            break;
        case 4:
            // Create twitter login.
            if (![socialLoginInfo isEqualToString:@"twitter"]) {
                [self loginTwitterOAuth];
            }
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 2) {
        return 55;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 800; // or any number based on your estimation
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
