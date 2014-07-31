//
//  TextQRCodeViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 21/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "TextQRCodeViewController.h"
#import "GenerateQRCodeViewController.h"

@interface TextQRCodeViewController ()<UITextViewDelegate>
@property(nonatomic,retain)IBOutlet UITextView *textView;
@end

@implementation TextQRCodeViewController

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
    [Flurry endTimedEvent:@"Create QRText" withParameters:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [Flurry logEvent:@"Create QRText" timed:YES];
    
    [_textView becomeFirstResponder];
    
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


-(IBAction)doneButtonPressed:(id)sender{
    
    if (!_textView.text.length) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Please enter some text to proceed"];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
        [alert show];
        return;
    }
    

    
    GenerateQRCodeViewController *generateQRCodeVC = [[GenerateQRCodeViewController alloc] initByAppendingDeviceNameWithTitle:@"Generate QRCode"];

    generateQRCodeVC.qrCodeString = _textView.text;
    generateQRCodeVC.qrCodeType = @"text";
    [self.navigationController pushViewController:generateQRCodeVC animated:YES];
    
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
