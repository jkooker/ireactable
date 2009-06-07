//
//  MainView.m
//  iReactable
//
//  Created by John Kooker on 6/6/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "MainView.h"

#define CGPointNull CGPointMake(-1, -1)
#define TRACE NSLog(@"%@ %s", [self class], _cmd)

#define GROW_ANIMATION_DURATION_SECONDS 0.15    // Determines how fast a piece size grows when it is moved.
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15  // Determines how fast a piece size shrinks when a piece stops moving.

@implementation MainView

- (void)awakeFromNib {
    activeImage = nil;
    
    [self bringSubviewToFront:sink]; // sink is special, and stationary
    
    allImages = [[NSArray arrayWithObjects:squarewave, vcf, lfo, nil] retain];
    for (UIImageView *image in [allImages reverseObjectEnumerator]) {
        [self bringSubviewToFront:image];
    }
    
    primaryTouchLocation = secondaryTouchStartLocation = CGPointNull;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();

    CGContextSetRGBFillColor(contextRef, 0.8, 0, 0, 1);
    CGContextSetRGBStrokeColor(contextRef, 1, 1, 1, .8);
    CGContextSetLineWidth(contextRef, 3.0);
    
    CGContextBeginPath(contextRef);

    // draw from vcf to sink
    CGContextMoveToPoint(contextRef, vcf.center.x, vcf.center.y);
    CGContextAddLineToPoint(contextRef, sink.center.x, sink.center.y);
    // draw from squarewave to vcf
    CGContextMoveToPoint(contextRef, squarewave.center.x, squarewave.center.y);
    CGContextAddLineToPoint(contextRef, vcf.center.x, vcf.center.y);
    // draw from lfo to vcf
    CGContextMoveToPoint(contextRef, lfo.center.x, lfo.center.y);
    CGContextAddLineToPoint(contextRef, vcf.center.x, vcf.center.y);

    CGContextDrawPath(contextRef, kCGPathStroke);
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
                    [self activateImage:anImage];
                    break; // don't try to activate any others
                }
            }
        } else if (CGPointEqualToPoint(secondaryTouchStartLocation, CGPointNull)) {
            secondaryTouchStartLocation = [touch locationInView:self];
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
                [self setNeedsDisplay];
            }
        } else if (CGPointEqualToPoint([touch previousLocationInView:self], secondaryTouchStartLocation) || CGPointEqualToPoint([touch previousLocationInView:self], secondaryTouchEndLocation)) {
            secondaryTouchEndLocation = [touch locationInView:self];
            
            // rotate to that angle
            [self updateRotation];
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
        } else if (CGPointEqualToPoint([touch previousLocationInView:self], secondaryTouchEndLocation) || CGPointEqualToPoint([touch locationInView:self], secondaryTouchEndLocation)) {
            // secondary touch ended
            secondaryTouchStartLocation = secondaryTouchEndLocation = CGPointNull;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // deactivate tapped view
    [self deactivateImage];
    
    // reset touch locations
    primaryTouchLocation = secondaryTouchStartLocation = secondaryTouchEndLocation = CGPointNull;
}

#pragma mark Animations

- (void)activateImage:(UIImageView*)image
{
    activeImage = image;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	image.transform = CGAffineTransformMakeScale(1.2, 1.2);
    image.center = primaryTouchLocation;
    [self setNeedsDisplay];
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

- (void)updateRotation
{
    // this should be replaced by real angle calculations
    CGFloat angle = (secondaryTouchStartLocation.y - secondaryTouchEndLocation.y)/15.0;
    
    CGAffineTransform t = CGAffineTransformMakeScale(1.2, 1.2);
    activeImage.transform = CGAffineTransformRotate(t, angle);
}

@end
