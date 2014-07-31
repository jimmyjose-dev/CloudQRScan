//
//  UIViewController+Utils.h
//  VMCategories
//
//  Created by Jimmy on 10/04/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

- (id)initByAppendingDeviceName;
- (void)initByAppendingDeviceNameAndPush;
- (void)initByAppendingDeviceNameAndPushAnimated:(BOOL)animated;
- (id)initByAppendingDeviceNameWithTitle:(NSString*)title;
- (void)initByAppendingDeviceNameAndPushWithTitle:(NSString*)title;
- (void)initByAppendingDeviceNameAndPushWithTitle:(NSString*)title animated:(BOOL)animated;
- (id)initByAppendingDeviceNameForNibName:(NSString *)forNibName;
- (void)initByAppendingDeviceNameAndPushForNibName:(NSString *)forNibName;
- (void)initByAppendingDeviceNameAndPushForNibName:(NSString *)forNibName animated:(BOOL)animated;
- (id)initByAppendingDeviceNameForNibName:(NSString *)forNibName withTitle:(NSString*)title;
- (void)initByAppendingDeviceNameAndPushForNibName:(NSString *)forNibName withTitle:(NSString*)title;
- (void)initByAppendingDeviceNameAndPushForNibName:(NSString *)forNibName withTitle:(NSString*)title animated:(BOOL)animated;

/* //It was using a private api setParentViewController
// A "Pop Up" is intended to only take up a portion of the screen, similar to a UIAlertView

// Adds a "Pop Up" view to the current view controller
- (void)presentPopUpViewController:(UIViewController*)viewController;

// Dismisses the "Pop Up" view
- (void)dismissPopUpViewController; // Calls the method below on parentViewController
- (void)dismissPopUpViewController:(UIViewController*)viewController;
 */

@end
