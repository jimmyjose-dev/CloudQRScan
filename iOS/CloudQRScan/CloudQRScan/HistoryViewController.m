//
//  HistoryViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 18/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryDetailViewController.h"
//#import "CustomTableViewCell.h"
#import "CustomTableViewCellWithSubHeading.h"
#import "ODRefreshControl.h"
#import "LoginViewController.h"
#import "HistoryManager.h"
#import "ViewController.h"
#import "ALPickerView.h"
#import "HistoryParser.h"

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate,ALPickerViewDelegate,UISearchBarDelegate>
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSArray *tableDataArray;
@property(nonatomic,retain) NSArray *heading;
@property(nonatomic,retain) NSArray *subHeading;
@property(nonatomic,retain) NSArray *imageArray;
@property(nonatomic,retain) NSArray *valueArray;
@property(nonatomic,retain) NSDictionary *dictHistory;
@property(nonatomic,retain) NSDictionary *dictQRProfile;
@property(nonatomic,retain) NSDictionary *dictQRProduct;
@property(nonatomic,retain) NSDictionary *dictQRLocker;
@property(nonatomic,retain) NSMutableDictionary *dictFilter;
@property(nonatomic,retain) ViewController *viewController;
@property(nonatomic,assign) BOOL shouldReloadDB;
@property(nonatomic,assign) BOOL activeState;

@property(nonatomic,retain) NSArray *entries;
@property(nonatomic,retain) NSMutableDictionary *selectionStates;

@property(nonatomic,retain) ALPickerView *pickerView;
@property(nonatomic,retain) IBOutlet UIView *pickerMainView;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic,retain) IBOutlet UISearchBar *searchbar;
@property(nonatomic,retain) UIView *disableViewOverlay;
@property(nonatomic,retain) BlockAlertView *alertLogin;

//@property(nonatomic,retain) HistoryDetailViewController *historyDetailVC;


@end

@implementation HistoryViewController
@synthesize heading,subHeading,imageArray,valueArray,dictHistory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    _tableView.contentOffset = CGPointMake(0, _searchbar.size.height);
    _tableView.tableHeaderView = _searchbar;
    _searchbar.delegate = self;
    
    [super viewWillAppear:animated];
    
    [Flurry logEvent:@"History View" timed:YES];

    UIImage *backButtonImage = [UIImage imageByAppendingDeviceName:@"btn_back"];
    
    CGRect backButtonFrame = CGRectZero;
    backButtonFrame.origin.x += 5;
    backButtonFrame.size = backButtonImage.size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:backButtonFrame];
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = back;
    
    /*
    UIImage *userButtonImage = [UIImage imageByAppendingDeviceName:@"btn_user_top"];
    
    if ([self isUserActive]) {
        userButtonImage = [UIImage imageByAppendingDeviceName:@"btn_user_top_logged"];
    }
    
    CGRect userButtonFrame = CGRectZero;
    //userButtonFrame.origin.x += 5;
    userButtonFrame.size = userButtonImage.size;
    
    UIButton *userButton = [[UIButton alloc] initWithFrame:userButtonFrame];
    [userButton setImage:userButtonImage forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(userLoginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *userBarButton = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    //self.navigationItem.rightBarButtonItem = userBarButton;
    */
    
    [self setRightBarButtonWithStateActive:NO];
    
    CGRect frame = _tableView.frame;
    
    frame.origin.y = 0;
    
    
    //ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
    //[refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    /*
   
    if (![self isUserActive]) {
        [self userNotSignedIn];
        frame.origin.y = 44;
    }else{
        [self userSignedIn];
        frame.origin.y = 0;
        ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
        [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }*/
    
    _tableView.frame = frame;
    
   // if(!_shouldReloadDB){
    
        [self loadHistoryData];
    //}
     
    
}

