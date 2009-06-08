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
    
    primaryTouchLocation = secondaryTouchStartLocation = secondaryTouchEndLocation = CGPointNull;
    secondaryTouchStartAngle = 0;
    currentRotation = 0;
    
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

    if (vcf.isConnected) {
        // draw from vcf to its destination
        CGContextMoveToPoint(contextRef, vcf.center.x, vcf.center.y);
        CGContextAddLineToPoint(contextRef, vcf.target.center.x, vcf.target.center.y);
    }
    if (squarewave.isConnected) {
        // draw from squarewave to its destination
        CGContextMoveToPoint(contextRef, squarewave.center.x, squarewave.center.y);
        CGContextAddLineToPoint(contextRef, squarewave.target.center.x, squarewave.target.center.y);
    }
    if (lfo.isConnected) {
        // draw from lfo to its destination
        CGContextMoveToPoint(contextRef, lfo.center.x, lfo.center.y);
        CGContextAddLineToPoint(contextRef, lfo.target.center.x, lfo.target.center.y);
    }
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}

- (CGFloat)distanceFrom:(UIImageView*)first to:(UIImageView*)second {
    CGFloat dx = first.center.x - second.center.x;
    CGFloat dy = first.center.y - second.center.y;
    
    CGFloat distance = sqrtf(dx*dx + dy*dy);
    
    return distance;
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
            for (ReactImageView *anImage in allImages) {
                if (CGRectContainsPoint([anImage frame], primaryTouchLocation)) {
                    [self activateImage:anImage];
                    [self updateConnectionsFrom:anImage];
                    break; // don't try to activate any others
                }
            }
        } else if (CGPointEqualToPoint(secondaryTouchStartLocation, CGPointNull)) {
            secondaryTouchStartLocation = [touch locationInView:self];
            secondaryTouchStartAngle = angleBetweenPoints(primaryTouchLocation, secondaryTouchStartLocation);
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
                [self updateConnectionsFrom:activeImage];
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
            activeImage.angle += currentRotation;
            currentRotation = 0;
            secondaryTouchStartLocation = secondaryTouchEndLocation = CGPointNull;
            secondaryTouchStartAngle = 0;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // deactivate tapped view
    [self deactivateImage];
    
    // reset touch locations
    primaryTouchLocation = secondaryTouchStartLocation = secondaryTouchEndLocation = CGPointNull;
    secondaryTouchStartAngle = 0;
}

#pragma mark Animations
#define GROW_ANIMATION_DURATION_SECONDS 0.15    // Determines how fast a piece size grows when it is moved.
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15  // Determines how fast a piece size shrinks when a piece stops moving.

static CGFloat kScaleFactor = 1.3;

- (void)activateImage:(ReactImageView*)image
{
    activeImage = image;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
    CGAffineTransform t = CGAffineTransformMakeScale(kScaleFactor, kScaleFactor);
	image.transform = CGAffineTransformRotate(t, image.angle);
    image.center = primaryTouchLocation;
    [self setNeedsDisplay];
	[UIView commitAnimations];
}

- (void)deactivateImage
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	// Set the transform back to the identity, thus undoing the previous scaling effect.
	activeImage.transform = CGAffineTransformMakeRotation(activeImage.angle);
	[UIView commitAnimations];
    
    activeImage = nil;
}

- (void)updateRotation
{
    CGFloat angle = angleBetweenPoints(primaryTouchLocation, secondaryTouchEndLocation) - secondaryTouchStartAngle;
    
    CGAffineTransform t = CGAffineTransformMakeScale(kScaleFactor, kScaleFactor);
    activeImage.transform = CGAffineTransformRotate(t, angle + activeImage.angle);

    currentRotation = angle;
    //NSLog(@"angle control: %.2f", convertAngleToControlValue(angle + activeImage.angle));
    activeImage.reactObject.param1 = convertAngleToControlValue(angle + activeImage.angle);
}

- (void)updateConnectionsFrom:(ReactImageView*)image
{
    static CGFloat kMaxPieceDistance = 150;
    static CGFloat kMaxSinkDistance = 100;

    if (image == squarewave) {
        // squarewave can connect to vcf, sink, and devnull
        CGFloat d2vcf = [self distanceFrom:squarewave to:vcf];
        CGFloat d2sink = [self distanceFrom:squarewave to:sink];
        
        if (d2sink <= kMaxSinkDistance) {
            // make sure vcf isn't closer
            if (d2sink <= d2vcf) {
                // connect to sink
                image.target = sink;
                image.isConnected = YES;
                image.reactObject.targetName = @"sink";
            } else {
                // connect to vcf
                image.target = vcf;
                image.isConnected = YES;
                image.reactObject.targetName = @"vcf-signal";
            }
        } else if (d2vcf <= kMaxPieceDistance) {
            // connect to vcf
            image.target = vcf;
            image.isConnected = YES;
            image.reactObject.targetName = @"vcf-signal";
        } else {
            // disconnect
            image.target = nil;
            image.isConnected = NO;
            image.reactObject.targetName = @"devnull";
        }
    } else if (image == vcf) {
        // vcf can connect to sink and devnull
        CGFloat d2sink = [self distanceFrom:vcf to:sink];
        
        if (d2sink <= kMaxSinkDistance) {
            // connect to sink
            image.target = sink;
            image.isConnected = YES;
            image.reactObject.targetName = @"sink";
        } else {
            // disconnect
            image.target = nil;
            image.isConnected = NO;
            image.reactObject.targetName = @"devnull";
        }
    } else if (image == lfo) {
        // lfo can connect to squarewave, vcf, and devnull
        CGFloat d2squarewave = [self distanceFrom:lfo to:squarewave];
        CGFloat d2vcf = [self distanceFrom:lfo to:vcf];
        
        if (d2squarewave <= kMaxPieceDistance) {
            // make sure vcf isn't closer
            if (d2squarewave <= d2vcf) {
                // connect to squarewave
                image.target = squarewave;
                image.isConnected = YES;
                image.reactObject.targetName = @"squarewave";
            } else {
                // connect to vcf
                image.target = vcf;
                image.isConnected = YES;
                image.reactObject.targetName = @"vcf-control";
            }
        } else if (d2vcf <= kMaxPieceDistance) {
            // connect to vcf
            image.target = vcf;
            image.isConnected = YES;
            image.reactObject.targetName = @"vcf-control";
        } else {
            // disconnect
            image.target = nil;
            image.isConnected = NO;
            image.reactObject.targetName = @"devnull";
        }
    }
}


@end
