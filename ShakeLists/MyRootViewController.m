//
//  MyRootViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 3/4/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "MyRootViewController.h"
#import "Define.h"

@interface MyRootViewController ()

@end

@implementation MyRootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:MY_NAVIGATION_VIEWID];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:MENU_VIEWID];
}

@end
