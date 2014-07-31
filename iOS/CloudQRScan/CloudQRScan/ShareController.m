//
//  ShareController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 03/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ShareController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MessageUI/MessageUI.h>
#import "PrintPageRenderer.h"
#import "PrintPageConstants.h"


typedef void(^SaveImageCompletion)(NSError* error);

@interface ShareController ()<MFMailComposeViewControllerDelegate>
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) MFMailComposeViewController *mailComposeVC;
@property (nonatomic,retain) AppDelegate *app;
@property (nonatomic,retain) UIBarButtonItem *printButton;
@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) NSString *filePath;
@end

@implementation ShareController

-(id)init{
    
    self = [super init];
    
    return self;
}

-(id)initWithImage:(UIImage *)image{
    
    self = [self init];
    _image = image;
    
    return self;
}

-(id)initWithDocumentPath:(NSString *)documentPath webView:(UIWebView *)webView andBarButton:(UIBarButtonItem *)printButton{
    
    self = [self init];
    _webView = webView;
    _filePath = documentPath;
    _printButton = printButton;
    
    return self;
}


-(void)shareImageOnFacebook{
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    UIImage *facebookImage = [UIImage imageByAppendingDeviceName:@"btn_Facebook"];
    [MMProgressHUD showProgressWithStyle:MMProgressHUDProgressStyleIndeterminate title:nil status:@"Posting on Facebook" image:facebookImage];
    
    
    if (FBSession.activeSession.isOpen) {
    
        [self shareButtonPressed];
        
    
    } else {
    
        [self openSessionWithAllowLoginUI:YES];
    }
    }
    
}

-(void)shareButtonPressed{
    
    NSString *graphPath = @"me/photos";
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:kShareMessageFacebook,  @"message", nil];
    
    NSString*httpMethod = @"POST";
    
    [params setObject:_image forKey:@"source"];
    
    
    [FBRequestConnection startWithGraphPath:graphPath parameters:params HTTPMethod:httpMethod completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSString *msg = nil;
        if (!error) {
            DLog(@"%@",result);
            msg = [result valueForKey:@"post_id"];
        }
        else{
            msg = [error localizedDescription];
            DLog(@"error %@",[error localizedDescription]);
        }
       
        /*
        if (msg)
            [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
         */
        
        [MMProgressHUD dismiss];
        
    }];
    
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (_image) {
            [self shareButtonPressed];
            }else{
            
                [self shareDocument];
            }
            
                        
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
         //   [[[UIAlertView alloc] initWithTitle:nil message:@"FBSessionStateClosedLoginFailed" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            //[self showLoginView];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        /*
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
         */
        
        [MMProgressHUD dismiss];
    }
}

- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Login failed"];
    [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
    [alert show];
    
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    /*
     NSArray *permissions = [[NSArray alloc] initWithObjects:
     @"email",
     @"user_likes",
     @"publish_actions",
     nil];
     */
    
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"publish_actions",
                            nil];
    
  
    return [FBSession openActiveSessionWithPublishPermissions:permissions
                                              defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:allowLoginUI completionHandler:^(FBSession *session,
                                                                                                                                             FBSessionState state,
                                                                                                                                             NSError *error) {
                                                  [self sessionStateChanged:session
                                                                      state:state
                                                                      error:error];
                                              }];
    
    
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(void)shareImageOnTwitter{
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:kShareMessageTwitter];
        [tweetSheet addImage:_image];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	    [app.navigationController presentModalViewController:tweetSheet animated:YES];
        
    }
    else
    {
       BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
    }
    }
    
}

