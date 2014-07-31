//
//  URLQRCodeViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 21/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "URLQRCodeViewController.h"
#import "GenerateQRCodeViewController.h"

@interface URLQRCodeViewController ()<UITextFieldDelegate>
@property(nonatomic,retain)IBOutlet UITextField *textField;
@end

@implementation URLQRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [_textField becomeFirstResponder];
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"Create QRURL" withParameters:nil];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [Flurry logEvent:@"Create QRURL" timed:YES];
    
    [_textField becomeFirstResponder];
    
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

-(BOOL)isValidUrl{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_textField.text trim]]];
    return [NSURLConnection canHandleRequest:request];
    
}


-(IBAction)doneButtonPressed:(id)sender{

    if (![self isValidUrl]) {

        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Please enter a valid URL"];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
        [alert show];

        return;
    }

    
    GenerateQRCodeViewController *generateQRCodeVC = [[GenerateQRCodeViewController alloc] initByAppendingDeviceNameWithTitle:@"Generate QRCode"];

    generateQRCodeVC.qrCodeString = _textField.text;
    generateQRCodeVC.qrCodeType = @"url";
    [self.navigationController pushViewController:generateQRCodeVC animated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textField.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
