//
//  TwitterFeedsTableViewCell.h
//  ShakeLists
//
//  Created by Software Superstar on 3/8/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterFeedsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *indexNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@end
