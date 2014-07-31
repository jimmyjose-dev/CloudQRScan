//
//  OptionActiveParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 25/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionActiveParser : NSObject
-(id)initWithOptionObject:(id)optionObject andOptionType:(NSString *)optionType;
-(NSDictionary *)getOptionsActiveWithDictionary;
@end
