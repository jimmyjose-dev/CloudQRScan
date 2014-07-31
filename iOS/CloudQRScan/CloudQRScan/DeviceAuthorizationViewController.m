//
//  DeviceAuthorizationViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 03/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "DeviceAuthorizationViewController.h"
#import "CustomTableViewCell.h"
#import "RequestAuthorizationViewController.h"

@interface DeviceAuthorizationViewController ()<UITableViewDataSource,UITableViewDelegate,EGOImageViewDelegate>
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSArray *tableDataArray;
@end

@implementation DeviceAuthorizationViewController

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
    [Flurry endTimedEvent:@"Device Authorization View" withParameters:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [Flurry logEvent:@"Device Authorization View" timed:YES];
    
    
    [self getAuthorizedDeviceList];
    
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
        
}

-(void)getAuthorizedDeviceList{

    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{
        
        if (!(_tableDataArray && [_tableDataArray count])) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Authorized user list";    
        }
    
        
        
    
    NSString *deviceAuthorizationList = DEVICE_AUTHORIZATION_LIST_URL([UIDevice UDID]);
    DLog(@"deviceAuthorizationList %@",deviceAuthorizationList);
    
    NSURL *deviceAuthorizationListURL = [NSURL URLWithString:deviceAuthorizationList];
    
    /*
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:deviceAuthorizationListURL
                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                              timeoutInterval:kTimeoutInterval];
     */
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:deviceAuthorizationListURL];
    [request setTimeoutInterval:kTimeoutInterval];
        
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        if (!error) {
            
            NSError *err = nil;
            NSArray *responseJSON = [[NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingAllowFragments error:&err] valueForKey:@"AuthoriseProfilesResult"];
            if (!err) {
                
                
                DLog(@"response %@ %@",responseJSON,[data stringASCII]);
                if (![responseJSON count]) {
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"No Authorized device found\nScan QRLocker to register your device"];
                    [alert setDestructiveButtonWithTitle:@"Dismiss" block:^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    [alert show];
                }
                else{
                
                _tableView.dataSource = self;
                _tableView.delegate = self;
                
                _tableDataArray = [NSArray new];
                _tableDataArray = [NSArray arrayWithArray:responseJSON];
                
                [_tableView reloadData];
                    
                }
                
                
                
            }
            else{
                BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:[err localizedDescription]];
                [alert setDestructiveButtonWithTitle:@"Dismiss" block:^{
                
                    if (![_tableDataArray count]) [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }];
                [alert show];
            
            }
            
        }
        else{
        
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:[error localizedDescription]];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:^{
            
                if (![_tableDataArray count]) [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert show];
        }
        
    }];
        
    }

}


- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error{
    
    UIImage *image = nil;
    
    image = [UIImage imageByAppendingDeviceName:@"icon_profile"];
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
    
    NSString *cellId = [NSString stringWithFormat:@"cell_%d",indexPath.section];//@"CustomTableViewCell";//
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        
        [cell.imgVW setDelegate:self];
        UIImage *placeHolderImage = [UIImage imageByAppendingDeviceName:@"icon_profile"];
        [cell.imgVW setPlaceholderImage:placeHolderImage];
       

    }
    

    
    NSString *titleText = [[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"UserName"];
    
    [cell.title setText:titleText];
    [cell.imgVW setDelegate:self];
    [cell.imgVW setImageURL:[NSURL URLWithString:[[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"Avatar"]]];
    
    
    BOOL deviceStatus = [[[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"DeviceStatus"] boolValue];
    
    UIButton *button = nil;
    
    if (!deviceStatus) {
        
        
        UIImage *imageAuthorizeButton = [UIImage imageByAppendingDeviceName:@"btn_authorize"];
        CGRect frame = CGRectMake(0, 0, imageAuthorizeButton.size.width, imageAuthorizeButton.size.height);
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = indexPath.row;
        [button setFrame:frame];
        [button setImage:imageAuthorizeButton forState:UIControlStateNormal];
        [button setShowsTouchWhenHighlighted:YES];
        
        [button addTarget:self action:@selector(authorizeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else {
        
        UIImage *imageAuthorizeButton = [UIImage imageByAppendingDeviceName:@"btn_deauthorize"];
        CGRect frame = CGRectMake(0, 0, imageAuthorizeButton.size.width, imageAuthorizeButton.size.height);
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:frame];
        button.tag = indexPath.row;
        [button setImage:imageAuthorizeButton forState:UIControlStateNormal];
        [button setShowsTouchWhenHighlighted:YES];
       
        [button addTarget:self action:@selector(deauthorizeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    cell.accessoryView = button;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{

    [self performActionForTappedViewAtPath:indexPath];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self performActionForTappedViewAtPath:indexPath];
}

-(void)performActionForTappedViewAtPath:(NSIndexPath *)indexPath{

    BOOL deviceStatus = [[[_tableDataArray objectAtIndex:indexPath.row] valueForKey:@"DeviceStatus"] boolValue];
    
    int index = indexPath.row;
    
    DLog(@"index1 %d",index);
    
    if (!deviceStatus) {
        DLog(@"index2 %d",index);
        
      //  [self authorizeButtonPressed:index];
    }else{
        DLog(@"index3 %d",index);
       // [self deauthorizeButtonPressed:index];
    }
}


-(void)authorizeButtonPressed:(UIButton *)sender{
    
    int index = [sender tag];
    
    RequestAuthorizationViewController *requestVC = [[RequestAuthorizationViewController alloc] initByAppendingDeviceNameWithTitle:@"Request Authorization"];
   
    requestVC.toName = [[_tableDataArray objectAtIndex:index] valueForKey:@"UserName"];
    requestVC.toEmail = [[_tableDataArray objectAtIndex:index] valueForKey:@"Email"];
    requestVC.imageURLString = [[_tableDataArray objectAtIndex:index] valueForKey:@"Avatar"];
    requestVC.accountID  = [[_tableDataArray objectAtIndex:index] valueForKey:@"AccountId"];
    
    
    [self.navigationController pushViewController:requestVC animated:YES];
 
}


-(void)deauthorizeButtonPressed:(UIButton *)sender{
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{
    int index = [sender tag];
        
    NSString *userName = [[_tableDataArray objectAtIndex:index] valueForKey:@"UserName"];
    NSString *msg = [NSString stringWithFormat:@"Are you sure you want to Deauthorize %@",userName];
    
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
    
    [alert setNOButtonWithBlock:nil];
    [alert setYESButtonWithBlock:^{
        
        NSString *deviceUDID = [UIDevice UDID];
        
        NSString *accountId = [[_tableDataArray objectAtIndex:index] valueForKey:@"AccountId"];
        NSDictionary *Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              accountId, @"ProfileId",
                              deviceUDID, @"UDID",
                             
                              nil];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:Dict
                                                           options:nil
                                                             error:nil];

        NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
        
        NSString *deviceDeauthorization = REQUEST_DEVICE_DEAUTHORIZATION_URL;
        
        [request setURL:[NSURL URLWithString:deviceDeauthorization]];
        
        DLog(@"deviceDeauthorization %@",deviceDeauthorization);
        DLog(@"post data %@",Dict);
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
        
       
        NSString *name = [[_tableDataArray objectAtIndex:index] valueForKey:@"UserName"];
        NSString *msg = [NSString stringWithFormat:@"Deauthorizing device for user %@",name];
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText= msg;
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            if (!error) {
                
                NSError *err = nil;
                NSString *response = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments error:&err];
                DLog(@"%@",[data stringUTF8]);
                if (!err) {
                    
                    DLog(@"%@",response);
                    if ([response isEqualToString:@"De-Authorized Successfully"]) {
                        
                            [self getAuthorizedDeviceList];

                        
                    }
                    
                }
                
            }
            
        }];
        
    }];
    
    
    
    [alert show];
    
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
