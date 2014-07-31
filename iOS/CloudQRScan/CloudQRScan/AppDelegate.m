//
//  AppDelegate.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 15/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CustomNavigationController.h"
#import "SplashViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CustomWindow.h"

@implementation AppDelegate
NSString *const FBSessionStateChangedNotification =
@"com.varshylmobile.FacebookSSO:FBSessionStateChangedNotification";


-(void)CQRSNotifcationData:(NSDictionary *)userInfo{

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //Registering successfully for APNS will result in device token
    NSString* newToken = [deviceToken deviceToken];
    DLog(@"Device Token %@ length %d",newToken,[newToken length]);
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    //Error while registering for APNS
    DLog(@"Error %@",[err localizedDescription]);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //App recieved notification, this function is called if the app is in foreground
    
    /*for (id key in userInfo) {
     DLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
     }
     */

    DLog(@"Received notification: %@", userInfo);
	//[self CQRSNotifcationData:userInfo updateUI:YES];

}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    DLog(@"kFlurryApiKey %@",kFlurryApiKey);
   
     [Flurry setCrashReportingEnabled:YES];
    //[UIFont printAllFontBeginningWithName:@"goth" ignoreCase:YES];
    
    [Flurry startSession:kFlurryApiKey];
    [Flurry setEventLoggingEnabled:YES];
    
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];//Build
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];//Version
    
    
    NSDictionary *appVersion = [NSDictionary dictionaryWithObject:version forKey:@"version"];
    NSDictionary *appBuild = [NSDictionary dictionaryWithObject:build forKey:@"build"];
    
    [Flurry logEvent:@"Version" withParameters:appVersion];
    [Flurry logEvent:@"Build" withParameters:appBuild];
    
    DLog(@"ver %@ build %@",version,build);
    
    
    //  DDLog Usage
    //  Log levels: off, error, warn, info, verbose
    
      [DDLog addLogger:[DDTTYLogger sharedInstance]];
      [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
     //  for logging to file
    //  fileLogger = [[DDFileLogger alloc] init];
    //  fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    //  fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    //  [DDLog addLogger:fileLogger];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"enableScannerSound"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enableScannerSound"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"enableUpdates"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enableUpdates"];
    }
    
    
    BOOL setOn = kCheckDeviceAutoLock;
    
    application.idleTimerDisabled = setOn;
    
    // DLog(@"Registering for push notifications...");
    
    // Registering for push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
   
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[LocationManagerDelegate sharedInstance] startLocationManager];
    
    //If app lunches from push notification
    if (launchOptions) {
        //[self CQRSNotifcationData:userInfo updateUI:YES];
    }
    
    
    // Add the ZBar call embedded reader
    [ZBarReaderView class];
    
    // Google maps sdk api key
    [GMSServices provideAPIKey:kGoogleApiKey];

    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = [[CustomWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    

    NSString *deviceName = @"_iPhone";
    if ([UIDevice isiPad]) {
        deviceName = @"_iPad";
    }
    
    NSString *navBarHeaderImage = [NSString stringWithFormat:@"bg_header%@",deviceName];
    
    // Override point for customization after application launch.
    
   
   // self.splashViewController = [[SplashViewController alloc] initByAppendingDeviceName:@"SplashViewController"];
    
    self.viewController = [[ViewController alloc] initByAppendingDeviceName];
    
    self.navigationController = [[CustomNavigationController alloc]
                            initWithRootViewController:self.viewController];
    
    [Flurry logAllPageViews:self.navigationController];
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    [self.navigationController setTitleBarImage:navBarHeaderImage];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [[DBManager new] copyDB];
    [[DBManager new] createDirectoryForSharing];
    
    return YES;
}


/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url isFileURL])
    {
        NSString *fileExt = [[url pathExtension] lowercaseString];
    
        if([fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"jpg"] || [fileExt isEqualToString:@"jpeg"]){
        
            UIImage *image = [UIImage imageWithContentsOfFile:[url path]];
           
            ZBarReaderController *read = [ZBarReaderController new];
            
            id<NSFastEnumeration> results = [read scanImage:image.CGImage];
            BOOL isQRCode = NO;
            for(ZBarSymbol *sym in results) {
                
                
                if ([sym.typeName isEqualToString:@"QR-Code"]) {
                 
                    isQRCode = YES;
                    break;
                    
                }
                
            }
            if (isQRCode) {
           
                [self.viewController performActionWithSymbol:results andImage:image];
            }
            else{
            
                BlockAlertView *alert = [BlockAlertView alertWithTitle:@"No QRCode in image" message:@"\n\n\n\n\n\n\n\n\n\n"];
                UIView *vw = [alert view];
                
                UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
                imgView.height = 220;
                imgView.width = 220;
                imgView.y = 58;
                imgView.x = 28;
                
                
                [vw addSubview:imgView];
                
                [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
                [alert show];
            }
           
            return YES;
        
        }
     
    }
    
    return [FBSession.activeSession handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[LocationManagerDelegate sharedInstance] stopLocationManager];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[LocationManagerDelegate sharedInstance] startLocationManager];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UIDevice isInternetReachable]) {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"enableUpdates"] ||
        [[NSUserDefaults standardUserDefaults] boolForKey:@"enableUpdates"]) {
        
        [self checkForNewVersion];

    }
    else{
    
        DLog(@"Update check turned off from settings");
        
    }
    
    }else{
    
        DLog(@"Cannot check for updates, no internet available");
    }

}

-(void)checkForNewVersion{

    
    NSString *serverURL = VERSION_CHECK_URL;
    NSString *service = @"Version Check";

    DLog(@"serverURL %@",serverURL);
    ServerController *server = [[ServerController alloc] initWithServerURL:serverURL forServiceType:service];
    
    [server connectUsingGetMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
        
        if (errorString){
           
            DLog(@"Couldn't get app update due to error %@",errorString);
            
        }else{
            
            DLog(@"server response %@",serverResponse);
            NSDictionary *response = [serverResponse objectAtIndex:0];
            
            if ([[response valueForKey:@"Updated"] integerValue]) {
                
                NSString *versionNumber = [response valueForKey:@"version"];
                NSString *title = [NSString stringWithFormat:@"New version available(%@)",versionNumber];
//                NSString *msg = @"Download now ?";
                
            NSString *msg = [response valueForKey:@"Message"];/*
            
            if (![serverResponse isEqualToString:@"Updated"]) {
            
            
            NSString *title = @"New version available";
            NSString *msg = @"Download now ?";
            */
            BlockAlertView *alert = [BlockAlertView alertWithTitle:title message:msg];
            [alert setYESButtonWithBlock:^{
                //Redirect to itunes store
                NSString *appStoreURL = @"https://itunes.apple.com/us/app/cloudqrscan/id699597535?ls=1&mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL]];
            }];
            [alert setNOButtonWithBlock:^{
            
                NSString *msg = @"You can turn off auto update check from settings screen.";
                BlockAlertView *alert = [BlockAlertView alertWithTitle:Nil message:msg];
                [alert setOKButtonWithBlock:NULL];
                [alert show];
            }];
            [alert show];
            
            
        }
        }
        
    }];
    

}




- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[LocationManagerDelegate sharedInstance] stopLocationManager];
}

void uncaughtExceptionHandler(NSException *exception) {
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

@end
