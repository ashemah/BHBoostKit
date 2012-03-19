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
@property (readwrite, copy) HeightForRowBlock heightForRowBlock;
@property (readwrite, copy) ConfigureCellForRowBlock configureCellForRowBlock;
@property (readwrite, copy) DidTapCellInSectionBlock didTapCellInSectionBlock;
@property (readwrite, copy) DidSwipeDeleteCellInSectionBlock didSwipeDeleteCellInSectionBlock;

- (void)addWidgetWithClass:(NSString*)widgetClass;
+ (BHFormSectionBasic*)formSectionForFormVC:(BHFormViewController*)vc;

@end
