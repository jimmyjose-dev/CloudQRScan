//
//  SelectionViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/06/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "SelectionViewController.h"
#import "EGOImageView.h"
#import "CustomTableViewCell.h"
#import "DocumentViewController.h"
#import "QRProfileViewController.h"

#import "EGO/Libraries/EGOPhotoViewer/EGOPhotoGlobal.h"
#import "EGO/Model/MyPhoto.h"
#import "EGO/Model/MyPhotoSource.h"
#import "VideoController.h"


@interface SelectionViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,EGOImageViewDelegate,CustomTableViewCellDelegate>
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@end

@implementation SelectionViewController

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
    
    
//    [self setHidesBottomBarWhenPushed:YES];
    
    // this will hide the Tabbar
    //[self.tabBarController.tabBar setHidden:YES];
    //[self.navigationController setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController setToolbarHidden:YES];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    [app.navigationController setToolbarHidden:YES];
    [app.navigationController setHidesBottomBarWhenPushed:YES];
    
}

-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.dataSource = self;
    _tableView.delegate = self;

    
    [_tableView reloadData];
    
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error{
  
    UIImage *image = nil;
    if ([_type isEqualToString:@"People"]) {
    
        image = [UIImage imageByAppendingDeviceName:@"icon_profile"];
    }
    
  
    [imageView setImage:image];
  
    
}



