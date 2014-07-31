//
//  DeviceAuthorizationParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "DeviceAuthorizationParser.h"

@implementation DeviceAuthorizationParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithUserData:(NSDictionary *)userDataDictionary{
    
    self = [self init];
    [self setDataForVerificationWithUserData:userDataDictionary];
    return self;
    
}

-(void)setDataForVerificationWithUserData:(NSDictionary *)userDataDictionary{


    
}

-(void)isDeviceAuthorizedForQRLockerID:(NSString *)qrLockerID withProfileID:(NSString *)profileID{
    
    NSString *deviceUDID = [UIDevice UDID];
    
    NSString *deviceAuthorizationStatus = DEVICE_AUTHORIZATION_URL(profileID,deviceUDID,qrLockerID);
    
    DLog(@"AuthorizeQRLockerMessage %@",deviceAuthorizationStatus);
    
    NSURL *deviceAuthorizationStatusURL = [NSURL URLWithString:deviceAuthorizationStatus];
    /*
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:deviceAuthorizationStatusURL
                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                              timeoutInterval:kTimeoutInterval];
     */
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:deviceAuthorizationStatusURL];
    [request setTimeoutInterval:kTimeoutInterval];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
        if (!error) {
            
            NSError *err = nil;
            NSString *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments error:&err];
            if (!err) {
                
                DLog(@"responseJSON %@",responseJSON);
                
            }else{
                
                DLog(@"error in JSON %@",[err localizedDescription]);
            }
            
        }
        
        else{
            
            DLog(@"Error %@",[error localizedDescription]);
        }
    }];
    
    
}
@end
