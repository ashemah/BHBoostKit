//
//  BHTextFieldHelper.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/1/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHTextFieldHelper.h"

@implementation BHTextFieldHelper

@synthesize fields;
@synthesize info;
@synthesize textCharSet;
@synthesize numbersCharSet;
@synthesize currencyCharSet;
@synthesize hasChanged;
@synthesize hasChangedButton;
@synthesize dataDict;
@synthesize numbersPunctCharSet;
@synthesize emailRegEx;

@synthesize fieldDataDidChange;
@synthesize fieldDidBeginEditing;
@synthesize fieldDidEndEditing;
@synthesize fieldShouldReturn;

@synthesize infoForKey;
@synthesize tableView;

- (id)init {
    if ((self = [super init])) {
        self.fields             = [NSMutableDictionary dictionary];
        self.info               = [NSMutableDictionary dictionary];        
        self.infoForKey         = [NSMutableDictionary dictionary];        
        self.textCharSet        = [NSCharacterSet alphanumericCharacterSet];
        self.numbersPunctCharSet= [NSCharacterSet characterSetWithCharactersInString:@"1234567890-() "];
        self.numbersCharSet     = [NSCharacterSet decimalDigitCharacterSet];
        self.currencyCharSet    = [NSCharacterSet characterSetWithCharactersInString:@"1234567890."];
        self.dataDict           = [NSMutableDictionary dictionary];
        self.emailRegEx         = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";    
        
    }
    
    return self;
}

- (void)setTextFromDictionary:(NSDictionary*)dict {
    
    if (dict) {
        [self.dataDict addEntriesFromDictionary:dict];
    }
}

- (void)dealloc {
    for (BHTextFieldHelperInfo *i in [self.fields allValues]) {
        // Nop
    }
}

+ (BHTextFieldHelper*)textFieldHelper {
    return [[BHTextFieldHelper alloc] init];
}

- (void)resetHasChanged {
    self.hasChanged = NO;
}

- (BHTextFieldHelperInfo*)addTextField:(UITextField*)field title:(NSString*)title key:(NSString*)key type:(BHTextFieldHelperField)type presenterParser:(BHTextFieldPresenterParser*)presenterParser {
    NSAssert(field, @"Invalid field! %@", key);
    
    BHTextFieldHelperInfo *i = [self.infoForKey objectForKey:key];
    
    if (!i) {
        i = [[BHTextFieldHelperInfo alloc] init];
    }
    
    i.field    = field;
    i->tabOrder = [self.info count];
    i->type     = type;
    i->title    = title;
    i->key      = key;
    i.presenterParser = presenterParser;
    
    field.delegate = self;    
    field.placeholder = title;
	[field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];        
    
    field.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    field.secureTextEntry = NO;
    
    switch (type) {
        case BHTextFieldHelperField_Numbers: {
            field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        } break;
            
        case BHTextFieldHelperField_EmailAddress:
        case BHTextFieldHelperField_ReadOnlyEmailAddress: {
            field.keyboardType              = UIKeyboardTypeEmailAddress;
            field.autocapitalizationType    = UITextAutocapitalizationTypeNone;            
            field.enabled                   = (type != BHTextFieldHelperField_ReadOnlyEmailAddress);
            
        } break;
            
        case BHTextFieldHelperField_PhoneNumber: {
            field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        } break;
            
        case BHTextFieldHelperField_Currency: {
            field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        } break;
            
        case BHTextFieldHelperField_Password: {
            field.secureTextEntry = YES;
        } break;
            
        default: {
            
        }
    }
    
    [self.infoForKey setObject:i forKey:key];
    [self.fields setObject:field forKey:key];
    [self.info setObject:i forKey:[NSNumber numberWithInteger:[field hash]]];
        
    [self setFieldFromDataValue:i dataValue:[self.dataDict objectForKey:key]];    
    //    field.text = [self textForKey:key];
    
    return i;    
}

- (BHTextFieldHelperInfo*)addTextField:(UITextField*)field title:(NSString*)title key:(NSString*)key type:(BHTextFieldHelperField)type {
    return [self addTextField:field title:title key:key type:type presenterParser:nil];
}


