//
//  UIViewController+overView.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 29/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (OverView)
- (void)presentOverViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
- (void)dismissOverViewControllerAnimated:(BOOL)animated;
@end
