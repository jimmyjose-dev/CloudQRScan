//
//  WifiParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 02/10/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "WifiParser.h"

@interface WifiParser ()
@property(nonatomic,retain)NSString *formattedText;
@property(nonatomic,retain)NSString *title;
@end

@implementation WifiParser


-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithQRScanResult:(NSString *)qrScanString{
    
    self = [self init];
    [self parseForWifiWithQRScanResult:qrScanString];
    return self;
    
}

-(void)parseForWifiWithQRScanResult:(NSString *)qrScanString{
    
    [self setWifiDataWithQRScanResult:qrScanString];
}

-(void)setWifiDataWithQRScanResult:(NSString *)qrScanString{
    
    NSArray *wifiArray = [qrScanString componentsSeparatedByString:@";"];
    
    NSString *encryptionType = [[wifiArray objectAtIndex:0] trim];
    NSString *encryption = [[[encryptionType componentsSeparatedByString:@":"] lastObject] trim];
    
    NSString *ssid  = nil;
    if ([wifiArray count]>1) {
    
        ssid  = [[wifiArray objectAtIndex:1] trim];
        ssid = [[[ssid componentsSeparatedByString:@":"] lastObject] trim];
    }
    
    NSString *password  =  nil;
    
    if ([wifiArray count]>2) {
    
        password  = [[wifiArray objectAtIndex:2] trim];
        password = [[[password componentsSeparatedByString:@":"] lastObject] trim];
        
        if (!password || ![password length]) {
            password = @"";
        }
    }
    
    _title = ssid;
    _formattedText = [NSString stringWithFormat:@"ENCR: %@\nSSID:  %@\nPASS: %@",encryption,ssid,password];
    NSString *noteMSg = @"\n\n\n\nNote: You can enter these values manually to access the network.\nSettings -> Wi-Fi";
    _formattedText = [_formattedText stringByAppendingString:noteMSg];
    DLog(@"_formattedText %@",_formattedText);
    
}

-(NSString *)getFormattedDetail{


    return _formattedText;
}

-(NSString *)getTitle{

    return _title;
}

@end