-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    [moreButton addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = moreBarButton;
    
/*
    UIImage *userButtonImage = [UIImage imageByAppendingDeviceName:@"btn_user_top"];
    
    if ([self isUserActive]) {
        userButtonImage = [UIImage imageByAppendingDeviceName:@"btn_user_top_logged"];
    }
    
    
    CGRect userButtonFrame = CGRectZero;
    //userButtonFrame.origin.x += 5;
    userButtonFrame.size = userButtonImage.size;
    
    UIButton *userButton = [[UIButton alloc] initWithFrame:userButtonFrame];
    [userButton setImage:userButtonImage forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(userLoginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *userBarButton = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    self.navigationItem.rightBarButtonItems = @[userBarButton,moreBarButton];
    
    CGRect frame = _tableView.frame;
    
    frame.origin.y = 0;
    
    if (![self isUserActive]) {
        [self userNotSignedIn];
        frame.origin.y = 44;
    }else{
        [self userSignedIn];
        frame.origin.y = 0;
        ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
        [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }
 */
    
    //[_optionsView setHidden:!state];
    
    _activeState = state;
    //[_tableView setUserInteractionEnabled:!state];
    
    if (!state) {
        if ([_disableViewOverlay isDescendantOfView:self.view]) {
        
            [_disableViewOverlay removeFromSuperview];
        }
        _tableView.allowsSelection = YES;
        _tableView.scrollEnabled = YES;
       
    } else {

        [_searchbar resignFirstResponder];
        _tableView.contentOffset = CGPointMake(0, _searchbar.size.height);
        // the if condition doesnt make sense now... but i will let it be here
        if (_tableView.contentOffset.y == _searchbar.size.height) {
            _disableViewOverlay.y = 0.0;
        }else{
        
            _disableViewOverlay.y = 44.0;
        }
        
        self.disableViewOverlay.alpha = 0;
        if (![_disableViewOverlay isDescendantOfView:self.view]) {
            [self.view addSubview:self.disableViewOverlay];
        }
		
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5];
        _disableViewOverlay.alpha = 0.6;
        [UIView commitAnimations];
    }
    
    if (state) {
        
        [self.view addSubview:_pickerMainView];
        _pickerMainView.y = 200;
        _pickerView = [[ALPickerView alloc] initWithFrame:CGRectMake(0, 244, 0, 0)];
        _pickerView.delegate = self;
        [self.view addSubview:_pickerView];
        
    }
    else{
    
        if ([_pickerView isDescendantOfView:self.view]) {
            [_pickerView removeFromSuperview];
            [_pickerMainView removeFromSuperview];
        }
    }
    
    
}

-(IBAction)doneButtonPressed:(id)sender{

    [self loadFilteredDB];
    [self setRightBarButtonWithStateActive:NO];
}

-(void)moreButtonPressed{
    
    [self setRightBarButtonWithStateActive:!_activeState];
    
}

