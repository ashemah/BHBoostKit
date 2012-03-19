//
//  BHNIBTools.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHNIBTools : NSObject

+ (id)cachedTableCellWithClass:(NSString*)cellClass tableView:(UITableView*)tableView;

+ (id)loadFirstFromNIB:(NSString*)nibName;
+ (id)loadFirstFromNIB:(NSString*)nibName owner:(UIView*)owner;

@end