-(void)saveImageToGallery{
    
    [self saveImage:_image toAlbum:@"CloudQRScan" withCompletionBlock:^(NSError *error) {
        if (error) {
            DLog(@"error %@",[error localizedDescription]);
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:[error localizedDescription]];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
            [alert show];
        }else{
        
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"QRCode saved to gallery successfully."];
            [alert setOKButtonWithBlock:nil];
            [alert show];
        
        }
    }];
    
}

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    //write the image data to the assets library (camera roll)
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
                          completionBlock:^(NSURL* assetURL, NSError* error) {
                              
                              //error handling
                              if (error!=nil) {
                                  completionBlock(error);
                                  return;
                              }
                              
                              //add the asset to the custom photo album
                              [self addAssetURL: assetURL
                                        toAlbum:albumName
                            withCompletionBlock:completionBlock andLibrary:library];
                              
                          }];
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock andLibrary:(ALAssetsLibrary *)library
{
    __block BOOL albumWasFound = NO;
    
    //search all photo albums in the library
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               
                               //compare the names of the albums
                               if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                   
                                   //target album is found
                                   albumWasFound = YES;
                                   
                                   //get a hold of the photo's asset instance
                                   [library assetForURL: assetURL
                                            resultBlock:^(ALAsset *asset) {
                                                
                                                //add photo to the target album
                                                [group addAsset: asset];
                                                
                                                //run the completion block
                                                completionBlock(nil);
                                                
                                            } failureBlock: completionBlock];
                                   
                                   //album was found, bail out of the method
                                   return;
                               }
                               
                               if (group==nil && albumWasFound==NO) {
                                   //photo albums are over, target album does not exist, thus create it
                                   
                                   __weak ALAssetsLibrary* weakSelf = library;
                                   
                                   //create new assets album
                                   [library addAssetsGroupAlbumWithName:albumName
                                                            resultBlock:^(ALAssetsGroup *group) {
                                                                
                                                                //get the photo's instance
                                                                [weakSelf assetForURL: assetURL
                                                                          resultBlock:^(ALAsset *asset) {
                                                                              
                                                                              //add photo to the newly created album
                                                                              [group addAsset: asset];
                                                                              
                                                                              //call the completion block
                                                                              completionBlock(nil);
                                                                              
                                                                          } failureBlock: completionBlock];
                                                                
                                                            } failureBlock: completionBlock];
                                   
                                   //should be the last iteration anyway, but just in case
                                   return;
                               }
                               
                           } failureBlock: completionBlock];
    
}


-(void)shareImageWithMail{

    _mailComposeVC = [MFMailComposeViewController new];
    
    if ([MFMailComposeViewController canSendMail]) {
       /*
        NSLog(@"ori %d",_image.imageOrientation);
        if (_image.imageOrientation == UIImageOrientationRight) {
            NSLog(@"right");
        }
        */
        /*
        NSData *data = UIImagePNGRepresentation(_image);
        UIImage *tmp = [UIImage imageWithData:data];
        UIImage *fixedImage = [UIImage imageWithCGImage:tmp.CGImage
                                             scale:_image.scale
                                       orientation:UIImageOrientationRightMirrored];
        */
        
        UIImage *img = [self scaleAndRotateImage:_image];
        
        [_mailComposeVC addAttachmentData:UIImagePNGRepresentation(img) mimeType:@"image/png" fileName:@"CQRS_QRCode.png"];
        
        
        _mailComposeVC.mailComposeDelegate = self;
        
        
        NSString *emailBody = kShareMessage;
        NSString *emailSubject = kShareMessageSubject;
        
       
            
        [_mailComposeVC setSubject:emailSubject];
        
        [_mailComposeVC setMessageBody:emailBody isHTML:YES]; // depends. Mostly YES, unless you want to send
        

        
       
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[app.navigationController topViewController] presentViewController:_mailComposeVC animated:YES completion:NULL];
        
    }
    else{
    
        [[[UIAlertView alloc] initWithTitle:nil message:@"Email not configured in this device" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
    }
    
}




- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    
    int width = image.size.width;
    int height = image.size.height;
    CGSize size = CGSizeMake(width, height);
    
    CGRect imageRect;
    
    if(image.imageOrientation==UIImageOrientationUp
       || image.imageOrientation==UIImageOrientationDown)
    {
        imageRect = CGRectMake(0, 0, width, height);
    }
    else
    {
        imageRect = CGRectMake(0, 0, height, width);
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if(image.imageOrientation==UIImageOrientationLeft)
    {
        CGContextRotateCTM(context, M_PI / 2);
        CGContextTranslateCTM(context, 0, -width);
    }
    else if(image.imageOrientation==UIImageOrientationRight)
    {
        CGContextRotateCTM(context, - M_PI / 2);
        CGContextTranslateCTM(context, -height, 0);
    }
    else if(image.imageOrientation==UIImageOrientationUp)
    {
        //DO NOTHING
    }
    else if(image.imageOrientation==UIImageOrientationDown)
    {
        CGContextTranslateCTM(context, width, height);
        CGContextRotateCTM(context, M_PI);
    }
    
    CGContextDrawImage(context, imageRect, image.CGImage);
    CGContextRestoreGState(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (img);
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
        {
            DLog(@"Mail Saved");
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Mail Saved"];
            [alert setOKButtonWithBlock:NULL];
            [alert show];
            
        }
            break;
            
        case MFMailComposeResultSent:
        {
            DLog(@"Mail Sent");
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Mail Sent"];
            [alert setOKButtonWithBlock:NULL];
            [alert show];
        }
            break;
            
        case MFMailComposeResultFailed:
        {
            DLog(@"Mail Failed");
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Sending Failed - Unknown Error"];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            [alert show];

        }
            break;
            
        default:
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Sending Failed - Unknown Error"];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            [alert show];
            
        }
            
            break;
    }
    
    
    [_mailComposeVC dismissViewControllerAnimated:YES completion:NULL];
   
}

