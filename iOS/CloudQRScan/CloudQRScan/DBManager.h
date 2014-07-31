//
//  DBManager.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 05/04/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DBManager : NSObject


-(id)init;

-(void)createDirectoryForSharing;

-(void)copyDB;

-(void)deleteLink:(NSString *)link;

-(void)saveLink:(NSString *)link withHeading:(NSString *)heading subHeading:(NSString *)subheading type:(NSString *)type fromLocation:(NSString *)location onDate:(NSString *)dateStr;

-(void)saveLink:(NSString *)link withHeading:(NSString *)heading subHeading:(NSString *)subheading type:(NSString *)type andImagePath:(NSString *)imagePathName fromLocation:(NSString *)location onDate:(NSString *)dateStr;

-(void)saveEncryptedLink:(NSString *)link fromUser:(NSString *)username fromLocation:(NSString *)location onDate:(NSString *)dateStr;

-(void)saveProductLink:(NSString *)link forProduct:(NSString *)product fromLocation:(NSString *)location onDate:(NSString *)dateStr;

-(void)updateSyncDate;

@end
