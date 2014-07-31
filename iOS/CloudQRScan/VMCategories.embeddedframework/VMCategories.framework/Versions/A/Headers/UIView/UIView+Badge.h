//
//  UIView+Badge.h
//  MLTBadgedView
//
//  Created by Robert Rasmussen on 10/2/10.
//  Copyright 2010 Moonlight Tower. All rights reserved.
//


/*
 
 
 // Huge badge with custom colors
 UIButton *b3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 b3.frame = CGRectMake(100, 200, 200, 50);
 [b3 setTitle:@"Ugly Badge Support" forState:UIControlStateNormal];
 b3.badge.outlineWidth = 5.0;
 b3.badge.outlineColor = [UIColor blackColor];
 b3.badge.badgeColor = [UIColor brownColor];
 b3.badge.textColor = [UIColor purpleColor];
 b3.badge.minimumDiameter = 60.0;
 b3.badge.font = [UIFont boldSystemFontOfSize:20];
 b3.badge.badgeValue = 50;
 [self.view addSubview:b3];
 
 
 */

#import <UIKit/UIKit.h>

typedef enum {
  kBadgePlacementUpperLeft,
  kBadgePlacementUpperRight,
  kBadgePlacementUpperBest
} MLTBadgePlacement;


@interface MLTBadgeView : UIView {
  
}
// Determines where badge is placed
@property MLTBadgePlacement placement;
// The numeric value to display on the badge
@property NSInteger badgeValue;
// The font for the badge number
@property(nonatomic, retain) UIFont *font;
// The interior color of the badge
@property(nonatomic, retain) UIColor *badgeColor;
// The color for badge text
@property(nonatomic, retain) UIColor *textColor;
// The outline color for the badge
@property(nonatomic, retain) UIColor *outlineColor;
// The width of the outline around the badge
@property float outlineWidth;
// Force the badge to a minimum size
@property float minimumDiameter;
// Show the badge no matter what
@property BOOL displayWhenZero;
@end

// Addition to UIView which allows any UIView to display
// a badge in the upper left or upper right corner of
// the view.
@interface UIView(Badged)
@property(nonatomic, readonly) MLTBadgeView *badge;
@end