//
//  EncryptedQRCodeParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EncryptedQRCodeParserDelegate <NSObject>

-(void)checkForDeviceAuthorizationFailedWithError:(NSString *)error;
-(void)checkForDeviceAuthorizationStartedForUser:(NSString *)username;
-(void)checkForDeviceAuthorizationEndedForUser:(NSString *)username;

-(void)encryptedQRCodeHasDeviceAuthorizedForMessage:(NSString *)base64String;
-(void)encryptedQRCodeDeviceAuthorizationFailedDueToError:(NSString *)error;
-(void)encryptedQRCodeHasNoDeviceAuthorizedForUser:(NSString *)username withDecodedDataDictionary:(NSDictionary *)decodedDataDictionary;

@end

@interface EncryptedQRCodeParser : NSObject
@property(nonatomic,retain)id <EncryptedQRCodeParserDelegate> delegate;
-(id)initWithEncryptedString:(NSString *)encryptedString;
-(NSDictionary*)getUserDataDictionary;
@end
