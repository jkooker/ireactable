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
	}
	return self;
}

- (lo_address)loAddress {
    return t;
}

@end
