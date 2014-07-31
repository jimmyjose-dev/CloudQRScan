//
//  EncryptedQRCodeParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "EncryptedQRCodeParser.h"
#import "HistoryManager.h"

@interface EncryptedQRCodeParser ()
@property(nonatomic,retain)NSDictionary *decodedDataDictionary;
@end

@implementation EncryptedQRCodeParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithEncryptedString:(NSString *)encryptedString{
    
    self = [self init];
    [self decodeEncryptedString:encryptedString];
    return self;
    
}

-(void)decodeEncryptedString:(NSString *)encryptedString{
    
    NSString *encryptedCodeHeader = @"=encrypted";// data Use CloudQRScan App";
    
    NSRange marker = [encryptedString rangeOfString:encryptedCodeHeader];
    
    NSString *base64String = [encryptedString substringWithRange:NSMakeRange(0, marker.location)];
    
    NSString *base64StringWithUserInfo = [base64String base64DecodedString];
    
    NSString *patternSeparator = @"_-_";
    
    NSArray *separatedArray = [base64StringWithUserInfo componentsSeparatedByString:patternSeparator];
    
    NSString *userName = [[separatedArray firstObject] capitalizedString];//[[separatedArray objectAtIndex:1] capitalizedString];
    
    NSString *userInfo = [separatedArray lastObject];
    
    NSString *userEncryptedString = [separatedArray firstObject];
    //DLog(@"userEncryptedString %@",userEncryptedString);
    
    NSData *encodedData =[userEncryptedString base64DecodedData];
    
    NSArray *userInfoArray = [userInfo componentsSeparatedByString:@"&"];
    
    NSString *profileID = [[[userInfoArray firstObject] componentsSeparatedByString:@"="] lastObject];
    
    NSString *qrlockerID = [[[userInfoArray lastObject] componentsSeparatedByString:@"="] lastObject];
    
    //NSString *hint = [[[userInfoArray lastObject] componentsSeparatedByString:@"="] lastObject];
    
    _decodedDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              profileID,@"profileid",
                              qrlockerID,@"qrlockerid",
                              userName,@"username",
                              encodedData,@"userdata",nil];
    [[HistoryManager new] saveEncryptedLink:encryptedString fromUser:userName fromLocation:nil onDate:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"savetodb"];
    
    if ([_delegate respondsToSelector:@selector(checkForDeviceAuthorizationStartedForUser:)]) {
        [_delegate checkForDeviceAuthorizationStartedForUser:userName];
    }else{
    
        DLog(@"else of del");
    }
    

    
    [self isDeviceAuthorizedForQRLockerID:qrlockerID withProfileID:profileID];
    
}

-(void)isDeviceAuthorizedForQRLockerID:(NSString *)qrLockerID withProfileID:(NSString *)profileID{
        
    [_delegate checkForDeviceAuthorizationStartedForUser:[_decodedDataDictionary valueForKey:@"username"]];
    
    NSString *deviceUDID = [UIDevice UDID];
    
    NSString *deviceAuthorizationStatus = DEVICE_AUTHORIZATION_URL(profileID,deviceUDID,qrLockerID);
    
    DLog(@"deviceAuthorization %@",deviceAuthorizationStatus);
    
    NSURL *deviceAuthorizationStatusURL = [NSURL URLWithString:deviceAuthorizationStatus];
    
    
   // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:deviceAuthorizationStatusURL
                                               //   cachePolicy:NSURLCacheStorageNotAllowed
                                              //timeoutInterval:kTimeoutInterval];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:deviceAuthorizationStatusURL];
    [request setTimeoutInterval:kTimeoutInterval];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
        
        [_delegate checkForDeviceAuthorizationEndedForUser:[_decodedDataDictionary valueForKey:@"username"]];
        if (!error) {
            
            NSError *err = nil;
            NSDictionary *responseJSON = [[[NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments error:&err] valueForKey:@"AuthorizeQRLockerMessageResult"] objectAtIndex:0];
            if (!err) {
                
                DLog(@"responseJSON %@",responseJSON);
                if (![[responseJSON valueForKey:@"Status"] isEqualToString:@"FAILED"]) {
                
                    NSString *message = [responseJSON valueForKey:@"Message"];
                    [_delegate encryptedQRCodeHasDeviceAuthorizedForMessage:message];
                }
                else
                    [_delegate encryptedQRCodeHasNoDeviceAuthorizedForUser:[_decodedDataDictionary valueForKey:@"username"] withDecodedDataDictionary:_decodedDataDictionary];
                
            }else{
                
                DLog(@"error in JSON %@",[err localizedDescription]);
                [_delegate encryptedQRCodeDeviceAuthorizationFailedDueToError:[err localizedDescription]];
            }
            
        }
        
        else{
            
            DLog(@"Error %@",[error localizedDescription]);
            [_delegate encryptedQRCodeDeviceAuthorizationFailedDueToError:[error localizedDescription]];
        }
    }];
    
    
}

-(NSDictionary*)getUserDataDictionary{
    
    return _decodedDataDictionary;
    
}



@end