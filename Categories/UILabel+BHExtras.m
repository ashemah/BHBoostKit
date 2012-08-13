//
//  UILabel+BHExtras.m
//  BeatTheQ
//
//  Created by Ashemah Harrison on 31/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UILabel+BHExtras.h"


@implementation UILabel (UILabel_BHExtras)

- (void)sizeToFitFixedWidth:(CGFloat)fixedWidth {

    self.lineBreakMode = UILineBreakModeWordWrap;
    self.numberOfLines = 0;
    
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize: CGSizeMake(fixedWidth, CGFLOAT_MAX) lineBreakMode: UILineBreakModeWordWrap];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWidth, size.height);    
}

- (void)sizeHeightKeepingFixedWidth {
    [self sizeToFitFixedWidth:self.frame.size.width];
}

@end
