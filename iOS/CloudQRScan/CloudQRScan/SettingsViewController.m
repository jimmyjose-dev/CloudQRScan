//
//  SettingsViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "SettingsViewController.h"
#import "IQFeedbackView.h"
#define kCellDeviceAutoLock -1
#define kCellScannerSound   0
#define kCellNotifyNewApp   1

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UITableView *tableView;
    NSArray *tableDataSource;
    IBOutlet UIView *appInfoVIew;
    IBOutlet UILabel *lblAppVersion;
    IBOutlet UILabel *lblAppServer;
    IBOutlet UILabel *lblAppDateTime;
}
@property(nonatomic,retain)UIBarButtonItem *logoutBarButton;
@end

@implementation SettingsViewController

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
    
    [Flurry endTimedEvent:@"Settings Page" withParameters:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [Flurry logEvent:@"Settings Page" timed:YES];
    
    UIImage *backButtonImage = [UIImage imageByAppendingDeviceName:@"btn_back"];
    
    CGRect backButtonFrame = CGRectZero;
    backButtonFrame.origin.x += 5;
    backButtonFrame.size = backButtonImage.size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:backButtonFrame];
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = back;
    
    
    
    UIImage *logoutButtonImage = [UIImage imageByAppendingDeviceName:@"btn_logout"];

    
    CGRect logoutButtonFrame = CGRectZero;
    //userButtonFrame.origin.x += 5;
    logoutButtonFrame.size = logoutButtonImage.size;
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:logoutButtonFrame];
    [logoutButton setImage:logoutButtonImage forState:UIControlStateNormal];
    
    [logoutButton addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _logoutBarButton = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    
    
    [_logoutBarButton setEnabled:[self isUserActive]];
    
   /* if ([self isUserActive]) {
    self.navigationItem.rightBarButtonItem = _logoutBarButton;
    }*/
    
}

-(BOOL)isUserActive{
    
    BOOL userActive = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserActiveKey]) {
        userActive = [[NSUserDefaults standardUserDefaults] boolForKey:kUserActiveKey];
    }
    
    return userActive;
}

-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)logoutButtonPressed{

    NSString *msg = @"Do you want to logout?";
//    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil] show];
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
    [alert setYESButtonWithBlock:^{
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserActiveKey];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kUserIDKey];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kUserActiveEmailKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_logoutBarButton setEnabled:NO];
    
    }];
    
    [alert setNOButtonWithBlock:NULL];
    [alert show];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
/*
    tableDataSource = [NSArray arrayWithObjects:@"Device Auto Lock",@"Scanner Sound",@"Check for Updates",@"Privacy Policy",@"About Us",@"Rate Us",@"Send Feedback",@"Bug Report", nil];
  
 */
    
    tableDataSource = [NSArray arrayWithObjects:@"Scanner Sound",@"Check for Updates",@"About Us",@"Rate this App",@"Send Feedback",@"Report a Bug", nil];
    
    
    if (kShowBuildInfo) {
    
        [self setFotterViewData];
        tableView.tableFooterView = appInfoVIew;
    }
    
    
}

