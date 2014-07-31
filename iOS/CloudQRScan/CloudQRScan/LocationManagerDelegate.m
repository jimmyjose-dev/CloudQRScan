//
//  LocationManagerDelegate.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 20/12/12.
//  Copyright (c) 2012 VarshylMobile. All rights reserved.
//

#import "LocationManagerDelegate.h"

@implementation LocationManagerDelegate

@synthesize latitude, longitude, hasFoundLocation, location,shouldStopLocationManagerOnBackground;

LocationManagerDelegate* locationManagerDelegate = nil;
+ (LocationManagerDelegate*)sharedInstance {
    if (locationManagerDelegate == nil)
        locationManagerDelegate = [[LocationManagerDelegate alloc] init];
    
    return locationManagerDelegate;
}

- (id)init {
    if ((self = [super init])) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.shouldStopLocationManagerOnBackground = YES;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    hasFoundLocation = YES;
    
    location = newLocation;
    
    latitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
    [Flurry setLatitude:newLocation.coordinate.latitude
              longitude:newLocation.coordinate.longitude
     horizontalAccuracy:newLocation.horizontalAccuracy
       verticalAccuracy:newLocation.verticalAccuracy];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kLocationNotificationName object:nil]];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    hasFoundLocation = NO;
    
    if ([error domain] == kCLErrorDomain) {
        
        switch ([error code]) {
                // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
                // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
            case kCLErrorDenied:
            {
                
                
            }
                
            case kCLErrorLocationUnknown:
                
            default:
                break;
        }
    } else {
       
    }
    
}

- (void)startLocationManager {
    [locationManager startUpdatingLocation];
}

- (void)stopLocationManager {
    [locationManager stopUpdatingLocation];
}

@end