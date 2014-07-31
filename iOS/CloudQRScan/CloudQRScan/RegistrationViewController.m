//
//  RegistrationViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 06/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "RegistrationViewController.h"
#import "HistoryViewController.h"


@interface RegistrationViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
@property(nonatomic,retain)IBOutlet UITextField *textFieldFirstName;
@property(nonatomic,retain)IBOutlet UITextField *textFieldLastName;
@property(nonatomic,retain)IBOutlet UITextField *textFieldEmail;
@property(nonatomic,retain)IBOutlet UITextField *textFieldPassword1;
@property(nonatomic,retain)IBOutlet UITextField *textFieldPassword2;
@property(nonatomic,retain)IBOutlet UIImageView *imgViewAccountType;
@property(nonatomic,retain)IBOutlet UIButton *btnAccountIndividual;
@property(nonatomic,retain)IBOutlet UIButton *btnAccountBusiness;
@property(nonatomic,retain)NSMutableArray *dataSource;
@property(nonatomic,retain)UITextField *field;
@property(nonatomic,retain)BSKeyboardControls *keyboardControls;
@property(nonatomic,assign)BOOL isAccountIndividual;
@property(nonatomic,assign)BOOL isAccountBusiness;
@property(nonatomic, assign)UIControl *currentControl;


@end

@implementation RegistrationViewController

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textFieldFirstName.delegate = self;
    _textFieldLastName.delegate = self;
    _textFieldEmail.delegate = self;
    _textFieldPassword1.delegate = self;
    _textFieldPassword2.delegate = self;
    
    _isAccountBusiness = NO;
    _isAccountIndividual = YES;
   
    NSArray *fields = @[ _textFieldFirstName, _textFieldLastName, _textFieldEmail, _textFieldPassword1, _textFieldPassword2];
    
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



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField == _textFieldFirstName) [_textFieldLastName becomeFirstResponder];
    else if (textField == _textFieldLastName) [_textFieldEmail becomeFirstResponder];
    else if (textField == _textFieldEmail) [_textFieldPassword1 becomeFirstResponder];
    else if (textField == _textFieldPassword1) [_textFieldPassword2 becomeFirstResponder];
    else if (textField == _textFieldPassword2) [self submitButtonPressed:nil];
    
    return YES;
}

-(IBAction)submitButtonPressed:(id)sender{

    if (![self checkDataValidity]) {
        return;
    }
    else{
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Registering new user...";
        
        
        NSString *firstName = [[_textFieldFirstName text] trim];
        NSString *lastName = [[_textFieldLastName text] trim];
        NSString *email = [[_textFieldEmail text] trim];
        NSString *password = [[[_textFieldPassword1 text] trim] MD5String];
        //1 if account type is individual or Pass 2 if account type is Business User
        NSString *accountType = _isAccountIndividual?@"1":@"2";
        
        NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:firstName,@"FirstName",
                                   lastName,@"LasttName",
                                   email,@"Email",
                                   password,@"Password",
                                   accountType,@"AccountType",
                                   nil];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        
        NSString *userRegistration = QRREGISTRATION_URL;
        DLog(@"userRegistration %@",userRegistration);
        NSURL *userRegistrationURL = [NSURL URLWithString:userRegistration];
        
        /*
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:userRegistrationURL
                                                      cachePolicy:NSURLCacheStorageNotAllowed
                                                  timeoutInterval:kTimeoutInterval];
        */
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:userRegistrationURL];
        [request setTimeoutInterval:kTimeoutInterval];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            
            if (!error) {
                
                NSError *err = nil;
                
                DLog(@"data %@",[data stringUTF8]);
                
                NSString *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingAllowFragments error:&err];
                if (!err) {
                    
                    DLog(@"responseJSON %@",responseJSON);
                    
                    if ([responseJSON.lowercaseString isEqualToString:@"success"]) {
                    
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Registration successful" message:@"Please login with your credentials"];
                        [alert setOKButtonWithBlock:^{
                            [self.navigationController popViewControllerAnimated:YES];
                            /*
                            
                            NSArray *controllers = [self.navigationController viewControllers];
                            for (UIViewController *vc in controllers) {
                                if ([vc isKindOfClass:[HistoryViewController class]]) {
                                    [self.navigationController popToViewController:vc animated:YES];
                                    break;
                                }
                            }*/
                            
                        }];
                        [alert show];
                    }
                    else {
                    
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"User already exists" message:@"Please choose a different email"];
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
    
    NSString *firstName = [[_textFieldFirstName text] trim];
    NSString *lastName = [[_textFieldLastName text] trim];
    NSString *email = [[_textFieldEmail text] trim];
    NSString *password1 = [[_textFieldPassword1 text] trim];
    NSString *password2 = [[_textFieldPassword2 text] trim];
    
    NSString *msg = nil;
    
    if (!firstName.length) msg = @"First name cannot be blank";
    else if (!lastName.length) msg = @"Last name cannot be blank";
    else if (!email.length) msg = @"Email cannot be blank";
    else if (![email isEmailAddress]) msg = @"Not a valid email address";
    else if (!password1.length) msg = @"Password cannot be blank";
    else if (!password2.length) msg = @"Confirm password cannot be blank";
    else if (![password1 isEqualToString:password2]) msg = @"Password doesnt match";
    
    
    if (msg) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:msg message:nil];
        [alert setDismissButtonRedWithBlock:NULL];
        [alert show];
        isValid = NO;
    }
    
    return isValid;

}

-(IBAction)accountTypeButtonPressed:(UIButton *)sender{

    if (sender.tag) {
    
        _isAccountBusiness = YES;
        _isAccountIndividual = !_isAccountBusiness;
        
    }else{
    
        _isAccountIndividual = YES;
        _isAccountBusiness = !_isAccountIndividual;
    }
    
    UIColor *colorIndiviaualAcc = _isAccountIndividual ? [UIColor whiteColor]: [UIColor lightGrayColor];
    UIColor *colorBusinessAcc = _isAccountBusiness ? [UIColor whiteColor]: [UIColor lightGrayColor];
    
    [_btnAccountIndividual setTitleColor:colorIndiviaualAcc forState:UIControlStateNormal];
    [_btnAccountBusiness setTitleColor:colorBusinessAcc forState:UIControlStateNormal];
    

    
    UIImage *imageAcc = _isAccountIndividual ? [UIImage imageByAppendingDeviceName:@"btn_register_IndividualSelect"]:[UIImage imageByAppendingDeviceName:@"btn_register_BusinessSelect"];
    [_imgViewAccountType setImage:imageAcc];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
