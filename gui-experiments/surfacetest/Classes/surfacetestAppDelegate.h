//
//  surfacetestAppDelegate.h
//  surfacetest
//
//  Created by John Kooker on 5/24/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class surfacetestViewController;

@interface surfacetestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    surfacetestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet surfacetestViewController *viewController;

@end

