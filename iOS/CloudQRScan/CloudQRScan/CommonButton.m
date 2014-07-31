//
//  CommonButton.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 20/04/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "CommonButton.h"

@interface CommonButton ()
@property(nonatomic,retain)AppDelegate *app;
@end

@implementation CommonButton
-(UIBarButtonItem *)backButton{

    UIImage *backButtonImage = [UIImage imageByAppendingDeviceName:@"btn_back"];
    
    CGRect backButtonFrame = CGRectZero;
    backButtonFrame.origin.x += 5;
    backButtonFrame.size = backButtonImage.size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:backButtonFrame];
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return back;
    
}

-(void)backButtonPressed{
    
    // _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // [_app.navigationController popViewControllerAnimated:YES];
    DLog(@"%s",__func__);
    
}


@end
