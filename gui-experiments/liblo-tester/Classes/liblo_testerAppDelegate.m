//
//  liblo_testerAppDelegate.m
//  liblo-tester
//
//  Created by John Kooker on 5/19/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "liblo_testerAppDelegate.h"
#import "liblo_testerViewController.h"

@implementation liblo_testerAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
