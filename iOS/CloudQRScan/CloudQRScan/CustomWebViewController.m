//
//  CustomWebViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/01/14.
//  Copyright (c) 2014 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "CustomWebViewController.h"
#import "UIWebViewAdditions.h"
#import "ShareController.h"
#import "ViewController.h"

@interface CustomWebViewController ()<UIActionSheetDelegate,UIWebViewDelegate>
@property(nonatomic,retain)IBOutlet UIWebView *webView;
@property(nonatomic,retain)IBOutlet UIToolbar *toolBar;
@property(nonatomic,retain)IBOutlet UIBarButtonItem *backButton;
@property(nonatomic,retain)IBOutlet UIBarButtonItem *refreshButton;
@property(nonatomic,retain)IBOutlet UIBarButtonItem *stopButton;
@property(nonatomic,retain)IBOutlet UIBarButtonItem *forwardButton;
@property(nonatomic,retain)NSString *selectedLinkURL;
@property(nonatomic,retain)NSString *selectedImageURL;
@property(nonatomic,retain)ViewController *viewController;
@end

@implementation CustomWebViewController
@synthesize selectedLinkURL,selectedImageURL;

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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    
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

- (void)updateBarButtons
{
    _backButton.enabled = _webView.canGoBack;
    _refreshButton.enabled = !_webView.isLoading;
    _stopButton.enabled =  _webView.isLoading;
    _forwardButton.enabled = _webView.canGoForward;
}


-(IBAction)backBarButtonPressed:(id)sender{
    
    [_webView goBack];
}


-(IBAction)refreshBarButtonPressed:(id)sender{
    
    [_webView reload];

}

-(IBAction)stopBarButtonPressed:(id)sender{
    
    [_webView stopLoading];
    
}

-(IBAction)forwardBarButtonPressed:(id)sender{
    
        [_webView goForward];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView.userInteractionEnabled = NO;
    
    
    
    if (![_urlString beginsWithString:@"http://"] && ![_urlString beginsWithString:@"https://"]) {
        
        _urlString = [NSString stringWithFormat:@"http://%@",_urlString];
    }
    
    
    _urlString = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:urlRequest];
    _webView.delegate = self;
    
    
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSelection:) name:@"TapAndHoldShortNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];
    
}



- (void)stopSelection:(NSNotification*)notification{
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}

- (void)contextualMenuAction:(NSNotification*)notification
{
    CGPoint pt;
    NSDictionary *coord = [notification object];
    pt.x = [[coord objectForKey:@"x"] floatValue];
    pt.y = [[coord objectForKey:@"y"] floatValue];
    
    // convert point from window to view coordinate system
    pt = [_webView convertPoint:pt fromView:nil];
    
    // convert point from view to HTML coordinate system
    CGPoint offset  = [_webView scrollOffset];
    CGSize viewSize = [_webView frame].size;
    CGSize windowSize = [_webView windowSize];
    
    CGFloat f = windowSize.width / viewSize.width;
    pt.x = pt.x * f + offset.x;
    pt.y = pt.y * f + offset.y;
    
    [self openContextualMenuAt:pt];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self updateBarButtons];

    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"Website";
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:[error localizedDescription]];
    [alert setDestructiveButtonWithTitle:@"Dismiss" block:^{
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    //[alert show];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self updateBarButtons];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activity startAnimating];
    
    UIBarButtonItem *activityBarButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
    
    self.navigationItem.rightBarButtonItem = activityBarButton;
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    webView.userInteractionEnabled = YES;
    [self updateBarButtons];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    
    if (title && [[title trim] length]) {
        self.title = title;
    }
    else{
        
        self.title = @"Website";
    }
    
    //webView.frame = self.view.bounds;
    //NSLog(@"%@",[_webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]);
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open"]){
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:selectedLinkURL]]];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Copy"]){
        [[UIPasteboard generalPasteboard] setString:selectedLinkURL];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Copy Image"]){
        [[UIPasteboard generalPasteboard] setString:selectedImageURL];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save Image"]){
      /*  NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveImageURL:) object:selectedImageURL];
        [queue addOperation:operation];
        */
        [self saveImageURL:selectedImageURL];
        
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open with CloudQRScan"]){
        
        [self openLinkInCQRS:selectedImageURL];
        
    }
    
}

