//
//  BHFetchedResultsControllerFormSection.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHFormSection.h"

@interface BHFormSectionFRC : BHFormSection<NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain) NSFetchedResultsController *frc;
@property (nonatomic, retain) NSString *widgetClass;
@property (readwrite, copy) HeightForFRCRowBlock heightForRowBlock;
@property (readwrite, copy) ConfigureCellForFRCRowBlock configureCellForRowBlock;
@property (readwrite, copy) DidTapCellInFRCSectionBlock didTapCellInSectionBlock;
@property (readwrite, copy) DidSwipeDeleteCellInFRCSectionBlock didSwipeDeleteCellInSectionBlock;
@property (nonatomic, retain) id currentObject;

- (id)initWithFormVC:(BHBlockTableViewController*)formVC1 widgetClass:(NSString*)widgetClass1 frc:(NSFetchedResultsController*)frc1;
+ (BHFormSectionFRC*)formSectionForFormVC:(BHBlockTableViewController*)vc widgetClass:(NSString*)widgetClass1 frc:(NSFetchedResultsController*)frc1;

@end
