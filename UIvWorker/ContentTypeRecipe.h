//
//  ContentTypeRecipe.h
//  UIvWorker
//
//  Created by Lion User on 19/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IContentType.h"

@interface ContentTypeRecipe : NSObject <IContentType>


@property NSString* ID;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSString* Description;
@property (strong, nonatomic) NSString* Ingredients;
@property (strong, nonatomic) NSString* PreparationSteps; 
@property (strong, nonatomic) UIImage*  Picture;

+(id<IContentType>) GenerateByID:(NSString*) Id;
+(NSString*) GetCellIdentifier;

@end
