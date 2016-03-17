//
//  Define.h
//  ShakeLists
//
//  Created by Software Superstar on 3/5/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#ifndef Define_h
#define Define_h

#define TOP_TWITTERERS_LIMIT 10
#define TWITTER_FEEDS_LIMIT 20
#define TIME_STAMP (long)([[NSDate date] timeIntervalSince1970]*1000)

// Storyboard viewcontroller indentifiers

#define ACCOUNT_SETTING_VIEWID @"settingViewController"
#define NEW_SHAKELIST_VIEWID @"NewShakeListController"
#define MY_SHAKELIST_VIEWID @"MyShakeListController"
#define HOME_SCREEN_VIEWID @"homeViewController"
#define EMAIL_REGISTER_VIEWID @"emailRegisterViewController"
#define TWITTER_FEEEDS_VIEWID @"twitterFeedsViewController"
#define SEARCH_SHAKELIST_VIEWID @"SearchShakeListViewController"
#define SHAKELIST_PREVIEW_VIEWID @"PreviewModalViewController"
#define EMAIL_LOGIN_VIEWID @"emailLoginViewController"
#define MY_NAVIGATION_VIEWID @"contentController"
#define LOGIN_HOME_VIEWID @"loginHomeController"
#define MENU_VIEWID @"menuController"

// NSUserDefaults Keys

#define MY_SHAKE_LIST @"MY_SHAKE_LIST"
#define FOLLOWING_USER_LIST @"FOLLOWING_USER_LIST" 
#define USER_NAME_KEY @"USER_NAME_KEY"
#define EMAIL_ADDRESS_KEY @"EMAIL_ADDRESS_KEY"
#define SELECTED_SHAKE_KEY @"SELECTED_SHAKE_KEY"
#define SHAKE_EDIT_KEY @"SHAKE_EDIT_KEY"
#define SOCIAL_LOGIN_KEY @"SOCIAL_LOGIN_KEY"
#define FOLLOWING_USER_KEY @"FOLLOWING_USER_KEY"

// Introduction page info
#define PAGE_1_TITLE @"Welcome to ...."
#define PAGE_2_TITLE @"Make A List!"
#define PAGE_3_TITLE @"Take A List!";
#define PAGE_4_TITLE @"Shake A List!"

#define PAGE_1_DESC @"Pellentesque vel aliquet sem, at suscipit nisi. Donec at nibh. Curabitur placerat mi eu mauris pellentesque conque."
#define PAGE_2_DESC @"Creating a new list is simple..."
#define PAGE_3_DESC @"It's a big world! See what others are shaking!"
#define PAGE_4_DESC @"Pair a ... and get shaking!"

// Alert Message
#define LOGIN_CONFIRM_MSG @"You haven't a twitter login. You can create a new twitter login. \n Do you want to create a twitter login for the app?"

// Firebase Keys

#define FB_REF [[Firebase alloc] initWithUrl: @"https://shakelist1.firebaseio.com"]
#define FB_TWITTER_USER_KEY @"twitter-users"
#define FB_SHAKE_LISTS_KEY @"shake-lists"

// Menu Arrays

#define MENU_TITLES @[@"Home", @"My Activity", @"My ShakeLists", @"Ball Pairing", @"Settings", @"Find Friends", @"Twitter Feeds", @"About", @"Help"]
#define ACTIVITIES_PER_MENU @[@"homeViewController", @"MyShakeListController", @"MyShakeListController", @"homeViewController", @"settingViewController", @"homeViewController", @"twitterFeedsViewController", @"homeViewController", @"homeViewController"]
#define ACCOUNT_SETTING_ARRAY @[@"Name", @"Email", @"Password", @"Facebook", @"Twitter"]

// Twitter API

#define TWITTER_API_KEY @"lY8FRwr0f9oN8riDoYCPAxsT7"
#define TWITTER_API_SECRET @"ekHkE2DDautB8BOlOFgO5ZCMogfYsUi5YKVOUZY4yycTs7PdlZ"

#endif /* Define_h */