//
//  BHFormSection.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHFormViewController.h"

typedef CGFloat (^HeightForCellBlock)();
typedef void (^ConfigureCellBlock)();
typedef void (^DidTapCellInSectionBlock)();
typedef void (^DidSwipeDeleteCellInSectionBlock)();

typedef CGFloat (^HeightForFRCRowBlock)();
typedef void (^ConfigureCellForFRCRowBlock)();
typedef void (^DidTapCellInFRCSectionBlock)();
typedef void (^DidSwipeDeleteCellInFRCSectionBlock)();

typedef BOOL (^IsHiddenBlock)();

@interface BHFormSection : NSObject {
    BOOL _isHidden;
    BOOL _isOpen;
    BOOL _isEmpty;    
    NSInteger _emptyRowCount;
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
@property (nonatomic, assign) BOOL isLastRow;
@property (nonatomic, assign) BOOL isFirstRow;
@property (nonatomic, assign) NSInteger lastTappedRow;

- (id)initWithFormVC:(BHBlockTableViewController*)formVC;

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
