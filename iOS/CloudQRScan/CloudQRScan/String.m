//
//  String.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 10/04/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "String.h"

@implementation String


+(NSString *)googleAPIKey{return @"AIzaSyC5_P6FGF5nBSOvMa2rIIByFu2_AuY03j0";}

+(NSString *)getServiceURLForProfileID:(NSString *)profileID
{
    return [NSString stringWithFormat:@"%@/QRService.svc/GetQR/%@",kSERVER_DOMAIN,profileID];
}

@end
