//
//  EventTypeBiography.h
//  UIvWorker
//
//  Created by Lion User on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeBase.h"
@class ContentTypeBiography;

@interface EventTypeBiography : EventTypeBase


-(EventTypeBiography*)initWithTime:(EventTime)Time;
+(NSMutableArray*)GenerateByMinute:(int)Minute andSecond:(int)Second;

@end
