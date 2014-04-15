//
//  ContentTypeSong.h
//  UIvWorker
//
//  Created by Lion User on 30/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IContentType.h"

@interface ContentTypeSong : NSObject <IContentType>
+(id<IContentType> )GenerateByID:(NSString *)Id;

@property (strong, nonatomic) UIImage* ArtistPicture;
@property (strong, nonatomic) UIImage* AlbumPicture;
@property  (strong, nonatomic) NSString* PerformerName;
@property  (strong, nonatomic) NSString* SongName;
@property (strong, nonatomic) NSString* AlbumName;
@property (strong, nonatomic) NSString* Lyrics;

+(NSString*) GetCellIdentifier;
@end
