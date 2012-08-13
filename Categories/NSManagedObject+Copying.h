//
//  NSManagedObject+Copying.h
//  BeatTheQ
//
//  Created by Ashemah Harrison on 1/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface NSManagedObject (NSManagedObject_Copying) <NSCopying>

-(void)setRelationshipsToObjectsByIDs:(id)objects;
-(id)deepCopyWithZone:(NSZone *)zone;
-(NSDictionary *)ownedIDs;

-(void)cloneAttribsFrom:(NSManagedObject *)other;

@end
