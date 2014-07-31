//
//  QRProfileViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "QRProfileViewController.h"
#import "CommonHeaders.h"
#import "EGOImageView.h"
#import "UIView+Origami.h"
#import "ProfileParser.h"
#import "CustomTableViewCell.h"
#import "GoogleMapViewController.h"
#import "WebViewController.h"
#import "ProfileTableView.h"
#import "OptionsActiveViewController.h"
#import "LayoutParser.h"
#import "UIViewController+overView.h"
#import "ContactParser.h"
#import "ContactController.h"

#import "DocumentViewController.h"
#import "SelectionViewController.h"
#import "AudioStreamerController.h"

#import "CFShareCircleView.h"
#import "ShareController.h"

#import "HistoryManager.h"

#import "AudioStreamer.h"
#import "ViewController.h"

@interface QRProfileViewController ()<NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate,ProfileTableViewDelegate,EGOImageViewDelegate,ContactControllerDelegate,CFShareCircleViewDelegate,AudioDelegate>{

    long long bytesReceived;
    long long expectedBytes;
    
    float percentComplete;
    float progress;
   
    MBProgressHUD *HUD;
    NSTimeInterval start;
    
    int folds;
    float duration;
    ProfileParser *profileParser;
    int cellIndexInCurrentView;
    int selectedIndex;
    
    ContactController *contactController;
    BOOL shouldReset;
    
    BOOL setBackButton;
    
    BOOL isPlaying;
    
    NSMutableDictionary *flurryQRProfileUserInfo;
    BOOL toggleAnimation;

}

@property (nonatomic, strong) IBOutlet UIView *scanDetailsView;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIButton *mapButton;
@property (nonatomic, strong) IBOutlet UIButton *callButton;
@property (nonatomic, strong) IBOutlet UIButton *websiteButton;
@property (nonatomic, strong) IBOutlet UIImageView *shareOrBackImageView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *companyLabel;
@property (nonatomic, strong) IBOutlet EGOImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UIView *optionsView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *scandetailLabel;
@property (nonatomic, strong) NSMutableData *responseData;
//@property (nonatomic, strong) NSString *profileID;
@property (nonatomic, strong) NSArray *tableDataArray;
@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, retain) IBOutlet ProfileTableView *tableView;
@property (nonatomic, retain) OptionsActiveViewController *optionsAtiveVC;
@property (nonatomic, retain) AudioStreamerController *audioStreamer;
@property (nonatomic, retain) CFShareCircleView *shareCircleView;
@property (nonatomic, retain) ShareController *shareController;
//@property (nonatomic, retain) AudioStreamer *audio;


@end

@implementation QRProfileViewController
@synthesize scanDetailsView,optionsView,responseData,optionsAtiveVC;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        profileParser = [[ProfileParser alloc] init];
       
        _profileImageView.delegate = self;
        cellIndexInCurrentView = 0;
        selectedIndex = -1;
       
                
    }
    return self;
}


-(void)initOrigami{

    
    if ([scanDetailsView isDescendantOfView:self.view]) {
        [scanDetailsView removeFromSuperview];
        }
    
    if ([optionsView isDescendantOfView:self.view]) {
        [optionsView removeFromSuperview];
    }
    
    [self.view addSubview:scanDetailsView];
    [self.view addSubview:optionsView];
    
    
    
    folds = 1;
    duration = 0.4;
    
    
    
    [optionsView showOrigamiTransitionWith:scanDetailsView
                             NumberOfFolds:0
                                  Duration:0.0
                                 Direction:XYOrigamiDirectionFromLeft
                                completion:^(BOOL finished) {
                                    [scanDetailsView setHidden:NO];
                                }];

}

-(void)resetAudio{

    isPlaying = NO;
    if (_audioStreamer) {
        if ([_audioStreamer isAudioPlaying]) {
            [_audioStreamer stopAudio];
            _audioStreamer = nil;
        }
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self logForFlurry];
    
    UIFont *font = [UIFont fontWithName:kHeaderFont size:kHeaderFontSize];
    
    [_nameLabel setFont:font];
    [_scandetailLabel setFont:font];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    
    [self resetAudio];
    toggleAnimation = NO;
    
    /*
    _shareController = [[ShareController alloc] initWithImage:_qrCodeImage];
    
   
    setBackButton = NO;
    UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_share"];
    if (!_qrCodeImage || [_qrCodeImage isEqual:[NSNull null]]) {
        
        image = [UIImage imageByAppendingDeviceName:@"btn_back"];
    
        setBackButton = YES;
    }
    
    [_shareOrBackImageView setImage:image];
    
    */
    //[self resetView];
   
    //[self initOrigami];
    //[_optionsButton setEnabled:YES];
    
    
    
    if (shouldReset) {
        shouldReset = !shouldReset;
    }
    else{
        //[optionsView setHidden:YES];
       // [self optionsButtonPressed:nil];
    }
     
    
    [[self.navigationController navigationBar] setHidden:YES];

}


