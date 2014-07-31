//
//  BarcodeProductViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "BarcodeProductViewController.h"

@interface BarcodeProductViewController ()
@property(nonatomic,retain)IBOutlet UILabel *currency;
@property(nonatomic,retain)IBOutlet UILabel *price;
@property(nonatomic,retain)IBOutlet UILabel *productName;
@property(nonatomic,retain)IBOutlet EGOImageView *productImage;
@end

@implementation BarcodeProductViewController

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
    // Do any additional setup after loading the view from its nib.
    [self updateGUIWithDictionary:_serverResponse];
}

-(void)updateGUIWithDictionary:(NSDictionary *)serverResponse{
    
    NSDictionary *productDict = serverResponse;
   
    [_currency setText:[productDict valueForKey:@"currency"]];
    [_price setText:[productDict valueForKey:@"price"]];
    
    
    [_productName setText:[productDict valueForKey:@"productname"]];
    
    NSString *imageURlStr= [productDict valueForKey:@"imageurl"];
    DLog(@"imageURlStr %@",imageURlStr);
    
    _productImage.imageURL = [NSURL URLWithString:imageURlStr];
    
    _productImage.contentMode = UIViewContentModeCenter;
   
}

-(IBAction)websiteButtonPressed:(id)sender{

    WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:@"Product Website"];
    webVC.urlString = [_serverResponse valueForKey:@"producturl"];
    [self.navigationController pushViewController:webVC animated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
