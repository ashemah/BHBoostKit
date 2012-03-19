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
@synthesize heightForRowBlock;
@synthesize configureCellForRowBlock;
@synthesize didTapCellInSectionBlock;
@synthesize didSwipeDeleteCellInSectionBlock;

+ (BHFormSectionBasic*)formSectionForFormVC:(BHFormViewController*)vc {
    return [[[BHFormSectionBasic alloc] initWithFormVC:vc] autorelease];
}

- (id)initWithFormVC:(BHFormViewController*)formVC1 {
    
    if ((self = [super initWithFormVC:formVC1])) {
        self.fields = [NSMutableArray array];
    }
    
    return self;
}

- (void)addWidgetWithClass:(NSString*)widgetClass {
    [self.fields addObject:widgetClass];
}

- (NSInteger)rowCount {
    return [self.fields count];
}

- (CGFloat)internalHeightForRow:(NSInteger)row {
    
    if (self.defaultRowHeight > 0) {
        return self.defaultRowHeight;
    }
    
    NSString *widgetClass = [self.fields objectAtIndex:row];
    UITableViewCell *dummyCell = [self.formVC cachedCell:widgetClass];
    
    if (self.heightForRowBlock) {
        return self.heightForRowBlock(dummyCell, row);
    }
    
    return dummyCell.frame.size.height;
}

- (id)internalCellForRow:(NSInteger)row {
    
    NSString *widgetClass = [self.fields objectAtIndex:row];
    self.currentCell = [BHNIBTools cachedTableCellWithClass:widgetClass tableView:self.formVC.tableView];
    
    if (self.configureCellForRowBlock) {
        self.configureCellForRowBlock(self.currentCell, row);
    }
    
    return self.currentCell;
}

- (void)didTapRow:(NSInteger)row {
    
    NSString *widgetClass = [self.fields objectAtIndex:row];
    id cell = [BHNIBTools cachedTableCellWithClass:widgetClass tableView:self.formVC.tableView];
    
    if (self.didTapCellInSectionBlock) {
        self.didTapCellInSectionBlock(cell, row);
    }
}

- (void)didSwipeDeleteRow:(NSInteger)row {
    
    NSString *widgetClass = [self.fields objectAtIndex:row];
    id cell = [BHNIBTools cachedTableCellWithClass:widgetClass tableView:self.formVC.tableView];
    
    if (self.didSwipeDeleteCellInSectionBlock) {
        self.didSwipeDeleteCellInSectionBlock(cell, row);
    }    
}

- (BOOL)isEditable {
    return (self.didSwipeDeleteCellInSectionBlock != nil);
}

@end
