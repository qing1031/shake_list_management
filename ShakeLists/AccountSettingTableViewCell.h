//
//  AccountSettingTableViewCell.h
//  ShakeLists
//
//  Created by Software Superstar on 3/9/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *confirmFlagImageView;

@end
