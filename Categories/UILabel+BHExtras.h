//
//  UILabel+BHExtras.h
//  BeatTheQ
//
//  Created by Ashemah Harrison on 31/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UILabel (UILabel_BHExtras)
- (void)sizeToFitFixedWidth:(CGFloat)fixedWidth;
- (void)sizeHeightKeepingFixedWidth;
@end
