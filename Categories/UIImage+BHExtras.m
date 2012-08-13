//
//  UIImage+BHExtras.m
//  BeatTheQ
//
//  Created by Ashemah Harrison on 8/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+BHExtras.h"

@implementation UIImage (Tint)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor {
    UIGraphicsBeginImageContext(self.size);
    CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:drawRect];
    [tintColor set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceAtop);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

- (UIImage *)darken {
    
    if (self.leftCapWidth > 0 || self.topCapHeight > 0) {
        return [[self tintedImageUsingColor:[UIColor colorWithWhite:0.0 alpha:0.2]] stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    }
    
    return [self tintedImageUsingColor:[UIColor colorWithWhite:0.0 alpha:0.2]];
}

@end