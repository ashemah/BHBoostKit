//
//  BHFormSection.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHFormTableViewController.h"

@class BHCompositeTableSection;

typedef CGFloat (^HeightForCellBlock)(BHCompositeTableSection *section);
typedef void (^ConfigureCellBlock)(BHCompositeTableSection *section);
typedef void (^didTapRow)(BHCompositeTableSection *section);
typedef void (^didSwipeToDeleteRow)(BHCompositeTableSection *section);

typedef CGFloat (^HeightForFRCRowBlock)(BHCompositeTableSection *section);
typedef void (^ConfigureCellForFRCRowBlock)(BHCompositeTableSection *section);
typedef void (^DidTapCellInFRCSectionBlock)(BHCompositeTableSection *section);
typedef void (^DidSwipeDeleteCellInFRCSectionBlock)(BHCompositeTableSection *section);

typedef BOOL (^IsHiddenBlock)();

///
@interface BHCompositeTableSection : NSObject {
    BOOL _isHidden;
    BOOL _isOpen;
    BOOL _isEmpty;    
    NSInteger _emptyRowCount;
    NSInteger _heightCacheSize;
    BOOL _currentCellIsNewCell;
}

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) BHCompositeTableViewController *formVC;
@property (nonatomic, assign) NSInteger defaultRowHeight;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, retain) NSString *emptyCellClass;
@property (nonatomic, retain) UITableViewCell *emptyCell;
@property (nonatomic, assign) CGFloat rowSpacing;
@property (nonatomic, assign) id currentCell;
@property (nonatomic, assign) id dummyCell;
@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, assign) NSUInteger sectionIndex;
@property (nonatomic, assign) id currentObject;
@property (nonatomic, assign) BOOL isLastRow;
@property (nonatomic, assign) BOOL isFirstRow;
@property (nonatomic, assign) BOOL isLastSection;
@property (nonatomic, assign) BOOL isFirstSection;
@property (nonatomic, assign) BOOL hasSingleRow;
@property (nonatomic, assign) NSInteger lastTappedRow;
@property (nonatomic, assign) BOOL showHeader;
@property (nonatomic, retain) NSMutableArray *heightCache;
@property (nonatomic, retain) NSMutableDictionary *cellInfoCache;
@property (nonatomic, assign) BOOL hideHeaderWhenEmpty;

- (id)initWithViewController:(BHCompositeTableViewController*)formVC isHidden:(BOOL)isHidden;

- (BOOL)hasCachedHeightForRow:(NSInteger)row;

- (id)cachedObjectForCurrentRow:(NSString*)key;
- (void)cacheObjectForCurrentRow:(id)object forKey:(NSString*)key;

- (CGFloat)cachedHeightForCurrentRow;
- (void)cacheHeightForCurrentRow:(CGFloat)height;

- (void)buildCellInfoCacheOfSize:(NSInteger)rowCount;

- (NSInteger)rowCount;
- (NSInteger)internalRowCount;

- (void)didTapRow:(NSInteger)row;
- (void)didSwipeDeleteRow:(NSInteger)row;

- (id)cellForRow:(NSInteger)row;
- (CGFloat)heightForRow:(NSInteger)row;

- (id)internalCellForRow:(NSInteger)row;
- (CGFloat)internalHeightForRow:(NSInteger)row;

- (BOOL)isEditable;

- (BOOL)currentCellIsNewCell;

- (void)reloadCell:(NSInteger)row animation:(UITableViewRowAnimation)animation;
- (void)reload;
- (void)reloadWithAnimation:(UITableViewRowAnimation)animation;
- (void)singleSelectRow:(NSInteger)row usingAnimation:(UITableViewRowAnimation)animation;

@end
