//
//  AccountSettingsView.h
//  UIvWorker
//
//  Created by user on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSettingsView : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;
- (IBAction)btnFBLogin_TouchedUpInside:(id)sender;

@end
