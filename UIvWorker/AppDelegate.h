//
//  AppDelegate.h
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordingView, ContentDetailsView, MyContentView, MyCouponsTable, Facebook, FacebookDelegate, AccountSettingsView;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    RecordingView *RecordViewController;
    AccountSettingsView *accountSettingsView; // 2 and 3 are view controllers for future tabs.
    MyContentView *myContentView;
    ContentDetailsView *viewController4;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
