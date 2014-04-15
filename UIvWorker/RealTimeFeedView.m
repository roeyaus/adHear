//
//  RealTimeFeedView.m
//  UIvWorker
//
//  Created by Lion User on 27/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RealTimeFeedView.h"
#import "ContentDetailsView.h"
#import "EventTypesAll.h"
#import "ContentTypesAll.h"

@implementation RealTimeFeedView
@synthesize tvRealTimeFeed, tvEvents;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        dicEventsForMinute = [[NSMutableDictionary alloc] init];
        dicIndexToSeconds = [[NSMutableDictionary alloc] init];
        aDataSource = [[NSMutableArray alloc] init];
        [self Init];
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    customCellsNib = [UINib nibWithNibName:@"EventTypeCells" bundle:nil];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"תוכנית" style:UIBarButtonItemStylePlain target:self action:@selector(displayShowInformationView:)];
}

- (void)viewDidUnload
{
    [self setTvRealTimeFeed:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    self.navigationController.tabBarItem.badgeValue = nil;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    int numOfSections = aDataSource.count;
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    int numOfRowsInSection = ((NSMutableArray*)[aDataSource objectAtIndex:section]).count;
    return numOfRowsInSection;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    id cls = [((NSMutableArray*)[aDataSource objectAtIndex: indexPath.section]) objectAtIndex:indexPath.row];
    NSString* className = NSStringFromClass([cls class]);
    SEL s = NSSelectorFromString([NSString stringWithFormat:@"generateCellFor%@:", className] );
    UITableViewCell* cell = [self performSelector:s withObject: cls];    
    // Configure the cell...
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //get time
    EventTypeBase* etc = [((NSMutableArray*)[aDataSource objectAtIndex:section]) objectAtIndex:0];
    //create time view
    UIView* tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 15)];
    tmpView.backgroundColor = [UIColor clearColor];
    UILabel* lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
    lblTime.font = [UIFont systemFontOfSize:10];
    lblTime.textColor = [UIColor whiteColor];
    lblTime.text = [NSString stringWithFormat:@"%02d:%02d", etc.eventTime.Minute, etc.eventTime.Second];
    lblTime.backgroundColor = [UIColor blueColor];
    [tmpView addSubview:lblTime];
    return tmpView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}



-(void)GetAndMergeFeedsForMinute:(int)Minute
{
    NSMutableDictionary* mainMinuteDic = [[NSMutableDictionary alloc] init];
      //iterate over all event types
    for (int i = ETIntroduction ; i < ETLast; ++i)
    {
        //get their next minute
        NSMutableDictionary* mergeDic = [NSClassFromString([EventTypeBase EventTypeEnumToString:i]) GenerateByMinute:Minute]; 
      
        for (NSNumber* keySec in mergeDic)
        {
            NSLog(@"current second : %d", [keySec intValue]);
            if ([mainMinuteDic objectForKey:keySec] != nil) //we have this second in our merge dictionary
            {
                NSMutableArray* mergeArr = [mainMinuteDic objectForKey:keySec];
                NSMutableArray* arr = [mergeDic objectForKey:keySec];
                [mergeArr addObjectsFromArray:arr];
            }
            else
            {
                
                [mainMinuteDic setObject:[mergeDic objectForKey:keySec] forKey:keySec];
            }
                
        }
        
    }
    [dicEventsForMinute setObject:mainMinuteDic forKey:[NSNumber numberWithInt:Minute]];
    
        
}

