//
//  FlipsideViewController.h
//  iReactable
//
//  Created by John Kooker on 6/6/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "lo/lo.h"

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	id <FlipsideViewControllerDelegate> delegate;
    
    NSArray *tableTitles;
    NSArray *objectNames;
    NSArray *infoStrings;
    
    lo_address t;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

