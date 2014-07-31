//
//  QRProfileViewController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRProfileViewController : UIViewController
//- (id)initWithNibName:(NSString *)nibNameOrNil withQRCode:(NSString *)qrCodeResult bundle:(NSBundle *)nibBundleOrNil andQRCodeImage:(UIImage *)qrCodeImage;
@property (nonatomic,retain) NSDictionary *serverResponse;
@property (nonatomic,retain) UIImage *qrCodeImage;
@property (nonatomic,retain) NSString *qrCodeString;
@property (nonatomic,retain) NSString *profileID;
@end