-(void)printWithAirPrinter{

    [self printDocument];
}


- (void)printDocument
{
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if(!controller){
        DLog(@"Couldn't get shared UIPrintInteractionController!");
        return;
    }
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundVerticalPositionAdjustment:-50.0 forBarMetrics:UIBarMetricsDefault];
        
        if(!completed && error){
            DLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
        }
    };
    
    // Obtain a printInfo so that we can set our printing defaults.
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    // This application produces General content that contains color.
    printInfo.outputType = UIPrintInfoOutputGeneral;
    // We'll use the URL as the job name
    printInfo.jobName = _filePath;
    // Set duplex so that it is available if the printer supports it. We
    // are performing portrait printing so we want to duplex along the long edge.
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    // Use this printInfo for this print job.
    controller.printInfo = printInfo;
    
    // Be sure the page range controls are present for documents of > 1 page.
    controller.showsPageRange = YES;
    
    // This code uses a custom UIPrintPageRenderer so that it can draw a header and footer.
    PrintPageRenderer *printRenderer = [[PrintPageRenderer alloc] init];
    // The MyPrintPageRenderer class provides a jobtitle that it will label each page with.
    printRenderer.jobTitle = printInfo.jobName;
    // To draw the content of each page, a UIViewPrintFormatter is used.
    UIViewPrintFormatter *viewFormatter = [_webView viewPrintFormatter];
    
#if SIMPLE_LAYOUT
    /*
     For the simple layout we simply set the header and footer height to the height of the
     text box containing the text content, plus some padding.
     
     To do a layout that takes into account the paper size, we need to do that
     at a point where we know that size. The numberOfPages method of the UIPrintPageRenderer
     gets the paper size and can perform any calculations related to deciding header and
     footer size based on the paper size. We'll do that when we aren't doing the simple
     layout.
     */
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FOOTER_TEXT_HEIGHT];
    CGSize titleSize = [printRenderer.jobTitle sizeWithFont:font];
    printRenderer.headerHeight = printRenderer.footerHeight = titleSize.height + HEADER_FOOTER_MARGIN_PADDING;
