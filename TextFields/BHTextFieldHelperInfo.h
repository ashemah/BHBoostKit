//
//  BHTextFieldHelperInfo.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHTextFieldPresenterParser.h"

typedef enum {
    BHTextFieldHelperField_Text,
    BHTextFieldHelperField_Numbers,
    BHTextFieldHelperField_EmailAddress,
    BHTextFieldHelperField_PhoneNumber,
    BHTextFieldHelperField_Currency,
    BHTextFieldHelperField_Custom,
    BHTextFieldHelperField_ReadOnlyEmailAddress,
    BHTextFieldHelperField_Password
} BHTextFieldHelperField;

@interface BHTextFieldHelperInfo : NSObject {
@public
    NSInteger tabOrder;
    BHTextFieldHelperField type;
    NSString *title;
    NSString *key;
    NSString *text;
    BHTextFieldPresenterParser *presenterParser;
}

@property (nonatomic, retain) id field;
@property (nonatomic, retain) BHTextFieldPresenterParser *presenterParser;
@end
