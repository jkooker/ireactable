//
//  Surface.h
//  surfacetest
//
//  Created by John Kooker on 5/24/09.
//  Copyright 2009 John Kooker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Surface : UIView {
    IBOutlet UIImageView *squarewave;
    IBOutlet UIImageView *vcf;
    IBOutlet UIImageView *lfo;
    IBOutlet UIImageView *sink;
    
    UIImageView *activeImage;
    NSArray *allImages;
    
    CGPoint primaryTouchLocation;
    CGPoint secondaryTouchStartLocation;
    CGPoint secondaryTouchEndLocation;
}

- (void)activateImage:(UIImageView*)image;
- (void)deactivateImage;
- (void)updateRotation;

@end
