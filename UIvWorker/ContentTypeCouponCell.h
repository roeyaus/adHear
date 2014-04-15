//
//  ContentTypeCouponCell.h
//  UIvWorker
//
//  Created by user on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentTypeCellBase.h"

@interface ContentTypeCouponCell : UITableViewCell <ContentTypeCellBase>

- (int)getCellHeight;

@property (weak, nonatomic) IBOutlet UIImageView *ivCouponPicture;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponDescription;

@end
