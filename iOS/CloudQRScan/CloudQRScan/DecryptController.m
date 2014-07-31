//
//  DecryptController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "DecryptController.h"
#import "AESEncryption.h"

@implementation DecryptController

-(id)init{

    self = [super init];
    return self;
}
-(NSString *)dataWithPassMD5:(NSData *)pass andEncodedData:(NSData *)encodedData{

    AESEncryption *crypto = [[AESEncryption alloc] init];
    CCOptions padding = kCCOptionPKCS7Padding;
    // NSString *userKey = @"cloudqrscan12345";
    // NSString * _key = [password MD5String];
    
    //DLog(@"hash %@",_key);
    
   
    DLog(@"pass %@",[pass stringASCII]);
    DLog(@"data before decrypt %@ %@ %@ %@",[encodedData stringASCII],[encodedData stringUTF8],[encodedData stringUTF16],[encodedData stringUTF32]);
    
    NSData *decryptedData = [crypto decrypt:encodedData key:pass padding:&padding];
    
    
    NSString *decryptedString = [[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    DLog(@"decrypted data before alert: %@", decryptedString);
    
    
    return decryptedString;



}
@end
