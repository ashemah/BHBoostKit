//
//  BHBasicFormSection.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHFormSectionBasic.h"
#import "BHNIBTools.h"

@implementation BHFormSectionBasic

@synthesize fields;
@synthesize heightForRow;
@synthesize configureRow;
@synthesize didTapRow;
@synthesize didSwipeToDeleteRow;

+ (BHFormSectionBasic*)formSectionForFormVC:(BHBlockTableViewController*)vc {
    return [[[BHFormSectionBasic alloc] initWithFormVC:vc] autorelease];
}

- (id)initWithFormVC:(BHFormViewController*)formVC1 {
    
    if ((self = [super initWithFormVC:formVC1])) {
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

- (NSInteger)rowCount {
    return [self.fields count];
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
    
    if (self.heightForRow) {
        return self.heightForRow(row);
    }
    
    return ((UIView*)self.dummyCell).frame.size.height;
}

- (id)internalCellForRow:(NSInteger)row {
    
    NSString *widgetClass = [self.fields objectAtIndex:row];
    self.currentCell = [BHNIBTools cachedTableCellWithClass:widgetClass tableView:self.formVC.tableView];
    self.currentRow = row;
    
    self.isFirstRow = row == 0;
    self.isLastRow  = row == [self.fields count]-1;
    
    if (self.configureRow) {
        self.configureRow(row);
    }
    
    return self.currentCell;
}

- (void)didTapRow:(NSInteger)row {
    
    self.currentCell = [self.formVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:self.sectionIndex]];
    self.currentRow = row;
    
    self.isFirstRow = row == 0;
    self.isLastRow  = row == [self.fields count]-1;
    
    if (self.didTapRow) {
        self.didTapRow(row);
    }
}

- (void)didSwipeDeleteRow:(NSInteger)row {
    
    self.currentCell    = [self.formVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:self.sectionIndex]];
    self.currentRow = row;
    
    self.isFirstRow = row == 0;
    self.isLastRow  = row == [self.fields count]-1;
    
    if (self.didSwipeToDeleteRow) {
        self.didSwipeToDeleteRow(row);
    }    
}

- (BOOL)isEditable {
    return (self.didSwipeToDeleteRow != nil);
}

@end
