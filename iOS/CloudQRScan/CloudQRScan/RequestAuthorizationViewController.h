//
//  RequestAuthorizationViewController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 03/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestAuthorizationViewController : UIViewController
@property(nonatomic,retain)NSString *toName;
@property(nonatomic,retain)NSString *toEmail;
@property(nonatomic,retain)NSString *accountID;
@property(nonatomic,retain)NSString *imageURLString;
@end