-(void)viewWillDisappear:(BOOL)animated{

    
    [super viewWillDisappear:animated];
    
    [Flurry endTimedEvent:@"QRProfile" withParameters:nil];
    
    [self resetAudio];
    
    shouldReset = YES;
    
    if ([self shouldWriteToDB]) {
        UIImage *image = [UIImage imageByAppendingDeviceName:@"icon_profile_iPhone"];
        NSData *imageData = UIImagePNGRepresentation(image);
        
        [self saveToHistoryWithImageData:imageData hasError:YES];
    }
    
    //[[self.navigationController navigationBar] setHidden:NO];
    [[self.navigationController navigationBar] setHidden:NO];
}


-(IBAction)shareButtonPressed:(id)sender{
    
    if (setBackButton) {
    
        [self backButtonPressed];
    }else{
    
        [Flurry logEvent:@"Sharing Started"];
        toggleAnimation = !toggleAnimation;
        if (toggleAnimation) [_shareCircleView animateIn];
        else [_shareCircleView animateOut];

    }
}

-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

-(IBAction)optionsButtonPressed:(id)sender{

   
    [optionsView setHidden:NO];
    [optionsView hideOrigamiTransitionWith:scanDetailsView
                             NumberOfFolds:folds
                                  Duration:duration
                                 Direction:XYOrigamiDirectionFromLeft
                                completion:^(BOOL finished) {
                                    [scanDetailsView setHidden:YES];
                                }];

}

-(IBAction)optionsActiveButtonPressed:(id)sender{
    
    
    [scanDetailsView setHidden:NO];
    [optionsView showOrigamiTransitionWith:scanDetailsView
                             NumberOfFolds:folds
                                  Duration:duration
                                 Direction:XYOrigamiDirectionFromLeft
                                completion:^(BOOL finished) {
                                    [optionsView setHidden:YES];
                                }];
    
}


-(IBAction)histroyButtonPressed:(id)sender{
  
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
    
   // HistoryViewController *historyVC = [[HistoryViewController alloc] initByAppendingDeviceNameWithTitle:@"History"];
    
    //[self.navigationController pushViewController:historyVC animated:YES];


}

-(IBAction)deviceAuthorizationButtonPressed:(id)sender{
    
    DeviceAuthorizationViewController *deviceAuthorizationVC = [[DeviceAuthorizationViewController alloc] initByAppendingDeviceNameWithTitle:kDeviceAuthorizationTitle];
    
    [self.navigationController pushViewController:deviceAuthorizationVC animated:YES];
    

    
}

-(IBAction)cameraButtonPressed:(id)sender{

    //[self.navigationController popViewControllerAnimated:YES];
    
    NSArray *subController = self.navigationController.viewControllers;
    [subController enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        UIViewController *vc = (UIViewController *)obj;
        if ([vc isKindOfClass:[ViewController class]]) {
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popToViewController:vc animated:YES];
            *stop = YES;
        
        }
    }];
}

-(IBAction)createQRCodeButtonPressed:(id)sender{
    
    CreateQRViewController *createQRViewController = [[CreateQRViewController alloc] initByAppendingDeviceNameWithTitle:@"Create QR"];
    
    [self.navigationController pushViewController:createQRViewController animated:YES];
    
}

-(IBAction)settingsButtonPressed:(id)sender{
    
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] initByAppendingDeviceNameWithTitle:@"Settings"];
    
    [self.navigationController pushViewController:settingsVC animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // [self getProfileData];
    
    DLog(@"_serverResponse %@",_serverResponse);
    [self updateGUIWithDictionary:_serverResponse];
    [self initOrigami];
    [_optionsButton setEnabled:YES];
    
    CGRect frame = self.view.frame;
    //frame.origin.y = 20;
    _shareCircleView = [[CFShareCircleView alloc] initWithFrame:frame];
    _shareCircleView.delegate = self;
    [scanDetailsView addSubview:_shareCircleView];
    
    _shareController = [[ShareController alloc] initWithImage:_qrCodeImage];
    
    setBackButton = NO;
    UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_share"];
    if (!_qrCodeImage || [_qrCodeImage isEqual:[NSNull null]]) {

        image = [UIImage imageByAppendingDeviceName:@"btn_back"];
        
        setBackButton = YES;
    }
    
    [_shareOrBackImageView setImage:image];
    
}


