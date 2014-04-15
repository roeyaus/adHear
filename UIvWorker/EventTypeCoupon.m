//
//  EventTypeCoupon.m
//  UIvWorker
//
//  Created by Lion User on 09/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeCoupon.h"
#import "ContentTypeCoupon.h"

@implementation EventTypeCoupon
@synthesize eventCoupon;

-(EventTypeCoupon*)initWithTime:(EventTime)Time andCoupon:(ContentTypeCoupon*)Coupon
{
    self = [super init];
    if (self)
    {
        self.eventTime = Time;
        self.eventCoupon = Coupon;
    }
    
    
    
    return self;
}

+(NSMutableArray*)GenerateByMinute:(int)Minute andSecond:(int)Second andID:(NSString*)ID
{
    EventTime time;
    time.Minute = Minute;
    time.Second = Second;
    NSMutableArray* aEvents = [[NSMutableArray alloc] init];
    [aEvents addObject:[[EventTypeCoupon alloc] initWithTime:time andCoupon:[ContentTypeCoupon GenerateByID:ID]]];
    

    return aEvents;
    
}

+(NSMutableDictionary*)GenerateByMinute:(int)Minute
{
    NSMutableDictionary* dicEvents = [[NSMutableDictionary alloc] init];
    if (Minute == 2)
    {
        [dicEvents setObject:[self GenerateByMinute:2 andSecond:58 andID:@"1"] forKey:[NSNumber numberWithInt:58]];
    }
    return dicEvents;
}
@end