#endif
    [printRenderer addPrintFormatter:viewFormatter startingAtPageAtIndex:0];
    // Set our custom renderer as the printPageRenderer for the print job.
    controller.printPageRenderer = printRenderer;
    
    
    // The method we use presenting the printing UI depends on the type of
    // UI idiom that is currently executing. Once we invoke one of these methods
    // to present the printing UI, our application's direct involvement in printing
    // is complete. Our custom printPageRenderer will have its methods invoked at the
    // appropriate time by UIKit.
   // [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    
   // [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [controller presentFromBarButtonItem:_printButton animated:YES completionHandler:completionHandler];  // iPad
    else{
        
        //[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        
        
       // [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        
        
        
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        //[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
       //AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
       
        //[app.navigationController pushViewController:controller animated:YES];
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundVerticalPositionAdjustment:1.0 forBarMetrics:UIBarMetricsDefault];

        
        [controller presentAnimated:YES completionHandler:completionHandler];  // iPhone
        
       // [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        
        
        //[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        
        
        
       // [[UIApplication sharedApplication] setStatusBarHidden:YES];
       // [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        
    }
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
}

-(void)shareDocumentOnFacebook{

    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    UIImage *facebookImage = [UIImage imageByAppendingDeviceName:@"btn_Facebook"];
    [MMProgressHUD showProgressWithStyle:MMProgressHUDProgressStyleIndeterminate title:nil status:@"Posting on Facebook" image:facebookImage];
    
    
    if (FBSession.activeSession.isOpen) {
        
            [self shareDocument];
        
        
        
    } else {
        
        [self openSessionWithAllowLoginUI:YES];
    }
    }

}

-(void)shareDocument{

    NSString *graphPath = @"me/feed";
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_filePath,  @"message", nil];
    
    NSString*httpMethod = @"POST";
    
    
    [FBRequestConnection startWithGraphPath:graphPath parameters:params HTTPMethod:httpMethod completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSString *msg = nil;
        if (!error) {
            DLog(@"%@",result);
            msg = [result valueForKey:@"post_id"];
        }
        else{
            msg = [error localizedDescription];
            DLog(@"error %@",[error localizedDescription]);
        }
        
        /*
         if (msg)
         [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
         */
        
        [MMProgressHUD dismiss];
        
    }];

}
-(void)shareDocumentOnTwitter{

    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:@"Document Shared Via CloudQRScan"];
        [tweetSheet addURL:[NSURL URLWithString:_filePath]];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	    [app.navigationController presentModalViewController:tweetSheet animated:YES];
        
        
    }
    else
    {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
        
        
    }
    }
    
}
-(void)shareDocumentWithMail{

    _mailComposeVC = [MFMailComposeViewController new];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        NSString *bodyText =@"<html>";
        bodyText = [bodyText stringByAppendingString:@"<head>"];
        bodyText = [bodyText stringByAppendingString:@"</head>"];
        bodyText = [bodyText stringByAppendingString:@"<body>"];
        bodyText = [bodyText stringByAppendingString:[NSString stringWithFormat:@"<a     href=\"%@\">Document Shared Via CloudQRScan",_filePath]];
        bodyText = [bodyText stringByAppendingString:@"</a>"];
        [_mailComposeVC setMessageBody:bodyText isHTML:YES];
        _mailComposeVC.mailComposeDelegate = self;
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[app.navigationController topViewController] presentViewController:_mailComposeVC animated:YES completion:NULL];
        
        
    }
    else{
        
        
    }

}

-(void)shareTextWithMailTo:(NSString *)to andSubject:(NSString *)subject{
    
    _mailComposeVC = [MFMailComposeViewController new];
    
    if ([MFMailComposeViewController canSendMail]) {
        
//        NSString *bodyText =@"<html>";
//        bodyText = [bodyText stringByAppendingString:@"<head>"];
//        bodyText = [bodyText stringByAppendingString:@"</head>"];
//        bodyText = [bodyText stringByAppendingString:@"<body>"];
//        bodyText = [bodyText stringByAppendingString:[NSString stringWithFormat:@"<a     href=\"%@\">Document Shared Via CloudQRScan",_filePath]];
//        bodyText = [bodyText stringByAppendingString:@"</a>"];
//        [_mailComposeVC setMessageBody:bodyText isHTML:YES];

        
        _mailComposeVC.mailComposeDelegate = self;
        
        
        [_mailComposeVC setToRecipients:@[to]];
        [_mailComposeVC setSubject:subject];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[app.navigationController topViewController] presentViewController:_mailComposeVC animated:YES completion:NULL];
        
        
    }
    else{
        
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
