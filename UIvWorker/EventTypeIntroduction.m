//
//  EventTypeIntroduction.m
//  UIvWorker
//
//  Created by Lion User on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeIntroduction.h"
#import "ContentTypesAll.h"

@implementation EventTypeIntroduction

+(NSMutableArray*)GenerateByMinute:(int)Minute andSecond:(int)Second
{
    EventTime time;
    time.Minute = Minute;
    time.Second = Second;
    NSMutableArray* aEvents = [[NSMutableArray alloc] init];
    EventTypeIntroduction* intro = [[EventTypeIntroduction alloc] initWithTime:time];
    [intro.aContentTypes addObject:[ContentTypeGeneral GenerateByID:@"1"]];
    [intro.aContentTypes addObject:[ContentTypeFriend GenerateByID:@"1"]];
    [intro.aContentTypes addObject:[ContentTypeVideo GenerateByID:@"1"]];
    [aEvents addObject:intro];
    return aEvents;
}

-(EventTypeIntroduction*)initWithTime:(EventTime)Time
{
    self = [super init];
    if (self)
    {
        self.eventTime = Time;
        self.aContentTypes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+(NSMutableDictionary*)GenerateByMinute:(int)Minute
{
    NSMutableDictionary* dicEvents = [[NSMutableDictionary alloc] init];
    
    [dicEvents setObject:[self GenerateByMinute:0 andSecond:1] forKey:[NSNumber numberWithInt:1]];
    
    return dicEvents;
}

@end
