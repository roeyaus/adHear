//
//  RealTimeFeedView.h
//  UIvWorker
//
//  Created by Lion User on 27/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventTypeBase, EventTypeViewFactory;

@interface RealTimeFeedView : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UINib* customCellsNib;
    NSMutableDictionary* dicEventsForMinute; //this is a dictionary of dictionaries. The main dictionary is  key:Minute, value:Dictionary of Key:Second Value: Array of events
    NSMutableDictionary* dicIndexToSeconds; //this is a dictionary with key : index of section , value: second that event occurs.
    
    NSMutableArray* aDataSource; //the main datasource for the realtime feed tableview. Each entry is a "section" (second), and each contains an array of EventTypes. (multiple events each second)
    int currentMinute;
    
    int lastSecond;
    EventTypeViewFactory* eventTypeViewFactory;
}

@property (strong, nonatomic) IBOutlet UITableView *tvRealTimeFeed;
@property (strong, nonatomic) IBOutlet UITableView *tvEvents;
// -------- cell generation -------
- (UITableViewCell*) generateCellForEventTypeComment:(EventTypeBase*)Event;

- (void)FeedForSecondsOffset:(int)SecondsOffset; //this is a temprary function only for the prototype!!
-(void)GetAndMergeFeedsForMinute:(int)Minute;
-(void)displayShowInformationView;
-(void)Init;
@end
