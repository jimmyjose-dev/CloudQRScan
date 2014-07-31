//
//  ViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 15/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"

#import "CommonHeaders.h"

#import <AudioToolbox/AudioToolbox.h>
#import "RequestAuthorizationViewController.h"
#import "EncryptedQRCodeParser.h"
#import "QRCodeTypeParser.h"
#import "PerformOperation.h"
#import "DecryptController.h"
#import "QRProductViewController.h"
#import "BarcodeProductViewController.h"
#import "HistoryManager.h"


@interface ViewController ()<ZBarReaderDelegate,ZBarReaderViewDelegate,EncryptedQRCodeParserDelegate,UIAlertViewDelegate>{
    
      IBOutlet ZBarReaderView *reader; // ZBar embedded reader
    CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;
    UIImage *qrCodeImage;
    int passwordTryCount;
}
@property (nonatomic,retain) NSDictionary   *selectorDictionary;
@property (readwrite)        CFURLRef		soundFileURLRef;
@property (readonly)         SystemSoundID	soundFileObject;
@property (nonatomic,retain) PerformOperation *performOperation;
@property (nonatomic,retain) UIImage *qrCodeImage;
@property (nonatomic,retain) NSString *qrCodeString;
@property (nonatomic, retain) UIPopoverController *popOver;
//@property (nonatomic,retain) IBOutlet UIButton *galleryButton;

@end

@implementation ViewController

- (void) viewDidAppear: (BOOL) animated
{
    // run the reader when the view is visible
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [reader start]; // Initiate the ZBar reader
    //reader.trackingColor = [UIColor clearColor];
    _qrCodeImage = nil;
    [[self.navigationController navigationBar] setHidden:YES]; // Hide the navigation bar
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [Flurry logEvent:@"Scanner Started" timed:YES];
    passwordTryCount = 0;
    
}

- (void) viewWillDisappear: (BOOL) animated
{
    [reader stop];// Stop the ZBar reader to save memory
    [[self.navigationController navigationBar] setHidden:NO]; // Show the naviagtion bar
    [Flurry endTimedEvent:@"Scanner Started" withParameters:nil];
}


-(IBAction)flashButtonPressed:(id)sender{
    
    [Flurry logEvent:@"Flash Pressed"];
    reader.torchMode = !reader.torchMode; // Toggle Camera torch
    
}

-(IBAction)histroyButtonPressed:(id)sender{
    // Show histroy view
    
    HistoryManager *historyManager = [[HistoryManager alloc] init];
    NSDictionary *dictHistory = [historyManager getDBData];
    int count = [[dictHistory valueForKey:@"value"] count];
    
    if (!count) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Nothing to show in history"];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
    }
    else
    {
        HistoryViewController *historyVC = [[HistoryViewController alloc] initByAppendingDeviceNameWithTitle:kHistoryTitle];
        historyVC.historyDataDict = dictHistory;
    
        [self.navigationController pushViewController:historyVC animated:YES];
    }
}

-(IBAction)deviceAuthorizationButtonPressed:(id)sender{
    
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    
    // Show device authorization view
    DeviceAuthorizationViewController *deviceAuthorizationVC = [[DeviceAuthorizationViewController alloc] initByAppendingDeviceNameWithTitle:kDeviceAuthorizationTitle];
    
    [self.navigationController pushViewController:deviceAuthorizationVC animated:YES];
    
    }
    
}

-(IBAction)createQRCodeButtonPressed:(id)sender{
    
    // Show createqr view
    CreateQRViewController *createQRViewController = [[CreateQRViewController alloc] initByAppendingDeviceNameWithTitle:kCreateQRTitle];
    
    [self.navigationController pushViewController:createQRViewController animated:YES];
    
    
}

-(IBAction)galleryButtonPressed:(id)sender{
    
    [Flurry logEvent:@"Gallery View" timed:YES];
    
    ZBarReaderController *readerGallery = [ZBarReaderController new];
    readerGallery.readerDelegate = self;
    
    readerGallery.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    CGRect frame = CGRectMake(0, 0, 100, 100);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:readerGallery];
        [popover presentPopoverFromRect:frame inView:reader permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        _popOver = popover;
    } else {
        [self presentModalViewController: readerGallery animated: YES];
    }
    

    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [Flurry endTimedEvent:@"Gallery View" withParameters:nil];
    [Flurry logEvent:@"Gallery View"];
    
    [picker dismissModalViewControllerAnimated:YES];
    if (_popOver != nil) {
        [_popOver dismissPopoverAnimated:YES];
        _popOver=nil;
    }
}

