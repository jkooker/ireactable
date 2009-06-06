//
//  flipsidetestAppDelegate.h
//  flipsidetest
//
//  Created by John Kooker on 6/5/09.
//  Copyright John Kooker 2009. All rights reserved.
//

@class MainViewController;

@interface flipsidetestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

