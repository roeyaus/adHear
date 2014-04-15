//
//  ContentTypeFacebookCell.h
//  UIvWorker
//
//  Created by user on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentTypeCellBase.h"

@interface ContentTypeFriendsCell : UITableViewCell <ContentTypeCellBase>

- (int)getCellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lblNumOfFriends;
@property (weak, nonatomic) IBOutlet UILabel *lblFriendPictures;

@end
