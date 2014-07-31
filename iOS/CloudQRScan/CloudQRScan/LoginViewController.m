//
//  LoginViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 03/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate,KBKeyboardHandlerDelegate,BSKeyboardControlsDelegate>
@property(nonatomic,retain)IBOutlet UITextField *emailTextField;
@property(nonatomic,retain)IBOutlet UITextField *passwordTextField;
@property(nonatomic,retain)NSMutableArray *dataSource;
@property(nonatomic,retain)UITextField *field;
@property(nonatomic,retain)KBKeyboardHandler *keyboard;
@property(nonatomic,retain)BSKeyboardControls *keyboardControls;
@property(nonatomic, assign)UIControl *currentControl;

@end

@implementation LoginViewController

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

}


-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _emailTextField) [_passwordTextField becomeFirstResponder];
    else if (textField == _passwordTextField) [self signInButtonPressed:nil];
    
    return YES;
}


-(IBAction)signUpButtonPressed:(id)sender{

    RegistrationViewController *registrationVC = [[RegistrationViewController alloc] initByAppendingDeviceNameWithTitle:@"Sign Up"];
    
    [self.navigationController pushViewController:registrationVC animated:YES];
    

}

-(IBAction)signInButtonPressed:(id)sender{
    
    /*
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserActiveEmailKey]) {
        
        NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:kUserActiveEmailKey];
        
        if ([[email trim] length]) {
           
            NSString *msg = [NSString stringWithFormat:@"You are already logged in with email '%@'\nIf you continue you will be logged out of the current session & signed in with the new one.\nDo you want to continue ?",[[NSUserDefaults standardUserDefaults] valueForKey:kUserActiveEmailKey]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Continue", nil];
            [alert show];
            return;
        }
        
        
    }
    */
    
    if (![self checkDataValidity]) {
        return;
    }
    else{
    
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Verifying user...";
        
        
    NSString *email = [[_emailTextField text] trim];
    NSString *pass = [[[_passwordTextField text] trim] MD5String];
    NSString *userLoginStatus = USERLOGIN_URL(email, pass);
    
    DLog(@"userLoginStatus %@",userLoginStatus);
    
    NSURL *userLoginStatusURL = [NSURL URLWithString:userLoginStatus];
    
    /*
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:userLoginStatusURL
                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                              timeoutInterval:kTimeoutInterval];
    */
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:userLoginStatusURL];
    [request setTimeoutInterval:kTimeoutInterval];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        
        if (!error) {
            
            NSError *err = nil;
            NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments error:&err];
            
            if (!err) {
                
                DLog(@"responseJSON %@",responseJSON);
                NSDictionary *responseDict = [responseJSON objectAtIndex:0];
                if ([[responseDict valueForKey:@"LoginMessage"] isEqualToString:@"SUCCESS"]) {
                    
                    NSString *userID = [responseDict valueForKey:@"AccountID"];
                    NSString *email = [responseDict valueForKey:@"Email"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserActiveKey];
                    [[NSUserDefaults standardUserDefaults] setValue:userID forKey:kUserIDKey];
                    [[NSUserDefaults standardUserDefaults] setValue:email forKey:kUserActiveEmailKey];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                   
                }else{
                
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserActiveKey];
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kUserIDKey];
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kUserActiveEmailKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Wrong email or password !!!"];
                    [alert setDismissButtonRedWithBlock:NULL];
                    [alert show];
                    
                }
                
            }else{
                
                DLog(@"error in JSON %@",[err localizedDescription]);
                BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Server under maintenance" message:[err localizedDescription]];
                [alert setDismissButtonRedWithBlock:NULL];
                [alert show];
            }
            
        }
        
        else{
            
            DLog(@"Error %@",[error localizedDescription]);
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Server under maintenance" message:[error localizedDescription]];
            [alert setDismissButtonRedWithBlock:NULL];
            [alert show];
        }
    }];
    
    }

}

-(BOOL)checkDataValidity{
    
    BOOL isValid = YES;
    
    NSString *email = [[_emailTextField text] trim];
    NSString *password = [[_passwordTextField text] trim];

    
    NSString *msg = nil;
    
    if (!email.length) msg = @"Email cannot be blank";
    else if (![email isEmailAddress]) msg = @"Not a valid email address";
    else if (!password.length) msg = @"Password cannot be blank";
    
    
    if (msg) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:msg message:nil];
        [alert setDismissButtonRedWithBlock:NULL];
        [alert show];
        isValid = NO;
    }
    
    return isValid;
    
}


-(IBAction)forgotPasswordButtonPressed:(id)sender{
    
    ForgotPasswordViewController *forgotVC = [[ForgotPasswordViewController alloc] initByAppendingDeviceNameWithTitle:@"Forgot Password"];
    
    [self.navigationController pushViewController:forgotVC animated:YES];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex) {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kUserActiveEmailKey];
        [self signInButtonPressed:nil];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//    _keyboard = [[KBKeyboardHandler alloc] init];
//    //_keyboard.delegate = self;
//    
    NSArray *fields = @[ _emailTextField, _passwordTextField];
    
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];

    
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    _currentControl = textField;
    [self.view moveViewForInputField:_currentControl withPadding:0.0f animate:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    [self.view moveViewForInputField:_currentControl withPadding:0.0f animate:YES];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _currentControl) {
        //If the textfield is still the same one, we can reset the view animated
        [self.view resetView];
    }else {
        
    }
}


#pragma mark -
#pragma mark Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    //UIView *view = keyboardControls.activeField.superview.superview;
   // [self.tableView scrollRectToVisible:view.frame animated:YES];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