-(void)loadFilteredDB{

    NSArray *keyFilter =[_selectionStates allKeysForObject:[NSNumber numberWithBool:YES]];
    
    if ([keyFilter count] && [keyFilter count]!= [[_selectionStates allKeys] count]) {
    
    NSMutableArray *tempHeadingArray = [NSMutableArray new];
    NSMutableArray *tempSubHeadingArray = [NSMutableArray new];
    NSMutableArray *tempImageArray = [NSMutableArray new];
    NSMutableArray *tempValueArray = [NSMutableArray new];
   
    [self setHistoryData];
    
    int size = [subHeading count];
    for (int idx =0; idx<size ; ++idx) {
        
        NSString *key = [subHeading objectAtIndex:idx];
        
        if ([[_selectionStates valueForKey:key] integerValue]) {

            [tempHeadingArray addObject:[heading objectAtIndex:idx]];
            [tempSubHeadingArray addObject:[subHeading objectAtIndex:idx]];
            [tempImageArray addObject:[imageArray objectAtIndex:idx]];
            [tempValueArray addObject:[valueArray objectAtIndex:idx]];
            
        }
        
    }
    
    heading = [NSArray arrayWithArray:tempHeadingArray];
    subHeading = [NSArray arrayWithArray:tempSubHeadingArray];
    imageArray = [NSArray arrayWithArray:tempImageArray];
    valueArray = [NSArray arrayWithArray:tempValueArray];

    [_tableView reloadData];
    
    }else{
    
        [self loadHistoryData];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [Flurry endTimedEvent:@"History View" withParameters:nil];
    [self removeSignInImageView];
}

-(void)removeSignInImageView{

    [[self.navigationController.view viewWithTag:kSignInImageViewTag] removeFromSuperview];

}

-(void)loadHistoryData{

    //DDLogCWarn(@"%s",__func__);
    
    [self setHistoryData];
    
    [_tableView reloadData];
    

}

-(void)setHistoryData{

    HistoryManager *historyManager = [[HistoryManager alloc] init];
    
    dictHistory = [NSDictionary dictionaryWithDictionary:[historyManager getDBData]];
    
    heading = [dictHistory objectForKey:@"temphead"];
    subHeading = [dictHistory objectForKey:@"tempsub"];
    imageArray = [dictHistory objectForKey:@"tempimage"];
    valueArray = [dictHistory objectForKey:@"value"];
    _dictQRProfile = [dictHistory objectForKey:@"qrprofile"];
    _dictQRProduct = [dictHistory objectForKey:@"qrproduct"];
    _dictQRLocker = [dictHistory objectForKey:@"qrlocker"];
    
    
    
}

-(void)userLoginButtonPressed{

    /*if ([self isUserActive]) {
     
        BlockAlertView *alert = [BlockAlertView alertWithTitle:Nil message:@"You are already logged in."];
        [alert setOKButtonWithBlock:NULL];
        [alert show];
        
    }else{
     */
    LoginViewController *loginVC = [[LoginViewController alloc] initByAppendingDeviceNameWithTitle:@"Sign In"];
    
    [self.navigationController pushViewController:loginVC animated:YES];
    //}
}

-(BOOL)isUserActive{

    BOOL userActive = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserActiveKey]) {
        userActive = [[NSUserDefaults standardUserDefaults] boolForKey:kUserActiveKey];
    }
    
    return userActive;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewController = [[ViewController alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    _tableDataArray = [NSArray arrayWithObjects:@"First",@"Second", nil];
    _searchbar.delegate = self;
    
    _disableViewOverlay = [[UIView alloc]
                               initWithFrame:CGRectMake(0.0f,_searchbar.size.height,320.0f,650.0f)];
    _disableViewOverlay.backgroundColor=[UIColor blackColor];
    _disableViewOverlay.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnDisabledView:)];
    [tap setNumberOfTapsRequired:1];
    [_disableViewOverlay addGestureRecognizer:tap];
    
    _shouldReloadDB = YES;
    
    _dictFilter = [NSMutableDictionary new];
    [self setHistoryData];
    
  //  [_toolbar setBarStyle:UIBarStyleBlackTranslucent];
    UIImage *toolbarImage = [UIImage imageNamed:@"bg_toolbar"];
    [_toolbar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
   // [_toolbar setBackgroundColor:_pickerView.backgroundColor];
    
    NSSet *values = [NSSet setWithArray:subHeading];
    _entries = [[values allObjects] sortedArrayUsingSelector:@selector(compare:)];
    _selectionStates = [NSMutableDictionary new];
    for (NSString *key in _entries)
        [_selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
    
  
}

-(void)tappedOnDisabledView:(UITapGestureRecognizer *)sender{

    [_searchbar resignFirstResponder];
    _tableView.contentOffset = CGPointMake(0, _searchbar.size.height);
    if ([_pickerView isDescendantOfView:self.view]) {
        [_pickerView removeFromSuperview];
        [_pickerMainView removeFromSuperview];
    }
    
    if ([_disableViewOverlay isDescendantOfView:self.view]) {
        [_disableViewOverlay removeFromSuperview];
    }

}

-(void)userNotSignedIn{

    UIImage *signInImage = [UIImage imageByAppendingDeviceName:@"login_to_sync"];
    UIImageView *signInImageView = [[UIImageView alloc] initWithImage:signInImage];
    CGRect frame = signInImageView.frame;
    frame.origin.x = floor(self.view.frame.size.width / 2)-40;
    frame.origin.y = 30;
    signInImageView.frame = frame;
    signInImageView.tag = kSignInImageViewTag;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.navigationController.navigationBar addSubview:signInImageView];
    [app.navigationController.navigationBar bringSubviewToFront:signInImageView];

}

