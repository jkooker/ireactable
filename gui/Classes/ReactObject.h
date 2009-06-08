//
//  ReactObject.h
//  iReactable
//
//  Created by John Kooker on 6/7/09.
//  Copyright 2009 John Kooker. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReactObject : NSObject {
    CGFloat param1;
    CGFloat param2;
    NSString *targetName;
    BOOL isEnabled;
}

@property (copy,readwrite) NSString *targetName;
@property CGFloat param1;
@property CGFloat param2;
@property BOOL isEnabled;

@end
