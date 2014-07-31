//
//  EventParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EKEvent,EKEventStore;
@interface EventParser : NSObject
-(id)initWithQRScanResult:(NSString *)qrScanString;
-(NSDictionary *)getEventDictionary;
-(EKEvent *)getEvent;
-(EKEventStore *)getEventStore;
@end
