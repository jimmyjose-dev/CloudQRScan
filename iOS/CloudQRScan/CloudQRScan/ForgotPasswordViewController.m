//
//  ForgotPasswordViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 02/12/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()<UITextFieldDelegate>
@property(nonatomic,retain)IBOutlet UITextField *txtEmail;
@end

@implementation ForgotPasswordViewController

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
    
    [_txtEmail becomeFirstResponder];
    [_txtEmail setKeyboardAppearance:UIKeyboardAppearanceAlert];
    
}


-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //[self.view endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self doneButtonPressed:NULL];
    return YES;
}

-(IBAction)doneButtonPressed:(id)sender{
    
    if (![self checkDataValidity]) {
        return;
    }
    else{
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].detailsLabelText = @"Verifying user...";
        
        
        NSString *email = [[_txtEmail text] trim];
        
        NSString *userForgotPasswordStatus = USERFORGOTPASSWORD_URL(email);
        
        DLog(@"userForgotPasswordStatus %@",userForgotPasswordStatus);
        
        NSURL *userForgotPasswordStatusURL = [NSURL URLWithString:userForgotPasswordStatus];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:userForgotPasswordStatusURL];
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
                        
                        NSString *msg = [NSString stringWithFormat:@"Password sent to '%@'",[[_txtEmail text] trim]];
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
                        [alert setOKButtonWithBlock:^{
                        
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert show];
                        
                        
                        
                        
                    }else{
                        NSString *msg = [NSString stringWithFormat:@"User with email %@ doesn't exists",[[_txtEmail text] trim]];
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
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
    
    NSString *email = [[_txtEmail text] trim];
    
    
    NSString *msg = nil;
    
    if (!email.length) msg = @"Email cannot be blank";
    else if (![email isEmailAddress]) msg = @"Not a valid email address";
    
    if (msg) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:msg message:nil];
        [alert setDismissButtonRedWithBlock:NULL];
        [alert show];
        isValid = NO;
    }
    
    return isValid;
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    _txtEmail.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
