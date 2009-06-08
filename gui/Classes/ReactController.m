//
//  ReactController.m
//  iReactable
//
//  Created by John Kooker on 6/7/09.
//  Copyright 2009 John Kooker. All rights reserved.
//

#import "ReactController.h"
#import "SynthesizeSingleton.h"

@implementation ReactController

@synthesize oscAddress;
@synthesize oscPort;
@synthesize squarewave;
@synthesize vcf;
@synthesize lfo;

SYNTHESIZE_SINGLETON_FOR_CLASS(ReactController);

- (id)init
{
	if (self = [super init]) {
        // initialization code
        self.oscAddress = [NSString stringWithString:@"192.168.1.100"];
        self.oscPort = [NSString stringWithString:@"7000"];
        
        // OSC initializations
        t = lo_address_new([oscAddress cStringUsingEncoding:[NSString defaultCStringEncoding]], [oscPort cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        lo_send(t, "/hello", ""); // make the connection
        
        squarewave = [[ReactObject alloc] init];
        vcf = [[ReactObject alloc] init];
        lfo = [[ReactObject alloc] init];
        
        [NSThread detachNewThreadSelector:@selector(sendPeriodicUpdates) toTarget:self withObject:nil];
	}
	return self;
}

- (void)dealloc {
    lo_address_free(t);
    [super dealloc];
}

- (lo_address)loAddress {
    return t;
}

- (void)sendPeriodicUpdates {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BOOL sendOSC = YES;
    // send all state information every 1 second
    while (sendOSC) {
        lo_send(t, "/ireactable/connect", "ss", "squarewave", [[squarewave targetName] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        lo_send(t, "/ireactable/connect", "ss", "lfo", [[lfo targetName] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        lo_send(t, "/ireactable/connect", "ss", "vcf", [[vcf targetName] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        lo_send(t, "/ireactable/squarewave", "ff", [squarewave param1], [squarewave param2]);
        lo_send(t, "/ireactable/vcf", "ff", [vcf param1], [vcf param2]);
        lo_send(t, "/ireactable/lfo", "ff", [lfo param1], [lfo param2]);
        
        [NSThread sleepForTimeInterval:0.10];
    }
    [pool release];
}


@end
