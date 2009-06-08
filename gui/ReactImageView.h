//
//  ReactImageView.h
//  iReactable
//
//  Created by John Kooker on 6/7/09.
//  Copyright 2009 John Kooker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactObject.h"

@interface ReactImageView : UIImageView {
    ReactObject *reactObject;
    CGFloat angle;
    BOOL isConnected;
    UIImageView *target;
}

@property (retain, readwrite) ReactObject *reactObject;
@property CGFloat angle;
@property BOOL isConnected;
@property (retain, readwrite) UIImageView *target;

@end
