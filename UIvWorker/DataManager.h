//
//  DataManager.h
//  UIvWorker
//
//  Created by user on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//this is the DAL responsible for retrieving and saving the various content objects needed by the application.
//the actual data layer is a webservice, but might be anything.

#import <Foundation/Foundation.h>
#import "ContentTypesAll.h"
#import "FacebookManager.h"

@class WebServiceManager;

@interface DataManager : NSObject
{
    WebServiceManager* wsManager;
}

+ (DataManager *)sharedSingleton;

-(NSMutableArray*)GetAllContentTypesByContentID:(NSString*)ContentID;
-(NSArray*)GetAllViewedContentIDsByUserID:(NSString*)UserID;
-(NSArray*)GetAllContentTypeCouponsByUserID:(NSString*)UserID;
//returns array of Users
-(NSMutableArray*)GetAllWatchingUserIdByContentId:(NSString*)ContentID;
-(NSMutableArray*)GetVideosByContentId:(NSString*)ContentID;

//for events - get array of EventTypeBase of events for minute X in the broadcast
-(NSMutableArray*)GetEventsForContentId:(NSString*)ContentID ForMinute:(int)Minute;

-(bool)AddContentIDViewedByUserID:(NSString*)ContentID UserID:(NSString*)UserID;
-(bool)AddContentTypeCouponUnlockedByUserID:(ContentTypeCoupon*)Coupon UserID:(NSString*)UserID;


@end
