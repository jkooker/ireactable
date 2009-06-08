//
//  FlipsideViewController.h
//  iReactable
//
//  Created by John Kooker on 6/6/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "lo/lo.h"
#import "ReactController.h"

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	id <FlipsideViewControllerDelegate> delegate;
    
    NSArray *tableTitles;
    NSArray *objectNames;
    NSArray *infoStrings;
    NSArray *configItems;
    
    ReactController *react;
    lo_address t;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done;
- (void)runOSCTestScript;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

