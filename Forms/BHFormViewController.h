//
//  BHFormViewController.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/13/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHTextFieldHelper.h"
#import "BHBlockTableViewController.h"

@interface BHFormViewController : BHBlockTableViewController {
    BHTextFieldHelper *_tfHelper;
}

@property (nonatomic, retain) BHTextFieldHelper *textFieldHelper;

@end