- (BHTextFieldHelperInfo*)addTextView:(UITextView*)field title:(NSString*)title key:(NSString*)key type:(BHTextFieldHelperField)type {

    NSAssert(field, @"Invalid field! %@", key);
    
    BHTextFieldHelperInfo *i = [self.infoForKey objectForKey:key];
    
    if (!i) {
        i = [[BHTextFieldHelperInfo alloc] init];
    }
    
    i.field    = field;
    i->tabOrder = [self.info count];
    i->type     = type;
    i->title    = title;
    i->key      = key;
    
    field.delegate = self;
    
    [self.fields setObject:field forKey:key];
    [self.info setObject:i forKey:[NSNumber numberWithInteger:[field hash]]];
    
    [self setFieldFromDataValue:i dataValue:[self.dataDict objectForKey:key]];
//    field.text = [self.dataDict objectForKey:key];    
    
    return i;
}

- (BHTextFieldHelperInfo*)infoForTextField:(UITextField*)field {
    NSNumber *num = [NSNumber numberWithInteger:[field hash]];
    return [self.info objectForKey:num];
}

- (BHTextFieldHelperInfo*)infoForTextView:(UITextView*)field {
    NSNumber *num = [NSNumber numberWithInteger:[field hash]];
    return [self.info objectForKey:num];
}

- (void)setData:(id)data forKey:(NSString *)key {
    
    if (data == nil) {
        return;
    }
    
    [self.dataDict setObject:data forKey:key];
}

- (id)dataForKey:(NSString *)key {
    return [self.dataDict objectForKey:key];
}

- (void)setText:(NSString*)text forKey:(NSString*)fieldName {
    
    if (text) {
        [self.dataDict setObject:text forKey:fieldName];        
    }
    else {
        [self.dataDict removeObjectForKey:fieldName];
    }
    
    id field = [self.fields objectForKey:fieldName];    
    [field setText:text];
}

- (NSString*)textForKey:(NSString*)fieldName {
    
    id data = [self.dataDict objectForKey:fieldName];
    
    if (data) {
        if ([data isKindOfClass:[NSString class]]) {
            return data;
        }
        else if ([data isKindOfClass:[NSNumber class]]) {
            return [data stringValue];
        }
        
        return [data description];
    }
    else {
        return @"";
    }
}

//

- (BOOL) textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered {
    
    BHTextFieldHelperInfo *i = [self infoForTextField:textField];
    
    BOOL isValid = [self validateField:i->key forData:textEntered];
    
    if (!isValid) {
        return NO;
    }
    
    [self.dataDict setObject:textField.text forKey:i->key];
    
//    if (self.fieldDataDidChangeBlock) {
//        self.fieldDataDidChangeBlock(i->key, textField.text);
//    }
    
    return YES;
}

- (void)resignFirstResponderForKey:(NSString*)fieldName {
    BHTextFieldHelperInfo *i = [self.infoForKey objectForKey:fieldName];
    [i.field resignFirstResponder];
}

- (BOOL)validateField:(NSString*)fieldName forData:(NSString*)data {
    
    BHTextFieldHelperInfo *i = [self.infoForKey objectForKey:fieldName];
    
    if (i->type == BHTextFieldHelperField_Numbers) {
        
        for (int i = 0; i < [data length]; i++) {
            unichar c = [data characterAtIndex:i];
            if (![self.numbersCharSet characterIsMember:c]) {
                return NO;
            }
        }        
    }
    
    if (i->type == BHTextFieldHelperField_PhoneNumber) {
        
        for (int i = 0; i < [data length]; i++) {
            unichar c = [data characterAtIndex:i];
            if (![self.numbersPunctCharSet characterIsMember:c]) {
                return NO;
            }
        }        
    }
    
    
    if (i->type == BHTextFieldHelperField_Currency) {
        
        for (int i = 0; i < [data length]; i++) {
            unichar c = [data characterAtIndex:i];
            if (![self.currencyCharSet characterIsMember:c]) {
                return NO;
            }
        }        
    }
    
//    if (i->type == BHTextFieldHelperField_EmailAddress) {
//        
//        NSPredicate *regExPredicate =
//        [NSPredicate predicateWithFormat:@"SELF MATCHES[cd] %@", self.emailRegEx];        
//        BOOL isValid = [regExPredicate evaluateWithObject:data];        
//        if (!isValid) {
//            return NO;
//        }        
//    }    
    
    return YES;
}

