//
//  DocumentViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 01/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "DocumentViewController.h"
#import "CFShareCircleView.h"
#import "ShareController.h"


@interface DocumentViewController ()<UIWebViewDelegate,CFShareCircleViewDelegate>{

    BOOL toggleAnimation;
}
@property(nonatomic,retain)IBOutlet UIWebView *webView;
@property(nonatomic,retain)IBOutlet UIView *optionsView;
@property (nonatomic, retain) CFShareCircleView *shareCircleView;
@property (nonatomic, retain) ShareController *shareController;

@end

@implementation DocumentViewController

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
    toggleAnimation = NO;
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
    
    [self setRightBarButtonWithStateActive:NO];
        
    
}

-(void)setRightBarButtonWithStateActive:(BOOL)state{

    self.navigationItem.rightBarButtonItem = nil;
    
    UIImage *moreButtonImage = [UIImage imageByAppendingDeviceName:@"btn_options"];

    if (state) moreButtonImage = [UIImage imageByAppendingDeviceName:@"btn_options_active"];
    
    CGRect moreButtonFrame = CGRectZero;
    //userButtonFrame.origin.x += 5;
    moreButtonFrame.size = moreButtonImage.size;
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:moreButtonFrame];
    [moreButton setImage:moreButtonImage forState:UIControlStateNormal];
    
    [moreButton addTarget:self action:@selector(showShareOption) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = moreBarButton;
    
    [_optionsView setHidden:!state];

}

-(void)showShareOption{

    toggleAnimation = !toggleAnimation;
    if (toggleAnimation) [_shareCircleView animateIn];
    else [_shareCircleView animateOut];

}

-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)moreButtonPressed{
    
    [self setRightBarButtonWithStateActive:YES];
    
}


-(void)setRightBarButtonWithActivityIndicator{

    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activity startAnimating];
    
    UIBarButtonItem *activityBarButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
    
    self.navigationItem.rightBarButtonItem = activityBarButton;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_webView setDelegate:self];
    
    NSURL *url = [[NSURL alloc] initWithString:_documentURLString];
    
//    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:kTimeoutInterval];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setTimeoutInterval:kTimeoutInterval];
    
    [_webView loadRequest:urlRequest];
    
    
    CGRect frame = self.view.frame;
    //frame.origin.y = 20;
    _shareCircleView = [[CFShareCircleView alloc] initWithFrame:frame forDocument:YES];
    _shareCircleView.delegate = self;
    [self.view addSubview:_shareCircleView];
    

    _shareController = [[ShareController alloc] initWithDocumentPath:_documentURLString webView:_webView andBarButton:[UIBarButtonItem new]];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self setRightBarButtonWithActivityIndicator];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    [self setRightBarButtonWithStateActive:NO];
    
    webView.frame = self.view.bounds;
    
//    CGSize contentSize = webView.scrollView.contentSize;
//    CGSize viewSize = self.view.bounds.size;
//    
//    float rw = viewSize.width / contentSize.width;
//    
//    webView.scrollView.minimumZoomScale = rw;
//    webView.scrollView.maximumZoomScale = rw;
//    webView.scrollView.zoomScale = rw;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    DLog(@"error %@",[error localizedDescription]);
    [self setRightBarButtonWithStateActive:NO];
    
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:[error localizedDescription]];
    [alert setDestructiveButtonWithTitle:@"Dismiss" block:^{
    
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert show];
}

- (void)shareCircleView:(CFShareCircleView *)aShareCircleView didSelectSharer:(CFSharer *)sharer {
    DLog(@"Selected sharer: %@", sharer.name);
    
    
    
    if ([sharer.name isEqualToString:@"Facebook"]) {
        [_shareController shareDocumentOnFacebook];
    }else if ([sharer.name isEqualToString:@"Twitter"]) {
        [_shareController shareDocumentOnTwitter];
    }else if([sharer.name isEqualToString:@"Print"]) {
        [_shareController printWithAirPrinter];
    }else if([sharer.name isEqualToString:@"Mail"]) {
        [_shareController shareDocumentWithMail];
    }
    
}

- (void)shareCircleCanceled: (NSNotification*)notification{
    DLog(@"Share circle view was canceled.");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
