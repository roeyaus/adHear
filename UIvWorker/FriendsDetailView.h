//
//  FriendsDetailView.h
//  UIvWorker
//
//  Created by user on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsDetailView : UIViewController



@property (strong, nonatomic) IBOutlet UIWebView *wvFacebookComments;
@property (weak, nonatomic) IBOutlet UIView *uvCommentView;
- (IBAction)OnUpdateButtonTouchUpInside:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfCommentURL;

- (void) loadCommentsView;

@end
