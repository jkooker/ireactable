//
//  MainView.m
//  iReactable
//
//  Created by John Kooker on 6/6/09.
//  Copyright John Kooker 2009. All rights reserved.
//

#import "MainView.h"

#define CGPointNull CGPointMake(-1, -1)

CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    return atan2f(first.y - second.y, first.x - second.x);
}

// converts to an angle between 0 and 2pi
CGFloat fixAngle(CGFloat angle) {
    CGFloat fixedangle = fmodf(angle, 2*M_PI);
    if (fixedangle < 0) fixedangle += 2*M_PI;
    
    return fixedangle;
}

CGFloat convertAngleToControlValue(CGFloat angle) {
    CGFloat x = (fixAngle(angle)/(2*M_PI)) - 0.5;
    if (x<0) x += 1;
    
    return x;
}

@implementation MainView

- (void)awakeFromNib {
    activeImage = nil;
    
    [self bringSubviewToFront:sink]; // sink is special, and stationary
    
    allImages = [[NSArray arrayWithObjects:squarewave, vcf, lfo, nil] retain];
    for (UIImageView *image in [allImages reverseObjectEnumerator]) {
        [self bringSubviewToFront:image];
    }
    
    primaryTouchLocation = secondaryTouchStartLocation = CGPointNull;
    react = [ReactController sharedReactController];
    
    squarewave.reactObject = [react squarewave];
    vcf.reactObject = [react vcf];
    lfo.reactObject = [react lfo];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();

    CGContextSetRGBFillColor(contextRef, 0.8, 0, 0, 1);
    CGContextSetRGBStrokeColor(contextRef, 0.09, 0.46, 1, 1);
    CGContextSetLineWidth(contextRef, 3.0);
    
    CGContextBeginPath(contextRef);

    if ([self checkProximityOf:vcf to:sink]) {
        // draw from vcf to sink
        CGContextMoveToPoint(contextRef, vcf.center.x, vcf.center.y);
        CGContextAddLineToPoint(contextRef, sink.center.x, sink.center.y);
    }
    if ([self checkProximityOf:squarewave to:vcf]) {
        // draw from squarewave to vcf
        CGContextMoveToPoint(contextRef, squarewave.center.x, squarewave.center.y);
        CGContextAddLineToPoint(contextRef, vcf.center.x, vcf.center.y);
    }
    if ([self checkProximityOf:lfo to:vcf]) {
        // draw from lfo to vcf
        CGContextMoveToPoint(contextRef, lfo.center.x, lfo.center.y);
        CGContextAddLineToPoint(contextRef, vcf.center.x, vcf.center.y);
    }
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}

- (BOOL)checkProximityOf:(UIImageView*)first to:(UIImageView*)second {
    CGFloat dx = first.center.x - second.center.x;
    CGFloat dy = first.center.y - second.center.y;
    
    CGFloat distance = sqrtf(dx*dx + dy*dy);
    static CGFloat kMinDistance = 150;
    if (distance <= kMinDistance) return YES;
    else return NO;
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
#define GROW_ANIMATION_DURATION_SECONDS 0.15    // Determines how fast a piece size grows when it is moved.
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15  // Determines how fast a piece size shrinks when a piece stops moving.

static CGFloat kScaleFactor = 1.3;

- (void)activateImage:(UIImageView*)image
{
    activeImage = image;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	image.transform = CGAffineTransformMakeScale(kScaleFactor, kScaleFactor);
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
    CGFloat angle = angleBetweenPoints(primaryTouchLocation, secondaryTouchEndLocation) - angleBetweenPoints(primaryTouchLocation, secondaryTouchStartLocation);
    
    CGAffineTransform t = CGAffineTransformMakeScale(kScaleFactor, kScaleFactor);
    activeImage.transform = CGAffineTransformRotate(t, angle);

    NSLog(@"angle: %.2f, control: %.2f", fixAngle(angle), convertAngleToControlValue(angle));
}

@end
