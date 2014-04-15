//
//  EventTypeBase.m
//  UIvWorker
//
//  Created by Lion User on 25/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeBase.h"

@implementation EventTypeBase
@synthesize eventTime, eventUser, aContentTypes;

+(EventTypeBase*)GenerateByMinute:(int)Minute andSecond:(int)Second

{
    return nil;//not meant to be called!
}

+(NSMutableArray*)GenerateByMinute:(int)Minute
{
    return nil;
}

+(NSString*)EventTypeEnumToString:(int)ETEnum
{
    switch (ETEnum) {
        case 0:
            return @"EventTypeIntroduction";
            break;
        case 1:
            return @"EventTypeComment";
            break;
        case 2:
            return @"EventTypeCoupon";
            break;
        case 3:
            return @"EventTypeSong";
            break;
        case 4:
            return @"EventTypeBiography";
            break;
        default:
            break;
    }
    return nil;
}

@end
