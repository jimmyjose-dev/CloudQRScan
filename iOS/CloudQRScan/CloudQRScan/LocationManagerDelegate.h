//
//  LocationManagerDelegate.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 20/12/12.
//  Copyright (c) 2012 VarshylMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kLocationNotificationName @"locationNotification"

@interface LocationManagerDelegate : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager* locationManager;
    CLLocation *location;
    
    NSString* latitude;
    NSString* longitude;
    
    bool hasFoundLocation;
    bool shouldStopLocationManagerOnBackground;

}

+ (LocationManagerDelegate*)sharedInstance;

- (void)startLocationManager;
- (void)stopLocationManager;

@property (nonatomic, assign) bool shouldStopLocationManagerOnBackground;
@property (nonatomic, strong) NSString* latitude;
@property (nonatomic, strong) NSString* longitude;
@property (nonatomic, strong) CLLocation *location;
@property (assign) bool hasFoundLocation;

@end
