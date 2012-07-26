//
//  BHFetchedResultsControllerFormSection.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHCompositeTableSection.h"

@interface BHCompositeTableSectionFRC : BHCompositeTableSection<NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_frc;
}

@property (nonatomic, retain) NSFetchedResultsController *frc;
@property (nonatomic, retain) NSString *widgetClass;
@property (nonatomic, assign) NSInteger frcSourceSection;
@property (readwrite, copy) HeightForFRCRowBlock heightForRow;
@property (readwrite, copy) ConfigureCellForFRCRowBlock configureRow;
@property (readwrite, copy) DidTapCellInFRCSectionBlock didTapRow;
@property (readwrite, copy) DidSwipeDeleteCellInFRCSectionBlock didSwipeToDeleteRow;

- (id)initWithViewController:(BHCompositeTableViewController*)formVC1 widgetClassName:(NSString*)widgetClass1 frc:(NSFetchedResultsController*)frc1 isHidden:(BOOL)isHidden;

+ (BHCompositeTableSectionFRC*)sectionForViewController:(BHCompositeTableViewController*)vc widgetClassName:(NSString*)widgetClass1 frc:(NSFetchedResultsController*)frc1;

+ (BHCompositeTableSectionFRC*)sectionForViewController:(BHCompositeTableViewController*)vc widgetClassName:(NSString*)widgetClass1 frc:(NSFetchedResultsController*)frc1 isHidden:(BOOL)isHidden;

- (NSIndexPath*)sourceIndexPathForRow:(NSInteger)row;
- (id)objectAtIndexPath:(NSIndexPath*)indexPath;

- (void)setFrc:(NSFetchedResultsController *)frc1;

@end
