//
//  HistoryViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 18/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "HistoryDetailViewController.h"
//#import "CustomTableViewCell.h"
#import "CustomTableViewCellWithSubHeading.h"
#import "ODRefreshControl.h"
#import "LoginViewController.h"
#import "HistoryManager.h"
#import "ViewController.h"
#import "ALPickerView.h"


@interface HistoryDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ALPickerViewDelegate>
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSArray *tableDataArray;
@property(nonatomic,retain) NSMutableArray *heading;
@property(nonatomic,retain) NSMutableArray *subHeading;
@property(nonatomic,retain) NSMutableArray *imageArray;
@property(nonatomic,retain) NSMutableArray *valueArray;
@property(nonatomic,retain) NSMutableArray *dateArray;

@property(nonatomic,retain) NSMutableArray *headingOrg;
@property(nonatomic,retain) NSMutableArray *subHeadingOrg;
@property(nonatomic,retain) NSMutableArray *imageArrayOrg;
@property(nonatomic,retain) NSMutableArray *valueArrayOrg;
@property(nonatomic,retain) NSMutableArray *dateArrayOrg;


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
@property(nonatomic,retain) UIView *disableViewOverlay;


@end

@implementation HistoryDetailViewController
@synthesize heading,subHeading,imageArray,valueArray,dictHistory,dateArray;

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
    
    [super viewWillAppear:animated];
    
    [Flurry logEvent:@"History Detail View" timed:YES];

    UIImage *backButtonImage = [UIImage imageByAppendingDeviceName:@"btn_back"];
    
    CGRect backButtonFrame = CGRectZero;
    backButtonFrame.origin.x += 5;
    backButtonFrame.size = backButtonImage.size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:backButtonFrame];
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = back;
    
    CGRect frame = _tableView.frame;
    
    frame.origin.y = 0;
  
    _tableView.frame = frame;
    [self setRightBarButtonWithStateActive:NO];
    
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
        NSMutableArray *tempDateArray = [NSMutableArray new];
        
        
        [self setHistoryData];
        
        int size = [dateArray count];
        for (int idx =0; idx<size ; ++idx) {
            
            NSString *key = [dateArray objectAtIndex:idx];
            
            if ([[_selectionStates valueForKey:key] integerValue]) {
                
                [tempHeadingArray addObject:[heading objectAtIndex:idx]];
                [tempSubHeadingArray addObject:[subHeading objectAtIndex:idx]];
                [tempImageArray addObject:[imageArray objectAtIndex:idx]];
                [tempValueArray addObject:[valueArray objectAtIndex:idx]];
                [tempDateArray addObject:[dateArray objectAtIndex:idx]];
                
            }
            
        }
        
        heading    = [NSArray arrayWithArray:tempHeadingArray];
        subHeading = [NSArray arrayWithArray:tempSubHeadingArray];
        imageArray = [NSArray arrayWithArray:tempImageArray];
        valueArray = [NSArray arrayWithArray:tempValueArray];
        dateArray  = [NSArray arrayWithArray:tempDateArray];
        
        [_tableView reloadData];
        
    }else{
        
        [self loadHistoryData];
    }
    
}




