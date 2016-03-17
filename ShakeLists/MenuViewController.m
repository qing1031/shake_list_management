//
//  MenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MenuViewController.h"
#import "MyShakeListViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedContainerViewController.h"
#import "MyNavigationViewController.h"
#import <Firebase/Firebase.h>
#import <TwitterKit/TwitterKit.h>
#import "LoginHomeViewController.h"
#import "Define.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyNavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:MY_NAVIGATION_VIEWID];
    NSArray *IDs = ACTIVITIES_PER_MENU;
    
    if (indexPath.section == 0) {
        controllerID = IDs[indexPath.row];
        
        if ([controllerID isEqualToString:@"twitterFeedsViewController"]) {
            
            NSString *socialLoginInfo = [[NSUserDefaults standardUserDefaults] objectForKey:SOCIAL_LOGIN_KEY];
            
            if (![socialLoginInfo isEqualToString:@"twitter"]) {
                controllerID = @"homeViewController";
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Login Message"
                                                      message:LOGIN_CONFIRM_MSG
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction = [UIAlertAction
                                            actionWithTitle:@"YES"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                // here code.
                                                NSLog(@"Go to twitter login creation page.");
                                                controllerID = ACCOUNT_SETTING_VIEWID;
                                                UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:controllerID];
                                                navigationController.viewControllers = @[controller];
                                            }];
                [alertController addAction:yesAction];

                UIAlertAction *noAction = [UIAlertAction
                                           actionWithTitle:@"NO"
                                           style:UIAlertActionStyleCancel
                                           handler:nil];
                [alertController addAction:noAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
        }

        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:controllerID];
        navigationController.viewControllers = @[controller];
        
    } else {
        NSLog(@"Logout");
        
        // Logout the account.
        [FB_REF unauth];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_NAME_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:EMAIL_ADDRESS_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FOLLOWING_USER_LIST];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:MY_SHAKE_LIST];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SELECTED_SHAKE_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SHAKE_EDIT_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SOCIAL_LOGIN_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FOLLOWING_USER_KEY];
        
        TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
        NSString *userID = store.session.userID;
        
        [store logOutUserID:userID];

        LoginHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:LOGIN_HOME_VIEWID];
        [self.navigationController pushViewController:homeViewController animated:YES];
    }
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
        return 8;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = MENU_TITLES;
        cell.textLabel.text = titles[indexPath.row];
    } else {
        cell.textLabel.text = @"Logout";
    }
    
    return cell;
}
 
@end
