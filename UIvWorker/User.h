//
//  User.h
//  UIvWorker
//
//  Created by user on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property int ID;
@property (strong, nonatomic) NSString* FacebookID;
@property (strong, nonatomic) NSString* FullName;
@property (strong, nonatomic) NSString* PictureURL;
@property (strong, nonatomic) UIImage* Picture;

+(User*)GenerateByName:(NSString*)Name;



@end