-(void)userSignedIn{

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *view = [app.navigationController.navigationBar viewWithTag:kSignInImageViewTag];
    if (view) {
        [[app.navigationController.navigationBar viewWithTag:kSignInImageViewTag] removeFromSuperview];
    }

}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    
    if (![self isUserActive]) {
     
        [refreshControl endRefreshing];
        
        if (!_alertLogin) {
            
        _alertLogin = [BlockAlertView alertWithTitle:@"Login to use sync feature" message:@"Login or Sign up now ?"];
        [_alertLogin setNOButtonWithBlock:^{

            _alertLogin = nil;
        }];
        [_alertLogin setYESButtonWithBlock:^{
            _alertLogin = nil;
            [self userLoginButtonPressed];
        }];
        [_alertLogin show];
        }
    }else{
    
    /*
    double delayInSeconds = 3.0;
   
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
        
    });
      */
        
        
        
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
            
            NSDictionary *syncDataDict = [[HistoryManager new] getDBDataForSync];
                
                NSData *postData = [NSJSONSerialization dataWithJSONObject:syncDataDict
                                                                   options:nil
                                                                     error:nil];
                
                NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
                
                NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
                [request setTimeoutInterval:kTimeoutInterval];
                
               NSString *syncDBURLStr = HISTORY_SYNC_URL;
            
                [request setURL:[NSURL URLWithString:syncDBURLStr]];
                
            
                NSLog(@"syncDBURLStr %@",syncDBURLStr);
                NSLog(@"syncDataDict %@",syncDataDict);
                
                [request setHTTPMethod:@"POST"];
                [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                
                [request setHTTPBody:postData];
                
                
                NSString *msg = @"Sync in process....";
                
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText= msg;
                
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
                    
                    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                    if (!error) {
                        DLog(@"%@",[data stringUTF8]);
                        NSError *err = nil;
                        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingAllowFragments error:&err];
                        
                        if (!err) {
                            
                            if ([[response valueForKey:@"sync"] integerValue]) {
                                NSDictionary *syncDBDict = [response valueForKey:@"syncdata"];
                                
                                [self updateDatabaseWithData:syncDBDict];
                                [refreshControl endRefreshing];
                                BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"History synced successfully"];
                                [alert setOKButtonWithBlock:NULL];
                                
                                [alert show];
                                
                            }else{
                            
                                //nothing to sync
                                 [refreshControl endRefreshing];
                                BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"History synced successfully"];
                                [alert setOKButtonWithBlock:NULL];
                                
                                [alert show];
                                
                            }
                            
                                
                        }else{
                        
                            [refreshControl endRefreshing];
                            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:[err localizedDescription]];
                            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
                            
                            [alert show];
                            
                        
                        }
                            
                        
                        
                    }else{
                    
                        [refreshControl endRefreshing];
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:[error localizedDescription]];
                        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
                        
                        [alert show];
                    
                    }
                    
                }];
                
            
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;//[CustomTableViewCell heigthForCell];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [heading count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"CustomTableViewCell";//[NSString stringWithFormat:@"cell_%d",indexPath.section];
    
    CustomTableViewCellWithSubHeading *cell = (CustomTableViewCellWithSubHeading *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCellWithSubHeading" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    NSString *headingCellValue = [heading objectAtIndex:indexPath.row];
    NSString *subHeadingCellValue = [subHeading objectAtIndex:indexPath.row];
   
    
    
    UIImageView *disclosureImageView = [[UIImageView alloc] initWithImage: [UIImage imageByAppendingDeviceName:@"btn_forward"]];
    
    cell.accessoryView = nil;
    
    if ([subHeadingCellValue isEqualToString:@"QRProfile"]) {
        
        int count = [[[_dictQRProfile objectForKey:headingCellValue] valueForKey:@"heading"] count];
        
        if (count>1) headingCellValue = [headingCellValue stringByAppendingFormat:@" (%d)",count];
        cell.accessoryView = disclosureImageView;
        
       
        
    }
    else if ([subHeadingCellValue isEqualToString:@"QRProduct"]) {
        
        int count = [[[_dictQRProduct objectForKey:headingCellValue] valueForKey:@"heading"] count];
        
        if (count>1) headingCellValue = [headingCellValue stringByAppendingFormat:@" (%d)",count];
        cell.accessoryView = disclosureImageView;
        
    }
    else if ([subHeadingCellValue isEqualToString:@"QRLocker"]) {
        
        int count = [[[_dictQRLocker objectForKey:headingCellValue] valueForKey:@"heading"] count];
        
        
        if (count>1) headingCellValue = [headingCellValue stringByAppendingFormat:@" (%d)",count];
        
        cell.accessoryView = disclosureImageView;
        
    }
    else if(![subHeadingCellValue isEqualToString:@"SMS"] && ![subHeadingCellValue isEqualToString:@"Mail"] && ![subHeadingCellValue isEqualToString:@"Phone"] && ![subHeadingCellValue isEqualToString:@"iTunes"]&& ![subHeadingCellValue isEqualToString:@"BBM"]){
    cell.accessoryView = disclosureImageView;
    }
    else{
    
        cell.accessoryView = nil;
    }
    
    UIImage *image = nil;
    
    NSString *imagePath = [imageArray objectAtIndex:indexPath.row];//[NSString stringWithString:[data objectAtIndex:3]];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    
    
    if (fileExists) {
        NSString *errorStr = [[[imagePath lastPathComponent] componentsSeparatedByString:@"_"] objectAtIndex:0];
        
        if (errorStr && [errorStr isEqualToString:@"Error"]) {
           image = [UIImage imageByAppendingDeviceName:@"btn_profile_menu"];
        }else{
            image= [UIImage imageWithContentsOfFile:[imageArray objectAtIndex:indexPath.row]];
        }
    }else {
        image = [UIImage imageByAppendingDeviceName:@"btn_profile_menu"];
    }
    
    
    [cell.imgVW setImage:image];
    [cell.title setText:headingCellValue];
    [cell.subTitle setText:subHeadingCellValue];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"savetodb"];
    
    NSString *qrcodeString = [valueArray objectAtIndex:indexPath.row];
    
    NSString *headingCellValue = [heading objectAtIndex:indexPath.row];
    NSString *subHeadingCellValue = [subHeading objectAtIndex:indexPath.row];
    
    
    if ([subHeadingCellValue isEqualToString:@"QRProfile"]) {
        
        int count = [[[_dictQRProfile objectForKey:headingCellValue] valueForKey:@"heading"] count];
        
        if (count>1) {
            
            HistoryDetailViewController *historyDetailVC = [[HistoryDetailViewController alloc] initByAppendingDeviceNameWithTitle:headingCellValue];
            historyDetailVC.historyDataDict = [_dictQRProfile objectForKey:headingCellValue];
            
            [self.navigationController pushViewController:historyDetailVC animated:YES];
        }
        else{
        
            qrcodeString = [[[_dictQRProfile objectForKey:headingCellValue] valueForKey:@"value"] firstObject];
            //_viewController = [[ViewController alloc] init];
            [_viewController performActionWithQRCode:qrcodeString];
        }
        
    }
    else if ([subHeadingCellValue isEqualToString:@"QRProduct"]) {
        
        
        int count = [[[_dictQRProduct objectForKey:headingCellValue] valueForKey:@"heading"] count];
        
        if (count>1) {
            
            HistoryDetailViewController *historyDetailVC = [[HistoryDetailViewController alloc] initByAppendingDeviceNameWithTitle:headingCellValue];
            historyDetailVC.historyDataDict = [_dictQRProduct objectForKey:headingCellValue];
            
            [self.navigationController pushViewController:historyDetailVC animated:YES];
        }
        else{
            
            qrcodeString = [[[_dictQRProduct objectForKey:headingCellValue] valueForKey:@"value"] firstObject];
            //_viewController = [[ViewController alloc] init];
            [_viewController performActionWithQRCode:qrcodeString];
        }
    }
    else if ([subHeadingCellValue isEqualToString:@"QRLocker"]) {
        
        int count = [[[_dictQRLocker objectForKey:headingCellValue] valueForKey:@"heading"] count];
        
        if (count>1) {
            
            HistoryDetailViewController *historyDetailVC = [[HistoryDetailViewController alloc] initByAppendingDeviceNameWithTitle:headingCellValue];
            historyDetailVC.historyDataDict = [_dictQRLocker objectForKey:headingCellValue];
            
            [self.navigationController pushViewController:historyDetailVC animated:YES];
        }
        else{
            
            qrcodeString = [[[_dictQRLocker objectForKey:headingCellValue] valueForKey:@"value"] firstObject];
            //_viewController = [[ViewController alloc] init];
            [_viewController performActionWithQRCode:qrcodeString];
        }
        
    }
    else{
    
        //_viewController = [[ViewController alloc] init];
        [_viewController performActionWithQRCode:qrcodeString];
    }
    
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *link = [valueArray objectAtIndex:indexPath.row];
    NSString *title = [heading objectAtIndex:indexPath.row];
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:[NSString stringWithFormat:@"Remove %@ from history ?",title]];
    [alert setYESButtonWithBlock:^{
        
        [[HistoryManager new] deleteLink:link];
        [self loadHistoryData];
    }];
    [alert setNOButtonWithBlock:NULL];
    
    [alert show];
    
}


