//
//  MyCouponsScreen.m
//  UIvWorker
//
//  Created by Roey L on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyContentView.h"
#import "Screen5.h"
#import "ContentTypeGeneral.h"

@implementation MyContentView

@synthesize scrollingView;
@synthesize CouponTable;
@synthesize numOfNewContent;
@synthesize numOfContent;
@synthesize ContentArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        self.title = NSLocalizedString(@"התכנים שלי", @"Tab3");
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"like_thumbs_up" ofType: @"png"]];
        self.ContentArray = [NSMutableArray array];
        self.tabBarItem.image = img; 
        

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    contentIterator = 0;
    numOfContent = 0;
    numOfNewContent = 0;
    
    NSArray* items = [[NSArray alloc] initWithObjects:@"All", @"Expiring", nil];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:items]; 
    segmentedControl.selectedSegmentIndex = 0; 
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth; 
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
    //segmentedControl.frame = CGRectMake(0, 0, 400, 40); 
    [segmentedControl addTarget:self action:@selector(SegmentedControlTouched:) forControlEvents:UIControlEventValueChanged]; 
    
    self.navigationItem.titleView = segmentedControl;
    
//    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background1Purple_640x960" ofType: @"jpg"]];
//    
//    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:img];
//    [backgroundView setFrame:CGRectMake(0, 0, 320, 460)];
//    [CouponTable setBackgroundView:backgroundView];
    
}

- (void)HandleNewContent:(ContentTypeGeneral*) content
{
    if (content == nil)
    {
        return;
    }
    
    numOfNewContent++;
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", numOfNewContent];

    [ContentArray addObject:content];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.tabBarItem.badgeValue = nil;

    contentIterator = 0;
    [CouponTable reloadData];
    contentIterator = 0;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //change nav bar to purple
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:64/255.0 green:0/255.0 blue:128/255.0 alpha:1.0];
    
}

- (void)viewDidUnload
{
    [self setCouponTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return ContentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"]; 
    
    
    if (cell == nil) { 
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"]; 
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        
        
    } 
    
    
    //this is where the content should come. We'll give the same content for each row for now.
    if (contentIterator >= ContentArray.count)
    {
        return cell;
    }
    
    ContentTypeGeneral* coupon = [ContentArray objectAtIndex:contentIterator];
    UISegmentedControl * seg = ((UISegmentedControl *) self.navigationItem.titleView);
    if (seg.selectedSegmentIndex == 1)
    {
//        NSDate* date = [NSDate date]; //today's date
//        NSDate* expDate = coupon.ExpirationDate;
//        int diff = abs(([expDate timeIntervalSinceReferenceDate] - [date timeIntervalSinceReferenceDate]));
//        while (diff > 3600 * 24 * 7) //more than a week to expiration - not an expiring coupon
//        {
//            contentIterator++;    //skip this coupon
//            if (contentIterator >= ContentArray.count)
//            {
//                return cell;
//            }
//
//            coupon = [ContentArray objectAtIndex:contentIterator];
//            expDate = coupon.ExpirationDate;
//            diff = abs(([expDate timeIntervalSinceReferenceDate] - [date timeIntervalSinceReferenceDate]));
//        }
    }
    
    cell.textLabel.text = coupon.Title;    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]; //white
    cell.tag = contentIterator;
    cell.detailTextLabel.text = coupon.Description;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.8 green:1 blue:1 alpha:1.0]; //white
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    cell.imageView.image = coupon.Picture; 
    
    contentIterator++;
    return cell; 

   
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    ContentDetailsView* couponScreen = [[ContentDetailsView alloc] initWithNibName:@"ContentDetailsView" bundle:nil];
    NSString* iD = ((ContentTypeGeneral*)[ContentArray objectAtIndex:indexPath.row]).Id;
   // couponScreen.coupon = (ContentTypeCoupon*)([CouponArray objectAtIndex:[tableView cellForRowAtIndexPath:indexPath].tag]);
    [self.navigationController pushViewController:couponScreen animated:YES];
   
   
}


- (IBAction)SegmentedControlTouched:(id)sender {
    [CouponTable reloadData];
    contentIterator = 0;
    
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


@end