-(void)setFotterViewData{

    NSString *dateStr = [NSString stringWithUTF8String:__DATE__];
    NSString *timeStr = [NSString stringWithUTF8String:__TIME__];
    
    NSString *dateTime = [NSString stringWithFormat:@"Last build: %@ - %@",dateStr,timeStr];
    
    //NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];//Build
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];//Version
    
    
    NSString *appVersion = [NSString stringWithFormat:@"Version: %@",version];
    
    NSString *server = @"Server: Development";
    
    NSString *strAppInfo = appVersion;
    
    if (kLiveServer) {
        
        server = @"Server: Live";
    }
    
    DLog(@"strAppInfo %@ date %@ time %@",strAppInfo,dateStr,timeStr);
    
    
    [lblAppVersion setText:appVersion];
    [lblAppServer setText:server];
    [lblAppDateTime setText:dateTime];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [tableDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = nil;
    cell = [tableview dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = [tableDataSource objectAtIndex:indexPath.row];
    if (indexPath.row == kCellDeviceAutoLock) {
        BOOL shouldDeviceAutoLock = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldDeviceAutoLock"];

        UIImage *autoLockImage = nil;
        
        if(shouldDeviceAutoLock){
            autoLockImage = [UIImage imageByAppendingDeviceName:@"btn_on"];
        }else{
         autoLockImage = [UIImage imageByAppendingDeviceName:@"btn_off"];
        }
        
        UIImageView *autoLockStatus = [[UIImageView alloc] initWithImage:autoLockImage];
        cell.accessoryView = autoLockStatus;
        
    }
    else if (indexPath.row == kCellScannerSound){
        
        BOOL enableScannerSound = [[NSUserDefaults standardUserDefaults] boolForKey:@"enableScannerSound"];
        
        UIImage *enableScannerSoundImage = nil;
        
        if(enableScannerSound){
            enableScannerSoundImage = [UIImage imageByAppendingDeviceName:@"btn_on"];
        }else{
            enableScannerSoundImage = [UIImage imageByAppendingDeviceName:@"btn_off"];
        }
        
        UIImageView *enableScannerSoundStatus = [[UIImageView alloc] initWithImage:enableScannerSoundImage];
        cell.accessoryView = enableScannerSoundStatus;
    
    }
    else if (indexPath.row == kCellNotifyNewApp){
        
        BOOL enableUpdates = [[NSUserDefaults standardUserDefaults] boolForKey:@"enableUpdates"];
        
        UIImage *enableUpdatesImage = nil;
        
        if(enableUpdates){
            enableUpdatesImage = [UIImage imageByAppendingDeviceName:@"btn_on"];
        }else{
            enableUpdatesImage = [UIImage imageByAppendingDeviceName:@"btn_off"];
        }
        
        UIImageView *enableUpdatesStatus = [[UIImageView alloc] initWithImage:enableUpdatesImage];
        cell.accessoryView = enableUpdatesStatus;
        
    }
    else if (indexPath.row > kCellNotifyNewApp && indexPath.row < [tableDataSource count]-1-2) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageByAppendingDeviceName:@"arrow_forward"]];
    }
    else{
    
        cell.accessoryView = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableview deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (indexPath.row == -1) {
        BOOL shouldDeviceAutoLock = ![[NSUserDefaults standardUserDefaults] boolForKey:@"shouldDeviceAutoLock"];
        
        [[NSUserDefaults standardUserDefaults] setBool:shouldDeviceAutoLock forKey:@"shouldDeviceAutoLock"];
        
    }
    else if (indexPath.row == 0){
        
        BOOL enableScannerSound = ![[NSUserDefaults standardUserDefaults] boolForKey:@"enableScannerSound"];
       
        [[NSUserDefaults standardUserDefaults] setBool:enableScannerSound forKey:@"enableScannerSound"];
        
    }
    else if (indexPath.row == 1){
        
        BOOL enableUpdates = ![[NSUserDefaults standardUserDefaults] boolForKey:@"enableUpdates"];
        
        [[NSUserDefaults standardUserDefaults] setBool:enableUpdates forKey:@"enableUpdates"];
        if (enableUpdates) {
            
            if ([UIDevice isInternetReachable]) {
                [self checkForNewVersion];
            }
        }
        
    }
    /*
    else if (indexPath.row == 2){
        
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
        NSString *urlString = kPRIVACY_POLICY_LINK;
        NSString *title = [tableDataSource objectAtIndex:indexPath.row];
        
        WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:title];
        webVC.urlString = urlString;
        
        [self.navigationController pushViewController:webVC animated:YES];
        }
    
    }*/
    else if (indexPath.row == 2){
    
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
        NSString *urlString = kABOUT_US_LINK;
        NSString *title = [tableDataSource objectAtIndex:indexPath.row];
        
        WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:title];
        webVC.urlString = urlString;
        
        [self.navigationController pushViewController:webVC animated:YES];
        }
        
    }
    else if (indexPath.row == 3){
    
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
        [self gotoReviews];
        }
    }
    else if (indexPath.row == 4){
        
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
            [self sendFeedback];
        }
    
    }else if (indexPath.row == 5){
    
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
            [self sendBugReport];
        }
    }
    
    
    //[tableview reloadData];
    [tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)checkForNewVersion{
    
    
    NSString *serverURL = VERSION_CHECK_URL;
    NSString *service = @"Version Check";
    
    DLog(@"serverURL %@",serverURL);
    ServerController *server = [[ServerController alloc] initWithServerURL:serverURL forServiceType:service];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Checking for updates...";
    
    [server connectUsingGetMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        
        if (errorString){
            
            DLog(@"Couldn't get app update due to error %@",errorString);
            
            
        }else{
            
            DLog(@"server response %@",serverResponse);
            
            NSDictionary *response = [serverResponse objectAtIndex:0];
            
            
             if (![[response valueForKey:@"Updated"] integerValue]) {
            
            NSString *versionNumber = [response valueForKey:@"version"];
                 NSString *title = [NSString stringWithFormat:@"New version available(%@)",versionNumber];
            NSString *msg = @"Download now ?";

                 NSString *msg1 = [response valueForKey:@"Message"];//@"Thank you for all your support and feedback\n\nIn this version we have tried to incorporate most of them:\n1) Built for performance, lighter and better.. yeah baby !!!!!!\n2) Updated to support legacy and new type of QRCodes\n3) Make an audio QRCode and hear its sweet sound through our inbuilt audio streamer\n4) Make a QRCode for your doc/pdf/excel file and it opens directly in our in built document reader, provides option to share your awesome stuff on fb/twitter/email\n5) Auto update feature, can be turned off from settings\n6) Report a bug with screenshot right from settings screen\n7) Report an issue right from settings screen\n8) Minor quick fixes\n\nDownload now ?";
                 
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:title message:msg1];
            [alert setYESButtonWithBlock:^{
                //Redirect to itunes store
                NSString *appStoreURL = @"https://itunes.apple.com/us/app/cloudqrscan/id699597535?ls=1&mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL]];
            }];
            [alert setNOButtonWithBlock:NULL];
            [alert show];
            
            
        }
        }
        
        
    }];
    
    
    
}


