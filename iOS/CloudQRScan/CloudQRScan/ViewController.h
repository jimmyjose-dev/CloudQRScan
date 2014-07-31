//
//  ViewController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 15/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
-(id)init;
-(void)performActionWithQRCode:(NSString *)qrCodeScanResult;
-(void)performActionWithSymbol:(id)symbolSet andImage:(UIImage *)image;
@end
