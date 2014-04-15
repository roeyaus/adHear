//
//  FriendsDetailView.m
//  UIvWorker
//
//  Created by user on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsDetailView.h"

@implementation FriendsDetailView
@synthesize tfCommentURL;
@synthesize wvFacebookComments;
@synthesize uvCommentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    // Do any additional setup after loading the view from its nib.
    [self loadCommentsView];
}

- (void)viewDidUnload
{
    [self setWvFacebookComments:nil];
    [self setUvCommentView:nil];
    [self setTfCommentURL:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)OnUpdateButtonTouchUpInside:(id)sender {
    [wvFacebookComments loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tfCommentURL.text]]];
}

- (void) loadCommentsView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tfCommentURL.text]]];
    wvFacebookComments = webView;
    [self.uvCommentView addSubview:webView];

}



@end
