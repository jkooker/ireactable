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
}

@property (retain, readwrite) ReactObject *reactObject;

@end