-(void)performActionWithSymbol:(id)symbolSet andImage:(UIImage *)image{

     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"savetodb"];
    
    NSString *scanResult = nil;
    BOOL isQRCode = NO;
    
    self.qrCodeImage = image;
    
    BOOL shouldMakeClickSound = kShouldMakeSound;
    
    for(ZBarSymbol *sym in symbolSet) {
        
        scanResult = sym.data;
        _qrCodeString = scanResult;
        DLog(@"%@",scanResult);
        if (shouldMakeClickSound) {
            [self makeClickSound];
        }
        if ([sym.typeName isEqualToString:@"QR-Code"]) {
            
            isQRCode = YES;
            
        }
        break;// only interested in the first result.
    }
    
    
    if (isQRCode) {
        
        if (scanResult) {
            
            [self performActionWithQRCode:scanResult];
        }
    }
    else{
        
       // [self performActionWithBarCode:scanResult];
    }

    
}

- (void) imagePickerController: (UIImagePickerController*) readerZBar
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //[reader stop];
    [readerZBar dismissModalViewControllerAnimated: YES];
    
    if (_popOver != nil) {
        [_popOver dismissPopoverAnimated:YES];
        _popOver=nil;
    }


    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
//    self.qrCodeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [Flurry logEvent:@"Using Gallery for scanning"];
    [Flurry logEvent:@"Selected QRCode from Gallery"];
    [Flurry endTimedEvent:@"Gallery View" withParameters:nil];
    
    [self performActionWithSymbol:results andImage:image];
    
    /*
    NSString *scanResult = nil;
    BOOL isQRCode = NO;
    
    BOOL shouldMakeClickSound = kShouldMakeSound;
    
    for(ZBarSymbol *sym in results) {
        
        scanResult = sym.data;
        _qrCodeString = scanResult;
        DLog(@"%@",scanResult);
        if (shouldMakeClickSound) {
            [self makeClickSound];
        }
        if ([sym.typeName isEqualToString:@"QR-Code"]) {
            
            isQRCode = YES;
            
        }
        break;// only interested in the first result.
    }
    
    
    if (isQRCode) {
        
        if (scanResult) {
            
            [self performActionWithQRCode:scanResult];
        }
    }
    else{
        
        [self performActionWithBarCode:scanResult];
    }
     */
    
}

- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    //self.qrCodeImage = img;

    [Flurry logEvent:@"Using Camera for scanning"];
    [Flurry logEvent:@"Scanned QRCode with Camera"];
    
    
    [self performActionWithSymbol:syms andImage:img];
    
    
    /*
    // do something useful with results
    NSString *scanResult = nil;
    BOOL isQRCode = NO;
    
    BOOL shouldMakeClickSound = kShouldMakeSound;
    
    for(ZBarSymbol *sym in syms) {
        
        scanResult = sym.data;
        _qrCodeString = scanResult;
        DDLogInfo(@"%@",scanResult);
        if (shouldMakeClickSound) {
            [self makeClickSound];
        }
        if ([sym.typeName isEqualToString:@"QR-Code"]) {
            
            isQRCode = YES;
            
        }
        break;// only interested in the first result.
    }
    
    
    if (isQRCode) {
        
        if (scanResult) {
            
            [Flurry logEvent:@"Scanned QRCode with Camera"];
            [self performActionWithQRCode:scanResult];
        }
    }
    else{
        
        [Flurry logEvent:@"Scanned BarCode with Camera"];
        [self performActionWithBarCode:scanResult];
    }
     
     */
    
}

