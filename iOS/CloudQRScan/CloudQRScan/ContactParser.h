//
//  ContactParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/04/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactParser : NSObject
-(id)initWithUserInfo:(NSDictionary *)userInfoDictionary;
-(id)initWithmeCard:(NSString *)qrcodeString;
-(ABRecordRef)getContactPerson;
@end
