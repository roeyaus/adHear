//
//  Tab3.m
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ContentDetailsView.h"
#import "Screen5.h"
#import "ContentTypesAll.h"
#import "QuartzCore/CALayer.h"
#import "AllCells.h"
#import "FacebookManager.h"
#import "DataManager.h"
#import "User.h"
#import "EventTypeViewFactory.h"
#import "EventTypeBase.h"
#import "CouponDetailsViewController.h"
#import "FriendsDetailView.h"
#import "VideosDetailView.h"

@implementation ContentDetailsView
@synthesize ivCouponImage;
@synthesize lblCouponDesc;
@synthesize tvcCouponCell;

@synthesize screenSwitched;

@synthesize tvContentDetails;
@synthesize tvcMainTitleCell;
@synthesize lblMainTitle;
@synthesize ivMainImage;
@synthesize lblMainDescription;
@synthesize btnBuyCoupon;
@synthesize EventType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon-3" ofType: @"png"]];
       self.tabBarItem.image = img; 
        eventTypeViewFactory = [EventTypeViewFactory alloc];
        [eventTypeViewFactory initWithNibName:@"ContentTypeCells"];
     
    }


    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Facebook Delegate methods

- (void)request:(FBRequest *)request didLoad:(id)result
{
    
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    customCellsNib = [UINib nibWithNibName:@"ContentTypeCells" bundle:nil];
    //imgCoupon.clipsToBounds = NO;
    [self PopulateCellsArray];
   
    
}

-(void)PopulateCellsArray
{
    aCells = [[NSMutableArray alloc] init];
    for (int i = 0; i < EventType.aContentTypes.count; ++i)
    {
        [aCells addObject:[eventTypeViewFactory GenerateCellForEventType:EventType CellNumber:i]];
    }
}


- (void)viewDidUnload
{

  
    [self setTvcMainTitleCell:nil];
    [self setLblMainTitle:nil];
    [self setIvMainImage:nil];
    [self setLblMainDescription:nil];
    [self setTvContentDetails:nil];

    [self setBtnBuyCoupon:nil];
    [self setIvCouponImage:nil];
    [self setLblCouponDesc:nil];
    [self setTvcCouponCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //change nav bar to blue
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:23/255.0 green:13/255.0 blue:176/255.0 alpha:1.0];
    self.navigationController.navigationBar.hidden = false;
 
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
     
        

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations. Currently portrait and upside down portrait supported.
    if ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
        (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        return YES;
    
    return NO;
}

- (IBAction)BackButton:(id)sender {
    [self.tabBarController setSelectedIndex:0];
    
}


//TODO: should be in EventTypeViewFactory
- (UITableViewCell*) generateCellForContentTypeRecipe
{
    
    UITableViewCell *cell = [tvContentDetails dequeueReusableCellWithIdentifier:[ContentTypeRecipe GetCellIdentifier]];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ContentTypeRecipe GetCellIdentifier]];
    }

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"לחצו כאן למתכון מנצח!";
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = UITextAlignmentRight;
    cell.textLabel.shadowOffset = CGSizeMake(0, 0);
    cell.textLabel.shadowColor = [UIColor blackColor];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recipeIcon" ofType: @"gif"]];
    
    return cell;
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat ret = 0;
    
    ret = [eventTypeViewFactory GetHeightOfCellForEventType:EventType WithCell:[aCells objectAtIndex:indexPath.row] andNumber:indexPath.row];
    
    return ret;
    
}   

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    int num = [eventTypeViewFactory GetNumberOfCellsForEventType:EventType];

    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tvContentDetails dequeueReusableCellWithIdentifier:[eventTypeViewFactory GetCellIdentifierForEventType:self.EventType CellNumber:indexPath.row]];
    if (cell != nil)
    {
        return cell;
    }
    int row = indexPath.row;
    return [aCells objectAtIndex:row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[contentArray objectAtIndex:indexPath.row] isKindOfClass:[ContentTypeCoupon class]])
    {
        CouponDetailsViewController *ContentDetailsView = [[CouponDetailsViewController alloc] initWithNibName:@"CouponDetailsViewController" bundle:nil];
        
      
        // ...
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:ContentDetailsView animated:YES];
        ContentDetailsView.ivCouponDetails.image = ((ContentTypeCoupon*)[contentArray objectAtIndex:indexPath.row]).ActualCoupon; 
        
    }
   
    if ([[contentArray objectAtIndex:indexPath.row] isKindOfClass:[ContentTypeFriend class]])
    {
        FriendsDetailView *FriendsDetailsView = [[FriendsDetailView alloc] initWithNibName:@"FriendsDetailView" bundle:nil];
        // ...
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:FriendsDetailsView animated:YES];
    }
    
    if ([[contentArray objectAtIndex:indexPath.row] isKindOfClass:[ContentTypeVideo class]])
    {
        VideosDetailView *videoDetailsView = [[VideosDetailView alloc] initWithNibName:@"VideosDetailView" bundle:nil];
        // ...
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:videoDetailsView animated:YES];
    }
    
    
     
}



@end
