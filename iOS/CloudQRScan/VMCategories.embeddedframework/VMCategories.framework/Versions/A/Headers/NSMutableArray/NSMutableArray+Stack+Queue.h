//
//  NSMutableArray+Stack+Queue.h
//  VMCategories
//
//  Created by Jimmy on 14/03/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


/** Enhancmeent that adds stack and queue operations to an array.
 */
@interface NSMutableArray (Stack_Queue)

/** Push an object onto the end of this array (like a LIFO stack).
 *
 * @param object the object to push onto the stack.
 */
- (void) push:(id) object;

/** Pop the last object off the array (like a LIFO stack).
 *
 * @return the object that was removed.
 */
- (id) pop;

/** Peek at the top of the stack without removing the object.
 *
 * @return the object at the top of the stack.
 */
- (id) peek;

/** Add an object to the beginning of a queue.
 *
 * @param the object to add.
 */
- (void) enqueue:(id) object;

/** Remove an object from the end of a queue.
 *
 * @return the object that was removed.
 */
- (id) dequeue;

@end
