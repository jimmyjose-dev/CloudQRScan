//
//  NSData+Utils.h
//  VMCategories
//
//  Created by Jimmy on 30/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Utils)

- (BOOL)isNullOrEmpty;
- (NSString *)stringASCII;
- (NSString *)stringUTF8;
- (NSString *)stringUTF16;
- (NSString *)stringUTF32;
- (NSString *)deviceToken;
- (NSData *)md5;
@end