- (void)FeedForSecondsOffset:(int)SecondsOffset
{
    //create a feed timeline
    int Minute = SecondsOffset / 60;
    int Second = SecondsOffset % 60;
    //if new minute
    if (currentMinute != Minute)
    {
        currentMinute = Minute;
        //get Dictionary of events for this minute 
        [self GetAndMergeFeedsForMinute:Minute];
       
    }
    
    
    NSMutableDictionary* dic = [dicEventsForMinute objectForKey:[NSNumber numberWithInt:currentMinute]];
    if (dic == nil)
    {
        return;
    }
    NSMutableArray* aEvents = [dic objectForKey:[NSNumber numberWithInt:Second]];
    if (aEvents == nil)
    {
        return;
    }
    // update the 
    [aDataSource insertObject:aEvents atIndex:0];
    [tvRealTimeFeed beginUpdates];
    //new section for second
    NSIndexSet* is = [[NSIndexSet alloc] initWithIndex:0];
    [tvRealTimeFeed insertSections:is withRowAnimation:UITableViewRowAnimationFade];
    
    if (!self.isViewLoaded || !self.view.window)
    {
        [self.navigationController.tabBarItem setBadgeValue:@"+"];
    }
    
   
    
    NSArray* arr = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
    [tvRealTimeFeed insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
    
    [tvRealTimeFeed endUpdates];
  
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTypeBase* touchedEvent = [((NSMutableArray*)[aDataSource objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    if (touchedEvent.aContentTypes.count == 0)
    {
        return;
    }
    ContentDetailsView *contentDetailsView = [[ContentDetailsView alloc] init];
    contentDetailsView.EventType = touchedEvent;

        // ...
        // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:contentDetailsView animated:YES];
          
    
}

-(void)displayShowInformationView
{
    EventTypeBase* touchedEvent = [((NSMutableArray*)[aDataSource objectAtIndex:aDataSource.count]) objectAtIndex:0];
    if (touchedEvent.aContentTypes.count == 0)
    {
        return;
    }
    ContentDetailsView *contentDetailsView = [[ContentDetailsView alloc] init];
    contentDetailsView.EventType = touchedEvent;
    
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:contentDetailsView animated:YES];
}
                                                                                                                                                        



//--------------------------------- Cell Generation ------------------------------------

- (UITableViewCell*) generateCellForEventWithTime:(EventTime)Time
{
    
    UITableViewCell *cell = [tvRealTimeFeed dequeueReusableCellWithIdentifier:@"EventTypeCommentCell"];
    if(cell == nil) {
        NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
        NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                          {
                              UITableViewCell *cell = (UITableViewCell *)obj;
                              return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:@"EventTypeCommentCell"];
                          } ];
        assert(idx != NSNotFound);
        cell = [topLevelItems objectAtIndex:idx];
    }
//    
//    UILabel* lblTitle = (UILabel*)[cell viewWithTag:1];
//    //lbl1 = [[UILabel alloc] init];
//    lblTitle.text = general.Title;
//    UIImageView* img = (UIImageView*)[cell viewWithTag:2];
//    img.image = general.Picture;
//    UILabel* lblDescription = (UILabel*)[cell viewWithTag:3];
//    //lbl2 = [[UILabel alloc] init];
//    lblDescription.text = general.Description;
//    UILabel* lblcast = (UILabel*)[cell viewWithTag:4];
//    lblcast.text = general.Cast;
    return cell;
}

- (UITableViewCell*) generateCellForEventTypeComment:(EventTypeComment*)CommentEvent
{
    
    UITableViewCell *cell = [tvRealTimeFeed dequeueReusableCellWithIdentifier:@"EventTypeCommentCell"];
    if(cell == nil) {
        NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
        NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                          {
                              UITableViewCell *cell = (UITableViewCell *)obj;
                              return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:@"EventTypeCommentCell"];
                          } ];
        assert(idx != NSNotFound);
        cell = [topLevelItems objectAtIndex:idx];
    }
    
    UIImageView* ivUser = (UIImageView*)[cell viewWithTag:2];
    //lbl1 = [[UILabel alloc] init];
    
    
    //Async load user picture.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:CommentEvent.eventUser.PictureURL]]];        
        dispatch_sync(dispatch_get_main_queue(), ^{
          ivUser.image = image;
        });
    });
    
    ivUser.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultFacebookProfile" ofType: @"jpg"]];
    UILabel* lblUserName = (UILabel*)[cell viewWithTag:1];
    lblUserName.text = [NSString stringWithFormat:@"%@ %@", CommentEvent.eventUser.FullName, CommentEvent.eventComment];
    return cell;
}

