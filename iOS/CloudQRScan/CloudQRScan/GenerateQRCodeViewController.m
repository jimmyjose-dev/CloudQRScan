//
//  GenerateQRCodeViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 25/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "GenerateQRCodeViewController.h"
#import "Barcode.h"
#import <QuartzCore/QuartzCore.h>
#import "CFShareCircleView.h"
#import "ShareController.h"


@interface GenerateQRCodeViewController ()<CFShareCircleViewDelegate>{

    BOOL toggleAnimation;

}
@property(nonatomic,retain) IBOutlet UIImageView *qrCodeBrandingImageView;
@property(nonatomic,retain) IBOutlet UIView *qrCodeBrandingView;
@property(nonatomic,retain) IBOutlet UIImageView *qrCodeImageView;
@property (nonatomic, retain) CFShareCircleView *shareCircleView;
@property (nonatomic, retain) ShareController *shareController;

@end

@implementation GenerateQRCodeViewController

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
    [Flurry endTimedEvent:@"Generate QRCode" withParameters:nil];
    
}


- (void) viewWillAppear:(BOOL)animated
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 30)];
    [button setImage:[UIImage imageByAppendingDeviceName:@"btn_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = back;
    
    UIBarButtonItem *option = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed:)];
       
    toggleAnimation = NO;
    
    [option setTintColor:[UIColor blackColor]];
    
    self.navigationItem.rightBarButtonItem = option;
    
    [super viewWillAppear:animated];
    
    [Flurry logEvent:@"Generate QRCode" timed:YES];
    
}


-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGRect frame = self.view.frame;
    //frame.origin.y = 20;
    _shareCircleView = [[CFShareCircleView alloc] initWithFrame:frame];
    _shareCircleView.delegate = self;
    [self.view addSubview:_shareCircleView];
    
	// Do any additional setup after loading the view.
    Barcode *barcode = [[Barcode alloc] init];
    //NSLog(@"_qrCodeString %@",_qrCodeString);
    [barcode setupQRCode:_qrCodeString];
    
    NSString *deviceName = @"_iPhone";
    
    if ([UIDevice isiPad]) deviceName = @"_iPad";
    else if ([UIDevice isiPhone5]) deviceName = @"_iPhone5";
    
    NSString *imageName = [NSString stringWithFormat:@"CloudQRScan_branding_%@%@",_qrCodeType,deviceName];
    
    UIImage *brandingImage = [UIImage imageNamed:imageName];
    
    [_qrCodeBrandingImageView setImage:brandingImage];
    
    /*
     CGRect imageViewFrame = CGRectMake(0, 72, 320, 320);
     imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
     [imageView setImage:barcode.qRBarcode];
     [imageView setBackgroundColor:[UIColor clearColor]];
     */
    [_qrCodeImageView setImage:barcode.qRBarcode];
    
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_qrCodeImageView setBackgroundColor:[UIColor clearColor]];
    
    
    
    //[brandingImageView addSubview:imageView];
    
    [self drawRect:_qrCodeBrandingView.frame];
    
    
    /*
     UIGraphicsBeginImageContext(brandingImageView.frame.size);
     [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
     self.QRCodeImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     */
    
    // Do any additional setup after loading the view from its nib.
}


-(void)drawRect:(CGRect)rect {
    
    UIGraphicsBeginImageContext(_qrCodeBrandingView.frame.size);
    [_qrCodeBrandingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _shareController = [[ShareController alloc] initWithImage:image];
}

- (void)shareCircleView:(CFShareCircleView *)aShareCircleView didSelectSharer:(CFSharer *)sharer {
    DLog(@"Selected sharer: %@", sharer.name);
    
    if ([sharer.name isEqualToString:@"Facebook"]) {
        [self facebookButtonPressed];
    }else if ([sharer.name isEqualToString:@"Twitter"]) {
        [self twitterButtonPressed];
    }else if([sharer.name isEqualToString:@"Dropbox"]) {
        [self dropboxButtonPressed];
    }else if([sharer.name isEqualToString:@"Photos"]) {
        [self photoButtonPressed];
    }else if([sharer.name isEqualToString:@"Mail"]) {
        [self mailButtonPressed];
    }
    
}

- (void)shareCircleCanceled: (NSNotification*)notification{
    DLog(@"Share circle view was canceled.");
}



-(IBAction)shareButtonPressed:(id)sender{
    
    toggleAnimation = !toggleAnimation;
    if (toggleAnimation) [_shareCircleView animateIn];
    else [_shareCircleView animateOut];
   
}


-(IBAction)facebookButtonPressed{
    
    
    [_shareController shareImageOnFacebook];
    
}

- (IBAction)twitterButtonPressed{
    
    [_shareController shareImageOnTwitter];
}

-(void)dropboxButtonPressed{
    
}

-(void)photoButtonPressed{
    
    [_shareController saveImageToGallery];
    
}


-(void)mailButtonPressed{
    
    
    [_shareController shareImageWithMail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