-(void)performActionWithBarCode:(NSString *)barCodeScanResult{
    
    NSString *serverURL = [NSString stringWithFormat:@"http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=FCF91554-8A3B-466E-BA69-B27C37F66A5B&upc=%@",[barCodeScanResult trim]];
    NSString *service = @"BarcodeProduct";
    
    ServerController *server = [[ServerController alloc] initWithServerURL:serverURL forServiceType:service];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Retriving data from server";
    [MBProgressHUD HUDForView:self.navigationController.view].labelText = @"Barcode  Detected";
    
    [server connectUsingGetMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        if (errorString){
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:errorString];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
            [alert show];
            
        }else{
            
            
            NSDictionary *productDict = [(NSDictionary *)serverResponse valueForKey:@"0"];
            

            if (productDict && [[productDict allKeys] count]) {
            
                BarcodeProductViewController *barCodeVC = [[BarcodeProductViewController alloc] initByAppendingDeviceNameWithTitle:@"Product Info"];
                barCodeVC.serverResponse = [NSDictionary dictionaryWithDictionary:productDict];
                
                [self.navigationController pushViewController:barCodeVC animated:YES];
            }
            else{
            
                BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:errorString];
                [alert setDestructiveButtonWithTitle:@"Product doesn't exists in our current database" block:nil];
                [alert show];
                
            }
            
            
        }
        
        
    }];
    
}
-(void)performActionWithQRCode:(NSString *)qrCodeScanResult{
    
    NSString *qrCodeType = [self getTypeForQRCode:qrCodeScanResult];
    self.qrCodeString = qrCodeScanResult;
    //self.qrCodeImage = nil;
    
    if (![qrCodeType isEqualToString:kOtherQRCode]) {
        
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
        
            NSString *aSelectorName = [_selectorDictionary valueForKey:qrCodeType];
            SEL selector = NSSelectorFromString(aSelectorName);
            
            [self performSelector:selector withObject:qrCodeScanResult];
        }
    }
    else{
    
        NSString *aSelectorName = [_selectorDictionary valueForKey:qrCodeType];
        SEL selector = NSSelectorFromString(aSelectorName);
        
        [self performSelector:selector withObject:qrCodeScanResult];
    }
    
    
    
}

-(NSString *)getTypeForQRCode:(NSString *)qrCode{
    
    NSString *type = kOtherQRCode;
    
    if ([self isQRCodeEncrypted:qrCode]) {
        type = kCQRSEncrypted;
    }
    else if ([qrCode containsString:kCQRSProfileMarker1 ignoringCase:YES] || [qrCode containsString:kCQRSProfileMarker2 ignoringCase:YES]) {
        type = kCQRSProfile;
    }else if ([qrCode containsString:kCQRSProductMarker1 ignoringCase:YES] || [qrCode containsString:kCQRSProductMarker2 ignoringCase:YES]) {
        type = kCQRSProduct;
    }else if ([qrCode beginsWithString:kSERVER_DOMAIN ignoringCase:YES]){
    
        //NSString *serverURL = kSERVER_DOMAIN;
        NSString *lastPartOfURL = [qrCode lastPathComponent];
        //int profileID = -1;
        if (lastPartOfURL) {
        
            lastPartOfURL = [lastPartOfURL trim];
            //Check if it is some html page
            NSArray *htmlArray = [lastPartOfURL componentsSeparatedByString:@"."];
            
            if (!([htmlArray count]>1)) {
                //we should check with some pages. like faq/contactus etc
                if ([lastPartOfURL isEqualToString:@"faq"]) {
                    
                }
                
                type = kCQRSProfileNew;
            }
            /*if ([lastPartOfURL isNumeric]) {
                profileID = [lastPartOfURL intValue];
            }*/
        }
        
        
        
    }
    
    
    return type;
}


-(BOOL)isQRCodeEncrypted:(NSString *)qrCodeString{
    
    BOOL isEncrypted = NO;
    NSString *encryptedCodeHeader = @"=encrypted";
    if ([qrCodeString containsString:encryptedCodeHeader ignoringCase:YES]) isEncrypted = YES;
    
    return isEncrypted;
}


-(IBAction)settingsButtonPressed:(id)sender{
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] initByAppendingDeviceNameWithTitle:kSettingsTitle];
    
    [self.navigationController pushViewController:settingsVC animated:YES];
    
}


