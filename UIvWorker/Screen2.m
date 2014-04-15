//
//  Screen2.m
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Screen2.h"
#import "AppDelegate.h"

@implementation Screen2
@synthesize CountdownAnimation, parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
       // appDelegate.tabBarController
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self startTimer]; // this method sets up the timer and animation.
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCountdownAnimation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)CancelButton:(id)sender {
    [timer invalidate];
    [self dismissModalViewControllerAnimated:NO];
}

-(void) startTimer {
    // Here the animation frames are loaded into the animation object.
    CountdownAnimation.animationImages = [NSArray arrayWithObjects:    
                                          [UIImage imageNamed:@"first.png"],
                                          [UIImage imageNamed:@"second.png"],
                                          nil];
    // all frames will execute in 3 seconds
    CountdownAnimation.animationDuration = 3;
    // repeat the annimation forever
    CountdownAnimation.animationRepeatCount = 1;
    // start animating
    [CountdownAnimation startAnimating];
    //timer is set up.
    timer = [NSTimer scheduledTimerWithTimeInterval:3.
                                     target:self
                                   selector:@selector(countdownFinish)
                                   userInfo:nil
                                    repeats:NO];
}

-(void) countdownFinish {
    //parent screen is switched

    [self dismissModalViewControllerAnimated:NO];
}


@end
