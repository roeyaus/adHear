//
//  ContentTypeBiography.h
//  UIvWorker
//
//  Created by Lion User on 24/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IContentType.h"

@interface ContentTypeBiography : NSObject <IContentType>
+(id<IContentType> )GenerateByID:(NSString *)Id;

@property (strong, nonatomic) UIImage* Picture;
@property (strong, nonatomic) NSString* FullName;
@property (strong, nonatomic) NSString* Summary;
@property (strong, nonatomic) NSString* Biography;
+(NSString*) GetCellIdentifier;
@end
