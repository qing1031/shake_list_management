//
//  MyShakeListViewController.h
//  ShakeLists
//
//  Created by Software Superstar on 2/23/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"
#import "REFrostedViewController.h"

@interface MyShakeListViewController : UIViewController<LMComBoxViewDelegate> {
    
    NSInteger list_count;
    NSString *userName;
    NSMutableArray *followingUserAry;
}

@property (weak, nonatomic) IBOutlet UITableView *shakeListTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIView *comboxView;
@property (weak, nonatomic) IBOutlet UILabel *sortByLabel;
@property (nonatomic, strong) NSMutableArray *listMutableArray;
@property (nonatomic, strong) NSMutableArray *followingListMutableArray;

- (IBAction)menuClicked:(id)sender;
- (IBAction)createNewShakeList:(id)sender;

@end
