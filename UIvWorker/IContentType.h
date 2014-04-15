//
//  IContentType.h
//  UIvWorker
//
//  Created by user on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol IContentType <NSObject>

+(id<IContentType>) GenerateByID:(NSString*) Id;
+(NSString*) GetCellIdentifier;
@end