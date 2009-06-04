//
//  Surface.m
//  surfacetest
//
//  Created by John Kooker on 5/24/09.
//  Copyright 2009 John Kooker. All rights reserved.
//

#import "Surface.h"


@implementation Surface

- (void)awakeFromNib
{
    activeImage = nil;
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
    [super dealloc];
}

#pragma mark Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    // figure out which object got tapped
    if (CGRectContainsPoint([squarewave frame], touchPoint)) {
        NSLog(@"touched squarewave");
        activeImage = squarewave;
    } else if (CGRectContainsPoint([vcf frame], touchPoint)) {
        NSLog(@"touched vcf");
        activeImage = vcf;
    } else if (CGRectContainsPoint([lfo frame], touchPoint)) {
        NSLog(@"touched lfo");
        activeImage = lfo;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if a view was tapped, move it here
    if (activeImage) {
        activeImage.center = [[touches anyObject] locationInView:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // deactivate tapped view
    activeImage = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // deactivate tapped view
    activeImage = nil;
}


@end
