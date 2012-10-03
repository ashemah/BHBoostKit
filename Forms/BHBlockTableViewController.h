//
//  BHBlockTableViewController.h
//  DistractMe
//
//  Created by Ashemah Harrison on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHBlockTableViewController;

//
typedef CGFloat (^HeightForCellBlockTableBlock)(BHBlockTableViewController *tableVC, NSInteger section, NSInteger row);
typedef void (^ConfigureCellBlockTableBlock)(BHBlockTableViewController *tableVC, NSInteger section, NSInteger row);
typedef void (^DidTapRowBlockTableBlock)(BHBlockTableViewController *tableVC, NSInteger section, NSInteger row);
typedef void (^DidSwipeToDeleteRowBlockTableBlock)(BHBlockTableViewController *tableVC, NSInteger section, NSInteger row);
typedef NSInteger (^NumberOfSectionsInTableBlockTableBlock)(BHBlockTableViewController *tableVC);
typedef NSInteger (^NumberOfRowsInSectionBlockTableBlock)(BHBlockTableViewController *tableVC, NSInteger section);
typedef UIView* (^ViewForHeaderInSectionBlockTableBlock)(BHBlockTableViewController *tableVC, NSInteger section);
typedef CGFloat (^HeightForHeaderInSectionBlockTableBlock)(BHBlockTableViewController *tableVC, NSInteger section);

//
@interface BHBlockTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    UITableViewCell *_cell;
    NSInteger _currentRow;
    NSInteger _currentSection;
    NSInteger _cachedNumberOfRowsInSection;
    NSInteger _cachedNumberOfSections;
    NSFetchedResultsController *_frc;
    NSIndexPath *_currentPath;
}
    
@property (readwrite, copy) HeightForCellBlockTableBlock heightForRow;
@property (readwrite, copy) ConfigureCellBlockTableBlock configureCellForRow;
@property (readwrite, copy) DidTapRowBlockTableBlock didTapRow;
@property (readwrite, copy) DidSwipeToDeleteRowBlockTableBlock didSwipeToDeleteRow;
@property (nonatomic, copy) NumberOfSectionsInTableBlockTableBlock numberOfSectionsInTable;
@property (nonatomic, copy) NumberOfRowsInSectionBlockTableBlock numberOfRowsInSection;
@property (nonatomic, copy) ViewForHeaderInSectionBlockTableBlock viewForHeaderInSection;
@property (nonatomic, copy) HeightForHeaderInSectionBlockTableBlock heightForHeaderInSection;
@property (nonatomic, assign) BOOL forceFullRefresh;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger defaultRowHeight;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, readonly) NSString *emptyCellClass;
@property (nonatomic, readonly) UITableViewCell *emptyCell;
@property (nonatomic, readonly) id currentCell;
@property (nonatomic, readonly) id dummyCell;

@property (nonatomic, readonly) NSInteger currentRow;
@property (nonatomic, readonly) BOOL currentRowIsLastRow;
@property (nonatomic, readonly) BOOL currentRowIsFirstRow;
@property (nonatomic, readonly) id currentObject;
@property (nonatomic, readonly) NSIndexPath *currentIndexPath;

@property (nonatomic, readonly) BOOL currentSectionIsFirstSection;
@property (nonatomic, readonly) BOOL currentSectionIsLastSection;

@property (nonatomic, readonly) BOOL currentRowIsSingleRow;

@property (nonatomic, retain) NSString *cellClass;

@property (nonatomic, retain) NSFetchedResultsController *frc;

@property (nonatomic, retain) NSIndexPath *lastTappedPath;
@property (nonatomic, retain) NSMutableSet *selectedPaths;

@property (nonatomic, assign) BOOL forceFullRefreshOnFRCChange;

- (UITableViewCell*)cachedCell:(NSString*)cellClass;
- (UITableViewCell*)cachedCell:(NSString*)cellClass isNewCell:(BOOL*)isNewCell;

- (void)addSelectedPath:(NSIndexPath*)path;
- (void)removeSelectedPath:(NSIndexPath*)path;
- (BOOL)isSelectedPath:(NSIndexPath*)path;
- (int)rowCountForSection:(NSInteger)section;
- (int)sectionCount;

@end
