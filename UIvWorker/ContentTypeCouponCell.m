//
//  ContentTypeCouponCell.m
//  UIvWorker
//
//  Created by user on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentTypeCouponCell.h"

@implementation ContentTypeCouponCell

@synthesize ivCouponPicture;
@synthesize lblCouponDescription;

- (int)getCellHeight
{
    return 168;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
