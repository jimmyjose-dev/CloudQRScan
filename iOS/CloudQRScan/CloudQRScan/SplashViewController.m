//
//  SplashViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 01/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "SplashViewController.h"
#import "ViewController.h"

@interface SplashViewController ()
@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@end

#define kAnimationDuration 2

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self moveToMainView];
    //[self startAnimationWithImages:[self getAnimationImagesForSplash]];
    
}


/**
	Function to get the splash screen images
	@returns array of images which constitue the splash animation
 */
-(NSArray *)getAnimationImagesForSplash{
    NSMutableArray *splashScreenArray = [NSMutableArray new];
    int totalImage = 21;
    for (int idx = 1; idx <= totalImage; ++idx) {
        UIImage *splashImage = [UIImage imageByAppendingDeviceName:
                                [NSString stringWithFormat:@"frame_%d",idx]];
        [splashScreenArray addObject:splashImage];
    }
    return (NSArray *)splashScreenArray;
}



/**
	Start animating with the images in the image array
	@param splashScreenArray  the image array with all the splash images
 */
-(void)startAnimationWithImages:(NSArray *)splashScreenArray{
    [_imageView setAnimationDuration:kAnimationDuration];
    [_imageView setAnimationRepeatCount:0];
    [_imageView setAnimationImages:splashScreenArray];
    [self performSelector:@selector(moveToMainView) withObject:nil afterDelay:kAnimationDuration];
    [_imageView startAnimating];
}


/**
	Function to move to the main view with embedded camera.
    Called after kAnimationDuration-0.3 secs
 */
-(void)moveToMainView{
    //[_imageView stopAnimating];
    ViewController *viewController = [[ViewController alloc]
                                      initByAppendingDeviceName];
    [self.navigationController pushViewController:viewController animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
