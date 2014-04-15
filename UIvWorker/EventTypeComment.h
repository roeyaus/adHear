//
//  EventTypeComment.h
//  UIvWorker
//
//  Created by Lion User on 25/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeBase.h"
@class User;

@interface EventTypeComment : EventTypeBase


@property (strong, nonatomic) NSString* eventComment;

-(EventTypeComment*)initWithTime:(EventTime)Time User:(User*)User Comment:(NSString*) Comment;
//Generates events for a specific minute and second. They are kept in an array in order of appearance.
+(NSMutableArray*)GenerateByMinute:(int)Minute andSecond:(int)Second andName:(NSString*)Name andComment:(NSString*)Comment;
//Generates events for a specific minute, sorted in a dictionary by second. (since there are seconds with no events)
+(NSMutableDictionary*)GenerateByMinute:(int)Minute;

@end
