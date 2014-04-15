//
//  BiographyViewController.m
//  UIvWorker
//
//  Created by Lion User on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BiographyViewController.h"
#import "EventTypeBiography.h"
#import "ContentTypeVideo.h"


@implementation BiographyViewController
//@synthesize ivPicture;
//@synthesize lblFullName;
//@synthesize lblSummary;
//@synthesize lblBiography;
@synthesize tvBiography;
@synthesize Biography;



-(id)initWithEventTypeBiography:(EventTypeBiography*)biography
{
    CellsNib = [UINib nibWithNibName:@"EventTypeCells" bundle:nil]; 
    self = [super initWithNibName:@"BiographyViewController" bundle:nil];
    if (self) {
        
        // Custom initialization
        self.Biography = biography;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{

    
}

- (void)viewDidUnload
{
    //[self setIvPicture:nil];
    //[self setLblFullName:nil];
    //[self setLblSummary:nil];
    //[self setLblBiography:nil];
    [self setTvBiography:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
   
    return self.Biography.Videos.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
    NSLog(@"%@", Biography.Biography);
    CGSize size = [Biography.Biography sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(303, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 120;
    }
    else {
        return 44;
    }
                                                                                    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        return [self generateCellForBiography];
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VideoCell"];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = UITextAlignmentRight;
        cell.textLabel.shadowOffset = CGSizeMake(-1, -1);
        cell.textLabel.shadowColor = [UIColor blackColor];
        ContentTypeVideo* ctv = [Biography.Videos objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = ctv.Name;
        
        cell.detailTextLabel.text = ctv.Description;
        cell.detailTextLabel.textAlignment = UITextAlignmentRight;
        
        
        
        cell.imageView.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ctv.URLToThumbnail]]];
        // Configure the cell...
        
        [cell addSubview:[self embedYouTube:ctv.URL withFrame:CGRectMake(0, 0, 58, cell.frame.size.height)]];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    // Configure the cell...
    
    return nil;
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


- (UITableViewCell*) generateCellForBiography
{
    
    UITableViewCell *cell = [tvBiography dequeueReusableCellWithIdentifier:@"BiographyCell"];
    if(cell == nil) {
        NSArray *topLevelItems = [CellsNib instantiateWithOwner:NULL options:nil];
        
        NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                          {
                              UITableViewCell *cell = (UITableViewCell *)obj;
                              return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:@"BiographyCell"];
                          } ];
        assert(idx != NSNotFound);
        cell = [topLevelItems objectAtIndex:idx];
    }
    
    
    //lbl1 = [[UILabel alloc] init];
    UIImageView* ivPic = (UIImageView*)[cell viewWithTag:0];
    UILabel* lblBio = (UILabel*)[cell viewWithTag:3];
    //Async load user picture.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        UIImage *image = Biography.Picture;        
        dispatch_sync(dispatch_get_main_queue(), ^{
            ivPic.image = image;
        });
    });
    
    //ivPicture.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultFacebookProfile" ofType: @"jpg"]];
    //lblFullName.text = Biography.FullName;
    //lblSummary.text = Biography.Summary;
    lblBio.text = Biography.Biography;
    [lblBio sizeToFit];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}
@end
