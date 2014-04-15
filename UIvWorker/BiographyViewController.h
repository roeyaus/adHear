//
//  BiographyViewController.h
//  UIvWorker
//
//  Created by Lion User on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventTypeBiography;
@interface BiographyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UINib* CellsNib; 
}
@property (strong, nonatomic) EventTypeBiography* Biography;

//@property (weak, nonatomic) IBOutlet UIImageView *ivPicture;
//@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
//@property (weak, nonatomic) IBOutlet UILabel *lblSummary;
//@property (weak, nonatomic) IBOutlet UILabel *lblBiography;
@property (weak, nonatomic) IBOutlet UITableView *tvBiography;


-(id)initWithEventTypeBiography:(EventTypeBiography*)biography;
 -(UITableViewCell*)generateCellForBiography;
@end
