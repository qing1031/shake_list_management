//
//  TwitterFeedsViewController.h
//  ShakeLists
//
//  Created by Software Superstar on 3/8/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"
#import "REFrostedViewController.h"

@interface TwitterFeedsViewController : UIViewController<LMComBoxViewDelegate, UITextFieldDelegate> {
    
    NSMutableArray *twitterUserArray;
    NSMutableArray *followingUserArray;
    NSString *userName;
    
    __weak IBOutlet UIView *sortByComboBox;
    __weak IBOutlet UITableView *feedsTableView;
}

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIButton *discoverButton;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UIButton *youButton;

- (IBAction)discoverButtonClicked:(id)sender;
- (IBAction)friendsButtonClicked:(id)sender;
- (IBAction)youButtonClicked:(id)sender;
- (IBAction)menuBarItemClicked:(id)sender;

@end
