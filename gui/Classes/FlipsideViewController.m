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
    infoStrings = [[NSArray arrayWithObjects:@"UCSD CSE 237D Project", @"By John Kooker", @"www.johnkooker.com/blog", nil] retain];
    
    configItems = [[NSArray arrayWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"IP", @"title",
            @"0.0.0.0", @"value",
            nil],
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"Port", @"title",
            @"7000", @"value",
            nil],
        nil] retain];
    
    // OSC initializations
    t = lo_address_new(NULL, "7000");
}

- (void)dealloc {
    [super dealloc];
    [tableTitles release];
    [objectNames release];
    [infoStrings release];
    [configItems release];
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
    static NSString *cellIDCheckmark = @"cellIDCheckmark";
    static NSString *cellIDBlueValue = @"cellIDBlueValue";
    static NSString *cellIDDefault = @"cellIDDefault";
    
    UITableViewCell *cell = nil;
        
    // actually put together the cell
    switch (indexPath.section) {
        case kObjects:
            cell = [tableView dequeueReusableCellWithIdentifier:cellIDCheckmark];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIDCheckmark] autorelease];
            }
            
            cell.textLabel.text = [objectNames objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case kConfiguration:
            cell = [tableView dequeueReusableCellWithIdentifier:cellIDBlueValue];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: cellIDBlueValue] autorelease];
            }
            
            cell.textLabel.text = [[configItems objectAtIndex:indexPath.row] valueForKey:@"title"];
            cell.detailTextLabel.text = [[configItems objectAtIndex:indexPath.row] valueForKey:@"value"];
            break;
        case kTesting:
            cell = [tableView dequeueReusableCellWithIdentifier:cellIDDefault];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIDDefault] autorelease];
            }

            cell.textLabel.text = @"Send Script";
            break;
        case kInfo:
            cell = [tableView dequeueReusableCellWithIdentifier:cellIDBlueValue];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: cellIDBlueValue] autorelease];
            }

            cell.textLabel.text = [infoStrings objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        default:
            break;
    }
    
    return cell; 

}


#pragma mark table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Disable for certain sections
    if (indexPath.section == kInfo || indexPath.section == kConfiguration)
		return nil;

	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kObjects:
            // flip on and off the checkmarks
            if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            } else {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        case kTesting:
            [self runOSCTestScript];
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark other

- (void)runOSCTestScript
{
    NSLog(@"running OSC test script.");
    
    // init object states
    lo_send(t, "/ireactable/connect", "sss", "squarewave", "devnull", "signal");
    lo_send(t, "/ireactable/connect", "sss", "squarewave", "devnull", "signal");
    lo_send(t, "/ireactable/connect", "sss", "squarewave", "devnull", "signal");
    lo_send(t, "/ireactable/squarewave", "ff", 440.0f, 0.8f);
    lo_send(t, "/ireactable/vcf", "ff", 440.0f, 0.5f);
    lo_send(t, "/ireactable/lfo", "f", 5.0f);
    
    // connect squarewave to output
    lo_send(t, "/ireactable/connect", "sss", "squarewave", "output", "signal");
    // wait
    
    // modify squarewave
    lo_send(t, "/ireactable/squarewave", "ff", 550.0f, 0.7f);
    // wait
    
    // connect squarewave to vcf signal input
    lo_send(t, "/ireactable/connect", "sss", "squarewave", "vcf", "signal");
    
    // connect vcf to output
    lo_send(t, "/ireactable/connect", "sss", "vcf", "output", "signal");
    // wait
    
    // modify vcf
    lo_send(t, "/ireactable/vcf", "ff", 330.0f, 0.5f);
    // wait
    
    // connect lfo to vcf control input
    lo_send(t, "/ireactable/connect", "sss", "lfo", "vcf", "control");
    
    // modify lfo
    lo_send(t, "/ireactable/lfo", "f", 10.0f);
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




@end
