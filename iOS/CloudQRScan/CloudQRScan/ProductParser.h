//
//  ProductParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 04/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductParser : NSObject
-(id)initWithServerResponseDictionary:(NSDictionary *)serverResponseDictionary;
-(NSDictionary *)getProductDictionary;
@end
