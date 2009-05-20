//
//  liblo_testerAppDelegate.h
//  liblo-tester
//
//  Created by John Kooker on 5/19/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class liblo_testerViewController;

@interface liblo_testerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    liblo_testerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet liblo_testerViewController *viewController;

@end

