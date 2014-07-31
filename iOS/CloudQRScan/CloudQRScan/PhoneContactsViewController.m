//
//  PhoneContactsViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 20/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "PhoneContactsViewController.h"
#import "GenerateQRCodeViewController.h"
#import "AddressBook/AddressBook.h"
#import "CustomTableViewCell.h"

@interface PhoneContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSMutableDictionary *contactDict;
    NSMutableDictionary *contactSortDict;
    NSArray *options;

}
@property (nonatomic,retain)IBOutlet UITableView *tableView;
@property (nonatomic,retain)NSMutableDictionary *contactDict;
@property (nonatomic,retain)NSMutableDictionary *contactSortDict;
@property (nonatomic,retain)NSArray *options;

@end


@implementation PhoneContactsViewController
@synthesize options,contactSortDict,contactDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        [self getContact];
        [self loadContacts];
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"Create QRContact" withParameters:nil];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [Flurry logEvent:@"Create QRContact" timed:YES];
    
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

/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.options count];
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;//[CustomTableViewCell heigthForCell];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellId = @"CustomTableViewCell";//[NSString stringWithFormat:@"cell_%d",indexPath.section];
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.title.text = [self.contactSortDict valueForKey:[self.options objectAtIndex:indexPath.row]];
/*
    ^{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordID recordId = (ABRecordID)[[options objectAtIndex:indexPath.row] intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordId);
    
    // Check for contact picture
    UIImage *image = nil;
    if (person != nil && ABPersonHasImageData(person)) {
        CFDataRef contactImageData = ABPersonCopyImageDataWithFormat(person,kABPersonImageFormatThumbnail);
        image = [UIImage imageWithData:(__bridge NSData *)contactImageData];
        CFBridgingRelease(contactImageData);
    }
    else {
        
        image =  [UIImage imageNamed:@"icon_default_profile_iPhone"];
    }
     
    
        CFRelease(addressBook);
        
     [cell.imgVW setImage:image];
        
    }();
 */
    [cell.imgVW setImage:[UIImage imageNamed:@"icon_default_profile_iPhone"]];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordID recordId = (ABRecordID)[[options objectAtIndex:indexPath.row] intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordId);
    [ [ NSOperationQueue mainQueue ] addOperation:
     [ NSBlockOperation blockOperationWithBlock:^{
        if (ABPersonHasImageData(person)) {
            
            CFDataRef contactImageData = ABPersonCopyImageDataWithFormat(person,kABPersonImageFormatThumbnail);
            UIImage *image = [UIImage imageWithData:(__bridge NSData *)contactImageData];
            CFBridgingRelease(contactImageData);
        [cell.imgVW setImage:image];
    }
        
    } ]] ;
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_forward_iPhone"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
}

-(void)loadContacts {
    ABAddressBookRef addressBook;
    if ([self isABAddressBookCreateWithOptionsAvailable]) {
        CFErrorRef error = nil;
        addressBook = ABAddressBookCreateWithOptions(NULL,&error);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // callback can occur in background, address book must be accessed on thread it was created on
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    // [self.delegate addressBookHelperError:self];
                } else if (!granted) {
                    //[self.delegate addressBookHelperDeniedAcess:self];
                } else {
                    // access granted
                    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
                    
                    // process the contacts to return
                    NSArray *contacts = (__bridge NSArray*)(people);
                    [self parseContactsWithContactsArray:contacts];
                    // AddressBookUpdated(addressBook, nil, (__bridge void *)(self));
                    CFRelease(people);
                    CFRelease(addressBook);
                }
            });
        });
    } else {
        // iOS 4/5
        addressBook = ABAddressBookCreate();
        ABAddressBookRevert(addressBook);
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        // process the contacts to return
        NSArray *contacts = (__bridge NSArray*)(people);
        [self parseContactsWithContactsArray:contacts];
        //AddressBookUpdated(addressBook, NULL, (__bridge void *)(self));
        CFRelease(people);
        CFRelease(addressBook);
    }
}

