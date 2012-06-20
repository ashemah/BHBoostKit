//
//  BHFormSection.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHFormViewController.h"

typedef CGFloat (^HeightForCellBlock)(NSInteger row);
typedef void (^ConfigureCellBlock)(NSInteger row);
typedef void (^didTapRow)(NSInteger row);
typedef void (^didSwipeToDeleteRow)(NSInteger row);

typedef CGFloat (^HeightForFRCRowBlock)(NSInteger row);
typedef void (^ConfigureCellForFRCRowBlock)(NSInteger row);
typedef void (^DidTapCellInFRCSectionBlock)(NSInteger row);
typedef void (^DidSwipeDeleteCellInFRCSectionBlock)(NSInteger row);

typedef BOOL (^IsHiddenBlock)();

@interface BHFormSection : NSObject {
    BOOL _isHidden;
    BOOL _isOpen;
    BOOL _isEmpty;    
    NSInteger _emptyRowCount;
    NSInteger _heightCacheSize;
}

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) BHBlockTableViewController *formVC;
@property (nonatomic, assign) NSInteger defaultRowHeight;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, retain) NSString *emptyCellClass;
@property (nonatomic, retain) UITableViewCell *emptyCell;
@property (nonatomic, assign) CGFloat rowSpacing;
@property (nonatomic, retain) id currentCell;
@property (nonatomic, retain) id dummyCell;
@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, assign) NSUInteger sectionIndex;
@property (nonatomic, assign) id currentObject;
@property (nonatomic, assign) BOOL isLastRow;
@property (nonatomic, assign) BOOL isFirstRow;
@property (nonatomic, assign) NSInteger lastTappedRow;
@property (nonatomic, assign) BOOL showHeader;
@property (nonatomic, retain) NSMutableArray *heightCache;
@property (nonatomic, retain) NSMutableDictionary *cellInfoCache;
@property (nonatomic, assign) BOOL hideHeaderWhenEmpty;

- (id)initWithFormVC:(BHBlockTableViewController*)formVC;

- (BOOL)hasCachedHeightForRow:(NSInteger)row;

- (CGFloat)cachedHeightForRow:(NSInteger)row;
- (id)cachedObjectForRow:(NSInteger)row andKey:(NSString*)key;

- (void)cacheHeight:(CGFloat)height forRow:(NSInteger)row;
- (void)cacheObject:(id)object forRow:(NSInteger)row andKey:(NSString*)key;

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

- (void)reloadCell:(NSInteger)row animation:(UITableViewRowAnimation)animation;
- (void)reload;
- (void)reloadWithAnimation:(UITableViewRowAnimation)animation;
- (void)singleSelectRow:(NSInteger)row usingAnimation:(UITableViewRowAnimation)animation;

@end
