//
//  NSObject+contentsDesc.h
//  VMCategories
//
//  Created by Jimmy on 14/03/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Adds the ability for all objects to print out a human-readable description of
 * their contents.
 */
@interface NSObject (ContentsDesc)

/** A description of this object's contents (except structs). */
@property(readonly) NSString* contentsDesc;

/** Get a description of this object's contents (except structs), indenting the
 * specified amount.
 *
 * @param spaces The number of spaces to indent.
 * @return The description.
 */
- (NSString*) contentsDescWithIndentation:(unsigned int) spaces;

/** (INTERNAL USE) Get a description of this object's contents (except structs),
 * indenting the specified amount.
 * This method also keeps a history of previously processed objects so as to avoid
 * an endless loop when it encounters a cyclical graph.
 *
 * @param spaces The number of spaces to indent.
 * @param context A mutable array containing objects that have already been processed.
 * @return The description.
 */
- (NSString*) contentsDescWithIndentation:(unsigned int) spaces context:(NSMutableArray*) processedObjects;

@end
