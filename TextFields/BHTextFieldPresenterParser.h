//
//  BHTextFieldPresenterParser.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHTextFieldPresenterParser : NSObject
- (NSString*)present:(NSString*)string;
- (NSString*)parse:(NSString*)string;
- (NSString*)transformFromData:(NSString*)string;
- (NSString*)transformToData:(NSString*)string;

@end

@interface BHTextFieldCurrencyPresenterParser : BHTextFieldPresenterParser
@end

@interface BHTextFieldPercentageToFractionPresenterParser : BHTextFieldPresenterParser
@property (nonatomic, retain) NSCharacterSet *fractionSet;
@end