//
//  FlipsideViewController.m
//  iReactable
//
//  Created by John Kooker on 6/6/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate;

enum tableGroups {
    kObjects = 0,
    kConfiguration,
    kTesting,
    kInfo
};

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    // set up table data
    tableTitles = [[NSArray arrayWithObjects:@"Objects", @"Configuration", @"Testing", @"Information", nil] retain];
    objectNames = [[NSArray arrayWithObjects:@"Square Wave", @"Filter", @"Oscillator", nil] retain];
    infoStrings = [[NSArray arrayWithObjects:@"By John Kooker", @"www.johnkooker.com/blog", nil] retain];
}

- (void)dealloc {
    [super dealloc];
    [tableTitles release];
    [objectNames release];
    [infoStrings release];
}

#pragma mark table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [tableTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSInteger numRows = 0;
    
    switch (section) {
        case kObjects:
            numRows = [objectNames count];
            break;
        case kConfiguration:
            numRows = 2;
            break;
        case kTesting:
            numRows = 1;
            break;
        case kInfo:
            numRows = [infoStrings count];
            break;
        default:
            break;
    }
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dumb cell initialization stuff
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: 
        SimpleTableIdentifier]; 
    if (cell == nil) { 
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier] autorelease]; 
    } 
    
    // actually put together the cell
    switch (indexPath.section) {
        case kObjects:
            cell.textLabel.text = [objectNames objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case kConfiguration:
            cell.textLabel.text = @"IP";
            break;
        case kTesting:
            cell.textLabel.text = @"Send Script";
            break;
        case kInfo:
            cell.textLabel.text = [infoStrings objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    return cell; 

}

#pragma mark table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected index path %@", indexPath);
}

#pragma mark other

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




@end
