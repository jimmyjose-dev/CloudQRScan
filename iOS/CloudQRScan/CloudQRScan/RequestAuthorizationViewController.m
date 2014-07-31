//
//  RequestAuthorizationViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 03/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "RequestAuthorizationViewController.h"

@interface RequestAuthorizationViewController ()<EGOImageViewDelegate,BSKeyboardControlsDelegate,UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,retain)IBOutlet EGOImageView *userImageView;
@property(nonatomic,retain)IBOutlet UILabel *toUserNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *toUserSubtitleLabel;
@property(nonatomic,retain)IBOutlet UITextField *forUserName;
@property(nonatomic,retain)IBOutlet UITextField *forUserEmail;
@property(nonatomic,retain)IBOutlet UITextView *forUserDescription;
@property(nonatomic,retain)UIControl *currentControl;
@property(nonatomic,retain)BSKeyboardControls *keyboard;


@end

@implementation RequestAuthorizationViewController

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
    
    UIImage *doneButtonImage = [UIImage imageByAppendingDeviceName:@"btn_done_top"];
    
    
    CGRect doneButtonFrame = CGRectZero;
    //userButtonFrame.origin.x += 5;
    doneButtonFrame.size = doneButtonImage.size;
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:doneButtonFrame];
    [doneButton setImage:doneButtonImage forState:UIControlStateNormal];
    
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    
    
}

-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)doneButtonPressed{

    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{
    
    NSString *msg = nil;
    BlockAlertView *alert = nil;
    if (!(_forUserName.text.length || _forUserEmail.text.length || _forUserDescription.text.length)) {
        msg = @"Please fill all the fields";

        alert = [BlockAlertView alertWithTitle:nil message:msg];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
        
    }
    else if (![_forUserName.text length]){
        msg = @"Please enter your name";
        alert = [BlockAlertView alertWithTitle:nil message:msg];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
        
    }
    else if (![_forUserEmail.text length]){
        msg = @"Please enter your email";
        alert = [BlockAlertView alertWithTitle:nil message:msg];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
        
    }
    else if (![_forUserEmail.text isEmailAddress]){
        msg = @"Please enter a valid email";
        alert = [BlockAlertView alertWithTitle:nil message:msg];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
        
    }
    
    else if (![_forUserDescription.text length]){
        msg = [NSString stringWithFormat:@"Please enter a short message for %@",_toName];
        alert = [BlockAlertView alertWithTitle:nil message:msg];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
        
    }
    else{
        
        //[self updateDB];
        
        NSString *msg = [NSString stringWithFormat:@"Sending authorization request to %@",_toName];
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText= msg;
        
        NSString *urlString = REQUEST_DEVICE_AUTHORIZATION_URL;
        
        NSString *deviceUDID = [UIDevice UDID];//[[NSUserDefaults standardUserDefaults] valueForKey:@"udid"];
        NSDictionary *Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              _accountID, @"ProfileId",
                              deviceUDID, @"UDID",
                              @"iPhone", @"DeviceType",
                              _forUserName.text, @"UserName",
                              _forUserEmail.text, @"UserEmailId",
                              _forUserDescription.text, @"ShortMessage",
                              nil];
        
    
        ServerController *server = [[ServerController alloc] initWithServerURL:urlString andPostParameter:Dict forServiceType:@"RequestDeviceAuth"];
        
        
        
        [server connectUsingPostMethodWithCompletionBlock:^(id serverResponse, NSString *errorString, NSString *service) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            
            DLog(@"res %@ error %@",(NSString *) serverResponse,errorString);
            if (!errorString) {
                
                if ([((NSString *) serverResponse) isEqualToString:@"SUCCESS"]) {
                
                    NSString *msg = [NSString stringWithFormat:@"Message sent to %@ for device authorization. Please be patient for the approval",_toName];
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Device Authorization" message:msg];
                    [alert setOKButtonWithBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                    [alert show];
                    
                    
                }else if ([((NSString *) serverResponse) isEqualToString:@"EXIST"]) {
                    
                    NSString *msg = [NSString stringWithFormat:@"You have sent a device authorization request to %@ before. Please be patient for the approval",_toName];
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Device Authorization" message:msg];
                    [alert setDestructiveButtonWithTitle:@"Dismiss" block:^{
                       [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                    [alert show];
                    
                    
                }else{
                    
                    NSString *msg = @"Could not connect to server. Please try again.";
                    
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Device Authorization" message:msg];
                    [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
                    [alert show];
                    
                }
            }
            else{
            
                NSString *msg = @"Could not connect to server. Please try again.";
                
                BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Device Authorization" message:msg];
                [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
                [alert show];
                
            }
            
        }];

                
        //[self.navigationController popViewControllerAnimated:YES];
        // [self dismissModalViewControllerAnimated:YES];
    }
    
    }


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    /*
    UIImage *backgroundImage = [UIImage imageByAppendingDeviceName:@"bg_input_large"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    [_forUserDescription setBackgroundColor:backgroundColor];
    */
    
    _toUserNameLabel.text = _toName;
    _toUserSubtitleLabel.text = _toEmail;
    NSURL *imageURL =  [NSURL URLWithString:_imageURLString];
    _userImageView.delegate = self;
    [_userImageView setImageURL:imageURL];
    
    _forUserName.delegate = self;
    _forUserEmail.delegate = self;
    _forUserDescription.delegate = self;
    NSArray *fields = @[ _forUserName, _forUserEmail, _forUserDescription];
    
    [self setKeyboard:[[BSKeyboardControls alloc] initWithFields:fields]];

    _keyboard.delegate  = self;

    
   
    
}

-(void)imageViewFailedToLoadImage:(EGOImageView *)imageView error:(NSError *)error{

    UIImage *image = [UIImage imageByAppendingDeviceName:@"icon_profile"];
    [imageView setImage:image];

}


#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_keyboard setActiveField:textField];
    [self.view moveViewForInputField:textField withPadding:0.0f animate:NO];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    _currentControl = textField;
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _currentControl) {
        //If the textfield is still the same one, we can reset the view animated
        [self.view resetView];
    }else {
        //However, if the currentControl has changed - that indicates the user has
        //gone into another control - so don't reset view, otherwise animations jump around
    }
    
    [self.view resetView];
}



-(void)textViewDidEndEditing:(UITextView *)textView{

    if ((UIControl *)textView == _currentControl) {
        //If the textfield is still the same one, we can reset the view animated
        [self.view resetView];
    }else {
        //However, if the currentControl has changed - that indicates the user has
        //gone into another control - so don't reset view, otherwise animations jump around
    }
    
    [self.view resetView];
}


#pragma mark -
#pragma mark Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _currentControl = (UIControl *)textView;
    [_keyboard setActiveField:textView];
    [self.view moveViewForInputField:(UIControl *)textView withPadding:10.0f animate:NO];
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    //UIView *view = keyboardControls.activeField.superview.superview;
    
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
    [self.view resetView];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
