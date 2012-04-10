//
//  BHTextFieldHelperInfo.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BHTextFieldHelperInfo.h"

@implementation BHTextFieldHelperInfo

@synthesize field;
@synthesize presenterParser;

- (void)dealloc {
    self.field = nil;    
    self.presenterParser = nil;
    
    [super dealloc];
}

@end