- (void)openContextualMenuAt:(CGPoint)pt{
    // Load the JavaScript code from the Resources and inject it into the web page
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
   // NSLog(@"file %d",[[NSFileManager defaultManager] fileExistsAtPath:path]);
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_webView stringByEvaluatingJavaScriptFromString:jsCode];
    
    // get the Tags at the touch location
    
    
    NSString *tags = [_webView stringByEvaluatingJavaScriptFromString:
                      [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
    
    NSString *tagsHREF = [_webView stringByEvaluatingJavaScriptFromString:
                          [NSString stringWithFormat:@"MyAppGetLinkHREFAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
    
    NSString *tagsSRC = [_webView stringByEvaluatingJavaScriptFromString:
                         [NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
    
    NSString *tags1 = [_webView stringByEvaluatingJavaScriptFromString:
                      [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint1(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
    
    
    NSLog(@"tags %@, tagsHREF %@, tagsSRC %@ ",tags,tagsHREF,tagsSRC);
    NSLog(@"tags1 %@ ",tags1);
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    selectedLinkURL = @"";
    selectedImageURL = @"";
    
    // If an image was touched, add image-related buttons.
    if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
        selectedImageURL = tagsSRC;
        
        if (sheet.title == nil) {
            sheet.title = tagsSRC;
        }
        
        [sheet addButtonWithTitle:@"Open with CloudQRScan"];
        [sheet addButtonWithTitle:@"Save Image"];
        [sheet addButtonWithTitle:@"Copy Image"];
    }
    // If a link is pressed add image buttons.
    /*
    if ([tags rangeOfString:@",A,"].location != NSNotFound){
        selectedLinkURL = tagsHREF;
        
        sheet.title = tagsHREF;
        [sheet addButtonWithTitle:@"Open"];
        [sheet addButtonWithTitle:@"Copy"];
    }
    */
    if (sheet.numberOfButtons > 0) {
        [sheet addButtonWithTitle:@"Cancel"];
        sheet.cancelButtonIndex = (sheet.numberOfButtons-1);
        [sheet showInView:_webView];
    }
}

-(void)saveImageURL:(NSString*)url{

    [self performSelectorOnMainThread:@selector(showStartSaveAlert) withObject:nil waitUntilDone:YES];
    //UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]], nil, nil, nil);
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    ShareController *share = [[ShareController alloc] initWithImage:image];
    [share saveImageToGallery];
   [self performSelectorOnMainThread:@selector(showFinishedSaveAlert) withObject:nil waitUntilDone:YES];
    
   // MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
   // hud.detailsLabelText = @"Saving image to gallery...";
    
    //[hud showWhileExecuting:@selector(saveImageToGalleryFromURL:) onTarget:self withObject:url animated:YES];
    
    
    
}

-(void)openLinkInCQRS:(NSString*)url{
    
    [self performSelectorOnMainThread:@selector(showStartSaveAlertWithDectionMsg) withObject:nil waitUntilDone:YES];
    //UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]], nil, nil, nil);
    
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    [self performSelectorOnMainThread:@selector(showFinishedSaveAlert) withObject:nil waitUntilDone:YES];
        
        ZBarReaderController *read = [ZBarReaderController new];
        
        id<NSFastEnumeration> results = [read scanImage:image.CGImage];
        BOOL isQRCode = NO;
        for(ZBarSymbol *sym in results) {
            
            
            if ([sym.typeName isEqualToString:@"QR-Code"]) {
                
                isQRCode = YES;
                break;
                
            }
            
        }
        if (isQRCode) {
            
            self.viewController = [[ViewController alloc] init];
            [self.viewController performActionWithSymbol:results andImage:nil];
            //to pass image and enable share button uncomment line below
            //[self.viewController performActionWithSymbol:results andImage:image];
        }
        else{
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"No QRCode in image" message:@"\n\n\n\n\n\n\n\n\n\n"];
            UIView *vw = [alert view];
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
            imgView.height = 220;
            imgView.width = 220;
            imgView.y = 58;
            imgView.x = 28;
            
            
            [vw addSubview:imgView];
            
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            [alert show];
        }
        
        
    
}

-(void)saveImageToGalleryFromURL:(NSString *)url{

    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    ShareController *share = [[ShareController alloc] initWithImage:image];
    [share saveImageToGallery];

}


-(void)showStartSaveAlert{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText = @"Saving QRCode....";
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Saving QRCode....";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Saving QRCode....";
    
    [MBProgressHUD showHUDAddedTo:_webView animated:YES].detailsLabelText = @"Saving QRCode....";
}

-(void)showStartSaveAlertWithDectionMsg{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText = @"Detecting QRCode...";
}

-(void)showFinishedSaveAlert{
    // Set custom view mode
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    [MBProgressHUD hideAllHUDsForView:vw animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end