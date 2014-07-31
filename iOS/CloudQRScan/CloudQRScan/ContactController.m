//
//  ContactController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 17/04/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ContactController.h"
#import "ContactParser.h"
#import "AppDelegate.h"

@interface ContactController ()<ABUnknownPersonViewControllerDelegate>
@property(nonatomic,retain)ABUnknownPersonViewController *picker;
@property(nonatomic,assign)ABRecordRef contactRecordRef;
@property(nonatomic,retain)NSString *contactName;
@property(nonatomic,retain)AppDelegate *app;
@end

@implementation ContactController
@synthesize picker;

-(id)init{

    self = [super init];
    
    return self;
}

-(id)initWithVCardString:(NSString *)vCardString{

    self = [self init];
    
    CFDataRef vCardData = (__bridge CFDataRef)[vCardString dataUsingEncoding:NSUTF8StringEncoding];
    ABAddressBookRef book = ABAddressBookCreate();
    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
    CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
    CFIndex index = 0;
    ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, index);
    
    
    _contactName = @"vCard";
    _contactRecordRef = person;
    [self setContactView];
    
    return self;
    

}

-(NSString *)getName{

    NSString *name = (__bridge NSString *)(ABRecordCopyCompositeName(_contactRecordRef));
    return name;
}

-(id)initWithmeCardString:(NSString *)meCardString{

    self = [self init];
    _contactName = @"meCard";
    _contactRecordRef = [[[ContactParser alloc] initWithmeCard:meCardString] getContactPerson];
    [self setContactView];
    
    return self;


}

-(id)initWithUserInfo:(NSDictionary *)userInfoDictionary{

    self = [self init];
    _contactName = [userInfoDictionary valueForKey:@"FullName"];
    _contactRecordRef = [[[ContactParser alloc] initWithUserInfo:userInfoDictionary] getContactPerson];
    [self setContactView];
    
    return self;
    
}

-(void)setContactView{

    //    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		// Do a taks in the background

		// Hide the HUD in the main tread
        //	dispatch_async(dispatch_get_main_queue(), ^{
    
			
            picker = [ABUnknownPersonViewController new];
            picker.unknownPersonViewDelegate = self;
            picker.displayedPerson = _contactRecordRef;
            //picker.allowsAddingToAddressBook = YES;//!contactExists;
            // picker.allowsActions = YES;
            //picker.alternateName = @"John Appleseed";
            picker.title = _contactName;
            //    picker.message = @"Company, Inc";
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 30)];
            [button setImage:[UIImage imageByAppendingDeviceName:@"btn_back"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:button];
            picker.navigationItem.leftBarButtonItem = back;
            
            
            UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveContactToAddressBook)];
            [save setTintColor:[UIColor blackColor]];
            
            picker.navigationItem.rightBarButtonItem = save;
            
            
            
	//	});
	//});


}

-(void)saveContactToAddressBook{
    
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    ABAddressBookAddRecord(addressBook, _contactRecordRef, &error);
    ABAddressBookSave(addressBook, &error);
    
    NSString *msg = nil;
    
    if (error != NULL)
    {
        DLog(@"got ERROR");
        msg = @"Contact Could not be Saved !!!";
    }
    else
    {
        DLog(@"Saved");
        msg = @"Contact Saved Successfully !!!";
    }
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
    [alert setOKButtonWithBlock:^{
        [self backButtonPressed];
    }];
    
    [alert show];
    
}

-(void)backButtonPressed{
   
    if([_delegate respondsToSelector:@selector(resetView)])[_delegate resetView];
    
    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [_app.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UINavigationControllerDelegate

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //set up the ABPeoplePicker controls here to get rid of he forced cacnel button on the right hand side but you also then have to
    // the other views it pushes on to ensure they have to correct buttons shown at the correct time.
   
    
    if([navigationController isKindOfClass:[ABPeoplePickerNavigationController class]]
       && [viewController isKindOfClass:[ABPersonViewController class]]){
        navigationController.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(backButtonPressed)];
        
        navigationController.topViewController.navigationItem.leftBarButtonItem = nil;
    }
    else if([navigationController isKindOfClass:[ABPeoplePickerNavigationController class]]){
        navigationController.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(backButtonPressed)];
        
        navigationController.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backButtonPressed)];
    }
     
}



- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person{

    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Contact Saved Successfully !!!"];
    
    [alert setOKButtonWithBlock:^{
        [self backButtonPressed];
    }];

    [alert show];

}

- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{

    return NO;
}


-(void)displayContactView{

    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [_app.navigationController setNavigationBarHidden:NO];
    [_app.navigationController pushViewController:picker animated:YES];

}



@end
