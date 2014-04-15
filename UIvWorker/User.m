//
//  User.m
//  UIvWorker
//
//  Created by user on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize ID;
@synthesize FacebookID;
@synthesize FullName;
@synthesize Picture;
@synthesize PictureURL;

+(User*)GenerateByName:(NSString *)Name
{
    
    User* u1 = [[User alloc] init];
    if ([Name isEqualToString:@"Roey"])
    {
        u1.FacebookID = @"783084822";
        u1.FullName = @"Roey Lehman";
        u1.PictureURL = @"https://fbcdn-sphotos-a.akamaihd.net/hphotos-ak-ash4/230857_6905259822_783084822_283959_3552_n.jpg";
        u1.Picture = nil;
    }
    if ([Name isEqualToString:@"Yaron"])
    {
        u1.FacebookID = @"783084822";
        u1.FullName = @"Yaron David";
        u1.PictureURL = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/157806_1650845822_1396065775_n.jpg";
        u1.Picture = nil;
    }
    if ([Name isEqualToString:@"Amir"])
    {
        u1.FacebookID = @"783084822";
        u1.FullName = @"Amir Reiner";
        u1.PictureURL = @"https://fbcdn-sphotos-a.akamaihd.net/hphotos-ak-ash4/309459_250020265034281_100000789282632_605607_1229353424_n.jpg";
        u1.Picture = nil;
    }
    if ([Name isEqualToString:@"Tzach"])
    {
        u1.FacebookID = @"783084822";
        u1.FullName = @"Tzach Nahmany";
        u1.PictureURL = @"https://fbcdn-sphotos-a.akamaihd.net/hphotos-ak-snc7/383721_10150430949070340_792590339_8471976_515094439_n.jpg";
        u1.Picture = nil;
    }
    return u1;
}

@end
