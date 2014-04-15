//
//  ContentTypeVideos.h
//  UIvWorker
//
//  Created by user on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentTypesAll.h"

@interface ContentTypeVideo : NSObject <IContentType>

@property int ID;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSString* Description;
@property (strong, nonatomic) NSString* URLToThumbnail;
@property (strong, nonatomic) NSString* URL;

+(id<IContentType>) GenerateByID:(NSString*) Id;
+(NSString*) GetCellIdentifier;
@end
