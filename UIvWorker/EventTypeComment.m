//
//  EventTypeComment.m
//  UIvWorker
//
//  Created by Lion User on 25/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeComment.h"
#import "EventTypeBase.h"
#import "User.h"

@implementation EventTypeComment
@synthesize eventComment;

-(EventTypeComment*)initWithTime:(EventTime)Time User:(User*)User Comment:(NSString*) Comment
{
    self = [super init];
    if (self)
    {
        self.eventTime = Time;
        self.eventUser = User;
        self.eventComment = Comment;
    }
    
    return self;
}

+(NSMutableArray*)GenerateByMinute:(int)Minute andSecond:(int)Second andName:(NSString*)UserName andComment:(NSString*)Comment
{
    User* u = [User GenerateByName:UserName];
    EventTime time;
    time.Minute = Minute;
    time.Second = Second;
    NSMutableArray* aEvents = [[NSMutableArray alloc] init];
    [aEvents addObject:[[EventTypeComment alloc] initWithTime:time User:u Comment:Comment]];
    
    //User* u1 = [User GenerateByName:UserName];
    //[aEvents addObject:[[EventTypeComment alloc] initWithTime:time User:u1 Comment:@"Second comment in this second"]];
    return aEvents;
    
}

+(NSMutableDictionary*)GenerateByMinute:(int)Minute
{
    NSMutableDictionary* dicEvents = [[NSMutableDictionary alloc] init];
    if (Minute == 0)
    {
    [dicEvents setObject:[self GenerateByMinute:0 andSecond:5 andName:@"Roey" andComment:@"אחלה פרק"] forKey:[NSNumber numberWithInt:5]];
    }
    if (Minute == 2)
    {
        [dicEvents setObject:[self GenerateByMinute:2 andSecond:40 andName:@"Yaron" andComment:@"אני מעדיף את סין.."] forKey: [NSNumber numberWithInt:40]];
        [dicEvents setObject:[self GenerateByMinute:2 andSecond:32 andName:@"Amir" andComment:@"איך הייתי טס לשם עכשיו.."] forKey:[NSNumber numberWithInt:32]];
    }
    return dicEvents;
}



@end
