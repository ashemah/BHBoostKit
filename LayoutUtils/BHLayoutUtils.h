//
//  BHLayoutUtils.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHLayoutUtils : NSObject

// Placing views
+ (void)place:(UIView*)view after:(UIView*)afterView;
+ (void)place:(UIView*)view after:(UIView*)afterView withSpacing:(CGFloat)spacing;
+ (void)centerHorizontally:(UIView*)view inView:(UIView*)parentView;
+ (void)centerVertically:(UIView*)view inView:(UIView*)parentView;
+ (void)move:(UIView*)view toX:(CGFloat)x;
+ (void)move:(UIView*)view toY:(CGFloat)y;

// Sizing views
+ (void)fillParentBounds:(UIView*)view;
+ (void)setView:(UIView*)view height:(CGFloat)height;
+ (void)setView:(UIView*)view width:(CGFloat)width;

// Label stuff
+ (CGSize)sizeForLabelRetainingWidth:(UILabel*)label;
+ (CGSize)sizeForLabel:(UILabel*)label usingFixedWidth:(CGFloat)fixedWidth;

+ (void)resizeLabel:(UILabel*)label usingFixedWidth:(CGFloat)fixedWidth;
+ (void)resizeLabelRetainingWidth:(UILabel*)label;

@end
