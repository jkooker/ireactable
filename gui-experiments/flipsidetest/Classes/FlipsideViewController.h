//
//  FlipsideViewController.h
//  flipsidetest
//
//  Created by John Kooker on 6/5/09.
//  Copyright John Kooker 2009. All rights reserved.
//

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	id <FlipsideViewControllerDelegate> delegate;
    NSArray *objectsListData;
    NSArray *settingsListData;
    NSArray *sectionTitles;
}

@property (nonatomic, retain) NSArray *objectsListData;
@property (nonatomic, retain) NSArray *settingsListData;
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

