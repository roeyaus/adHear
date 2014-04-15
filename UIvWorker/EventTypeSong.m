//
//  EventTypeSong.m
//  UIvWorker
//
//  Created by Lion User on 11/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeSong.h"
#import "ContentTypeVideo.h"

@implementation EventTypeSong

-(EventTypeSong*)initWithTime:(EventTime)Time
{
    self = [super init];
    if (self)
    {
        self.eventTime = Time;
        self.aContentTypes = [[NSMutableArray alloc] init];
    }
   
    return self;
}

+(NSMutableArray*)GenerateByMinute:(int)Minute andSecond:(int)Second
{
    EventTime time;
    time.Minute = Minute;
    time.Second = Second;
    NSMutableArray* aEvents = [[NSMutableArray alloc] init];
    EventTypeSong* song = [[EventTypeSong alloc] initWithTime:time];
    [song.aContentTypes addObject:[ContentTypeSong GenerateByID:@"1"]];
    [song.aContentTypes addObject:[ContentTypeVideo GenerateByID:@"1"]];
    [aEvents addObject:song];
    return aEvents;
}

+(NSMutableDictionary*)GenerateByMinute:(int)Minute
{
    NSMutableDictionary* dicEvents = [[NSMutableDictionary alloc] init];
    [dicEvents setObject:[self GenerateByMinute:0 andSecond:4] forKey:[NSNumber numberWithInt:4]];
    
    return dicEvents;
}

@end
