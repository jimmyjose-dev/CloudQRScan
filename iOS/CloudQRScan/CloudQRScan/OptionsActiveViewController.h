//
//  OptionsActiveViewController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsActiveViewController : UIViewController
@property(nonatomic,retain)NSArray *tableDataArray;
@property(nonatomic,assign)int activeButtonY;
@property(nonatomic,assign)NSString *activeButtonImageName;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,retain)NSString *value;

@end
