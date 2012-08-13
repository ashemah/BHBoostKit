//
//  UIImage+BHExtras.h
//  BeatTheQ
//
//  Created by Ashemah Harrison on 8/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Tint)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor;
- (UIImage *)darken;

@end
