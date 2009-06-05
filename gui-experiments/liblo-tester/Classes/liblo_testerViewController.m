//
//  liblo_testerViewController.m
//  liblo-tester
//
//  Created by John Kooker on 5/19/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "liblo_testerViewController.h"



@implementation liblo_testerViewController


- (IBAction)sendMessage1:(id)sender
{
    lo_send(t, "/quit", NULL);
}

- (IBAction)sendMessage2:(id)sender
{
    if (lo_send(t, "/foo/bar", "ff", 0.12345678f, 23.0f) == -1) {
        printf("OSC error %d: %s\n", lo_address_errno(t), lo_address_errstr(t));
    }
}

- (IBAction)sendScript:(id)sender
{
    // init object states
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


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    t = lo_address_new(NULL, "7000");
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

@end
