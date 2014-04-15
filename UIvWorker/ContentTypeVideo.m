//
//  ContentTypeVideos.m
//  UIvWorker
//
//  Created by user on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentTypeVideo.h"

@implementation ContentTypeVideo

@synthesize ID;
@synthesize Name;
@synthesize Description;
@synthesize URLToThumbnail;
@synthesize URL;


+(id<IContentType>) GenerateByID:(NSString*) Id
{
    ContentTypeVideo* ctv = [[ContentTypeVideo alloc] init];
    if ([Id isEqualToString:@"1"])
    {
  
    ctv.ID = 1;
    ctv.Name = @"אורן ואלון, האודישן";
    ctv.Description = @"אורן ואלון, נא להכיר!";
    ctv.URLToThumbnail = @"http://i1.ytimg.com/vi/XZV3gSPm5jw/default.jpg";
    ctv.URL = @"http://www.youtube.com/watch?v=XZV3gSPm5jw";
    }
    if ([Id isEqualToString:@"2"])
    {
        
        ctv.ID = 2;
        ctv.Name = @"אורן ואלון - נפל בעריכה";
        ctv.Description = @"אורן ואלון בקטע נדיר";
        ctv.URLToThumbnail = @"http://i2.ytimg.com/vi/yrl6J3CZYpU/default.jpg";
        ctv.URL = @"http://www.youtube.com/watch?v=yrl6J3CZYpU";
    }
    return ctv;
}

+(NSString*) GetCellIdentifier
{
    return @"VideoCell";
}

@end
