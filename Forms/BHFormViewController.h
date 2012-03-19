//
//  BHFormViewController.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/13/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHTextFieldHelper.h"
#import "TPKeyboardAvoidingTableView.h"

@class BHFormSection;

@interface BHFormField : NSObject {
    
}

@property (nonatomic, retain) NSString *widgetClass;

- (id)fieldWithWidgetClass:(NSString*)widgetClass;
                               
@end

///

@interface BHFormViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    BHTextFieldHelper *_tfHelper;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *activeSections;
@property (nonatomic, retain) NSMutableDictionary *cacheDict;
@property (nonatomic, retain) BHTextFieldHelper *textFieldHelper;

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
