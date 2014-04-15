//
//  VideosDetailView.m
//  UIvWorker
//
//  Created by user on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideosDetailView.h"
#import "DataManager.h"
#import "ContentTypeVideo.h"

@implementation VideosDetailView

@synthesize VideosArray;


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //load the videos array...
    VideosArray = [[DataManager sharedSingleton] GetVideosByContentId:@"1"];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //change nav bar to purple
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:64/255.0 green:0/255.0 blue:128/255.0 alpha:1.0];
    
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
    return VideosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [ContentTypeVideo GetCellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = UITextAlignmentRight;
    cell.textLabel.shadowOffset = CGSizeMake(-1, -1);
    cell.textLabel.shadowColor = [UIColor blackColor];
    ContentTypeVideo* ctv = [VideosArray objectAtIndex:indexPath.row];
    cell.textLabel.text = ctv.Name;
    
    cell.detailTextLabel.text = ctv.Description;
    cell.detailTextLabel.textAlignment = UITextAlignmentRight;
 
    
    
    cell.imageView.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ctv.URLToThumbnail]]];
    // Configure the cell...
    
    [cell addSubview:[self embedYouTube:ctv.URL withFrame:CGRectMake(0, 0, 58, cell.frame.size.height)]];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIWebView*)embedYouTube:(NSString*)url withFrame:(CGRect)frame
{  
    UIWebView* videoView;
    NSString* embedHTML = @"<html><head>\ <style type=\"text/css\">\ body {\ background-color: transparent;\ color: white;\ }\ </style>\ </head><body style=\"margin:0\">\ <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \ width=\"%0.0f\" height=\"%0.0f\"></embed>\ </body></html>";  
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];  
    if(videoView == nil) {  
        videoView = [[UIWebView alloc] initWithFrame:frame];  
        [self.view addSubview:videoView];  
    }  
    [videoView loadHTMLString:html baseURL:nil]; 
    return videoView;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
//    ContentTypeVideo* vid = [VideosArray objectAtIndex:indexPath.row];
//    NSURL *url = [NSURL URLWithString:vid.URL];
//    UIApplication* app = [UIApplication sharedApplication];
//    [app openURL:url];
}

@end
