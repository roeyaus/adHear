//
//  EventTypeIntroduction.h
//  UIvWorker
//
//  Created by Lion User on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeBase.h"


@interface EventTypeIntroduction : EventTypeBase

-(EventTypeIntroduction*)initWithTime:(EventTime)Time;
+(NSMutableArray*)GenerateByMinute:(int)Minute andSecond:(int)Second;
@end
