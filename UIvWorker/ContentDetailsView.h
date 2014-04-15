//
//  Tab3.h
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentTypeGeneral.h"
#import "facebook.h"

@class ContentTypeCoupon, ContentTypeGeneral,ContentTypeVideo, User, EventTypeBase;
@class EventTypeViewFactory;

@interface ContentDetailsView : UIViewController <UITableViewDelegate, UITableViewDataSource, FBSessionDelegate>
{
    BOOL screenSwitched;
    NSTimer *countdownTimer;
    int secondsLeft;
    NSMutableArray* contentArray;
    NSMutableArray* cellsArray;
    UINib* customCellsNib;
    NSMutableArray* usersWatchingArray;
    EventTypeViewFactory* eventTypeViewFactory;
    NSMutableArray* aCells;

}

- (IBAction)BackButton:(id)sender;
- (IBAction)OpenScreen5:(id)sender;
- (IBAction)DisplayTab1:(id)sender;
- (IBAction)DisplayTab2:(id)sender;
- (IBAction)DisplayTab3:(id)sender;

- (void)displayCouponDetails:(ContentTypeCoupon*) coup;
- (void)PopulateCellsArray;
- (UITableViewCell*) generateCellForContentTypeGeneral:(ContentTypeGeneral*)general;
- (UITableViewCell*) generateCellForContentTypeCoupon:(ContentTypeCoupon*)coupon;
- (UITableViewCell*) generateCellForContentTypeVideo;
//facebook methods

- (void)request:(FBRequest *)request didLoad:(id)result;
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error;


- (void) updateCountdown;
-(void)LoadUsersWatchingImagesAsync;
@property (assign, nonatomic) BOOL screenSwitched;


//tableview cells and controls
@property (weak, nonatomic) IBOutlet UIImageView *ivCouponImage;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponDesc;
@property (strong, nonatomic) IBOutlet UITableViewCell *tvcCouponCell;

//main cell
@property (weak, nonatomic) IBOutlet UITableView *tvContentDetails;
@property (strong, nonatomic) IBOutlet UITableViewCell *tvcMainTitleCell;
@property (weak, nonatomic) IBOutlet UILabel *lblMainTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivMainImage;
@property (weak, nonatomic) IBOutlet UILabel *lblMainDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnBuyCoupon;


//content type specific cells

@property (strong, nonatomic) EventTypeBase* EventType;




@end
