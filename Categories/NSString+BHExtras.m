//
//  NSString+BHExtras.m
//  BeatTheQ
//
//  Created by Ashemah Harrison on 1/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+BHExtras.h"


@implementation NSString (NSString_BHExtras)

+ (NSString*)formattedStringFromDecimalNumber:(NSDecimalNumber*)number {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setPositiveFormat:@"¤#,##0.00"];
    [numberFormatter setNegativeFormat:@"-¤#,##0.00"];
    return [numberFormatter stringFromNumber:number];
}

- (CGFloat)heightWithFont:(UIFont*)font constrainedToWidth:(CGFloat)width {
    
    CGFloat contentHeight = 
    [self sizeWithFont: font
     constrainedToSize: CGSizeMake( width, 9999)
         lineBreakMode: UILineBreakModeWordWrap].height;
    
    return contentHeight;
}

@end
