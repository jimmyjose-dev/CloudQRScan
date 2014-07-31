//
//  QRProductViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 04/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "QRProductViewController.h"
#import "CFShareCircleView.h"
#import "ShareController.h"
#import "SelectionViewController.h"
#import "HistoryManager.h"


@interface QRProductViewController ()<EGOImageViewDelegate,CFShareCircleViewDelegate>{
    
    NSString *productID;
    NSString *productName;
    NSString *websiteLink;
    NSString *buyNowLink;
    NSString *phoneNumer;
    NSString *emailID;
    NSArray *documentLink;
    NSArray  *videoLink;
    
    
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *currencyLabel;
    IBOutlet UILabel *likesLabel;
    IBOutlet UILabel *productTitleLabel;
    IBOutlet UITextView *productDetailTextView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *likeImageView;
    
    IBOutlet UIButton *videoButton;
    IBOutlet UIButton *documentButton;
    IBOutlet UIButton *weblinkButton;
    IBOutlet UIButton *buyNowButton;
    IBOutlet UIButton *callButton;
    IBOutlet UIButton *emailButton;
    
}

@property(nonatomic,retain)CFShareCircleView *shareCircleView;
@property(nonatomic,retain)ShareController *shareController;

@end

@implementation QRProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DLog(@"_serverResponse \n%@",_serverResponse);
    [self updateGUIWithDictionary:_serverResponse];
    CGRect frame = self.view.frame;
    //frame.origin.y = 20;
    _shareCircleView = [[CFShareCircleView alloc] initWithFrame:frame];
    _shareCircleView.delegate = self;
    [self.view addSubview:_shareCircleView];
    
    _shareController = [[ShareController alloc] initWithImage:_qrCodeImage];
    
    
    UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_share"];
    if (!_qrCodeImage || [_qrCodeImage isEqual:[NSNull null]]) {
        image = [UIImage imageByAppendingDeviceName:@"btn_back"];
        
        
    }
    
    [likesLabel setBackgroundColor:[UIColor clearColor]];
    
    
}


- (void)shareCircleView:(CFShareCircleView *)aShareCircleView didSelectSharer:(CFSharer *)sharer {
    DLog(@"Selected sharer: %@", sharer.name);
    
    
    
    if ([sharer.name isEqualToString:@"Facebook"]) {
        [_shareController shareImageOnFacebook];
    }else if ([sharer.name isEqualToString:@"Twitter"]) {
        [_shareController shareImageOnTwitter];
    }else if([sharer.name isEqualToString:@"Dropbox"]) {
        
    }else if([sharer.name isEqualToString:@"Photos"]) {
        [_shareController saveImageToGallery];
    }else if([sharer.name isEqualToString:@"Mail"]) {
        [_shareController shareImageWithMail];
    }
    
}

- (void)shareCircleCanceled: (NSNotification*)notification{
    DLog(@"Share circle view was canceled.");
}

-(void)updateGUIWithDictionary:(NSDictionary *)serverResponse{
    
    NSDictionary *productDict = serverResponse;
    
    //NSLog(@"serverResponse %@",serverResponse);
    
    [likesLabel setText:[NSString stringWithFormat:@"%@ Like(s)",[productDict valueForKey:@"Likes"]]];
    DLog(@"price %@",[productDict valueForKey:@"Price"]);
    
    NSArray *priceValue = [[productDict valueForKey:@"Price"] componentsSeparatedByString:@" "];
    NSString *currency = @"";
    NSString *price = @"No Price";
    if (priceValue && [priceValue count]>1) {
        
        currency = [[priceValue objectAtIndex:0] trim];
        price = [[priceValue objectAtIndex:1] trim];
    }
    
    if (!price.length) {
        currency = @"";
        price = @"No Price";
        UIFont *font = [UIFont systemFontOfSize:13];
        [priceLabel setFont:font];
        priceLabel.x -= 10;
    }
    
    [currencyLabel setText:currency];
    [priceLabel setText:price];
    [productTitleLabel setText:[productDict valueForKey:@"ProductName"]];
    [productDetailTextView setText:[productDict valueForKey:@"ProductDesc"]];
    
    productID = [productDict valueForKey:@"ProductId"];
    websiteLink = [productDict valueForKey:@"Website"];
    documentLink = [productDict valueForKey:@"Documents"];
    productName = [productDict valueForKey:@"ProductName"];
    buyNowLink = [productDict valueForKey:@"BuyNow"];
    phoneNumer = [productDict valueForKey:@"Phone"];
    emailID= [productDict valueForKey:@"Email"];
    self.title = productName;
    videoLink = [NSArray arrayWithArray:[productDict valueForKey:@"EmbededVideos"]];
    
    if (!websiteLink || ![websiteLink length]) {
        [weblinkButton setEnabled:NO];
    }
    
    if (!documentLink || ![documentLink count]) {
        [documentButton setEnabled:NO];
    }
    
    if (!videoLink || ![videoLink count]) {
        [videoButton setEnabled:NO];
    }
    
    if (!buyNowLink || ![buyNowLink length]) {
        [buyNowButton setEnabled:NO];
    }
    
    if (!phoneNumer || ![phoneNumer length]) {
        [callButton setEnabled:NO];
    }
    
    if (!emailID || ![emailID length]) {
        [emailButton setEnabled:NO];
    }
    
    
    [[HistoryManager new] saveProductLink:_qrCodeString forProduct:productName fromLocation:nil onDate:nil];
    
    NSArray *productImageArray = [productDict valueForKey:@"Images"];
    DLog(@"prodarray %@",productImageArray);
    int size = [productImageArray count];
    CGFloat contentOffset = 0.0f;
    if (size) {
        
        for (int i =0; i<size; ++i) {
            
            EGOImageView* imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageByAppendingDeviceName:@"image_loading_product"]];
            imageView.frame = CGRectMake(contentOffset, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
            imageView.delegate = self;
            
            //show the placeholder image instantly
            [scrollView addSubview:imageView];
            
            NSString *imageURlStr= [[productImageArray objectAtIndex:i] valueForKey:@"FullPath"];
            DLog(@"imageURlStr %@",imageURlStr);
            
            //load the image from url asynchronously with caching automagically
            imageView.imageURL = [NSURL URLWithString:imageURlStr];
            
            //imageView.contentMode = UIViewContentModeCenter;
            
            contentOffset += imageView.frame.size.width;
            scrollView.contentSize = CGSizeMake(contentOffset, scrollView.frame.size.height);
            
        }
        
    }
    else{
        
        EGOImageView* imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageByAppendingDeviceName:@"image_loading_product"]];
        imageView.frame = CGRectMake(contentOffset, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
        imageView.delegate = self;
        
        //show the placeholder image instantly
        [scrollView addSubview:imageView];
        
        imageView.image = [UIImage imageByAppendingDeviceName:@"image_not_available_product"];
        
        //imageView.contentMode = UIViewContentModeCenter;
        
        //contentOffset += imageView.frame.size.width;
        //scrollView.contentSize = CGSizeMake(contentOffset, scrollView.frame.size.height);
    
    }
    
    [scrollView bringSubviewToFront:documentButton];
    [scrollView bringSubviewToFront:weblinkButton];
    
}

