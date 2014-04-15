//
//  ContentTypeGeneralCell.m
//  UIvWorker
//
//  Created by user on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentTypeGeneralCell.h"

@implementation ContentTypeGeneralCell
@synthesize ivPicture;
@synthesize lblContentName;
@synthesize lblContentDescription;
@synthesize lblContentCast;



#pragma mark - View lifecycle

-(int)getCellHeight
{
    return 263;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
