//
//  String.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 10/04/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface String : NSObject
+(NSString *)googleAPIKey;
+(NSString *)getServiceURLForProfileID:(NSString *)profileID;
@end
