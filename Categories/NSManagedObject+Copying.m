//
//  NSManagedObject+Copying.m
//  BeatTheQ
//
//  Created by Ashemah Harrison on 1/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObject+Copying.h"
#import <CoreData/CoreData.h>

@implementation NSManagedObject (NSManagedObject_Copying)

- (id)deepCopyWithZone:(NSZone *)zone {
//	NSMutableDictionary *ownedIDs = [[self ownedIDs] mutableCopy];
	NSManagedObjectContext *context = [self managedObjectContext];
	id copied = [[[self class] allocWithZone: zone] initWithEntity: [self entity] insertIntoManagedObjectContext: context];
    
	for(NSString *key in [[[self entity] attributesByName] allKeys]) {
		[copied setValue: [self valueForKey: key] forKey: key];
	}

    //Loop through all relationships, and clone them.
    NSDictionary *relationships = [[self entity] relationshipsByName];
    
    for (NSRelationshipDescription *rel in relationships){
        NSString *keyName = [rel description];
        
        if ([[relationships objectForKey: keyName] isToMany]) {
            //get a set of all objects in the relationship
            NSMutableSet *sourceSet = [self mutableSetValueForKey:keyName];
            NSMutableSet *clonedSet = [copied mutableSetValueForKey:keyName];
            NSEnumerator *e = [sourceSet objectEnumerator];
            NSManagedObject *relatedObject;
            while ((relatedObject = [e nextObject])){
                NSManagedObject *clonedRelatedObject = [relatedObject deepCopyWithZone:zone];            
                [clonedSet addObject:clonedRelatedObject];
            }
        }
        else {
            NSManagedObject *relatedObject          = [self valueForKey:keyName];
            NSManagedObject *clonedRelatedObject    = [relatedObject deepCopyWithZone:zone];
            [copied setValue:clonedRelatedObject forKey:keyName];
        }
    }
    
//	for(NSManagedObjectID *key in [ownedIDs allKeys]) { // deep copy relationships
//		id copiedObject = [[context objectWithID: key] deepCopyWithZone:zone];
//		[ownedIDs setObject: copiedObject forKey: key];
//		[copiedObject release];
//	}
    
//	[self setRelationshipsToObjectsByIDs: ownedIDs];
//	for(NSManagedObjectID *key in [ownedIDs allKeys]) {
//		[[ownedIDs objectForKey: key] setRelationshipsToObjectsByIDs: ownedIDs];
//	}
	return copied;
}

-(void)cloneAttribsFrom:(NSManagedObject *)other {
	for(NSString *key in [[[other entity] attributesByName] allKeys]) {
        id value = [other valueForKey: key];
		[self setValue:value forKey: key];
	}
}

-(id)copyWithZone:(NSZone *)zone { // shallow copy
	NSManagedObjectContext *context = [self managedObjectContext];
	id copied = [[[self class] allocWithZone: zone] initWithEntity: [self entity] insertIntoManagedObjectContext: context];
    
	for(NSString *key in [[[self entity] attributesByName] allKeys]) {
		[copied setValue: [self valueForKey: key] forKey: key];
	}
    
	for(NSString *key in [[[self entity] relationshipsByName] allKeys]) {
		[copied setValue: [self valueForKey: key] forKey: key];
	}
	return copied;
}

-(void)setRelationshipsToObjectsByIDs:(id)objects {
	id newReference = nil;
	NSDictionary *relationships = [[self entity] relationshipsByName];
	for(NSString *key in [relationships allKeys]) {
		if([[relationships objectForKey: key] isToMany]) {
			id references = [NSMutableSet set];
			for(id reference in [self valueForKey: key]) {
				if((newReference = [objects objectForKey: [reference objectID]])) {
					[references addObject: newReference];
				} else {
					[references addObject: reference];
				}
			}
			[self setValue: references forKey: key];
		} else {
			if((newReference = [objects objectForKey: [[self valueForKey: key] objectID]])) {
				[self setValue: newReference forKey: key];
			}
		}
	}
}

-(NSDictionary *)ownedIDs {
	NSDictionary *relationships = [[self entity] relationshipsByName];
	NSMutableDictionary *ownedIDs = [NSMutableDictionary dictionary];
	for(NSString *key in [relationships allKeys]) {
		id relationship = [relationships objectForKey: key];
		if([relationship deleteRule] == NSCascadeDeleteRule) { // ownership
			if([relationship isToMany]) {
				for(id child in [self valueForKey: key]) {
					[ownedIDs setObject: child forKey: [child objectID]];
					[ownedIDs addEntriesFromDictionary: [child ownedIDs]];
				}
			} else {
				id reference = [self valueForKey: key];
				[ownedIDs setObject: reference forKey: [reference objectID]];
			}
		}
	}
	return ownedIDs;
}

@end