#pragma mark -
#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
	return [_entries count];
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
	return [_entries objectAtIndex:row];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
	return [[_selectionStates objectForKey:[_entries objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
	// Check whether all rows are checked or only one
	if (row == -1)
		for (id key in [_selectionStates allKeys])
			[_selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
	else
		[_selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[_entries objectAtIndex:row]];
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
	// Check whether all rows are unchecked or only one
	if (row == -1)
		for (id key in [_selectionStates allKeys])
			[_selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	else
		[_selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[_entries objectAtIndex:row]];
}



#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever
    // focus is given to the UISearchBar
    // call our activate method so that we can do some
    // additional things when the UISearchBar shows.
    [self searchBar:searchBar activate:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
    searchBar.text=@"";
    [self loadHistoryData];
    [self searchBar:searchBar activate:NO];
    _tableView.contentOffset = CGPointMake(0, _searchbar.size.height);
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Do the search and show the results in tableview
    // Deactivate the UISearchBar
	
    [self searchForText:searchBar.text];
    [self searchBar:searchBar activate:NO];
}

-(void)searchForText:(NSString *)searchText{

    NSMutableArray *tempHeadingArray = [NSMutableArray new];
    NSMutableArray *tempSubHeadingArray = [NSMutableArray new];
    NSMutableArray *tempImageArray = [NSMutableArray new];
    NSMutableArray *tempValueArray = [NSMutableArray new];
    
    [self setHistoryData];
    
    int size = [heading count];
    for (int idx =0; idx<size ; ++idx) {
        
        NSString *headingText = [heading objectAtIndex:idx];
        
        if ([headingText containsString:searchText ignoringCase:YES]) {
            
            [tempHeadingArray addObject:[heading objectAtIndex:idx]];
            [tempSubHeadingArray addObject:[subHeading objectAtIndex:idx]];
            [tempImageArray addObject:[imageArray objectAtIndex:idx]];
            [tempValueArray addObject:[valueArray objectAtIndex:idx]];
            
        }
        
    }
    
    if ([tempHeadingArray count]) {
    
    heading = [NSArray arrayWithArray:tempHeadingArray];
    subHeading = [NSArray arrayWithArray:tempSubHeadingArray];
    imageArray = [NSArray arrayWithArray:tempImageArray];
    valueArray = [NSArray arrayWithArray:tempValueArray];
    
        [_tableView reloadData];
    
    }
    else{
    
        NSString *msg = [NSString stringWithFormat:@"No entry found for '%@'",searchText];
        BlockAlertView *alert = [BlockAlertView alertWithTitle:Nil message:msg];
        [alert setDismissButtonRedWithBlock:NULL];
        [alert show];
                                 
    }
    
}

// We call this when we want to activate/deactivate the UISearchBar
// Depending on active (YES/NO) we disable/enable selection and
// scrolling on the UITableView
// Show/Hide the UISearchBar Cancel button
// Fade the screen In/Out with the disableViewOverlay and
// simple Animations
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active{
    _tableView.allowsSelection = !active;
    _tableView.scrollEnabled = !active;
    if (!active) {
        [_disableViewOverlay removeFromSuperview];
        [searchBar resignFirstResponder];
    } else {
        _disableViewOverlay.y = _searchbar.size.height;
        self.disableViewOverlay.alpha = 0;
        if (![_disableViewOverlay isDescendantOfView:self.view]) {
        [self.view addSubview:self.disableViewOverlay];
        }
		
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5];
        _disableViewOverlay.alpha = 0.6;
        [UIView commitAnimations];
		
        // probably not needed if you have a details view since you
        // will go there on selection
       /*
        NSIndexPath *selected = [_tableView
                                 indexPathForSelectedRow];
        if (selected) {
            [_tableView deselectRowAtIndexPath:selected
                                             animated:NO];
        }
        */
    }
    [searchBar setShowsCancelButton:active animated:YES];
}


-(void)syncDBWithServer{

    
}


-(void)updateDatabaseWithData:(NSDictionary *)dataDict{

    HistoryParser *historyParser = [[HistoryParser alloc] initWithSyncData:dataDict];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Updating Database...";
    
    [historyParser syncData];
    
    [self setHistoryData];

    [_tableView reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
