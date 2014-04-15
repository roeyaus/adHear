//
//  Screen2.h
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordingView.h"

@interface Screen2 : UIViewController
{
    NSTimer *timer;
}

-(void) startTimer;
-(void) countdownFinish;
- (IBAction)CancelButton:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *CountdownAnimation;
@property (assign, nonatomic) RecordingView *parent;

@end
