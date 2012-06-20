//
//  BHTextFieldHelper.h
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/1/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHTextFieldHelperInfo.h"

typedef void (^FieldDataDidChangeBlock)(NSString *key, NSString* text);
typedef void (^FieldDidBeginEditing)(NSString *key);
typedef void (^FieldDidEndEditing)(NSString *key);
typedef BOOL (^FieldShouldReturn)(NSString *key);

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
@property (readwrite, copy) FieldDidBeginEditing fieldDidBeginEditing;
@property (readwrite, copy) FieldDidEndEditing fieldDidEndEditing;
@property (readwrite, copy) FieldShouldReturn fieldShouldReturn;

@property (nonatomic, retain) UITableView *tableView;

+ (BHTextFieldHelper*)textFieldHelper;

- (void)resetHasChanged;
- (BHTextFieldHelperInfo*)addTextField:(UITextField*)field title:(NSString*)title key:(NSString*)key type:(BHTextFieldHelperField)type;
- (BHTextFieldHelperInfo*)addTextView:(UITextView*)field title:(NSString*)title key:(NSString*)key type:(BHTextFieldHelperField)type;
- (BHTextFieldHelperInfo*)addTextField:(UITextField*)field title:(NSString*)title key:(NSString*)key type:(BHTextFieldHelperField)type presenterParser:(BHTextFieldPresenterParser*)presenterParser;
- (BHTextFieldHelperInfo*)infoForTextField:(UITextField*)field;
- (BHTextFieldHelperInfo*)infoForTextView:(UITextView*)field;

- (void)setText:(NSString*)text forKey:(NSString*)fieldName;
- (NSString*)textForKey:(NSString*)fieldName;
- (BOOL)keyIsValid:(NSString*)key;
- (UIView *)findNextResponder:(NSInteger)tabOrder;
- (void)setTextFromDictionary:(NSDictionary*)dict;

- (void)setData:(id)data forKey:(NSString *)key;
- (id)dataForKey:(NSString *)key;

- (BOOL)hasDataForKey:(NSString*)key;
//- (void)setValuesFromRawData:(BHTextFieldHelperInfo*)fieldInfo rawString:(NSString*)rawString;
- (void)setFieldFromDataValue:(BHTextFieldHelperInfo*)fieldInfo dataValue:(NSString*)data;
- (void)setDataFromRawFieldValue:(BHTextFieldHelperInfo*)fieldInfo rawString:(NSString*)rawString;
@end
