//
//  FacebookManager.m
//  UIvWorker
//
//  Created by user on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookManager.h"
#import "Facebook.h"

@implementation FacebookManager 

@synthesize facebook;

-(id)init
{
    if (self = [super init])
    {
        //initialize facebook interface
        
        facebook = [[Facebook alloc] initWithAppId:@"291656724221978" andDelegate: self];
    }
    return self;
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSDictionary *dictionaryJSON = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
    
    void(^block)(id result, NSError* error) = [[request params] objectForKey:@"result"];
    block(result, nil);
    
}

-(void)GetPictureByUserID:(int)UserId withCompleteHandler:(void(^)(id result, NSError* error))block
{

    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
     
    FBRequest* request = [facebook requestWithGraphPath:@"https://graph.facebook.com/me?fields=name,id,picture" andParams:dictionary andDelegate:self];
     [[request params] setObject:block forKey:@"result"];
}


@end
