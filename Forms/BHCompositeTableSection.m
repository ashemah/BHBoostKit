//
//  BHFormSection.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHCompositeTableSection.h"
#import "BHNIBTools.h"

@implementation BHCompositeTableSection

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
@synthesize isLastSection;
@synthesize isFirstSection;
@synthesize hasSingleRow;
@synthesize lastTappedRow;
@synthesize showHeader;
@synthesize currentObject;
@synthesize heightCache;
@synthesize cellInfoCache;
@synthesize hideHeaderWhenEmpty;

- (id)initWithViewController:(BHCompositeTableViewController*)formVC1 isHidden:(BOOL)isHidden {
    if ((self = [super init])) {

        _heightCacheSize = 0;
        self.formVC = formVC1;
        self.isHidden = isHidden;
        self.showHeader = YES;
        
        _isOpen = YES;
        
        self.hideHeaderWhenEmpty = YES;
        [self.formVC addSection:self];
        
        if (self.emptyCellClass) {
            BOOL isNewCell;
            self.emptyCell = [BHNIBTools cachedTableCellWithClass:self.emptyCellClass tableView:self.formVC.tableView isNewCell:&isNewCell];
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
    
    if (doUpdate) {
        _isEmpty = isEmpty1;
    
        if (self.emptyCell) {
            _emptyRowCount = 1;
        }
        else {
            _emptyRowCount = 0;
        }
        
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
        
    NSInteger rc = [self internalRowCount];
        
    self.isEmpty = (rc == 0);
    
    if (_isEmpty) {        
        return _emptyRowCount;
    }
    
    if (rc != _heightCacheSize) {
        [self buildCellInfoCacheOfSize:rc];
    }
    
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

- (CGFloat)cachedHeightForCurrentRow {
    NSNumber *height = [self cachedObjectForCurrentRow:@"height"];
    return [height floatValue];
}

- (void)cacheHeightForCurrentRow:(CGFloat)height {
    [self cacheObjectForCurrentRow:[NSNumber numberWithFloat:height] forKey:@"height"];
}

- (void)cacheObjectForCurrentRow:(id)object forKey:(NSString*)key {
    int row = [self currentRow];
    NSMutableDictionary *cellInfo = [self.heightCache objectAtIndex:row];
    [cellInfo setObject:object forKey:key];
}

- (id)cachedObjectForCurrentRow:(NSString*)key {
    int row = [self currentRow];
    NSMutableDictionary *cellInfo = [self.heightCache objectAtIndex:row];
    return [cellInfo objectForKey:key];
}

- (BOOL)hasCachedHeightForRow:(NSInteger)row {
    CGFloat height = [[self cachedObjectForCurrentRow:@"height"] floatValue];
    return height != -1;
}

- (CGFloat)heightForRow:(NSInteger)row {
    
    if (_isEmpty) {
        return self.emptyCell.frame.size.height;
    }
    
    return [self internalHeightForRow:row] + self.rowSpacing;
}

- (BOOL)currentCellIsNewCell {
    return _currentCellIsNewCell;
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
