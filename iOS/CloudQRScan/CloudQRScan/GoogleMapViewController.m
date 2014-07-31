//
//  GoogleMapViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 21/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GoogleMapViewController ()<GMSMapViewDelegate>{

    GMSMapView *mapView;
    
}

@property(nonatomic,retain)GMSMapView *mapView;
@property(nonatomic,assign)float lat;
@property(nonatomic,assign)float lng;

@end

@implementation GoogleMapViewController
@synthesize mapView;

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
    
    DLog(@"%s",__func__);
}

- (void)loadView {
    [super loadView];
    
    _lat = [[[_latlonString componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
    _lng = [[[_latlonString componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
    CGFloat zoom = 18;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        zoom -= 1;
    }
    
    
    float lat =29.819487 ,lng = 77.965699;
    //lat = -37.827207;
    //lng = 144.968699;
    lat = _lat;
    lng = _lng;
    DLog(@"%f %f",lat,lng);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                      longitude:lng
                                                           zoom:zoom
                                                        bearing:10.f
                                                   viewingAngle:37.5f];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;

    self.mapView.delegate = self;
    self.view = self.mapView;
    
    NSString *snippet = nil;
    
    if (!_designation && !_companyName && ![[_designation trim] length] && [[_companyName trim] length]) {
        snippet = @"CloudQRScan";
    }else if (_designation && [[_designation trim] length]){
    
        snippet = _designation.trim;
        if (_companyName && [[_companyName trim] length]) {
            snippet = [snippet stringByAppendingFormat:@"\nat\n%@",[_companyName trim]];
        }
    }else if (_companyName && [[_companyName trim] length]) {
        snippet = [_companyName trim];
    }
    
   

   
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.title = _name;
    marker.snippet = snippet;
    marker.icon = [UIImage imageNamed:@"glow-marker"];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    marker.map = self.mapView;
    self.mapView.selectedMarker = marker;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
