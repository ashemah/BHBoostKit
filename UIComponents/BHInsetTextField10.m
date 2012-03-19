//
//  BHInsetTextField10.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/2/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHInsetTextField10.h"

@implementation BHInsetTextField10

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}
@end
