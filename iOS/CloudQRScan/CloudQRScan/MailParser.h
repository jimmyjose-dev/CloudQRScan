//
//  MailParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFMailComposeViewController;

@interface MailParser : NSObject
-(id)initWithMail1QRScanResult:(NSString *)qrcodeString;
-(id)initWithMail2QRScanResult:(NSString *)qrcodeString;
-(MFMailComposeViewController *)getMailController;
-(NSString *)getEmail;
@end