-(void)imageViewLoadedImage:(EGOImageView *)imageView{
    
  //  [profileParser setImageDataFromImage:imageView.image];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;//[CustomTableViewCell heigthForCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_tableDataArray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId = @"CustomTableViewCell";//[NSString stringWithFormat:@"cell_%d",indexPath.section];//@"CustomTableViewCell";//
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        
    }
    
    [cell setDelegate:self];
    
    [cell.imgVW setDelegate:self];
    
    
    NSString *titleText = nil;
    UIImage *image = nil;
    if ([_type isEqualToString:@"Documents"]) {
        
        titleText = [[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"DocumentName"];
        
        image =[UIImage imageByAppendingDeviceName:[NSString stringWithFormat:@"docuicon_%@", [[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"FileExt"]]];
        
        NSString *deviceName = @"_iPhone";
        if ([UIDevice isiPad]) {
            deviceName = @"_iPad";
        }
        
        NSString *fileName = [NSString stringWithFormat:@"docuicon_%@%@", [[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"FileExt"],deviceName];
        
         NSString *fullPathToFile = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"%@.png", fileName] ofType: nil];
        
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile];
        
        if (!exists) {
            image = [UIImage imageByAppendingDeviceName:@"docuicon_common"];
            
        }
        
        [cell.imgVW setImage:image];
        
    }
    if ([_type isEqualToString:@"Chat"]) {
        
        
        
        titleText = [[[_tableDataArray objectAtIndex:indexPath.row] allValues] objectAtIndex:0];
        image =[UIImage imageByAppendingDeviceName:[NSString stringWithFormat:@"chaticon_%@", [[[_tableDataArray objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]]];
        [cell.imgVW setImage:image];
    }
    
    
    if ([_type isEqualToString:@"SocialMedia"]) {
        
        titleText = [[[_tableDataArray objectAtIndex:indexPath.row] allValues] objectAtIndex:0];
        
        image =[UIImage imageByAppendingDeviceName:[NSString stringWithFormat:@"btn_%@", [[[_tableDataArray objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]]];
        [cell.imgVW setImage:image];
    }
    
    
    if ([_type isEqualToString:@"Evernote"]) {
        
        titleText = [[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"Title"];
        image =[UIImage imageByAppendingDeviceName:@"icon_evernote"];
        [cell.imgVW setImage:image];
    }
    
   
    
    if ([_type isEqualToString:@"Gallery"]) {
        
        titleText = [[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"GalleryName"];
        
       
        
        [cell.imgVW setImageURL:[NSURL URLWithString:[[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"CoverPhotoURL"]]];
    }
    
    
    if ([_type isEqualToString:@"Youtube"]) {
       
        titleText = [[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"YoutubeTitle"];
        
        image =[UIImage imageByAppendingDeviceName:@"icon_youtube"];
        
        [cell.imgVW setImage:image];
    }
    
    if ([_type isEqualToString:@"People"]) {
        
        titleText = [[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"FullName"];
        
        [cell.imgVW setImageURL:[NSURL URLWithString:[[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfileImage"]]];
    }
   
   
    
    [cell.title setText:titleText];
    
        
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    
    if (_aSelector.length) {

        id object = [_tableDataArray objectAtIndex:indexPath.row];
        SEL selector = NSSelectorFromString(_aSelector);

        [self performSelector:selector withObject:object];
    }
    
    }
    
}

-(void)showSelectedMessengerFromObject:(id)object{

    NSString *messengerValue = [[object allValues] objectAtIndex:0];
    NSString *typeName =[[object allKeys] objectAtIndex:0];
    
    NSString *messengerString = nil;
    
    if ([typeName isEqualToString:@"Skype"]) {
        messengerString = [NSString stringWithFormat:@"skype:%@?call",messengerValue];
    }else if ([typeName isEqualToString:@"Gtalk"]){
     
        messengerString = [NSString stringWithFormat:@"gtalk:call?jid=%@",messengerValue];
    
    }else if ([typeName isEqualToString:@"Yahoo"]){
    //messengerString = [NSString stringWithFormat:@"yahoo://",messengerValue];
    messengerString = [NSString stringWithFormat:@"yahoo://"];
        
    }
    else if ([typeName isEqualToString:@"Aim"]){
    //messengerString = [NSString stringWithFormat:@"aim://",messengerValue];
    messengerString = [NSString stringWithFormat:@"aim://"];
        
    }
    
    
    NSURL *url = [NSURL URLWithString:messengerString];
    
    if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
    
        [[UIApplication sharedApplication] openURL:url];
    }else{
    
        NSString *msg = [NSString stringWithFormat:@"%@ is not installed",[typeName capitalizedString]];
        BlockAlertView *alert =[BlockAlertView alertWithTitle:nil message:msg];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:nil];
        [alert show];
    
    }
    

    
}


-(void)showSelectedProfileFromObject:(id)object{
    
    NSString * qrCodeResult = [object valueForKey:@"ProfileId"];
   // QRProfileViewController *qrProfileViewController = [[QRProfileViewController alloc] initWithNibName:[NSString stringWithFormat:@"QRProfileViewController_%@",[UIDevice currentDeviceName]] withQRCode:qrCodeResult bundle:nil andQRCodeImage:nil];
    
    //[self.navigationController pushViewController:qrProfileViewController animated:YES];
    
    
    NSString *profileID = qrCodeResult;
    
    NSString *serverURL = PROFILE_DATA_URL(profileID);
    NSString *service = kServiceQRProfile;
    
    ServerController *server = [[ServerController alloc] initWithServerURL:serverURL forServiceType:service];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Fetching user data";
    [MBProgressHUD HUDForView:self.navigationController.view].labelText = @"QR Profile";
    
    [server connectUsingGetMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        if (errorString){
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:errorString];
            [alert setDestructiveButtonWithTitle:@"Please try again" block:nil];
            [alert show];
            
        }else{
            
            QRProfileViewController *qrProfileViewController = [[QRProfileViewController alloc] initByAppendingDeviceName];
            NSDictionary *serverResponseDictionary = (NSDictionary *)([(NSArray *)serverResponse objectAtIndex:0]);
            qrProfileViewController.serverResponse = [NSDictionary dictionaryWithDictionary:serverResponseDictionary];
            qrProfileViewController.qrCodeImage = nil;
            [self.navigationController pushViewController:qrProfileViewController animated:YES];
            
        }
        
        
    }];
    
    
}

-(void)showSelectedDocumentFromObject:(id)object{

    NSString *documentURL = [object valueForKey:@"DocumentURL"];
    NSString *title = [object valueForKey:@"DocumentName"];

    DocumentViewController *documentVC = [[DocumentViewController alloc] initByAppendingDeviceNameWithTitle:title];
    documentVC.documentURLString = documentURL;
    
    [self.navigationController pushViewController:documentVC animated:YES];
    

}

-(void)showSelectedSocialMediaFromObject:(id)object{
    
    NSString *urlString = [[object allValues] objectAtIndex:0];
    NSString *title = [[object allKeys] objectAtIndex:0];
    
    WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:title];
    webVC.urlString = urlString;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}

-(void)showSelectedEvernoteFromObject:(id)object{
    
    NSString *urlString = [object valueForKey:@"Link"];
    NSString *title = [object valueForKey:@"Title"];
    
    WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:title];
    webVC.urlString = urlString;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}



-(void)showSelectedGalleryFromObject:(id)object{

    NSDictionary *galleryDict =  object;
    
    NSMutableArray *photoSet = [[NSMutableArray alloc] init];
    
    int size = [[galleryDict valueForKey:@"GalleryImages"] count];
    if (size) {
        
        for (int i =0; i<size; ++i) {
           
            NSString *imageName = [[[galleryDict valueForKey:@"GalleryImages"] objectAtIndex:i] valueForKey:@"ImageName"];
            NSString *imageURlStr= [[[galleryDict valueForKey:@"GalleryImages"] objectAtIndex:i] valueForKey:@"ImageNameURL"];
            //NSLog(@"imagename %@ imageURL %@",imageName,imageURlStr);
            
            NSURL *imgUrl = [[NSURL alloc] initWithString:imageURlStr];
            
            MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:imgUrl name:imageName];
            [photoSet addObject:photo];
            
        }
        
        NSString *title = [galleryDict valueForKey:@"GalleryName"];
        DLog(@"Gallery title %@",title);
        MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:photoSet];
        
        EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source andTitle:title];
        
        photoController.title = title;
        
        [self.navigationController pushViewController:photoController animated:YES];
}
    else{
    
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Gallery has no images"];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
    
    }

}

-(void)showSelectedVideoFromObject:(id)object{

    NSString *videoLink = [object valueForKey:@"YoutubeLink"];
    
    videoLink = [videoLink stringByReplacingOccurrencesOfString:@"http://www.youtube.com/embed/" withString:@""];
    videoLink = [videoLink stringByReplacingOccurrencesOfString:@"https://www.youtube.com/embed/" withString:@""];
    
    videoLink = [videoLink stringByReplacingOccurrencesOfString:@"https://www.youtube.com/watch?v=" withString:@""];

    videoLink = [videoLink stringByReplacingOccurrencesOfString:@"http://www.youtube.com/watch?v=" withString:@""];

    
    VideoController *videoController = [[VideoController alloc] initWithVideoLink:videoLink];
   // [videoController playYouTubeVideo:videoLink];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
