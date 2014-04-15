//
//  AppDelegate.m
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Facebook.h"
#import "RecordingView.h"
#import "AccountSettingsView.h"
#import "ContentDetailsView.h"
#import "MyContentView.h"
#import "FacebookDelegate.h"
#import "RealTimeFeedView.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
   

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RecordViewController = [[RecordingView alloc] initWithNibName:@"RecordingView" bundle:nil];
    myContentView = [[MyContentView alloc] initWithNibName:@"MyContentView" bundle:nil];
    RecordViewController.MyContentViewReference = myContentView;
    // view controllers t 2 and 4 are here as placeholders for future tab bars. They use the code for Tab4, so that they are included in the tab bar and their title is changed accordingly.
    accountSettingsView = [[AccountSettingsView alloc] initWithNibName:@"AccountSettingsView" bundle:nil];
  
    viewController4 = [[ContentDetailsView alloc] initWithNibName:@"ContentDetailsView" bundle:nil];
    
     
    RealTimeFeedView* rtfv = [[RealTimeFeedView alloc] initWithNibName:@"RealTimeFeedView" bundle:nil];
    RecordViewController.RealTimeFeedView = rtfv;
    UINavigationController* realtimeFeedNavController = [[UINavigationController alloc]  initWithRootViewController:rtfv];
    realtimeFeedNavController.navigationBar.tintColor = [UIColor colorWithRed:23/255.0 green:13/255.0 blue:176/255.0 alpha:1.0];
    realtimeFeedNavController.navigationBar.hidden = true;
    //recording screen navigation controller
    UINavigationController* recordingNavController = [[UINavigationController alloc]  initWithRootViewController:RecordViewController];
    
    recordingNavController.navigationBar.tintColor = [UIColor colorWithRed:23/255.0 green:13/255.0 blue:176/255.0 alpha:1.0];
    recordingNavController.navigationBar.hidden = true;
    //my coupons screen navigation controller
    UINavigationController* myCouponsNavController = [[UINavigationController alloc]  initWithRootViewController:myContentView];
    myCouponsNavController.navigationBar.tintColor = [UIColor colorWithRed:23/255.0 green:13/255.0 blue:176/255.0 alpha:1.0];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:recordingNavController, accountSettingsView, myCouponsNavController, realtimeFeedNavController, nil];
 
    UITabBarItem *tabBarItem = [[[[self tabBarController]tabBar]items] objectAtIndex:1];
    [tabBarItem setEnabled:TRUE];
    tabBarItem.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon-2" ofType: @"png"]];
    tabBarItem.title = NSLocalizedString(@"החשבון שלי", @"Tab2");
    UITabBarItem *tabBarItem2 = [[[[self tabBarController]tabBar]items] objectAtIndex:3];
    [tabBarItem2 setEnabled:TRUE];
    tabBarItem2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon-3" ofType: @"png"]];
    tabBarItem2.title = NSLocalizedString(@"הפיד שלי", @"Tab2");
    self.window.rootViewController = self.tabBarController;
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

/*-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == viewController1) {
        return YES;
    }
    if (viewController == viewController4) {
        return YES;
    }
    return NO;
}*/


@end
