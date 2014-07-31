//
//  ShareController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 03/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareController : UIViewController
-(id)initWithImage:(UIImage *)image;
-(id)initWithDocumentPath:(NSString *)documentPath webView:(UIWebView *)webView andBarButton:(UIBarButtonItem *)printButton;
-(void)shareImageOnFacebook;
-(void)shareImageOnTwitter;
-(void)shareImageWithMail;
-(void)saveImageToGallery;
-(void)printWithAirPrinter;
-(void)shareDocumentOnFacebook;
-(void)shareDocumentOnTwitter;
-(void)shareDocumentWithMail;
-(void)shareTextWithMailTo:(NSString *)to andSubject:(NSString *)subject;
@end
