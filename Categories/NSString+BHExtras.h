//
//  NSString+BHExtras.h
//  BeatTheQ
//
//  Created by Ashemah Harrison on 1/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_BHExtras)
+ (NSString*)formattedStringFromDecimalNumber:(NSDecimalNumber*)number;
- (CGFloat)heightWithFont:(UIFont*)font constrainedToWidth:(CGFloat)width;

@end
