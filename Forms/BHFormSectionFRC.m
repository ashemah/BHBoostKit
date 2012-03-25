//
//  BHFetchedResultsControllerFormSection.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHFormSectionFRC.h"
#import "BHNIBTools.h"

@implementation BHFormSectionFRC

@synthesize frc;
@synthesize widgetClass;
@synthesize heightForRow;
@synthesize configureRow;
@synthesize didTapRow;
@synthesize didSwipeToDeleteRow;
@synthesize currentObject;

+ (BHFormSectionFRC*)formSectionForFormVC:(BHBlockTableViewController*)vc widgetClass:(NSString*)widgetClass1 frc:(NSFetchedResultsController*)frc1 {
    return [[[BHFormSectionFRC alloc] initWithFormVC:vc widgetClass:widgetClass1 frc:frc1] autorelease];
}

- (id)initWithFormVC:(BHBlockTableViewController*)formVC1 widgetClass:(NSString*)widgetClass1 frc:(NSFetchedResultsController*)frc1 {
    
    if ((self = [super initWithFormVC:formVC1])) {
        self.widgetClass = widgetClass1;
        self.frc = frc1;
    }
    
    return self;
}

- (NSInteger)rowCount {

    id <NSFetchedResultsSectionInfo> sectInfo = [[self.frc sections] objectAtIndex:0];
    NSInteger num = [sectInfo numberOfObjects];
    return num;
}

- (CGFloat)internalHeightForRow:(NSInteger)row {
    
    if (self.defaultRowHeight > 0) {
        return self.defaultRowHeight;
    }
    
    self.dummyCell      = [self.formVC cachedCell:self.widgetClass];
    
    if (self.heightForRow) {
        self.currentObject  = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];        
        self.currentRow     = row;

        self.isFirstRow = row == 0;
        self.isLastRow  = row == [self rowCount]-1;
        
        return self.heightForRow(row);
    }
    
    return ((UIView*)self.dummyCell).frame.size.height;
}

- (id)internalCellForRow:(NSInteger)row {
    
    self.currentCell = [BHNIBTools cachedTableCellWithClass:self.widgetClass tableView:self.formVC.tableView];
    
    if (self.configureRow) {
        
        self.currentObject  = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        self.currentRow     = row;

        self.isFirstRow = row == 0;
        self.isLastRow  = row == [self rowCount]-1;
        
        self.configureRow(row);
    }
    
    return self.currentCell;
}

- (void)didTapRow:(NSInteger)row {
        
    if (self.didTapRow) {
        
        self.currentCell    = [self.formVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:self.sectionIndex]];
        self.currentObject  = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        self.currentRow     = row;

        self.isFirstRow = row == 0;
        self.isLastRow  = row == [self rowCount]-1;
        
        self.didTapRow(row);
    }
}

- (void)didSwipeDeleteRow:(NSInteger)row {
        
    if (self.didSwipeToDeleteRow) {
        
        self.currentCell    = [self.formVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:self.sectionIndex]];
        self.currentObject  = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        self.currentRow     = row;
        
        self.isFirstRow = row == 0;
        self.isLastRow  = row == [self rowCount]-1;
        
        self.didSwipeToDeleteRow(row);
        
        [self.frc performFetch:nil];
        [self.formVC.tableView reloadData];        
    }        
}

- (BOOL)isEditable {
    return (self.didSwipeToDeleteRow != nil);
}


@end