-(void)showQRProfileViewForQRCode:(NSString *)qrCodeResult{
    
    qrCodeResult = [qrCodeResult stringByRemovingOccurrencesOfStrings:kCQRSProfileMarker1];
    qrCodeResult = [qrCodeResult stringByRemovingOccurrencesOfStrings:kCQRSProfileMarker2];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    NSString *profileID = qrCodeResult;
    
    NSString *serverURL = PROFILE_DATA_URL(profileID);
    NSString *service = kServiceQRProfile;
    
    ServerController *server = [[ServerController alloc] initWithServerURL:serverURL forServiceType:service];
    
    [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText = @"Fetching user data";
    [MBProgressHUD HUDForView:vw].labelText = @"QR Profile Detected";
    
    [server connectUsingGetMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
        
        [MBProgressHUD hideAllHUDsForView:vw animated:YES];
        if (errorString){
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:errorString];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
            [alert show];
            
        }else{
            
            
            QRProfileViewController *qrProfileViewController = [[QRProfileViewController alloc] initByAppendingDeviceName];
            NSDictionary *serverResponseDictionary = (NSDictionary *)([(NSArray *)serverResponse objectAtIndex:0]);
            qrProfileViewController.serverResponse = [NSDictionary dictionaryWithDictionary:serverResponseDictionary];
            qrProfileViewController.qrCodeImage = self.qrCodeImage;
            qrProfileViewController.qrCodeString = _qrCodeString;
            qrProfileViewController.profileID = profileID;
            //[self.navigationController.topViewController pushViewController:qrProfileViewController animated:YES];
            
            [app.navigationController pushViewController:qrProfileViewController animated:YES];
            
            
        }
        
        
    }];
    
}

-(void)showQRProfileViewNewForQRCode:(NSString *)qrCodeResult{
    
    //qrCodeResult = [qrCodeResult stringByRemovingOccurrencesOfStrings:kCQRSProfileMarker1];
    //qrCodeResult = [qrCodeResult stringByRemovingOccurrencesOfStrings:kCQRSProfileMarker2];
    
    //NSString *serverURL = kSERVER_DOMAIN;
    NSString *lastPartOfURL = [[qrCodeResult lastPathComponent] trim];
    //BOOL isNotMainProfile = [lastPartOfURL isNumeric]? YES:NO;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    //NSString *profile = lastPartOfURL;
    
    NSString *serverURL = [lastPartOfURL isNumeric]?PROFILE_DATA_URL(lastPartOfURL):PROFILE_DATA_BY_NAME_URL(lastPartOfURL);
    NSString *service = kServiceQRProfile;
    
    //NSLog(@"serverURL %@",serverURL);
    
    ServerController *server = [[ServerController alloc] initWithServerURL:serverURL forServiceType:service];
    
    [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText = @"Fetching user data";
    [MBProgressHUD HUDForView:vw].labelText = @"QR Profile Detected";
    
    [server connectUsingGetMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
        
        [MBProgressHUD hideAllHUDsForView:vw animated:YES];
        if (errorString){
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:errorString];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
            [alert show];
            
        }else{
            
            
            QRProfileViewController *qrProfileViewController = [[QRProfileViewController alloc] initByAppendingDeviceName];
            NSDictionary *serverResponseDictionary = (NSDictionary *)([(NSArray *)serverResponse objectAtIndex:0]);
            NSString *profileID = [serverResponseDictionary valueForKey:@"AccountId"];
            //NSLog(@"id %@ pro %@",profileID,[serverResponseDictionary valueForKey:@"AccountId"]);
            qrProfileViewController.serverResponse = [NSDictionary dictionaryWithDictionary:serverResponseDictionary];
            qrProfileViewController.qrCodeImage = self.qrCodeImage;
            qrProfileViewController.qrCodeString = _qrCodeString;
            qrProfileViewController.profileID = profileID;
            //[self.navigationController.topViewController pushViewController:qrProfileViewController animated:YES];
            
            [app.navigationController pushViewController:qrProfileViewController animated:YES];
            
            
        }
        
        
    }];
    
}