-(void)viewWillDisappear:(BOOL)animated{

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [Flurry endTimedEvent:@"History Detail View" withParameters:nil];
    //[self removeSignInImageView];
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

    
    heading    = _headingOrg;
    subHeading = _subHeadingOrg;
    imageArray = _imageArrayOrg;
    valueArray = _valueArrayOrg;
    dateArray  = _dateArrayOrg;
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableDataArray = [NSArray arrayWithObjects:@"First",@"Second", nil];
    
    
    _disableViewOverlay = [[UIView alloc]
                               initWithFrame:CGRectMake(0.0f,0.0f,320.0f,650.0f)];
    _disableViewOverlay.backgroundColor=[UIColor blackColor];
    _disableViewOverlay.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnDisabledView:)];
    [tap setNumberOfTapsRequired:1];
    [_disableViewOverlay addGestureRecognizer:tap];
    
    _shouldReloadDB = YES;
    
    _dictFilter = [NSMutableDictionary new];

    //HistoryManager *historyManager = [[HistoryManager alloc] init];
    
    //dictHistory = [NSDictionary dictionaryWithDictionary:[historyManager getDBData]];
    
    dictHistory = [NSDictionary dictionaryWithDictionary:_historyDataDict];

    _headingOrg    = [dictHistory objectForKey:@"heading"];
    _subHeadingOrg = [dictHistory objectForKey:@"subheading"];
    _imageArrayOrg = [dictHistory objectForKey:@"image"];
    _valueArrayOrg = [dictHistory objectForKey:@"value"];
    _dateArrayOrg  = [dictHistory objectForKey:@"date"];
    
        heading    = [dictHistory objectForKey:@"heading"];
        subHeading = [dictHistory objectForKey:@"subheading"];
        imageArray = [dictHistory objectForKey:@"image"];
        valueArray = [dictHistory objectForKey:@"value"];
        dateArray  = [dictHistory objectForKey:@"date"];
    
    
    UIImage *toolbarImage = [UIImage imageNamed:@"bg_toolbar"];
    [_toolbar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // [_toolbar setBackgroundColor:_pickerView.backgroundColor];
    
    NSSet *values = [NSSet setWithArray:dateArray];
    _entries = [[values allObjects] sortedArrayUsingSelector:@selector(compare:)];
    _selectionStates = [NSMutableDictionary new];
    for (NSString *key in _entries)
        [_selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];

}

-(void)tappedOnDisabledView:(UITapGestureRecognizer *)sender{

    if ([_pickerView isDescendantOfView:self.view]) {
        [_pickerView removeFromSuperview];
        [_pickerMainView removeFromSuperview];
    }
    
    
    if ([_disableViewOverlay isDescendantOfView:self.view]) {
        [_disableViewOverlay removeFromSuperview];
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
    
    //DLog(@"vaue %@",[valueArray objectAtIndex:indexPath.row]);
    NSString *headingCellValue = [heading objectAtIndex:indexPath.row];
    NSString *subHeadingCellValue = [subHeading objectAtIndex:indexPath.row];
    NSString *date = [dateArray objectAtIndex:indexPath.row];
    
    subHeadingCellValue = [subHeadingCellValue stringByAppendingFormat:@" | %@",date];
    
    UIImageView *disclosureImageView = [[UIImageView alloc] initWithImage: [UIImage imageByAppendingDeviceName:@"btn_forward"]];
    
    cell.accessoryView = disclosureImageView;
    
    UIImage *image = nil;
    
    NSString *imagePath = [imageArray objectAtIndex:indexPath.row];//[NSString stringWithString:[data objectAtIndex:3]];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    
    //NSLog(@"fileExists %d imagePath %@",fileExists,imagePath);
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
    
    
    NSString *qrcodeString = [valueArray objectAtIndex:indexPath.row];
    
    //NSLog(@"qrcodeString %@",qrcodeString);
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"savetodb"];
    
    _viewController = [[ViewController alloc] init];
    [_viewController performActionWithQRCode:qrcodeString];
    
   }


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *link = [valueArray objectAtIndex:indexPath.row];
    NSString *title = [heading objectAtIndex:indexPath.row];
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:[NSString stringWithFormat:@"Remove %@ from history ?",title]];
    [alert setYESButtonWithBlock:^{
        
        [[HistoryManager new] deleteLink:link];

        [_headingOrg removeObjectAtIndex:indexPath.row];
        [_subHeadingOrg removeObjectAtIndex:indexPath.row];
        [_imageArrayOrg removeObjectAtIndex:indexPath.row];
        [_valueArrayOrg removeObjectAtIndex:indexPath.row];
        [_dateArrayOrg removeObjectAtIndex:indexPath.row];
        
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
