//
//  BHLayoutUtils.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BHLayoutUtils.h"

@implementation BHLayoutUtils

// Layout
+ (void)place:(UIView*)view after:(UIView*)afterView {  
    [BHLayoutUtils place:view after:afterView withSpacing:0];
}

+ (void)place:(UIView*)view after:(UIView*)afterView withSpacing:(CGFloat)spacing {
    CGRect f = view.frame;
    f.origin.y = afterView.frame.origin.y + afterView.frame.size.height + spacing;
    view.frame = f;
}

+ (void)centerHorizontally:(UIView*)view inView:(UIView*)parentView {
    CGRect f = view.frame;
    f.origin.x = (parentView.frame.size.width/2)-(view.frame.size.width/2);
    view.frame = f;
}

+ (void)centerVertically:(UIView*)view inView:(UIView*)parentView {
    CGRect f = view.frame;
    f.origin.y = (parentView.frame.size.height/2)-(view.frame.size.height/2);
    view.frame = f;
}

+ (void)move:(UIView*)view toX:(CGFloat)x {
    CGRect f = view.frame;
    f.origin.x = x;
    view.frame = f;
}

+ (void)move:(UIView*)view toY:(CGFloat)y {
    CGRect f = view.frame;
    f.origin.y = y;
    view.frame = f;
}


// Sizing Views

+ (void)setView:(UIView*)view width:(CGFloat)width {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, view.frame.size.height);
}

+ (void)setView:(UIView*)view height:(CGFloat)height {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
}

+ (void)fillParentBounds:(UIView*)view {
    view.frame = view.superview.bounds;
}

// Sizing Labels

+ (CGSize)sizeForLabelRetainingWidth:(UILabel*)label {
    
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;    
    return [label.text sizeWithFont:label.font constrainedToSize: CGSizeMake(label.frame.size.width, CGFLOAT_MAX) lineBreakMode: UILineBreakModeWordWrap];
}

+ (CGSize)sizeForLabel:(UILabel*)label usingFixedWidth:(CGFloat)fixedWidth {
    
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    
    return [label.text sizeWithFont:label.font constrainedToSize: CGSizeMake(fixedWidth, CGFLOAT_MAX) lineBreakMode: UILineBreakModeWordWrap];
}

+ (void)resizeLabel:(UILabel*)label usingFixedWidth:(CGFloat)fixedWidth {
    
    CGSize size = [BHLayoutUtils sizeForLabel:label usingFixedWidth:fixedWidth];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, fixedWidth, size.height);    
}

+ (void)resizeLabelRetainingWidth:(UILabel*)label {
    [self resizeLabel:label usingFixedWidth:label.frame.size.width];
}

@end
