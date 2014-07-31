//
//  CustomNavigationController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) Jose on 04/02/12.
//  Copyright (c) 2012 Varshyl Mobile. All rights reserved.
//

#import "CustomNavigationController.h"

@implementation CustomNavigationController

-(void)setTitleBarImage :(NSString *)imageNameWithExt{
    
       /* [[UINavigationBar appearance] setTitleTextAttributes:@{
                                   UITextAttributeTextColor : [UIColor whiteColor],
                             UITextAttributeTextShadowColor : [UIColor blackColor],
                            UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(1, 0)],
                                        UITextAttributeFont : [UIFont fontWithName:kHeaderFont size:kHeaderFontSize]
         }];
        */
        
        UIImage *toolBarImg = [UIImage imageNamed: imageNameWithExt];
        
        if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [[UINavigationBar appearance] setBackgroundImage:toolBarImg forBarMetrics:UIBarMetricsDefault];
             [[UIBarButtonItem appearance] setBackButtonBackgroundVerticalPositionAdjustment:-50.0 forBarMetrics:UIBarMetricsDefault];
            //UIImage *backButtonImage = [UIImage imageByAppendingDeviceName:@"btn_back"];
            //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
        
//[[self navigationItem] setHidesBackButton:YES];
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    
    //return (interfaceOrientation == (UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown));
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}


-(BOOL)shouldAutorotate
{
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
