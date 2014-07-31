//
//  HistoryManager.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 21/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryManager : NSObject

-(void)saveLink:(NSString *)link withHeading:(NSString *)heading subHeading:(NSString *)subheading type:(NSString *)type fromLocation:(NSString *)location onDate:(NSString *)dateStr;

-(void)saveEncryptedLink:(NSString *)link fromUser:(NSString *)username fromLocation:(NSString *)location onDate:(NSString *)dateStr;
-(void)saveProductLink:(NSString *)link forProduct:(NSString *)product fromLocation:(NSString *)location onDate:(NSString *)dateStr;

-(NSDictionary *)getDBData;
-(NSDictionary *)getDBDataForSync;
-(void)deleteLink:(NSString *)link;
-(void)updateSyncDate;

@end
