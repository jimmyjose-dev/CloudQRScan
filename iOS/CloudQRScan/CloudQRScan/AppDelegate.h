//
//  AppDelegate.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 15/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomWindow;
extern NSString *const FBSessionStateChangedNotification;

@class CustomNavigationController;
@class ViewController;
//@class SplashViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomWindow *window;

@property (strong, nonatomic) ViewController *viewController;
//@property (strong, nonatomic) SplashViewController *splashViewController;
@property (strong, nonatomic) CustomNavigationController *navigationController;//Subclassed Navigation controller for iOS4&5

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;
- (void) shareButtonPressed;

@end