-(void)showQRProductViewForQRCode:(NSString *)qrCodeResult{


   qrCodeResult = [qrCodeResult stringByRemovingOccurrencesOfStrings:kCQRSProductMarker1];
   qrCodeResult = [qrCodeResult stringByRemovingOccurrencesOfStrings:kCQRSProductMarker2];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    NSString *productID = qrCodeResult;
    
    NSString *serverURL = PRODUCT_DATA_URL(productID);
    NSString *service = kServiceQRProduct;
    
    ServerController *server = [[ServerController alloc] initWithServerURL:serverURL forServiceType:service];
    
    [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText = @"Fetching product data";
    [MBProgressHUD HUDForView:vw].labelText = @"QR Product Detected";
    
    [server connectUsingGetMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {

        [MBProgressHUD hideAllHUDsForView:vw animated:YES];
        if (errorString){
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:errorString];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
            [alert show];
            
        }else{
            
        
            QRProductViewController *qrProductViewController = [[QRProductViewController alloc] initByAppendingDeviceNameWithTitle:@"Product"];
            
        
            NSDictionary *serverResponseDictionary = (NSDictionary *)[((NSArray *)(serverResponse)) objectAtIndex:0];
            qrProductViewController.serverResponse = [NSDictionary dictionaryWithDictionary:serverResponseDictionary];
            qrProductViewController.qrCodeImage = _qrCodeImage;
            qrProductViewController.qrCodeString = _qrCodeString;
            [app.navigationController pushViewController:qrProductViewController animated:YES];
            
        }
        
        
    }];

}

