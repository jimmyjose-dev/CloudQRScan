//
//  HistoryParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 05/12/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryParser : NSObject
-(id)initWithSyncData:(NSDictionary *)syncDataDict;
-(void)syncData;
-(NSDictionary *)getSyncData;
@end
