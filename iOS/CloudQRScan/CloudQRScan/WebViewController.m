//
//  WebViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 21/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property(nonatomic,retain)IBOutlet UIWebView *webView;
@end

@implementation WebViewController

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView.userInteractionEnabled = NO;

    /*
    if ([[_webView subviews] count] > 0) {
        // hide the shadows
        for (UIView* shadowView in [[[_webView subviews] objectAtIndex:0] subviews]) {
            [shadowView setHidden:YES];
        }
        // show the content
        [[[[[_webView subviews] objectAtIndex:0] subviews] lastObject] setHidden:NO];
    }
    _webView.backgroundColor = [UIColor whiteColor];
    */
    
    /*
    for (UIView *shadowView in [_webView.scrollView subviews]) { if ([shadowView isKindOfClass:[UIImageView class]]) { [shadowView setHidden:YES]; } }
    */
    
    
    if (![_urlString beginsWithString:@"http://"] && ![_urlString beginsWithString:@"https://"]) {
        
        _urlString = [NSString stringWithFormat:@"http://%@",_urlString];
    }
    
    
    _urlString = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    [_webView loadRequest:urlRequest];
    _webView.delegate = self;
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"Website";
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:[error localizedDescription]];
    [alert setDestructiveButtonWithTitle:@"Dismiss" block:^{
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert show];

}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activity startAnimating];
    
    UIBarButtonItem *activityBarButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
    
    self.navigationItem.rightBarButtonItem = activityBarButton;

    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    self.navigationItem.rightBarButtonItem = nil;
    
    webView.userInteractionEnabled = YES;
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    
    if (title && [[title trim] length]) {
        self.title = title;
    }
    else{
    
        self.title = @"Website";
    }
    
    webView.frame = self.view.bounds;

   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