/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    NSString *dateStr = [NSString stringWithUTF8String:__DATE__];
    NSString *timeStr = [NSString stringWithUTF8String:__TIME__];
 
    NSString *dateTime = [NSString stringWithFormat:@"Last build: %@ - %@",dateStr,timeStr];
    
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];//Build
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];//Version
    
    
    NSString *appVersion = [NSString stringWithFormat:@"Version: %@",version];
    
    NSString *server = @"Server: Development";
    
    NSString *strAppInfo = appVersion;
    
    if (kLiveServer) {
        
        server = @"Server: Live";
    }
    
    DLog(@"strAppInfo %@ date %@ time %@",strAppInfo,dateStr,timeStr);
    
    
    [lblAppVersion setText:appVersion];
    [lblAppServer setText:server];
    [lblAppDateTime setText:dateTime];
    
    
    return appInfoVIew;

}
 */

- (void)gotoReviews
{
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // app id from itunesconnect
    NSString *appid = @"699597535";
    str = [NSString stringWithFormat:@"%@%@", str,appid];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)sendBugReport
{
    IQFeedbackView *bugReport = [[IQFeedbackView alloc] initWithTitle:@"Bug Report" message:nil image:nil cancelButtonTitle:@"Cancel" doneButtonTitle:@"Send"];
    [bugReport setCanAddImage:YES];
    [bugReport setCanEditText:YES];
    
    [bugReport showInViewController:self completionHandler:^(BOOL isCancel, NSString *message, UIImage *image) {
    
        if (!isCancel) {
        if ([message.trim length] || image) {
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
            
            UIView *vw = [UIApplication sharedApplication].windows.lastObject;
            
            NSString *serverURL = BUGREPORT_URL;
            
            NSMutableDictionary *postParams = [NSMutableDictionary new];
            
            [postParams setObject:@"" forKey:@"ImageData"];
            [postParams setObject:@"" forKey:@"Message"];
            
            if (image) {
            
            NSString *imageData = [UIImagePNGRepresentation(image) base64EncodedString];
            
                [postParams setObject:imageData forKey:@"ImageData"];
            }
            
            if ([message.trim length]) {
            
                [postParams setObject:message.trim forKey:@"Message"];
            }
            
            
            ServerController *server = [[ServerController alloc] initWithServerURL:serverURL andPostParameter:postParams forServiceType:@"BugReport"];
            
            if (![UIDevice isiPhone5]) [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText = @"Sending bug report...";
            else [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Sending bug report...";

            
            [server connectUsingPostMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
                
                if (![UIDevice isiPhone5]) [MBProgressHUD hideAllHUDsForView:vw animated:YES];
                else [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                
                if (errorString) {
                    
                    NSString *msg = errorString;
                    
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
                    [alert setDismissButtonRedWithBlock:NULL];
                    [alert show];
                    
                }
                else{
                    DLog(@"response %@",serverResponse);
                    NSString *response = [[NSDictionary dictionaryWithDictionary:serverResponse] valueForKey:@"Message"];
                    if ([response isEqualToString:@"Success"]) {
                        
                        NSString *title = @"Hey Thanks a ton";
                        NSString *msg = @"Treat yourself with a cookie";
                        
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:title message:msg];
                        [alert setOKButtonWithBlock:^{
                            
                            [bugReport dismiss];
                        }];
                        
                        [alert show];
                    }
                    else{
                    
                        NSString *msg = @"Please try again";
                        
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
                        [alert setDismissButtonRedWithBlock:NULL];
                        [alert show];

                    
                    }
                }
                
            }];
            
            
        }
    }
        else{
        
            NSString *msg = @"Please enter bug description or an image";
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
            
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            [alert show];
        }
    }
        else{

            [bugReport dismiss];
        }
     
    }];
}

