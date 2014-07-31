//
//  BookmarkParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 27/09/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookmarkParser : NSObject
-(id)initWithQRScanResult:(NSString *)qrScanString;
-(NSString *)getTitle;
-(NSString *)getUrl;
@end
