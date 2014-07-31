//
//  OptionsActiveViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "OptionsActiveViewController.h"
#import "OptionsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+overView.h"



@interface OptionsActiveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)IBOutlet UITableView *tableView;

@property(nonatomic,retain)IBOutlet UIButton *optionActiveButton;

@property(nonatomic,retain)IBOutlet EGOImageView *optionImageView;
@property(nonatomic,retain)IBOutlet UILabel *optionLabel;


@end

@implementation OptionsActiveViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
/*
- (id)initWithNibName:(NSString *)nibNameOrNil withViewLayoutPoint:(CGPoint)viewLayoutPoint andTableDataDictionary:(NSDictionary *)tableDataDictionary bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        DLog(@"viewLayoutPoint %@",NSStringFromCGPoint(viewLayoutPoint));
        // _tableView.delegate = self;
        //_tableView.dataSource = self;
        _tableDataArray = [NSArray arrayWithArray:[tableDataDictionary allKeys]];
        
    }
    
    return self;
}
*/
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  /*
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // DLog(@"_tableDataArray %@",_tableDataArray);
    _tableView.separatorColor = [UIColor clearColor];
   [_tableView reloadData];

    CGRect frame = _optionActiveButton.frame;
    DLog(@"frame.origin.y %f",frame.origin.y);
    frame.origin.y += (_activeButtonY*74);
    DLog(@"frame.origin.y %f",frame.origin.y);
    _optionActiveButton.frame = frame;

    UIImage *image = [UIImage imageNamed:_activeButtonImageName];
    [_optionActiveButton setImage:image forState:UIControlStateNormal];
    
*/
    // Do any additional setup after loading the view from its nib.
    
    _optionImageView.image = _image;
    _optionLabel.text = _value;
  
}

-(IBAction)optionActiveButtonPressed:(id)sender{

    DLog(@"%s",__func__);
    [self dismissOverViewControllerAnimated:YES];

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
    
    OptionsTableViewCell *cell = (OptionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OptionsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *titleText = [_tableDataArray objectAtIndex:indexPath.row];
    DLog(@"titletext %@",titleText);
    cell.optionTitleLabel.text = titleText;
    UIImage *image = [[UIImage imageNamed:@"114x114_blue.png"] roundedCornerImage:10 borderSize:2];
    [cell.optionImageView setImage:image];
    
    [cell.optionImageView.layer setMasksToBounds:YES];
    //    [cell.optionImageView.layer setCornerRadius:50];
    cell.optionTitleLabel.textColor = [UIColor whiteColor];
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *keyName = [_tableDataArray objectAtIndex:indexPath.row];
    
    // NSString *aSelector = [[profileParser getSelectorDictionary] valueForKey:keyName];
    
    //SEL selector = NSSelectorFromString(aSelector);
    
    // [self performSelector:selector];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
