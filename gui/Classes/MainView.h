//
//  MainView.h
//  iReactable
//
//  Created by John Kooker on 6/6/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainView : UIView {
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
