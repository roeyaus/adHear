//
//  CouponDetailsViewController.m
//  UIvWorker
//
//  Created by Lion User on 13/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CouponDetailsViewController.h"

@interface CouponDetailsViewController ()

@end

@implementation CouponDetailsViewController
@synthesize ivCouponDetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setIvCouponDetails:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
