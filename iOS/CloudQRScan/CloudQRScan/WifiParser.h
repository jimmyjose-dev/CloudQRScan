//
//  WifiParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 02/10/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiParser : NSObject
-(id)initWithQRScanResult:(NSString *)qrScanString;
-(NSString *)getFormattedDetail;
-(NSString *)getTitle;

@end
