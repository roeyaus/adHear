//
//  VideosDetailView.h
//  UIvWorker
//
//  Created by user on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideosDetailView : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSMutableArray* VideosArray;

- (UIWebView*)embedYouTube:(NSString*)url withFrame:(CGRect)frame;
@end