- (void)shareCircleView:(CFShareCircleView *)aShareCircleView didSelectSharer:(CFSharer *)sharer {
    DLog(@"Selected sharer: %@", sharer.name);
    
    [Flurry logEvent:@"Sharing Selected" withParameters:[NSDictionary dictionaryWithObject:sharer.name forKey:@"Sharing Via"]];
    
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
    [Flurry logEvent:@"Sharing Canceled"];
}


-(void)updateGUIWithDictionary:(NSDictionary *)userInfoDict{
    
    
    profileParser = [[ProfileParser alloc] initWithUserInfo:userInfoDict];
    
    _nameLabel.text = [[profileParser getUserInfo] valueForKey:@"FullName"];
    _profileImageView.delegate = self;
    [_profileImageView setPlaceholderImage:[UIImage imageByAppendingDeviceName:@"img_profile_loading"]];
    [_profileImageView setImageURL:[[profileParser getUserInfo] valueForKey:@"ImageURL"]];
    
    _companyLabel.text = [[profileParser getCompanyInfo] valueForKey:@"Designation"];
    _userNameLabel.text = [[profileParser getUserInfo] valueForKey:@"FullName"];
    
    
    [self logForFlurry];
    
    NSString *soundFile = [[profileParser getSound] valueForKey:@"Audio"];
    if (soundFile && soundFile.length) {
        [_playButton setHidden:NO];
    }else{
    
        [_playButton setHidden:YES];
    }
    
    [HUD hide:YES afterDelay:2];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.profileTVDelegate = self;
    

    _tableDataArray = [profileParser getDisplayOrder];
    
    [_tableView reloadData];
    
    
    NSArray *loc = [[[profileParser getCompanyInfo] valueForKey:@"MapLocation"] componentsSeparatedByString:@","];
   
    NSString *location = [[profileParser getCompanyInfo] valueForKey:@"MapLocation"];
   
    
    NSString *lat = [[loc firstObject] trim];
    NSString *lon = [[loc lastObject] trim];
    
    if (lat && lat.length && lon && lon.length) [_mapButton setEnabled:YES];
    else [_mapButton setEnabled:NO];
    
    if ([location isEqualToString:@"0.00000,0.00000"]) {
        [_mapButton setEnabled:NO];

    }
    
    
    NSString *callNumber = [[profileParser getUserInfo]valueForKey:@"ContactNumber"];
    
    if (callNumber && callNumber.trim.length && ![UIDevice isiPad]) [_callButton setEnabled:YES];
    else [_callButton setEnabled:NO];
    
    NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [[profileParser getUserInfo]valueForKey:@"ContactNumber"]]];

    if (![[UIApplication sharedApplication] canOpenURL:callURL]) {
        [_callButton setEnabled:NO];
    }
    
    
    NSString *website = [[profileParser getCompanyInfo] valueForKey:@"Website"];
    
    if (website && website.trim.length) [_websiteButton setEnabled:YES];
    else [_websiteButton setEnabled:NO];
    
    
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error{

    [imageView setImage:[UIImage imageByAppendingDeviceName:@"img_default_profile"]];
    [profileParser setImageDataFromImage:imageView.image];

    NSData *imageData = UIImagePNGRepresentation(imageView.image);
    DLog(@"failed to load db");
    [self saveToHistoryWithImageData:imageData hasError:YES];

}

-(void)imageViewLoadedImage:(EGOImageView *)imageView{

    [profileParser setImageDataFromImage:imageView.image];
    
    NSData *imageData = UIImagePNGRepresentation(imageView.image);
    DLog(@"loaded db");
    [self saveToHistoryWithImageData:imageData hasError:NO];
}

