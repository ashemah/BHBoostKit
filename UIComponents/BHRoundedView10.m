//
//  BHRoundedView10.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BHRoundedView10.h"
#import <QuartzCore/QuartzCore.h>

@implementation BHRoundedView10

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 10;
    }
    return self;
}

@end