- (UITableViewCell*) generateCellForEventTypeCoupon:(EventTypeCoupon*)CouponEvent
{
    
    UITableViewCell *cell = [tvRealTimeFeed dequeueReusableCellWithIdentifier:@"EventTypeCouponCell"];
    if(cell == nil) {
        NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
        NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                          {
                              UITableViewCell *cell = (UITableViewCell *)obj;
                              return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:@"EventTypeCouponCell"];
                          } ];
        assert(idx != NSNotFound);
        cell = [topLevelItems objectAtIndex:idx];
    }
    
    UIImageView* ivUser = (UIImageView*)[cell viewWithTag:3];
    //lbl1 = [[UILabel alloc] init];
    
    ivUser.image = CouponEvent.eventCoupon.Picture;//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultFacebookProfile" ofType: @"jpg"]];
    
    UILabel* lblCouponTitle = (UILabel*)[cell viewWithTag:1];
    lblCouponTitle.text = [NSString stringWithFormat:@"%@", CouponEvent.eventCoupon.Title];
    UILabel* lblCouponDesc = (UILabel*)[cell viewWithTag:2];
    lblCouponDesc.text = [NSString stringWithFormat:@"%@", CouponEvent.eventCoupon.Title];
    return cell;
}

- (UITableViewCell*) generateCellForEventTypeSong:(EventTypeSong*)SongEvent
{
    
    UITableViewCell *cell = [tvRealTimeFeed dequeueReusableCellWithIdentifier:@"EventTypeSongCell"];
    if(cell == nil) {
        NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
        NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                          {
                              UITableViewCell *cell = (UITableViewCell *)obj;
                              return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:@"EventTypeSongCell"];
                          } ];
        assert(idx != NSNotFound);
        cell = [topLevelItems objectAtIndex:idx];
    }
    
    ContentTypeSong* cts = [SongEvent.aContentTypes objectAtIndex:0];
    
    UILabel* lblArtistName = (UILabel*)[cell viewWithTag:1];
    UILabel* lblSongName = (UILabel*)[cell viewWithTag:2];
    
    lblArtistName.text = cts.PerformerName;
    lblSongName.text = cts.SongName;

    return cell;
}

- (UITableViewCell*) generateCellForEventTypeBiography:(EventTypeBiography*)BiographyEvent
{
    
    UITableViewCell *cell = [tvRealTimeFeed dequeueReusableCellWithIdentifier:@"EventTypeBiographyCell"];
    if(cell == nil) {
        NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
        NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                          {
                              UITableViewCell *cell = (UITableViewCell *)obj;
                              return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:@"EventTypeBiographyCell"];
                          } ];
        assert(idx != NSNotFound);
        cell = [topLevelItems objectAtIndex:idx];
    }
    
    UIImageView* ivBio = (UIImageView*)[cell viewWithTag:3];
    UILabel* lblCouponTitle = (UILabel*)[cell viewWithTag:1];
    ContentTypeBiography* ctg = (ContentTypeBiography*)[BiographyEvent.aContentTypes objectAtIndex:0];
    lblCouponTitle.text = ctg.FullName;
    ivBio.image = ctg.Picture;
    return cell;
}

- (UITableViewCell*) generateCellForEventTypeIntroduction:(EventTypeIntroduction*)IntroEvent
{
    
    UITableViewCell *cell = [tvRealTimeFeed dequeueReusableCellWithIdentifier:@"EventTypeIntroductionCell"];
    if(cell == nil) {
        NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
        NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                          {
                              UITableViewCell *cell = (UITableViewCell *)obj;
                              return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:@"EventTypeIntroductionCell"];
                          } ];
        assert(idx != NSNotFound);
        cell = [topLevelItems objectAtIndex:idx];
    }
    
    ContentTypeGeneral* ctg = ((ContentTypeGeneral*)[IntroEvent.aContentTypes objectAtIndex:0]);
    UIImageView* ivIntroImage = (UIImageView*)[cell viewWithTag:1];
    ivIntroImage.image = ctg.Picture;
    
    
    return cell;
}

-(void)Init
{
    currentMinute = -1;
    lastSecond = -1;
    
}


@end