-(void)saveToHistoryWithImageData:(NSData *)imageData hasError:(BOOL)hasError{

    NSString *heading = [[profileParser getUserInfo] valueForKey:@"FullName"];
    NSString *subHeading = [[profileParser getCompanyInfo] valueForKey:@"Designation"];
    NSString *type = kHistoryQRProfile;
    NSString *link = _qrCodeString;
    
    NSString *errorStr = @"Error_";
    
    if (!_qrCodeString || [_qrCodeString  isEqual:[NSNull null]]) {
        return;
    }
    
    NSString *accountId = [[profileParser getUserInfo] valueForKey:@"AccountId"];
    
    
    NSString *imageWritePath = [[NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES] path];

    NSString *imagePathName = nil;
    
    if (hasError) {
        imagePathName = [NSString stringWithFormat:@"%@/%@%@_%@.png",imageWritePath,errorStr,kQRProfile,accountId];
    }else{
    
        imagePathName = [NSString stringWithFormat:@"%@/%@_%@.png",imageWritePath,kQRProfile,accountId];
    }
    
    [imageData writeToFile:imagePathName atomically:YES];
    
    [[DBManager new] saveLink:link withHeading:heading subHeading:subHeading type:type andImagePath:imagePathName fromLocation:nil onDate:nil];


}

-(BOOL)shouldWriteToDB{

    BOOL shouldWrite = NO;
    
    /*
    NSString *accountId = [[profileParser getUserInfo] valueForKey:@"AccountId"];
    NSString *imageWritePath = kCacheImagePath;
    NSString *imagePathName = [NSString stringWithFormat:@"%@/%@_%@.png",imageWritePath,kQRProfile,accountId];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePathName]) shouldWrite = YES;
    */
    if (!_qrCodeString || [_qrCodeString  isEqual:[NSNull null]]) {
        shouldWrite = NO;
    }
    
    
    return shouldWrite;

}

-(void)logForFlurry{

    NSString *latitude  = nil;
    NSString *longitude = nil;
    
    if ([[LocationManagerDelegate sharedInstance] hasFoundLocation]) {
        
        latitude = [[LocationManagerDelegate sharedInstance] latitude];
        longitude = [[LocationManagerDelegate sharedInstance] longitude];
    }
    else{
        
        latitude  = @"0";
        longitude = @"0";
    }
    
    NSString *flurryScannedFromLoc = [NSString stringWithFormat:@"%@,%@",latitude,longitude];
    
    
    NSString *flurryName = _userNameLabel.text;
    NSString *flurryAccountId = _profileID;//[[profileParser getUserInfo] valueForKey:@"AccountId"];
    NSString *flurryDesignation = _companyLabel.text;
    
    CLLocation *flurryLocation = [[LocationManagerDelegate sharedInstance] location];
    
    [Flurry setLatitude:flurryLocation.coordinate.latitude
              longitude:flurryLocation.coordinate.longitude
     horizontalAccuracy:flurryLocation.horizontalAccuracy
       verticalAccuracy:flurryLocation.verticalAccuracy];
    
    
    flurryQRProfileUserInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       flurryName,@"Name",
                                       flurryDesignation,@"Designation",
                                       flurryAccountId, @"ProfileID",
                                       flurryScannedFromLoc,@"ScannedFromLocation",nil];
    
    [Flurry logEvent:@"QRProfile" withParameters:flurryQRProfileUserInfo timed:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;//[CustomTableViewCell heigthForCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_tableDataArray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSString *cellId = [NSString stringWithFormat:@"cell_%d",indexPath.section];//@"CustomTableViewCell";//
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
    
        cell = [nib objectAtIndex:0];
    }
    
    NSString *titleText = [_tableDataArray objectAtIndex:indexPath.row];
    
    UIImage *image =(UIImage *)[[profileParser getFeatureNameAndIconDictionary] objectForKey:titleText];
    
    [cell.imgVW setImage:image];
    [cell.title setText:titleText];
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    selectedIndex = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *keyName = [_tableDataArray objectAtIndex:indexPath.row];
    
    NSString *aSelector = [[profileParser getSelectorDictionary] valueForKey:keyName];
    
    [flurryQRProfileUserInfo setValue:keyName forKey:@"Option selected"];
    
    [Flurry logEvent:@"QRProfile option selected" withParameters:flurryQRProfileUserInfo];
    
    SEL selector = NSSelectorFromString(aSelector);
    
    [self performSelector:selector];
    
}

-(void)tableViewTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    int yCord = location.y;
    int tappedOnCell =  yCord / 74;
    cellIndexInCurrentView = tappedOnCell;
    //DLog(@"yCord %d cell number %d selectedIndex %d",yCord,tappedOnCell,selectedIndex);
    
}

