//
//  EventTypeBase.h
//  UIvWorker
//
//  Created by Lion User on 25/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef struct EventTime
{
    int Minute;
    int Second;
    
} EventTime;


//Event data models describe events occuring at a specified time within a broadcast.
//It does NOT describe what the 
//Do not instantiate! use one of the EventTypes instead
@interface EventTypeBase : NSObject

@property  EventTime eventTime;
@property  (strong, nonatomic) User* eventUser;
@property  (strong, nonatomic) NSMutableArray* aContentTypes;

+(EventTypeBase*)GenerateByMinute:(int)Minute andSecond:(int)Second;
//generate array of events for the specified minutes
+(NSMutableDictionary*)GenerateByMinute:(int)Minute;
+(NSString*)EventTypeEnumToString:(int)ETEnum;
@end