/*
void AddressBookUpdated(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    
    
    ABAddressBookRevert(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    // process the contacts to return
    NSArray *contacts = (__bridge NSArray*)(people);
    

    
   
    }
};
 */

-(void)parseContactsWithContactsArray:(NSArray *)contactsArray{

    self.contactDict = [[NSMutableDictionary alloc] init];
    self.contactSortDict = [[NSMutableDictionary alloc] init];
    
    for (id person in contactsArray) {
        
        ABRecordRef record = (__bridge ABRecordRef)person; // get address book record
        
        if(ABRecordGetRecordType(record) ==  kABPersonType) // this check execute if it is person group
        {

        
        ABRecordRef contactPerson = (__bridge ABRecordRef)person;
        
        //4
        // NSString *firstNameString = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
        //        NSString *lastNameString =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
       
        ABRecordID recordId = ABRecordGetRecordID(record); // get record id from address book record
        
        NSString *recordIdString = [NSString stringWithFormat:@"%d",recordId]; // get record id string from record id

        

    NSString *name = (__bridge NSString *)(ABRecordCopyCompositeName(contactPerson));
               
    [self.contactDict setValue:name forKey:recordIdString];
    }
    }

    self.options = [self.contactDict keysSortedByValueUsingSelector:@selector(compare:)];
    
    for (int i=0; i<[self.options count]; ++i) {
        
        [self.contactSortDict setValue:[self.contactDict valueForKey:[NSString stringWithFormat:@"%@",[self.options objectAtIndex:i]]] forKey:[NSString stringWithFormat:@"%@",[self.options objectAtIndex:i]]];
    }
    
    
    if ([self.options count]) {
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView reloadData];
    }else{
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Please add atleast one contact and try again"];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        [alert show];
        
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordID recordId = (ABRecordID)[[options objectAtIndex:indexPath.row] intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordId);
    NSArray *peopleArray = [NSArray arrayWithObject:(__bridge id)(person)];
    CFDataRef vCardRef = ABPersonCreateVCardRepresentationWithPeople((__bridge CFArrayRef)(peopleArray));
    NSData *vCardData = (__bridge NSData *)(vCardRef);
    NSString *vCard = [self removeImageFromVCF:[vCardData stringUTF8]];
    DLog(@"%@",vCard);
    

    
    GenerateQRCodeViewController *generateVC = [[GenerateQRCodeViewController alloc] initByAppendingDeviceNameWithTitle:@"Generated QRCode"];
    
    generateVC.qrCodeString = [[NSString alloc] initWithString:vCard];
    generateVC.qrCodeType = @"contact";
    
    [self.navigationController pushViewController:generateVC animated:YES];
   
    
    
    
}   

- (NSString *)removeImageFromVCF:(NSString *)vCard {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:vCard];
    
    if ([vCard rangeOfString:@"X-SOCIALPROFILE"].location == NSNotFound) {
        
        while ([theScanner isAtEnd] == NO) {
            
            [theScanner scanUpToString:@"PHOTO" intoString:NULL] ;
            [theScanner scanUpToString:@"END:VCARD" intoString:&text] ;
            
            vCard = [vCard stringByReplacingOccurrencesOfString:
                          [NSString stringWithFormat:@"%@", text] withString:@""];
        }
        
    }else{
        
        while ([theScanner isAtEnd] == NO) {
            
            [theScanner scanUpToString:@"PHOTO" intoString:NULL] ;
            [theScanner scanUpToString:@"X-SOCIALPROFILE" intoString:&text] ;
            
            [theScanner scanUpToString:@"END:VCARD" intoString:NULL];
            
            vCard = [vCard stringByReplacingOccurrencesOfString:
                          [NSString stringWithFormat:@"%@", text] withString:@""];
            
            
        }
        
    }
    
    return vCard;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
