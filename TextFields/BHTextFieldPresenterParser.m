//
//  BHTextFieldPresenterParser.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BHTextFieldPresenterParser.h"

@implementation BHTextFieldPresenterParser

- (NSString*)present:(NSString*)string {
    NSAssert(nil, @"Not implemented");
    return nil;
}

- (NSString*)parse:(NSString*)string {
    NSAssert(nil, @"Not implemented");
    return nil;    
}

- (NSString*)transformFromData:(NSString*)string {
    NSAssert(nil, @"Not implemented");
    return nil;
}

- (NSString*)transformToData:(NSString*)string {
    NSAssert(nil, @"Not implemented");
    return nil;    
}

@end

//////////////////////////////////////////////
// Currency

@implementation BHTextFieldCurrencyPresenterParser

@end

//////////////////////////////////////////////
// Tax Rate

@implementation BHTextFieldPercentageToFractionPresenterParser

@synthesize fractionSet;

- (id)init {
    if ((self = [super self])) {
        self.fractionSet    = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];        
    }
    return self;
}

// Parses a fraction from the data and presents it as a percentage
- (NSString*)present:(NSString*)string {    
    return [string stringByAppendingString:@"%"];
}

- (NSString*)parse:(NSString*)string {
    NSString *str = [string stringByTrimmingCharactersInSet:self.fractionSet];
    return str;
}

- (NSString*)transformFromData:(NSString*)string {
    NSDecimalNumber *num  = [NSDecimalNumber decimalNumberWithString:string];
    num = [num decimalNumberByMultiplyingByPowerOf10:2];
    return [num stringValue];
}

- (NSString*)transformToData:(NSString*)string {
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:string];
    
    if ([num compare:[NSNumber numberWithInt:100]] == NSOrderedDescending) {
        num = [NSDecimalNumber decimalNumberWithString:@"1"];
    }
    else if ([num compare:[NSNumber numberWithInt:0]] == NSOrderedAscending) {
        num = [NSDecimalNumber zero];
    }
    else {
        num = [num decimalNumberByMultiplyingByPowerOf10:-2];    
    }
    return [num stringValue];    
}

@end
