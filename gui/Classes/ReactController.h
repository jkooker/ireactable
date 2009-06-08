//
//  ReactController.h
//  iReactable
//
//  Created by John Kooker on 6/7/09.
//  Copyright 2009 John Kooker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lo/lo.h"
#import "ReactObject.h"

#define TRACE NSLog(@"%@ %s", [self class], _cmd)

@interface ReactController : NSObject {
    NSString *oscAddress;
    NSString *oscPort;
    lo_address t;
    
    ReactObject *squarewave;
    ReactObject *vcf;
    ReactObject *lfo;
    
    NSArray *reactObjects;
}

@property (nonatomic, copy) NSString *oscAddress;
@property (nonatomic, copy) NSString *oscPort;
@property (readonly) ReactObject *squarewave;
@property (readonly) ReactObject *vcf;
@property (readonly) ReactObject *lfo;
@property (readonly) NSArray *reactObjects;

+ (ReactController *)sharedReactController;

- (lo_address)loAddress;
- (void)sendPeriodicUpdates;

@end
