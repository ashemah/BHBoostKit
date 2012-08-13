//
//  NSDictionary+BHExtras.m
//  BeatTheQ
//
//  Created by Ashemah Harrison on 3/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+BHExtras.h"


@implementation NSDictionary (NSDictionary_BHExtras)

- (id)objectForKey:(id)key defaultValue:(id)defaultValue {
    id obj = [self objectForKey:key];
    if (!obj) {
        return defaultValue;
    }
    return obj;
}    

@end
