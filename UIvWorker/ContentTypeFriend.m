//
//  ContentTypeFriends.m
//  UIvWorker
//
//  Created by user on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentTypeFriend.h"

@implementation ContentTypeFriend

@synthesize aFriendsIDs;

+(id<IContentType>) GenerateByID:(NSString*) Id
{
    ContentTypeFriend* ctf = [[ContentTypeFriend alloc] init];
    NSMutableArray* friends = [[NSMutableArray alloc] initWithCapacity:3];
    [friends addObject:[NSNumber numberWithInt:1]];
    [friends addObject:[NSNumber numberWithInt:2]];
    [friends addObject:[NSNumber numberWithInt:3]];
    ctf.aFriendsIDs = friends;
    
    return ctf;
}

+(NSString*) GetCellIdentifier
{
    return @"FriendsCell";
}
@end
