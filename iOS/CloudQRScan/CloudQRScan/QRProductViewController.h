//
//  QRProductViewController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 04/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRProductViewController : UIViewController
@property(nonatomic,retain)NSDictionary *serverResponse;
@property (nonatomic,retain) NSString *qrCodeString;
@property(nonatomic,retain)UIImage *qrCodeImage;
@end
