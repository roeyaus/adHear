//
//  MyCouponsScreen.h
//  UIvWorker
//
//  Created by Roey L on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentTypeGeneral;

@interface MyContentView : UIViewController  <UITableViewDelegate, UITableViewDataSource>
{
    int contentIterator;
}

- (IBAction)SegmentedControlTouched:(id)sender;

- (void)HandleNewContent:(ContentTypeGeneral*) content;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollingView;
@property (weak, nonatomic) IBOutlet UITableView *CouponTable;
@property (assign, nonatomic) int numOfNewContent;
@property (assign, nonatomic) int numOfContent;
@property (strong , nonatomic) NSMutableArray* ContentArray;

@end
