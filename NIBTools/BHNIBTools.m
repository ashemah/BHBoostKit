//
//  BHNIBTools.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BHNIBTools.h"

@implementation BHNIBTools

+ (id)cachedTableCellWithClass:(NSString*)cellClass tableView:(UITableView*)tableView {
    id cell = [tableView dequeueReusableCellWithIdentifier:cellClass];
    
    if (!cell) {
        cell = [BHNIBTools loadFirstFromNIB:cellClass];
    }
    
    NSAssert(cell, @"Invalid cellClass specified");
    
    return cell;
    
}

+ (id)loadFirstFromNIB:(NSString*)nibName {
    return [BHNIBTools loadFirstFromNIB:nibName owner:nil];
}

+ (id)loadFirstFromNIB:(NSString*)nibName owner:(UIView*)owner {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    return [nib objectAtIndex:0];
}

@end
