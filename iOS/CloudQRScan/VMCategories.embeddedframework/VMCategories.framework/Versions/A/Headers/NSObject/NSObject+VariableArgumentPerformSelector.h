//
//  NSObject+PerformSelectorVaried.h
//  VMCategories
//
//  Created by Jimmy on 14/03/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (VariableArgumentPerformSelector)

- (void) performSelector:(SEL)aSelector withObjects:(NSObject *)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (void)performSelector:(SEL)aSelector withEachObjectFrom:(id)collection;

- (NSArray *)resultsOfPerformingSelector:(SEL)aSelector withEachObjectFrom:(id)collection;

- (void)log; //A very commonly used method make it part of your default application project in PB or XC

- (id)arrayByAddingObject:(id)anObject; // a convenience for those of us who like to avoid special cases for collections


@end
