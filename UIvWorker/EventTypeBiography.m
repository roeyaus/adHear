//
//  EventTypeBiography.m
//  UIvWorker
//
//  Created by Lion User on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeBiography.h"
#import "ContentTypeVideo.h"
#import "ContentTypeBiography.h"

@implementation EventTypeBiography

+(NSMutableArray*)GenerateByMinute:(int)Minute andSecond:(int)Second
{
    EventTime time;
    time.Minute = Minute;
    time.Second = Second;
    NSMutableArray* aEvents = [[NSMutableArray alloc] init];
    EventTypeBiography* bio = [[EventTypeBiography alloc] initWithTime:time];
    
    if (Minute == 2 && Second == 19)
    {
        [bio.aContentTypes addObject:[ContentTypeBiography GenerateByID:@"1"]];
        [bio.aContentTypes addObject:[ContentTypeVideo GenerateByID:@"1"]];
        [bio.aContentTypes addObject:[ContentTypeVideo GenerateByID:@"2"]];
    }
    if (Minute == 2 && Second == 30)
    {
        [bio.aContentTypes addObject:[ContentTypeBiography GenerateByID:@"2"]];
    }
    [aEvents addObject:bio];
    return aEvents;
}

-(EventTypeBiography*)initWithTime:(EventTime)Time
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
    if (Minute == 2)
    {
        [dicEvents setObject:[self GenerateByMinute:2 andSecond:19] forKey:[NSNumber numberWithInt:19]];
        [dicEvents setObject:[self GenerateByMinute:2 andSecond:30] forKey:[NSNumber numberWithInt:30]];
    }
    return dicEvents;
}
                               
                               
@end
