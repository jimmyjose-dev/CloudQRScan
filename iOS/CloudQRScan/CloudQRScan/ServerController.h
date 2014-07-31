//
//  ServerController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 04/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ServerCallback)(id serverResponse, NSString *errorString, NSString *service);

@interface ServerController : NSObject

-(id)initWithServerURL:(NSString *)serverURL forServiceType:(NSString *)service;

-(id)initWithServerURL:(NSString *)serverURL andPostParameter:(NSDictionary *)postParameter forServiceType:(NSString *)service;

-(void)connectUsingGetMethodWithCompletionBlock:(ServerCallback)completion;

-(void)connectUsingPostMethodWithCompletionBlock:(ServerCallback)completion;


@end
