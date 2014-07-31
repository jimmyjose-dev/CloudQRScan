//
//  CreateQRViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "CreateQRViewController.h"
#import "PhoneContactsViewController.h"
#import "URLQRCodeViewController.h"
#import "TextQRCodeViewController.h"
#import "CustomWebViewController.h"

@interface CreateQRViewController (){

    IBOutlet UIView *whatIsQRCodeView;
    IBOutlet UIImageView *arrowImageView;

}

@end

@implementation CreateQRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [Flurry endTimedEvent:@"Create QRCode View" withParameters:nil];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [Flurry logEvent:@"Create QRCode View" timed:YES];
    
    UIImage *backButtonImage = [UIImage imageByAppendingDeviceName:@"btn_back"];
    
    CGRect backButtonFrame = CGRectZero;
    backButtonFrame.origin.x += 5;
    backButtonFrame.size = backButtonImage.size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:backButtonFrame];
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = back;

}

-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)whatIsQRCodeButtonPressed:(id)sender{

    int maxDown = 392;
    int maxUp = maxDown - 121;
    
    CGRect whatIsQRCodeViewFrame = whatIsQRCodeView.frame;
    int originY = whatIsQRCodeViewFrame.origin.y;
    
    UIImage *image = nil;
    
    if (originY != maxUp) {
        originY = maxUp;
        
        image = [UIImage imageByAppendingDeviceName:@"arrow_top"];
    
    }
    else{
    
        originY = maxDown;
        image = [UIImage imageByAppendingDeviceName:@"arrow_top"];
    }
    
    whatIsQRCodeViewFrame.origin.y = originY;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
   
    whatIsQRCodeView.frame = whatIsQRCodeViewFrame;
    [arrowImageView setImage:image];
   
    
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];
    
}


-(IBAction)createQRProfileButtonPressed:(id)sender{

    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    CustomWebViewController *webVC = [[CustomWebViewController alloc]
                                initByAppendingDeviceNameWithTitle:@"Create QR Profile"];

    webVC.urlString = kCreateQRPRofile_URL;
  
    [self.navigationController pushViewController:webVC animated:YES];
        
    }

}

-(IBAction)createEncryptedQRButtonPressed:(id)sender{
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    CustomWebViewController *webVC = [[CustomWebViewController alloc]
                                initByAppendingDeviceNameWithTitle:@"Create QR Locker"];
    
    webVC.urlString = kCreateQRLocker_URL;
    
    [self.navigationController pushViewController:webVC animated:YES];
        
    }
    
}

-(IBAction)createURIQRButtonPressed:(id)sender{
    
    URLQRCodeViewController *urlQRCodeVC = [[URLQRCodeViewController alloc] initByAppendingDeviceNameWithTitle:@"URL QRCode"];
    
    [self.navigationController pushViewController:urlQRCodeVC animated:YES];
    
}

-(IBAction)createTextQRButtonPressed:(id)sender{
    
    TextQRCodeViewController *textQRCodeVC = [[TextQRCodeViewController alloc] initByAppendingDeviceNameWithTitle:@"Create Text QRCode"];

    [self.navigationController pushViewController:textQRCodeVC animated:YES];
    
}

-(IBAction)createContactsQRButtonPressed:(id)sender{
    
    DLog(@"%s",__func__);
    
    int maxDown = 392;
    
    CGRect whatIsQRCodeViewFrame = whatIsQRCodeView.frame;
    int originY = whatIsQRCodeViewFrame.origin.y;
    
    if (![UIDevice isiPhone5] && ![UIDevice isiPad]) {
    
    if (originY != maxDown) {
        [self whatIsQRCodeButtonPressed:nil];
        return;
    }
    }
        
    PhoneContactsViewController *phoneContactsVC = [[PhoneContactsViewController alloc] initByAppendingDeviceNameWithTitle:@"Contacts"];
    
    
    [self.navigationController pushViewController:phoneContactsVC animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
