//
//  QRCodeTypeParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 20/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeTypeParser : NSObject
-(id)initWithQRCode:(NSString *)qrCodeString;
-(NSString *)getQRCodeType;
@end
