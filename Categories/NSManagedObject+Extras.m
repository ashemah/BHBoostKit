//
//  NSManagedObject+Extras.m
//  BeatTheQ
//
//  Created by Ashemah Harrison on 30/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObject+Extras.h"


@implementation NSManagedObject (NSManagedObject_Extras)

- (void)absorbValuesFrom:(NSDictionary*)objDict {
    
//    NSDictionary *attribInfo = [[self entity] attributesByName];
    
    for (NSString *key in [objDict allKeys]) {
        @try {
//            if ([attribInfo objectForKey:key] == nil) {
//                continue; // Skip relationship
//            }
            
            id val = [objDict objectForKey:key];
            if ([val isKindOfClass:[NSArray class]] || [val isKindOfClass:[NSDictionary class]]) {
                continue; // Skip non basic types
            }
            
            [self setValue:[objDict objectForKey:key] forKey:key];
        }
        @catch (NSException *e) {
            // Do nothin'
        }
    }
}

- (void)absorbValuesFromObject:(NSManagedObject*)otherObject {
    
    NSArray *props = [[otherObject entity] properties];
    for (NSString *key in props) {
        @try {
            //            if ([attribInfo objectForKey:key] == nil) {
            //                continue; // Skip relationship
            //            }
            
            id val = [otherObject valueForKey:key];            
            [self setValue:val forKey:key];
        }
        @catch (NSException *e) {
            // Do nothin'
        }
    }
}

@end
