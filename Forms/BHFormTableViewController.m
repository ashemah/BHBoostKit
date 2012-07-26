//
//  BHFormViewController.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/13/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHFormTableViewController.h"
#import "BHCompositeTableSection.h"
#import "BHNIBTools.h"

//-----------------------------------------------------------------------------------------------

@implementation BHFormTableViewController

@synthesize textFieldHelper = _tfHelper;

- (void)dealloc {
    [_tfHelper release];
    [super dealloc];
}

- (BHTextFieldHelper*)textFieldHelper {
    
    if (!_tfHelper) {
        _tfHelper = [[BHTextFieldHelper alloc] init];
        _tfHelper.tableView = self.tableView;
    }
    
    return _tfHelper;
}

@end
