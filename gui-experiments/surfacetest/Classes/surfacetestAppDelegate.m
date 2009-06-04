//
//  surfacetestAppDelegate.m
//  surfacetest
//
//  Created by John Kooker on 5/24/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "surfacetestAppDelegate.h"
#import "surfacetestViewController.h"

@implementation surfacetestAppDelegate

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
