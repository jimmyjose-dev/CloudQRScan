//
//  UIView+POViewFrameBuilder.h
//
//  Created by Sebastian Rehnby on 10/11/12.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POViewFrameBuilder.h"

@interface UIView (POViewFrameBuilder)

@property (nonatomic, strong, readonly) POViewFrameBuilder *po_frameBuilder;

@end


/*

 Resizing a view:
 
 [view.po_frameBuilder setWidth:100.0f height:40.0f];
 Moving a view to be centered within it's superview:
 
 [view.po_frameBuilder centerInSuperview];
 You can combine these methods to your own liking:
 
 [[view.po_frameBuilder setWidth:100.0f height:40.0f] centerHorizontallyInSuperview];


 
 One thing to note is that by default, the automaticallyCommitChanges property is set to YES. This means that the frame changes are committed after every modifying method in the chain. However, having multiple frame changes in an animation doesn't work, and the view ends up jumping around. To avoid this, begin the method chain by calling disableAutoCommit and finish the series of changes by calling the commit method, which will update the view's frame:
 
 [[[[view.po_frameBuilder disableAutoCommit] setWidth:100.0f height:40.0f] centerHorizontallyInSuperview] commit];
 Thanks to @rsobik, there is now also a shorter and more readable way to create these transactions:
 
 [self.squareView.po_frameBuilder update:^(POViewFrameBuilder *builder) {
 [builder setWidth:100.0f height:40.0f];
 [builder centerHorizontallyInSuperview];
 }];
 
 
*/