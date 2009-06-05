//
//  liblo_testerViewController.h
//  liblo-tester
//
//  Created by John Kooker on 5/19/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lo/lo.h"


@interface liblo_testerViewController : UIViewController {
    lo_address t;
}

- (IBAction)sendMessage1:(id)sender;
- (IBAction)sendMessage2:(id)sender;
- (IBAction)sendScript:(id)sender;

@end

