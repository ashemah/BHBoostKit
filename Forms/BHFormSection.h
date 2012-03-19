//
//  BHFormSection.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHFormViewController.h"

typedef CGFloat (^HeightForRowBlock)(id dummyCell, NSInteger row);
typedef void (^ConfigureCellForRowBlock)(id cell, NSInteger row);
typedef void (^DidTapCellInSectionBlock)(id cell, NSInteger row);
typedef void (^DidSwipeDeleteCellInSectionBlock)(id cell, NSInteger row);

typedef CGFloat (^HeightForFRCRowBlock)(id dummyCell, id obj, NSInteger row);
typedef void (^ConfigureCellForFRCRowBlock)(id cell, id obj, NSInteger row);
typedef void (^DidTapCellInFRCSectionBlock)(id cell, id obj, NSInteger row);
typedef void (^DidSwipeDeleteCellInFRCSectionBlock)(id cell, id obj, NSInteger row);

typedef BOOL (^IsHiddenBlock)();

@interface BHFormSection : NSObject {
    BOOL _isHidden;
    BOOL _isOpen;
    BOOL _isEmpty;    
    NSInteger _emptyRowCount;    
}

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) BHFormViewController *formVC;
@property (nonatomic, assign) NSInteger defaultRowHeight;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, retain) NSString *emptyCellClass;
@property (nonatomic, retain) UITableViewCell *emptyCell;
@property (nonatomic, assign) CGFloat rowSpacing;
@property (nonatomic, retain) id currentCell;
@property (nonatomic, assign) NSUInteger sectionIndex;


- (id)initWithFormVC:(BHFormViewController*)formVC;

- (NSInteger)rowCount;
- (NSInteger)internalRowCount;

- (void)didTapRow:(NSInteger)row;
- (void)didSwipeDeleteRow:(NSInteger)row;

- (id)cellForRow:(NSInteger)row;
- (CGFloat)heightForRow:(NSInteger)row;

- (id)internalCellForRow:(NSInteger)row;
- (CGFloat)internalHeightForRow:(NSInteger)row;

- (BOOL)isEditable;

@end
