//
//  ReactController.h
//  iReactable
//
//  Created by John Kooker on 6/7/09.
//  Copyright 2009 John Kooker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lo/lo.h"

@interface ReactController : NSObject {
    NSString *oscAddress;
    NSString *oscPort;

    lo_address t;
}

@property (nonatomic, copy) NSString *oscAddress;
@property (nonatomic, copy) NSString *oscPort;

+ (ReactController *)sharedReactController;

- (lo_address)loAddress;

@end
