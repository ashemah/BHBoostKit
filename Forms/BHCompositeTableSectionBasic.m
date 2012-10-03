//
//  BHBasicFormSection.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHCompositeTableSectionBasic.h"
#import "BHNIBTools.h"

@implementation BHCompositeTableSectionBasic

@synthesize fields;
@synthesize heightForRow;
@synthesize configureRow;
@synthesize didTapRow;
@synthesize didSwipeToDeleteRow;

+ (BHCompositeTableSectionBasic*)sectionForViewController:(BHCompositeTableViewController*)vc {
    return [[[BHCompositeTableSectionBasic alloc] initWithViewController:vc isHidden:NO] autorelease];
}

+ (BHCompositeTableSectionBasic*)sectionForViewController:(BHCompositeTableViewController*)vc isHidden:(BOOL)isHidden {
    return [[[BHCompositeTableSectionBasic alloc] initWithViewController:vc isHidden:isHidden] autorelease];
}

- (id)initWithViewController:(BHFormTableViewController*)formVC1 isHidden:(BOOL)isHidden {
    
    if ((self = [super initWithViewController:formVC1 isHidden:isHidden])) {
        self.fields = [NSMutableArray array];
    }
    
    return self;
}

- (void)addCellFromNIBWithName:(NSString*)widgetClass {
    [self.fields addObject:widgetClass];
}

- (void)removeAllCells {
    [self.fields removeAllObjects];
}

- (NSInteger)internalRowCount {
    
    NSInteger num = [self.fields count];
    
    return num;
}

- (CGFloat)internalHeightForRow:(NSInteger)row {
    
    if (self.defaultRowHeight > 0) {
        return self.defaultRowHeight;
    }
    
    NSString *widgetClass = [self.fields objectAtIndex:row];
    
    self.dummyCell = [self.formVC cachedCell:widgetClass];
    self.currentRow = row;

    self.isFirstRow = row == 0;
    self.isLastRow  = row == [self.fields count]-1;
    self.hasSingleRow = [self rowCount] == 1;
    self.isFirstSection  = self.sectionIndex == 0;
    self.isLastSection  = self.sectionIndex == [self.formVC.activeSections count]-1;
    
    if (self.heightForRow) {
        return self.heightForRow(self);
    }
    
    return ((UIView*)self.dummyCell).frame.size.height;
}

- (id)internalCellForRow:(NSInteger)row {
    
    NSString *widgetClass = [self.fields objectAtIndex:row];    
    self.currentCell = [BHNIBTools cachedTableCellWithClass:widgetClass tableView:self.formVC.tableView isNewCell:&_currentCellIsNewCell];
    self.currentRow = row;
    
    self.isFirstRow = row == 0;
    self.isLastRow  = row == [self.fields count]-1;
    self.hasSingleRow = [self rowCount] == 1;
    self.isFirstSection  = self.sectionIndex == 0;
    self.isLastSection  = self.sectionIndex == [self.formVC.activeSections count]-1;
        
    if (self.configureRow) {
        self.configureRow(self);
    }
    
    return self.currentCell;
}

- (void)didTapRow:(NSInteger)row {
    
    self.currentCell = [self.formVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:self.sectionIndex]];
    self.currentRow = row;
    
    self.isFirstRow = row == 0;
    self.isLastRow  = row == [self.fields count]-1;
    self.hasSingleRow = [self rowCount] == 1;
    self.isFirstSection  = self.sectionIndex == 0;
    self.isLastSection  = self.sectionIndex == [self.formVC.activeSections count]-1;
    
    if (self.didTapRow) {
        self.didTapRow(self);
    }
}

- (void)didSwipeDeleteRow:(NSInteger)row {
    
    self.currentCell    = [self.formVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:self.sectionIndex]];
    self.currentRow = row;
    
    self.isFirstRow = row == 0;
    self.isLastRow  = row == [self.fields count]-1;
    self.hasSingleRow = [self rowCount] == 1;
    self.isFirstSection  = self.sectionIndex == 0;
    self.isLastSection  = self.sectionIndex == [self.formVC.activeSections count]-1;
    
    if (self.didSwipeToDeleteRow) {
        self.didSwipeToDeleteRow(self);
    }    
}

- (BOOL)isEditable {
    return (self.didSwipeToDeleteRow != nil);
}

@end
