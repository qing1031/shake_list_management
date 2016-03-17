//
//  AccountSettingViewController.h
//  ShakeLists
//
//  Created by Software Superstar on 3/9/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSettingViewController : UIViewController {
    NSString *socialLoginInfo;
    NSString *userName;
    NSString *emailAddress;
}
@property (weak, nonatomic) IBOutlet UIImageView *accountImageView;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

- (IBAction)backbarItemClicked:(id)sender;

@end
