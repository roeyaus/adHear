//
//  ContentTypeGeneralCell.h
//  UIvWorker
//
//  Created by user on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentTypeCellBase.h"

@interface ContentTypeGeneralCell : UITableViewCell <ContentTypeCellBase>

- (int)getCellHeight;

@property (weak, nonatomic) IBOutlet UIImageView *ivPicture;
@property (weak, nonatomic) IBOutlet UILabel *lblContentName;
@property (weak, nonatomic) IBOutlet UILabel *lblContentDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblContentCast;

@end