-(IBAction)mapButtonPressed:(id)sender{

    [flurryQRProfileUserInfo setValue:@"YES" forKey:@"Map"];
    
    [Flurry logEvent:@"QRProfile Map" withParameters:flurryQRProfileUserInfo timed:YES];
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    
    GoogleMapViewController *googleMapVC = [[GoogleMapViewController alloc] initByAppendingDeviceNameWithTitle:@"Map"];
    
    googleMapVC.name = [[profileParser getUserInfo] valueForKey:@"FullName"];
    googleMapVC.designation = [[profileParser getCompanyInfo] valueForKey:@"Designation"];
    googleMapVC.companyName = [[profileParser getCompanyInfo] valueForKey:@"CompanyName"];
    googleMapVC.latlonString = [[profileParser getCompanyInfo] valueForKey:@"MapLocation"];
    
    [self.navigationController pushViewController:googleMapVC animated:YES];
    
    }
    
}

-(IBAction)callButtonPressed:(id)sender{

    UIWebView *phoneCallWebview = [[UIWebView alloc] init];
    NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [[profileParser getUserInfo]valueForKey:@"ContactNumber"]]];
    [phoneCallWebview loadRequest:[NSURLRequest requestWithURL:callURL]];
    
    [flurryQRProfileUserInfo setValue:@"YES" forKey:@"call"];
    
    [Flurry logEvent:@"QRProfile Call" withParameters:flurryQRProfileUserInfo timed:YES];
    
    [self.view addSubview:phoneCallWebview];

}

-(IBAction)websiteButtonPressed:(id)sender{

    [flurryQRProfileUserInfo setValue:@"YES" forKey:@"website"];
    
    [Flurry logEvent:@"QRProfile Website" withParameters:flurryQRProfileUserInfo timed:YES];
    
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    
    WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:@"Website"];
    
    webVC.urlString = [[profileParser getCompanyInfo] valueForKey:@"Website"];
    
    [self.navigationController pushViewController:webVC animated:YES];
        
    }

}


-(void)contactDetailsButtonPressed{
    
    contactController = [[ContactController alloc] initWithUserInfo:[profileParser getContactInfo]];
    [contactController setDelegate:self];
    [self.navigationController setNavigationBarHidden:NO];
    [contactController displayContactView];
    
   
}

-(void)similarPeopleButtonPressed{

    DLog(@"%@",[profileParser getSimilarPeople]);
    
    SelectionViewController *selectionVC = [[SelectionViewController alloc] initByAppendingDeviceNameWithTitle:@"Team"];
    
    selectionVC.type = @"People";
    selectionVC.aSelector = @"showSelectedProfileFromObject:";
    selectionVC.tableDataArray = [profileParser getSimilarPeople];
    
    
    [self.navigationController pushViewController:selectionVC animated:YES];

    
}

-(IBAction)soundButtonPressed:(id)sender{

    [flurryQRProfileUserInfo setValue:@"YES" forKey:@"audio"];
    
    [Flurry logEvent:@"QRProfile Audio" withParameters:flurryQRProfileUserInfo timed:YES];
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    
    [self soundButton];
        
    }
}

