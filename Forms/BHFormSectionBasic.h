//
//  BHBasicFormSection.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHFormSection.h"

@interface BHFormSectionBasic : BHFormSection {
    
}

@property (nonatomic, retain) NSMutableArray *fields;
@property (readwrite, copy) HeightForCellBlock heightForRow;
@property (readwrite, copy) ConfigureCellBlock configureRow;
@property (readwrite, copy) didTapRow didTapRow;
@property (readwrite, copy) didSwipeToDeleteRow didSwipeToDeleteRow;

- (void)addCellFromNIBWithName:(NSString*)widgetClass;
+ (BHFormSectionBasic*)formSectionForFormVC:(BHBlockTableViewController*)vc;
- (void)removeAllCells;
@end
