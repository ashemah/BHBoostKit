//
//  NSManagedObject+Extras.h
//  BeatTheQ
//
//  Created by Ashemah Harrison on 30/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSManagedObject (NSManagedObject_Extras)

- (void)absorbValuesFrom:(NSDictionary*)obDict;
- (void)absorbValuesFromObject:(NSManagedObject*)otherObject;

@end
