//
//  ReactObject.m
//  iReactable
//
//  Created by John Kooker on 6/7/09.
//  Copyright 2009 John Kooker. All rights reserved.
//

#import "ReactObject.h"


@implementation ReactObject

@synthesize targetName;
@synthesize param1;
@synthesize param2;
@synthesize isEnabled;

- (id)init
{
	if (self = [super init]) {
        // initialization code
        self.targetName = @"devnull";
        self.param1 = 0.5f;
        self.param2 = 0.5f;
        self.isEnabled = NO;
	}
	return self;
}

@end