-(void)soundButton{
   
    NSString *audioFilename = [[[profileParser getSound] valueForKey:@"Audio"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (!_audioStreamer) {
    _audioStreamer = [[AudioStreamerController alloc] initWithAudioFileName:audioFilename];
        _audioStreamer.delegate = self;

    }
 
 
    UIImage *buttonImage = nil;
    
   
    DLog(@"state %d",[_audioStreamer isAudioPlaying]);
    if (![_audioStreamer isAudioPlaying]) {
    
        buttonImage = [UIImage imageByAppendingDeviceName:@"btn_pause_top"];
        
        DLog(@"play");
        [_audioStreamer playAudio];
        
        [MMProgressHUD showWithTitle:@"Buffering..."
                              status:@"Double tap to cancel"
                 confirmationMessage:@"Tap to Cancel"
                         cancelBlock:^{
                             DLog(@"Task was cancelled!");
                             [_audioStreamer stopAudio];
                             [self resetAudio];
                             _audioStreamer = nil;
                             UIImage *buttonImage  = [UIImage imageByAppendingDeviceName:@"btn_play_top"];
                             [_playButton setImage:buttonImage forState:UIControlStateNormal];   
                         }];

        
    }
    else{
        
        DLog(@"pause");
        buttonImage = [UIImage imageByAppendingDeviceName:@"btn_play_top"];
    
        @try {
             [_audioStreamer stopAudio];
            [self resetAudio];
            _audioStreamer = nil;
            //[_audioStreamer pauseAudio];
        }
        @catch (NSException *exception) {
            DLog(@"exception in audio %@",[exception debugDescription]);
        }
        @finally {
            
          [_playButton setImage:buttonImage forState:UIControlStateNormal];   
        }
    }
    
    [_playButton setImage:buttonImage forState:UIControlStateNormal];
    
}

-(void)audioPlaying{


    [MMProgressHUD dismiss];
}

-(void)audioError{
    

    [MMProgressHUD dismiss];
    
}

-(void)audioStopped{

    DLog(@"pause");
    UIImage *buttonImage = [UIImage imageByAppendingDeviceName:@"btn_play_top"];
    
    @try {
        [_audioStreamer stopAudio];
        [self resetAudio];
        _audioStreamer = nil;
        //[_audioStreamer pauseAudio];
    }
    @catch (NSException *exception) {
        DLog(@"exception in audio %@",[exception debugDescription]);
    }
    @finally {
        
        [_playButton setImage:buttonImage forState:UIControlStateNormal];
    }
    
}

-(void)sociaMediaButtonPressed{
    
    NSMutableArray *dataArray = [NSMutableArray new];
    
    [[profileParser getSocialMedia] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [dataArray addObject:[NSDictionary dictionaryWithObject:obj forKey:key]];
    }];
    
    
    SelectionViewController *selectionVC = [[SelectionViewController alloc] initByAppendingDeviceNameWithTitle:@"Social Media"];
    
    selectionVC.type = @"SocialMedia";
    selectionVC.aSelector = @"showSelectedSocialMediaFromObject:";
    selectionVC.tableDataArray = dataArray;
    
    
    [self.navigationController pushViewController:selectionVC animated:YES];

}

-(void)instantMessagingButtonPressed{
    
    NSMutableArray *dataArray = [NSMutableArray new];
    
    [[profileParser getInstantMessaging] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [dataArray addObject:[NSDictionary dictionaryWithObject:obj forKey:key]];
    }];
    

    SelectionViewController *selectionVC = [[SelectionViewController alloc] initByAppendingDeviceNameWithTitle:@"Chat"];
    
    selectionVC.type = @"Chat";
    selectionVC.aSelector = @"showSelectedMessengerFromObject:";
    selectionVC.tableDataArray = dataArray;
    
    
    [self.navigationController pushViewController:selectionVC animated:YES];

    
}

-(void)documentsButtonPressed{
    
    SelectionViewController *selectionVC = [[SelectionViewController alloc] initByAppendingDeviceNameWithTitle:@"Documents"];
    
    selectionVC.type = @"Documents";
    selectionVC.aSelector = @"showSelectedDocumentFromObject:";
    selectionVC.tableDataArray = [profileParser getDocuments];
    
    
    [self.navigationController pushViewController:selectionVC animated:YES];
    
    
}

-(void)galleryButtonPressed{
    
    SelectionViewController *selectionVC = [[SelectionViewController alloc] initByAppendingDeviceNameWithTitle:@"Gallery"];
    
    selectionVC.type = @"Gallery";
    selectionVC.aSelector = @"showSelectedGalleryFromObject:";
    selectionVC.tableDataArray = [profileParser getGallery];
    
    
    [self.navigationController pushViewController:selectionVC animated:YES];
}

-(void)evernoteButtonPressed{
    
    SelectionViewController *selectionVC = [[SelectionViewController alloc] initByAppendingDeviceNameWithTitle:@"Evernote"];
    
    selectionVC.type = @"Evernote";
    selectionVC.aSelector = @"showSelectedEvernoteFromObject:";
    selectionVC.tableDataArray = [profileParser getEvernote];
    
    
    [self.navigationController pushViewController:selectionVC animated:YES];

    
}

-(void)videoButtonPressed{
   
    SelectionViewController *selectionVC = [[SelectionViewController alloc] initByAppendingDeviceNameWithTitle:@"YouTube"];
    
    selectionVC.type = @"Youtube";
    selectionVC.aSelector = @"showSelectedVideoFromObject:";
    selectionVC.tableDataArray = [profileParser getVideos];
    
    
    [self.navigationController pushViewController:selectionVC animated:YES];
    
}

-(void)resetView{
    
    shouldReset = YES;
    //[self optionsButtonPressed:nil];
    //[self optionsActiveButtonPressed:nil];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
