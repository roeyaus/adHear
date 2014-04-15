//
//  ContentTypeGeneral.h
//  UIvWorker
//
//  Created by user on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IContentType.h"

@interface ContentTypeGeneral : NSObject <IContentType>

+(id<IContentType> )GenerateByID:(NSString *)Id;

@property  (strong, nonatomic) NSString* Id;
@property (strong, nonatomic) NSString* Title;
@property (strong, nonatomic) NSString* Description;
@property (strong, nonatomic) NSString* Cast;
@property (strong, nonatomic) UIImage* Picture;
+(NSString*) GetCellIdentifier;
@end
