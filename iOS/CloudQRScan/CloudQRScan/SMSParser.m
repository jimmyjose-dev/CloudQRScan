//
//  SMSParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "SMSParser.h"
#import <MessageUI/MessageUI.h>

@interface SMSParser()
@property(nonatomic,retain)MFMessageComposeViewController *smsController;
@property(nonatomic,retain)NSString *number;
@end

@implementation SMSParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithQRScanResult:(NSString *)qrScanString{
    
    self = [self init];
    [self parseForSMSWithQRScanResult:qrScanString];
    return self;
    
}

-(void)parseForSMSWithQRScanResult:(NSString *)qrScanString{
    
    [self setSMSDataWithQRScanResult:qrScanString];
}

-(void)setSMSDataWithQRScanResult:(NSString *)smsString{
    
    NSArray *smsData = [smsString componentsSeparatedByString:@":"];
  
    _smsController = [MFMessageComposeViewController new];
    _smsController.body = [NSString stringWithString:[smsData objectAtIndex:2]];
    _smsController.recipients = [NSArray arrayWithObjects:[smsData objectAtIndex:1], nil];
    _number = [smsData objectAtIndex:1];
}

-(MFMessageComposeViewController *)getSMSController{
    
    return _smsController;
}

-(NSString *)getNumber{

    return _number;
}

@end