- (void)sendFeedback
{
    IQFeedbackView *feedback = [[IQFeedbackView alloc] initWithTitle:@"Feedback" message:nil image:nil cancelButtonTitle:@"Cancel" doneButtonTitle:@"Send"];
    [feedback setCanAddImage:NO];
    [feedback setCanEditText:YES];
    
    [feedback showInViewController:self completionHandler:^(BOOL isCancel, NSString *message, UIImage *image) {
        
        if (!isCancel) {
        
        if ([message.trim length]) {
            
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
            
            UIView *vw = [UIApplication sharedApplication].windows.lastObject;
            NSString *serverURL = FEEDBACK_URL;
            
            NSDictionary *postParams = [NSDictionary dictionaryWithObject:message.trim forKey:@"Message"];
            
            ServerController *server = [[ServerController alloc] initWithServerURL:serverURL andPostParameter:postParams forServiceType:@"Feedback"];
            
            if (![UIDevice isiPhone5]) [MBProgressHUD showHUDAddedTo:vw animated:YES].detailsLabelText = @"Sending feedback...";
            else [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Sending feedback...";
            
            [server connectUsingPostMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
            
                if (![UIDevice isiPhone5]) [MBProgressHUD hideAllHUDsForView:vw animated:YES];
                else [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
               
                if (errorString) {
                    
                    DLog(@"error %@",errorString);
                    
                    NSString *msg = errorString;
                    
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
                    [alert setDismissButtonRedWithBlock:NULL];
                    [alert show];

                    
                }else{
                
                    DLog(@"res %@",serverResponse);
                    NSString *response = [[NSDictionary dictionaryWithDictionary:serverResponse] valueForKey:@"Message"];
                    
                    if ([response isEqualToString:@"Success"]) {
                        
                    
                    NSString *msg = @"Thanks for your feedback";
                    
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
                    [alert setOKButtonWithBlock:^{
                        
                        [feedback dismiss];
                    }];
                    
                    [alert show];
                
                }
                    else {
                    
                        NSString *msg = @"Please try again";
                        
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
                        [alert setDismissButtonRedWithBlock:NULL];
                        [alert show];
                    }
                }
            }];
            
            
            
        }
        }
        else{
            
            NSString *msg = @"Please enter your feedback";
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
            
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            [alert show];
        
        }
        }
        else{
            
            [feedback dismiss];
        }
        
    }];
}

-(void)sendDataToServerWithMsg:(NSString *)message andImage:(UIImage *)image{

    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