-(void)showQREncryptedCode:(NSString *)qrCodeResult{
    
    EncryptedQRCodeParser *encParser = [[EncryptedQRCodeParser alloc] initWithEncryptedString:qrCodeResult];
    encParser.delegate = self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    [MBProgressHUD hideHUDForView:vw animated:YES];
    [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText= @"Encrypted QR code detected";
    
    //DLog(@"Result %@",[encParser getUserDataDictionary]);
    
}

-(void)checkForDeviceAuthorizationStartedForUser:(NSString *)username{
    
    NSString *msg = [NSString stringWithFormat:@"Verifying device authorization for %@'s encrypted QRCode",username];
    
    DLog(@"msg %@",msg);
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    [MBProgressHUD hideHUDForView:vw animated:YES];
    [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText= msg;
    
}

-(void)checkForDeviceAuthorizationFailedWithError:(NSString *)error{
    
    DLog(@"error %@",error);
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    [MBProgressHUD hideHUDForView:vw animated:YES];
    [MBProgressHUD hideHUDForView:vw afterDelay:2.0 withMessage:error animated:YES];
}

-(void)checkForDeviceAuthorizationEndedForUser:(NSString *)username{
    
    DLog(@"%s",__func__);
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    [MBProgressHUD hideHUDForView:vw animated:YES];
}

-(void)encryptedQRCodeHasDeviceAuthorizedForMessage:(NSString *)base64String{
    
    NSString *qrcodeContent = [base64String  base64DecodedString];
    
    [self performActionWithQRCode:qrcodeContent];
}

-(void)encryptedQRCodeHasNoDeviceAuthorizedForUser:(NSString *)username withDecodedDataDictionary:(NSDictionary *)decodedDataDictionary{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *vw = app.navigationController.topViewController.view;
    
    
    NSString *titleMessage = [NSString stringWithFormat:@"Encrypted QRCode from %@",username];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Name" forKey:username];
    
    [Flurry logEvent:@"QRLocker" withParameters:userInfo timed:YES];
    
    NSString *message = @"Enter password to procced";
    
    //NSString *hint = [decodedDataDictionary valueForKey:@"hint"];
    //NSString *hintMsg = [NSString stringWithFormat:@"Hint : %@",hint];
    
    
    UITextField *textField;
    
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:titleMessage message:message textField:&textField block:^(BlockTextPromptAlertView *alert){
        
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    //[alert.textField setPlaceholder:message];
    [alert.textField setSecureTextEntry:YES];
    [alert.textField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [alert.textField setTextAlignment:NSTextAlignmentLeft];
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    [alert addButtonWithTitle:@"Verify" block:^{
        DLog(@"Text: %@", textField.text);
        [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText = @"Verifying password please wait...";
        
        
        NSString *md5Pass = [textField.text MD5String];
        NSString *profileID = [decodedDataDictionary valueForKey:@"profileid"];
        NSString *qrlockerID = [decodedDataDictionary valueForKey:@"qrlockerid"];
        
        NSString *qrLockerStatus = QRLOCKER_STATUS_URL(profileID, qrlockerID, md5Pass);
        DLog(@"QRLOCKER_STATUS_URL %@",qrLockerStatus);
        
        NSURL *qrLockerStatusURL = [NSURL URLWithString:qrLockerStatus];
        
        /*
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:qrLockerStatusURL
                                                      cachePolicy:NSURLCacheStorageNotAllowed
                                                  timeoutInterval:kTimeoutInterval];
         */
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:qrLockerStatusURL];
        [request setTimeoutInterval:kTimeoutInterval];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:vw animated:YES];
            if (!error) {
                
                NSError *err = nil;
                
                //DLog(@"data %@",[data stringASCII]);
                
                NSDictionary *responseJSON = [[NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingAllowFragments error:&err] objectAtIndex:0];
                if (!err) {
                    
                    //DLog(@"responseJSON %@",responseJSON);
                    
                    if ([[responseJSON valueForKey:@"Status"] isEqualToString:@"SUCCESS"]) {
                        
                        NSString *message = [responseJSON valueForKey:@"Message"];
                        NSString *qrcodeContent = [message  base64DecodedString];
                        
                        [self performActionWithQRCode:qrcodeContent];
                        passwordTryCount = 0;
                    }
                    else{
                        
                        
                        
                        if (++passwordTryCount<=2) {
                        
                            NSString *msg = @"Do you want to ";
                            if (passwordTryCount == 1)     msg = [msg stringByAppendingString:@"try again"];
                            else msg = [msg stringByAppendingString:@"try last time"];

                            
                        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Wrong Password!!!" message:msg];
                        [alert setYESButtonWithBlock:^{
                            [self encryptedQRCodeHasNoDeviceAuthorizedForUser:username withDecodedDataDictionary:decodedDataDictionary];
                        }];
                        
                        [alert setNOButtonWithBlock:^{
                            passwordTryCount = 0;
                        }];
                        
                        [alert show];
                            
                        }
                        else{
                        
                            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Wrong Password!!!" message:[NSString stringWithFormat:@"You have tried 3 times.\nGet the password from %@ and try again",username]];
                            
                            [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
                            
                            [alert show];
                            passwordTryCount = 0;
                        }
                        
                    }
                    
                    /*
                    if ([responseJSON isEqualToString:@"FAILED"]) {
                        
                        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Wrong Password!!!" message:@"Scan and try again."];
                        [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
                        [alert show];
                    }else{
                        
                        NSLog(@"encrypted data %@",[[decodedDataDictionary valueForKey:@"userdata"] stringASCII]);
                        
                        DecryptController *decrypt = [[DecryptController alloc] init];
                        NSString *qrcodeContent = [decrypt dataWithPassMD5:[[textField.text MD5String] dataUTF8] andEncodedData:[decodedDataDictionary valueForKey:@"userdata"]];
                        DLog(@"encrypted msg was %@",qrcodeContent);
                        
                        [self performActionWithQRCode:qrcodeContent];
                    }
                    */
                    
                    
                }else{
                    
                    DLog(@"error in JSON %@",[err localizedDescription]);
                    
                    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Please scan and try again"];
                    
                    [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
                    
                    [alert show];
                    
                }
                
            }
            
            else{
                
                DLog(@"Error %@",[error localizedDescription]);
                
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Please scan and try again"];
                
                [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
                
                [alert show];
                
            }
        }];
        
        
        
    }];
    
    [alert addButtonWithTitle:@"Authorize Device" block:^{
        
        DLog(@"Text: %@", textField.text);

        [Flurry logEvent:@"Authorize Device Button" withParameters:userInfo];
        
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{

        [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText = @"Preparing for device authorization";
        
        NSString *profileData = PROFILE_LESS_DATA_URL([decodedDataDictionary valueForKey:@"profileid"]);
        
        NSURL *profileDataURL = [NSURL URLWithString:profileData];
        
            /*
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:profileDataURL
                                                      cachePolicy:NSURLCacheStorageNotAllowed
                                                  timeoutInterval:kTimeoutInterval];
            */
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:profileDataURL];
            [request setTimeoutInterval:kTimeoutInterval];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:vw animated:YES];
            if (!error) {
                
                NSError *err = nil;
                NSDictionary *responseJSON = [[[NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingAllowFragments error:&err] valueForKey:@"ProfileUserDetailsResult"] objectAtIndex:0];
                if (!err) {
                    
                    DLog(@"responseJSON %@",responseJSON);
                    
                    RequestAuthorizationViewController *requestVC = [[RequestAuthorizationViewController alloc] initByAppendingDeviceNameWithTitle:@"Device Authorization"];
                    
                    NSString *accountID = [responseJSON valueForKey:@"AccountId"];
                    NSString *toName = [responseJSON valueForKey:@"UserName"];
                    NSString *toEmail = [responseJSON valueForKey:@"Email"];
                    NSString *imageURL = [responseJSON valueForKey:@"Avatar"];
                    
                    
                    requestVC.toName = toName;
                    requestVC.toEmail = toEmail;
                    requestVC.accountID = accountID;
                    requestVC.imageURLString = imageURL;
                    
                    
                    [app.navigationController pushViewController:requestVC animated:YES];
                    
                }
                
            }
            
        }];
        }
        
    }];
    
    [alert show];
    
    
    
}


-(void)encryptedQRCodeDeviceAuthorizationFailedDueToError:(NSString *)error{
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:error];
    [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
    [alert show];
    
}


-(void)detectWhichOtherType:(NSString *)qrCodeResult{
    
    QRCodeTypeParser *qrCodeTypeParser = [[QRCodeTypeParser alloc] initWithQRCode:qrCodeResult];
    NSString *type = [qrCodeTypeParser getQRCodeType];
    DLog(@"type %@",type);
    _performOperation = [[PerformOperation alloc] initWithQRCode:qrCodeResult forType:type];
}

-(id)init{
    
    self = [super init];
    [self setSelectorForQRCodeType];
    return self;
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setSelectorForQRCodeType];
    reader.readerDelegate = self;
    passwordTryCount = 0;
    
   //AudioViewController *audioVC = [[AudioViewController alloc] initByAppendingDeviceNameWithTitle:@"Audio"];
    //[self.navigationController pushViewController:audioVC animated:YES];
    
    //[self showQRPRofileViewForQRCode:@"2"];
    
    //[self performActionWithBarCode:@"0081697521221"];
  
   /*
    UITextField *textField = nil;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"title" message:@"sda" textField:&textField block:^(BlockTextPromptAlertView *alert){
        
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert.textField setSecureTextEntry:YES];
    [alert.textField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [alert.textField setTextAlignment:NSTextAlignmentLeft];
    //[alert setCancelButtonWithTitle:@"Cancel" block:nil];
    //[alert addButtonWithTitle:@"Verify" block:nil];
   
    CGRect frame = textField.frame;
    frame.size.width -=100;
    textField.frame = frame;
   
    UIButton *gobutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [gobutton setTitle:@"Verify" forState:UIControlStateNormal];
    
    //frame = gobutton.frame;
    frame.origin.x = textField.frame.origin.x + textField.frame.size.width + 10;
    frame.size.width = 80;
    frame.size.height = 35;
    frame.origin.y -= 5;
    gobutton.frame = frame;
    
   // [gobutton ad];
    
    [alert.view addSubview:gobutton];
    [alert setCancelButtonWithTitle:@"Device Authorize" block:nil];
    [alert setDestructiveButtonWithTitle:@"Know more" block:nil];
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    [alert show];
    */
    
}

-(void)setSelectorForQRCodeType{
    
    _selectorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"showQREncryptedCode:",kCQRSEncrypted,
                           @"showQRProfileViewForQRCode:",kCQRSProfile,
                           @"showQRProfileViewNewForQRCode:",kCQRSProfileNew,
                           @"showQRProductViewForQRCode:",kCQRSProduct,
                           @"detectWhichOtherType:",kOtherQRCode,nil];
    
}

-(void)makeClickSound{
    
    NSURL *clickSound   = [[NSBundle mainBundle] URLForResource: @"click"
                                                  withExtension: @"aif"];
    
    // Store the URL as a CFURLRef instance
    _soundFileURLRef = (__bridge CFURLRef) clickSound;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (_soundFileURLRef,&_soundFileObject);
    
    PLAY_SOUND(_soundFileObject);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //AudioServicesDisposeSystemSoundID (_soundFileObject);
    //CFRelease (_soundFileURLRef);
}

@end
