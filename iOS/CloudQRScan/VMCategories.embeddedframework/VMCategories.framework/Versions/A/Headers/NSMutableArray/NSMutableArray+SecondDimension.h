//
//  NSMutableArray+SecondDimension.h
//  VMCategories
//
//  Created by Jimmy on 14/03/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SecondDimension)

+ (NSMutableArray *)arrayWithRows:(NSUInteger)rows andColumns:(NSUInteger)columns;

- (id)initWithRows:(NSUInteger)rows andColumns:(NSUInteger)columns;

- (id)objectAtRow:(NSUInteger)row andColumn:(NSUInteger)column;

- (void)insertObject:(id)anObject inRow:(NSUInteger)row andColumn:(NSUInteger)column;

@end
