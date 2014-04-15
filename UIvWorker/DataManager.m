//
//  DataManager.m
//  UIvWorker
//
//  Created by user on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "ContentTypesAll.h"
#import "WebServiceManager.h"
#import "User.h"
#import "EventTypesAll.h"

@implementation DataManager


+ (DataManager *)sharedSingleton
{
    static DataManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[DataManager alloc] init];
        
        return sharedSingleton;
    }
}

//init webservice class
-(id)init
{
    if (self = [super init])
    {
        wsManager = [[WebServiceManager alloc] init];
    }
    return self;
}


//returns a dictionary where key: contentType enum and value = IContentType object
-(NSMutableArray*)GetAllContentTypesByContentID:(NSString*)ContentID
{
    NSMutableArray* contentArray = [[NSMutableArray alloc] init];
    //commercial #1
    if ([ContentID isEqualToString:@"1"])
    {
        [contentArray addObject:(id<IContentType>)[ContentTypeGeneral GenerateByID:ContentID]];
        [contentArray addObject:(id<IContentType>)[ContentTypeCoupon GenerateByID:ContentID]];
        [contentArray addObject:(id<IContentType>)[ContentTypeFriend GenerateByID:ContentID]];
        [contentArray addObject:(id<IContentType>)[ContentTypeVideo GenerateByID:ContentID]];
        
    }
    //commercial #2
    if ([ContentID isEqualToString:@"2"])
    {
        [contentArray addObject:(id<IContentType>)[ContentTypeGeneral GenerateByID:ContentID]];
        [contentArray addObject:(id<IContentType>)[ContentTypeCoupon GenerateByID:ContentID]];
        
        //no friends watching this commercial
        //[contentArray addObject:(id<IContentType>)[ContentTypeFriend GenerateByID:ContentID]];
        
        [contentArray addObject:(id<IContentType>)[ContentTypeVideo GenerateByID:ContentID]];
        
    }
    //show #3
    if ([ContentID isEqualToString:@"3"])
    {
        [contentArray addObject:(id<IContentType>)[ContentTypeGeneral GenerateByID:ContentID]];
        //[contentArray addObject:(id<IContentType>)[ContentTypeCoupon GenerateByID:ContentID]];
        
        
        [contentArray addObject:(id<IContentType>)[ContentTypeFriend GenerateByID:ContentID]];
        
        [contentArray addObject:(id<IContentType>)[ContentTypeVideo GenerateByID:ContentID]];
        
         [contentArray addObject:(id<IContentType>)[ContentTypeRecipe GenerateByID:ContentID]];
        
    }
    return contentArray;
    
}

-(NSMutableArray*)GetAllWatchingUserIdByContentId:(NSString*)ContentID
{
    NSMutableArray* aUsers = [[NSMutableArray alloc] init];
    
    [aUsers addObject:[User GenerateByName:@"Roey"]];
    [aUsers addObject:[User GenerateByName:@"Yaron"]];
    [aUsers addObject:[User GenerateByName:@"Amir"]];
    [aUsers addObject:[User GenerateByName:@"Tzach"]];

    
    return aUsers;
}

-(NSMutableArray*)GetVideosByContentId:(NSString*)ContentID
{
    NSMutableArray* aVideos = [[NSMutableArray alloc] init];
    
    [aVideos addObject:[ContentTypeVideo GenerateByID:@"1"]];
    return aVideos;
    
}

-(NSMutableArray*)GetEventsForContentId:(NSString*)ContentID ForMinute:(int)Minute AndSecond:(int)Second
{
    NSMutableArray* aEvents = [[NSMutableArray alloc] init];
    [aEvents addObject:[EventTypeIntroduction GenerateByMinute:Minute andSecond:Second]];
    return aEvents;
}






@end
