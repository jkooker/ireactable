//
//  Surface.m
//  surfacetest
//
//  Created by John Kooker on 5/24/09.
//  Copyright 2009 John Kooker. All rights reserved.
//

#import "Surface.h"

#define CGPointNull CGPointMake(-1, -1)
#define TRACE NSLog(@"%@ %s", [self class], _cmd)

#define GROW_ANIMATION_DURATION_SECONDS 0.15    // Determines how fast a piece size grows when it is moved.
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15  // Determines how fast a piece size shrinks when a piece stops moving.


@implementation Surface

- (void)awakeFromNib
{
    activeImage = nil;
    
    allImages = [[NSArray arrayWithObjects:squarewave, vcf, lfo, nil] retain];
    
    primaryTouchLocation = secondaryTouchLocation = CGPointNull;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [allImages release];
    [super dealloc];
}

#pragma mark Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // is this a primary or secondary touch?
    for (UITouch *touch in touches) {
        if (CGPointEqualToPoint(primaryTouchLocation, CGPointNull)) {
            primaryTouchLocation = [touch locationInView:self];
            
            // figure out which object got tapped
            for (UIImageView *anImage in allImages) {
                if (CGRectContainsPoint([anImage frame], primaryTouchLocation)) {
                    NSLog(@"touched an image");
                    [self activateImage:anImage];
                }
            }
        } else if (CGPointEqualToPoint(secondaryTouchLocation, CGPointNull)) {
            secondaryTouchLocation = [touch locationInView:self];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (CGPointEqualToPoint([touch previousLocationInView:self], primaryTouchLocation)) {
            // this is the primary touch
            primaryTouchLocation = [touch locationInView:self];
            
            // if a view was tapped, move it here
            if (activeImage) {
                activeImage.center = [touch locationInView:self];
            }
        } else {
            // consider all others "secondary"
            // do nothing with them yet
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // reset certain touch locations
    for (UITouch *touch in touches) {
        if (CGPointEqualToPoint([touch previousLocationInView:self], primaryTouchLocation) || CGPointEqualToPoint([touch locationInView:self], primaryTouchLocation)) {
            // deactivate tapped view
            [self deactivateImage];
            primaryTouchLocation = CGPointNull;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // deactivate tapped view
    [self deactivateImage];
    
    // reset touch locations
    primaryTouchLocation = secondaryTouchLocation = CGPointNull;
}

#pragma mark Animations

- (void)activateImage:(UIImageView*)image
{
    activeImage = image;

    // no idea why we use a touchPointValue
    NSValue *touchPointValue = [[NSValue valueWithCGPoint:image.center] retain];
    [UIView beginAnimations:nil context:touchPointValue];
    [UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
	image.transform = transform;
	[UIView commitAnimations];
}

- (void)deactivateImage
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	// Set the transform back to the identity, thus undoing the previous scaling effect.
	activeImage.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
    
    activeImage = nil;
}

@end
