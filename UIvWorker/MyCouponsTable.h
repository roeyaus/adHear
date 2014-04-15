//
//  MyCouponsTable.h
//  UIvWorker
//
//  Created by Roey L on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponsTable : UITableViewController
-(void)HandleNewCoupon(NSstring* Id);
@property (assign, nonatomic) int numOfNewCoupons;
@property (assign, nonatomic) int numOfCoupons;
@end
