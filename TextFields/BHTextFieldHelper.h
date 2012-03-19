//
//  BHTextFieldHelper.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/1/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BHTextFieldHelperField_Text,
    BHTextFieldHelperField_Numbers,
    BHTextFieldHelperField_EmailAddress,
    BHTextFieldHelperField_PhoneNumber,
    BHTextFieldHelperField_Currency,
    BHTextFieldHelperField_Custom
} BHTextFieldHelperField;

@interface BHTextFieldHelperInfo : NSObject {
@public
    NSInteger tabOrder;
    BHTextFieldHelperField type;
    NSString *title;
    NSString *key;
    NSString *text;
}

@property (nonatomic, retain) UIView *field;

@end

typedef void (^FieldDataDidChangeBlock)(NSString *key, NSString* text);

@interface BHTextFieldHelper : NSObject<UITextFieldDelegate, UITextViewDelegate> {
    NSMutableDictionary *fields;
    NSMutableDictionary *info;
    NSCharacterSet *textCharSet;
    NSCharacterSet *numbersCharSet;
    NSCharacterSet *currencyCharSet;
    UIBarButtonItem *hasChangedButton;
    NSMutableDictionary *dataDict;
    BOOL hasChanged;    
}

@property (nonatomic, retain) NSMutableDictionary *fields;
@property (nonatomic, retain) NSMutableDictionary *info;
@property (nonatomic, retain) NSMutableDictionary *infoForKey;
@property (nonatomic, retain) NSMutableDictionary *dataDict;
@property (nonatomic, retain) NSCharacterSet *textCharSet;
@property (nonatomic, retain) NSCharacterSet *numbersCharSet;
@property (nonatomic, retain) NSCharacterSet *currencyCharSet;
@property (nonatomic, retain) NSCharacterSet *numbersPunctCharSet;
@property (nonatomic, assign) BOOL hasChanged;
@property (nonatomic, retain) UIBarButtonItem *hasChangedButton;
@property (readwrite, copy) FieldDataDidChangeBlock fieldDataDidChangeBlock;
@property (nonatomic, retain) UITableView *tableView;

+ (BHTextFieldHelper*)textFieldHelper;

- (void)resetHasChanged;
- (void)addTextField:(UITextField*)field title:(NSString*)title key:(NSString*)key type:(BHTextFieldHelperField)type;
- (void)addTextView:(UITextView*)field title:(NSString*)title key:(NSString*)key type:(BHTextFieldHelperField)type;
- (BHTextFieldHelperInfo*)infoForTextField:(UITextField*)field;
- (BHTextFieldHelperInfo*)infoForTextView:(UITextView*)field;

- (void)setText:(NSString*)text forKey:(NSString*)fieldName;
- (NSString*)textForKey:(NSString*)fieldName;
- (BOOL)keyIsValid:(NSString*)key;
- (UIView *)findNextResponder:(NSInteger)tabOrder;
- (void)setTextFromDictionary:(NSDictionary*)dict;

//- (NSDictionary*)dictionaryFromValues;

@end
