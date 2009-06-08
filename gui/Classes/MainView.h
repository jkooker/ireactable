//
//  MainView.h
//  iReactable
//
//  Created by John Kooker on 6/6/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactController.h"
#import "ReactImageView.h"

@interface MainView : UIView {
    IBOutlet ReactImageView *squarewave;
    IBOutlet ReactImageView *vcf;
    IBOutlet ReactImageView *lfo;
    IBOutlet UIImageView *sink;
    
    ReactImageView *activeImage;
    NSArray *allImages;
    
    CGPoint primaryTouchLocation;
    CGPoint secondaryTouchStartLocation;
    CGFloat secondaryTouchStartAngle;
    CGPoint secondaryTouchEndLocation;
    CGFloat currentRotation;
    
    ReactController *react;
}

- (void)activateImage:(ReactImageView*)image;
- (void)deactivateImage;
- (void)updateRotation;
- (BOOL)checkProximityOf:(UIImageView*)first to:(UIImageView*)second;

@end
