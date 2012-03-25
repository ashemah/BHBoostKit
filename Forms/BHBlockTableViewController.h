//
//  BHBlockTableViewController.h
//  BeatTheQ
//
//  Created by Ashemah Harrison on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHFormSection;

@interface BHFormField : NSObject {
    
}

@property (nonatomic, retain) NSString *widgetClass;

- (id)fieldWithWidgetClass:(NSString*)widgetClass;

@end

///
@interface BHBlockTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *activeSections;
@property (nonatomic, retain) NSMutableDictionary *cacheDict;

- (UITableViewCell*)cachedCell:(NSString*)cellClassName;
+ (UIView*)loadWidgetFromNIB:(NSString*)nibName;
- (void)updateActiveSections;
- (void)updateSection:(BHFormSection*) section;
- (void)toggleSectionAtIndex:(NSInteger)index;
- (void)openSectionAtIndex:(NSInteger)index;
- (void)closeSectionAtIndex:(NSInteger)index;
- (void)refreshForm;
- (void)addSection:(BHFormSection*)section;
@end
