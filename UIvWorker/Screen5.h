//
//  Screen5.h
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentDetailsView.h"

@interface Screen5 : UIViewController <UITableViewDataSource> {
    NSMutableArray *tableEntries;
}

@property (assign, nonatomic) ContentDetailsView *parent;
- (IBAction)BackButton:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *Table;

@end
