//
//  Screen5.m
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Screen5.h"

@implementation Screen5
@synthesize Table;

@synthesize parent;

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
    tableEntries = [NSMutableArray arrayWithObjects:@"List entry 1", @"List entry 2", nil];
    NSArray *pathIndex = [NSArray arrayWithObject:[NSIndexPath 
                                                   indexPathForRow:0 inSection:0]];
    Table.dataSource = self;
    [Table insertRowsAtIndexPaths:pathIndex withRowAnimation:NO];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)BackButton:(id)sender {
    [self dismissModalViewControllerAnimated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0]; 
    cell.textLabel.text = [tableEntries objectAtIndex:0];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // sets the number of sections in the table.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Sets the number of rows in one section of the table.
    return 2;
}
@end
