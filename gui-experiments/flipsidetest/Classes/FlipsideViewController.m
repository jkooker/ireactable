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
@synthesize listData;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    NSArray *array = [[NSArray alloc] initWithObjects:@"Sleepy", @"Sneezy", 
        @"Bashful", @"Happy", @"Doc", @"Grumpy", @"Dopey", @"Thorin", 
        @"Dorin", @"Nori", @"Ori", @"Balin", @"Dwalin", @"Fili", @"Kili", 
        @"Oin", @"Gloin", @"Bifur", @"Bofur", @"Bombur", nil]; 
    self.listData = array; 
    [array release]; 

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
    [super dealloc];
}

#pragma mark - 
#pragma mark Table View Data Source Methods 
- (NSInteger)tableView:(UITableView *)tableView 
    numberOfRowsInSection:(NSInteger)section 
{ 
    return [self.listData count]; 
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
    cell.textLabel.text = [listData objectAtIndex:row]; 
    return cell; 
}

@end
