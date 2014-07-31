//
//  NSURL+Utils.h
//  VMCategories
//
//  Created by Jimmy on 14/03/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLHelper.h"

@interface NSURL (Utils)

- (NSURL *)hostURL;
+ (NSURL *)URLByCheckingHTTPWithString:(NSString *)urlString;
@end
