//
//  EventTypeViewFactory.h
//  UIvWorker
//
//  Created by Lion User on 22/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EventTypeBase;
@class DataManager;
@interface EventTypeViewFactory : NSObject
{
    UINib* customCellsNib;
    DataManager* dataManager;
}


-(void)initWithNibName:(NSString*)Name;

-(UITableViewCell*)GenerateCellForEventType:(EventTypeBase*)EventType CellNumber:(int)Number;
-(NSString*) GetCellIdentifierForEventType:(EventTypeBase*)EventType CellNumber:(int)Number;
-(int)GetNumberOfCellsForEventType:(EventTypeBase*)EventType;
-(CGFloat)GetHeightOfCellForEventType:(EventTypeBase*)EventType WithCell:(UITableViewCell*)Cell andNumber:(int)Number;
@end
