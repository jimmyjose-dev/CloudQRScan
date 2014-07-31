//
//  DecryptController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecryptController : NSObject
-(id)init;
-(NSString *)dataWithPassMD5:(NSData *)data andEncodedData:(NSData *)data;
@end
