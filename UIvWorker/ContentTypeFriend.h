//
//  ContentTypeFriends.h
//  UIvWorker
//
//  Created by user on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentTypesAll.h"

@interface ContentTypeFriend : NSObject <IContentType>
{

}

@property  (strong, nonatomic) NSMutableArray* aFriendsIDs;

+(id<IContentType>) GenerateByID:(NSString*) Id;
+(NSString*) GetCellIdentifier;
@end
