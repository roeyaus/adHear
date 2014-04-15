//
//  EventTypeCoupon.h
//  UIvWorker
//
//  Created by Lion User on 09/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeBase.h"

@class ContentTypeCoupon;

@interface EventTypeCoupon : EventTypeBase
{
    
}

@property (strong, nonatomic) ContentTypeCoupon* eventCoupon;
-(EventTypeCoupon*)initWithTime:(EventTime)Time andCoupon:(ContentTypeCoupon*)Coupon;
+(NSMutableArray*)GenerateByMinute:(int)Minute andSecond:(int)Second andID:(NSString*)ID;

@end
