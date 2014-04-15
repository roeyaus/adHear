//
//  Coupon.h
//  UIvWorker
//
//  Created by Roey L on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IContentType.h"

@interface ContentTypeCoupon : NSObject <IContentType>

@property  (strong, nonatomic) NSString* Id;
@property (strong, nonatomic) NSString* Title;
@property (strong, nonatomic) NSString* Description;
@property float Price;
@property int PercentOff;
@property (strong, nonatomic) NSDate* IssueDate;
@property (strong, nonatomic) NSDate* ExpirationDate;
@property (strong, nonatomic) UIImage* Picture;
@property (strong, nonatomic) UIImage* ActualCoupon;
@property  NSInteger NumberOfBuyers;
+(id<IContentType>) GenerateByID:(NSString*) Id;
+(NSString*) GetCellIdentifier;
@end
