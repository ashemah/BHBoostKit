//
//  BHNIBTools.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 1/8/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHNIBTools : NSObject

+ (id)cachedTableCellWithClass:(NSString*)cellClass tableView:(UITableView*)tableView isNewCell:(BOOL*)isNewCell;

+ (id)loadFirstFromNIB:(NSString*)nibName;
+ (id)loadFirstFromNIB:(NSString*)nibName owner:(UIView*)owner;

@end
