//
//  BHFormSection.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHFormSection.h"
#import "BHNIBTools.h"

@implementation BHFormSection

@synthesize headerView;
@synthesize footerView;
@synthesize formVC;
@synthesize defaultRowHeight;
@synthesize isHidden    = _isHidden;
@synthesize isOpen      = _isOpen;
@synthesize isEmpty     = _isEmpty;
@synthesize emptyCellClass;
@synthesize emptyCell;
@synthesize rowSpacing;
@synthesize currentCell;
@synthesize sectionIndex;
@synthesize dummyCell;
@synthesize currentRow;
@synthesize isLastRow;
@synthesize isFirstRow;
@synthesize lastTappedRow;
@synthesize showHeader;
@synthesize currentObject;
@synthesize heightCache;
@synthesize cellInfoCache;
@synthesize hideHeaderWhenEmpty;

- (id)initWithFormVC:(BHBlockTableViewController*)formVC1 {
    if ((self = [super init])) {

        _heightCacheSize = 0;
        self.formVC = formVC1;
        self.isHidden = NO;
        self.showHeader = YES;
        self.hideHeaderWhenEmpty = YES;
        [self.formVC addSection:self];
        
        if (self.emptyCellClass) {
            self.emptyCell = [BHNIBTools cachedTableCellWithClass:self.emptyCellClass tableView:self.formVC.tableView];
        }
        
        self.lastTappedRow = -1;
    }
    
    return self;    
}

- (void)setIsHidden:(BOOL)isHidden1 {
    _isHidden = isHidden1;
    [self.formVC updateActiveSections];
}

- (void)setIsOpen:(BOOL)isOpen1 {
    _isOpen = isOpen1;    
    [self.formVC updateSection:self];
}

- (void)setIsEmpty:(BOOL)isEmpty1 {
    
    BOOL doUpdate = _isEmpty != isEmpty1;
    
    _isEmpty = isEmpty1;
    
    if (self.emptyCell) {
        _emptyRowCount = 1;
    }
    else {
        _emptyRowCount = 0;
    }
    
    if (doUpdate) {
        [self.formVC updateSection:self];
    }
}

- (BOOL)isEditable {
    return NO;
}

- (NSInteger)rowCount {
    
    if (!_isOpen) {
        return 0;
    }
    
    if (_isEmpty) {        
        return _emptyRowCount;
    }
    
    NSInteger rc = [self internalRowCount];
        
    return rc;
}

- (NSInteger)internalRowCount {
    return 0;
}

- (void)buildCellInfoCacheOfSize:(NSInteger)rowCount {
    
    self.heightCache = [NSMutableArray arrayWithCapacity:rowCount];
    
    for (int i=0; i < rowCount; i++) {
        [self.heightCache addObject:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithFloat:-1] forKey:@"height"]];
    }
    
    _heightCacheSize = rowCount;
}

- (void)cacheHeight:(CGFloat)height forRow:(NSInteger)row {
    [self cacheObject:[NSNumber numberWithFloat:height] forRow:row andKey:@"height"];
}

- (void)cacheObject:(id)object forRow:(NSInteger)row andKey:(NSString*)key {
    NSMutableDictionary *cellInfo = [self.heightCache objectAtIndex:row];
    [cellInfo setObject:object forKey:key];
}

- (CGFloat)cachedHeightForRow:(NSInteger)row {
    NSNumber *height = [self cachedObjectForRow:row andKey:@"height"];
    return [height floatValue];
}

- (id)cachedObjectForRow:(NSInteger)row andKey:(NSString*)key {
    NSMutableDictionary *cellInfo = [self.heightCache objectAtIndex:row];
    return [cellInfo objectForKey:key];
}

- (BOOL)hasCachedHeightForRow:(NSInteger)row {
    CGFloat height = [[self cachedObjectForRow:row andKey:@"height"] floatValue];
    return height != -1;
}

- (CGFloat)heightForRow:(NSInteger)row {
    
    if (_isEmpty) {
        return self.emptyCell.frame.size.height;
    }
    
    return [self internalHeightForRow:row] + self.rowSpacing;
}

- (id)cellForRow:(NSInteger)row {
    
    if (_isEmpty) {
        return self.emptyCell;

    }
    
    return [self internalCellForRow:row];
};

- (CGFloat)internalHeightForRow:(NSInteger)row {
    return 44;
}

- (id)internalCellForRow:(NSInteger)row {
    return nil;
};

- (void)didTapRow:(NSInteger)row {
    
    if (_isEmpty) {
        return;
    }
}

- (void)didSwipeDeleteRow:(NSInteger)row {
    if (_isEmpty) {
        return;
    }    
}

- (void)reloadCell:(NSInteger)row animation:(UITableViewRowAnimation)animation {
    if (row < 0 || row > self.rowCount-1) {
        return;
    }
    
    // TODO: Move into a delegate
    [self.formVC.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:self.sectionIndex]] withRowAnimation:animation];    
}

- (void)reload {
    [self reloadWithAnimation:UITableViewRowAnimationNone];
}

- (void)reloadWithAnimation:(UITableViewRowAnimation)animation {
    [self.formVC.tableView reloadData];
//    [self.formVC.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.sectionIndex] withRowAnimation:animation];
}

- (void)singleSelectRow:(NSInteger)row usingAnimation:(UITableViewRowAnimation)animation {

    if (self.lastTappedRow > 0 || self.lastTappedRow <= self.rowCount-1) {
        [self reloadCell:self.lastTappedRow animation:UITableViewRowAnimationNone];
    }
 
    if (row > 0 || row <= self.rowCount-1) {
        [self reloadCell:row animation:animation];
    }
    
    self.lastTappedRow = row;
}

@end
