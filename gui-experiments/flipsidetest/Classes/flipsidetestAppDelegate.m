//
//  flipsidetestAppDelegate.m
//  flipsidetest
//
//  Created by John Kooker on 6/5/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "flipsidetestAppDelegate.h"
#import "MainViewController.h"

@implementation flipsidetestAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