-(void)imageViewFailedToLoadImage:(EGOImageView *)imageView error:(NSError *)error{

    [imageView setImage:[UIImage imageByAppendingDeviceName:@"image_not_available_product"]];

}

-(IBAction)likesButtonPressed:(id)sender{

    NSString *deviceUDID = [UIDevice UDID];
    
    NSString *serverURL = PRODUCT_LIKE_URL(productID,deviceUDID);
    NSString *service = kServiceQRProduct;
    
    DLog(@"server url %@",serverURL);
    
    __block UIImage *likeImage = [UIImage imageByAppendingDeviceName:@"btn_like_inactive"];
    
    ServerController *server = [[ServerController alloc] initWithServerURL:serverURL forServiceType:service];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Posting Like";
    [MBProgressHUD HUDForView:self.navigationController.view].labelText = productName;
    
    [server connectUsingGetMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        if (errorString){
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:errorString];
            [alert setDestructiveButtonWithTitle:@"Please try again" block:nil];
            [alert show];
            
        }else{
            
            DLog(@"resposne %@",serverResponse);
            BlockAlertView *alert = nil;
            NSString *msg = nil;
            if ([[(NSDictionary *)serverResponse valueForKey:@"UpdateProductLikesResult"] isEqualToString:@"SUCCESS"]) {
                
                msg = @"Posted Successfully";
                alert = [BlockAlertView alertWithTitle:nil message:msg];
                [alert setOKButtonWithBlock:nil];
                likesLabel.text = [NSString stringWithFormat:@"%d Like(s)",[likesLabel.text integerValue]+1];
                likeImage = [UIImage imageByAppendingDeviceName:@"btn_like_active"];
                
            }
            else if ([[(NSDictionary *)serverResponse valueForKey:@"UpdateProductLikesResult"] isEqualToString:@"EXISTS"]) {
                
                msg = @"You have already posted";
                alert = [BlockAlertView alertWithTitle:nil message:msg];
                [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
                likeImage = [UIImage imageByAppendingDeviceName:@"btn_like_active"];
            }
            else{
            
                //error
                msg = @"Please try again!!!";
                alert = [BlockAlertView alertWithTitle:nil message:msg];
                [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
            }
            
//            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
  //          [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
            [alert show];
            [likeImageView setImage:likeImage];
            
        }
        
        
    }];

    

}


-(IBAction)videoButtonPressed:(id)sender{

    
    SelectionViewController *selectionVC = [[SelectionViewController alloc] initByAppendingDeviceNameWithTitle:@"YouTube"];
    selectionVC.type = @"Youtube";
    selectionVC.aSelector = @"showSelectedVideoFromObject:";
    selectionVC.tableDataArray = videoLink;
    
    
    [self.navigationController pushViewController:selectionVC animated:YES];
}

-(IBAction)documentButtonPressed:(id)sender{

    SelectionViewController *selectionVC = [[SelectionViewController alloc] initByAppendingDeviceNameWithTitle:@"Documents"];
    
    selectionVC.type = @"Documents";
    selectionVC.aSelector = @"showSelectedDocumentFromObject:";
    selectionVC.tableDataArray = documentLink;
    
    
    [self.navigationController pushViewController:selectionVC animated:YES];


}

-(IBAction)weblinkButtonPressed:(id)sender{

    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:@"Website"];
    webVC.urlString = websiteLink;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    }

}

-(IBAction)buyNowButtonPressed:(id)sender{
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{
        
        WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:@"Website"];
        webVC.urlString = buyNowLink;
        
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    
}

-(IBAction)callButtonPressed:(id)sender{

    UIWebView *phoneCallWebview = [[UIWebView alloc] init];
    NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumer]];
    [phoneCallWebview loadRequest:[NSURLRequest requestWithURL:callURL]];
    
    //[flurryQRProfileUserInfo setValue:@"YES" forKey:@"call"];
    
    //[Flurry logEvent:@"QRProfile Call" withParameters:flurryQRProfileUserInfo timed:YES];
    
    [self.view addSubview:phoneCallWebview];

    
}

-(IBAction)emailButtonPressed:(id)sender{

    _shareController = [[ShareController alloc] init];
    
    [_shareController shareTextWithMailTo:emailID andSubject:productName];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
