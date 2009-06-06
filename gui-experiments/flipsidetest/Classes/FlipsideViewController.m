//
//  FlipsideViewController.m
//  flipsidetest
//
//  Created by John Kooker on 6/5/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize settingsListData;
@synthesize objectsListData;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"Square Wave", @"Filter", @"Oscillator"];
    self.objectsListData = array;
    [array release];
    
    array = [[NSArray alloc] initWithObjects:@"by John Kooker", @"CSE 237D", 
        @"Spring 2009", @"Happy", @"Doc", @"Grumpy", @"Dopey", @"Thorin", 
        @"Dorin", @"Nori", @"Ori", @"Balin", @"Dwalin", @"Fili", @"Kili", 
        @"Oin", @"Gloin", @"Bifur", @"Bofur", @"Bombur", nil]; 
    self.settingsListData = array; 
    [array release];
    
    sectionTitles = [[NSArray arrayWithObjects:@"iReactable", @"Other Options",nil] retain];
}


- (IBAction)done {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [sectionTitles release];
    [super dealloc];
}

#pragma mark - 
#pragma mark Table View Data Source Methods 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView 
    numberOfRowsInSection:(NSInteger)section 
{ 
    return !section ? [self.objectsListData count] : [self.settingsListData count]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
       cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: 
        SimpleTableIdentifier]; 
    if (cell == nil) { 
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero 
                     reuseIdentifier: SimpleTableIdentifier] autorelease]; 
    } 
    NSUInteger row = [indexPath row]; 
    cell.textLabel.text = ![indexPath section] ? [objectsListData objectAtIndex:row] : [settingsListData objectAtIndex:row]; 
    return cell; 
}

@end
