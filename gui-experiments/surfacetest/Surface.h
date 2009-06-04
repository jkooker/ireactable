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
    
    UIImageView *activeImage;
    NSArray *allImages;
}

@end