- (BOOL)isValid:(NSString*)fieldName {    
    return [self validateField:fieldName forData:[self.dataDict objectForKey:fieldName]];
}

- (UIView *)findNextResponder:(NSInteger)tabOrder {
    
    NSInteger nextTag = tabOrder + 1;
    UIView *nextResponder = nil;
    
    for (BHTextFieldHelperInfo *i2 in [self.info allValues]) {
        if (i2->tabOrder == nextTag) {
            nextResponder = i2.field;
            break;
        }
    }    
    
    return nextResponder;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BHTextFieldHelperInfo *i = [self infoForTextField:textField];
    
    if (self.fieldShouldReturn) {
        if (self.fieldShouldReturn(i->key) == NO) {
            return NO;
        }
    }
    
    UIView *nextResponder = [self findNextResponder:i->tabOrder];
    
    int offs = 0;
    while (nextResponder && ![nextResponder isKindOfClass:[UITextView class]] && ![nextResponder isKindOfClass:[UITextField class]]) {
        offs++;
        nextResponder = [self findNextResponder:i->tabOrder+offs];
    }
                         
    if (nextResponder) {        
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        
        //
        if (self.tableView) {
            UIView *cell = nextResponder;
            
            int i = 0;
            while (i < 5) {
                
                if ([cell isKindOfClass:[UITableViewCell class]]) {
                    NSIndexPath *path = [self.tableView indexPathForCell:((UITableViewCell*)cell)];
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    break;
                }
                
                cell = cell.superview;                
                i++;
            }
        }
        
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    BHTextFieldHelperInfo *i = [self infoForTextField:textField];
    
    [self setDataFromRawFieldValue:i rawString:textField.text];
    
    if (i->tabOrder == [self.info count]) {
        textField.returnKeyType = UIReturnKeyDone;
    }
    else {
        textField.returnKeyType = UIReturnKeyNext;
    }
    
    if (self.fieldDidBeginEditing) {
        self.fieldDidBeginEditing(i->key);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    BHTextFieldHelperInfo *i = [self infoForTextField:textField];
    
    [self setDataFromRawFieldValue:i rawString:textField.text];
        
    if (self.fieldDidEndEditing) {
        self.fieldDidEndEditing(i->key);
    }
   
}

- (void)setFieldFromDataValue:(BHTextFieldHelperInfo*)fieldInfo dataValue:(NSString*)data {

    NSString *uiString = nil;
    
    if (fieldInfo->presenterParser) {
        
        uiString    = [fieldInfo.presenterParser transformFromData:data];
        uiString    = [fieldInfo.presenterParser present:uiString];
    }
    else {
        uiString    = data;
    }
    
    [fieldInfo.field setText: uiString];    
}

- (void)setDataFromRawFieldValue:(BHTextFieldHelperInfo*)fieldInfo rawString:(NSString*)rawString {

    NSString *dataString = nil;
    NSString *uiString = nil;
    
    if (fieldInfo->presenterParser) {
        NSString *cleanString  = [fieldInfo.presenterParser parse:rawString];             // Parse the string into a clean form
        dataString  = [fieldInfo.presenterParser transformToData:cleanString];  // Now in transformed data format

        uiString    = [fieldInfo.presenterParser present:cleanString];
    }
    else {
        dataString  = rawString;
        uiString    = rawString;
    }
    
    [fieldInfo.field setText: uiString];
    [self.dataDict setObject:dataString forKey:fieldInfo->key];
    
}

- (void)textFieldDidChange:(id)sender {
    BHTextFieldHelperInfo *i = [self infoForTextField:sender];    
    
    [self.dataDict setObject:[sender text] forKey:i->key];   
    
    if (self.fieldDataDidChange) {
        self.fieldDataDidChange(i->key, [sender text]);
    }    
}

- (BOOL)keyIsValid:(NSString*)fieldName {
    NSString *text = [self.dataDict objectForKey:fieldName];
    return text != nil;
}

- (BOOL)hasDataForKey:(NSString*)key {
    return [self.dataDict objectForKey:key] != nil;
}

@end
