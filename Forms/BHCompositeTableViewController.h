//
//  BHBlockTableViewController.h
//  BeatTheQ
//
//  Created by Ashemah Harrison on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHCompositeTableSection;

//
@interface BHCompositeTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSFetchedResultsController *_frc;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *activeSections;
@property (nonatomic, retain) NSMutableDictionary *cacheDict;
@property (nonatomic, retain) BHCompositeTableSection *currentSection;
@property (nonatomic, retain) NSMutableDictionary *tableCache;

- (UITableViewCell*)cachedCell:(NSString*)cellClassName;
+ (UIView*)loadWidgetFromNIB:(NSString*)nibName;
- (void)updateActiveSections;
- (void)updateSection:(BHCompositeTableSection*) section;
- (void)toggleSectionAtIndex:(NSInteger)index;
- (void)openSectionAtIndex:(NSInteger)index;
- (void)closeSectionAtIndex:(NSInteger)index;
- (void)refreshForm;
- (void)addSection:(BHCompositeTableSection*)section;

- (id)cachedObjectForKey:(NSString*)key;
- (void)cacheObject:(id)object forKey:(NSString*)key;

@end
