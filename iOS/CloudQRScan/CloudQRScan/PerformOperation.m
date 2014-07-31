//
//  PerformOperation.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 12/06/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "PerformOperation.h"
#import "TextViewController.h"
#import "EventParser.h"
#import "EventViewController.h"
#import <EventKit/EventKit.h>
#import "ContactController.h"
#import <MessageUI/MessageUI.h>
#import "SMSParser.h"
#import "MailParser.h"
#import "BookmarkParser.h"
#import "GoogleMapViewController.h"
#import "WifiParser.h"
#import "DocumentViewController.h"

@interface PerformOperation ()<ContactControllerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic,retain) NSDictionary   *selectorDictionary;
@property (nonatomic,retain) ContactController *contactController;
@property (nonatomic,retain) MFMailComposeViewController *picker;
@property (nonatomic,retain) AppDelegate *app;
@property (nonatomic,retain) EventViewController *eventVC;
@property (nonatomic,retain) EventParser *eventParser;
@property (nonatomic,retain) AudioViewController *audioVC;
@end

@implementation PerformOperation
@synthesize contactController;

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithQRCode:(NSString *)qrCodeString forType:(NSString *)qrCodeType{
    
    self = [self init];
    [self setSelectorForQRCodeType];
    [self chooseActionOnQRCode:qrCodeString forType:qrCodeType];
    return self;
    
}


-(void)setSelectorForQRCodeType{
    
    _selectorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"performActionForTextTypeWithQRCode:",    kQRCodeText,
                           @"performActionForCalendarTypeWithQRCode:",kQRCodeCalender,
                           @"performActionForiTunesTypeWithQRCode:",  kQRCodeiTunes,
                           @"performActionForvCardTypeWithQRCode:",   kQRCodevCard,
                           @"performActionFormeCardypeWithQRCode:",   kQRCodemeCard,
                           @"performActionForWebTypeWithQRCode:",     kQRCodeWeb,
                           @"performActionForPhoneTypeWithQRCode:",   kQRCodePhone,
                           @"performActionForSMSTypeWithQRCode:",     kQRCodeSMS,
                           @"performActionForMail1TypeWithQRCode:",   kQRCodeMail1,
                           @"performActionForMail2TypeWithQRCode:",   kQRCodeMail2,
                           @"performActionForMapTypeWithQRCode:",     kQRCodeMap,
                           @"performActionForBookmarkTypeWithQRCode:",kQRCodeBookmark,
                           @"performActionForWIFITypeWithQRCode:",    kQRCodeWifi,
                           @"performActionForAudioTypeWithQRCode:",   kQRCodeAudio,
                           @"performActionForDocumenTypeWithQRCode:", kQRCodeDoc,
                           @"performActionForBBMTypeWithQRCode:",     kQRCodeBBM,
                           nil];
    
}

-(void)chooseActionOnQRCode:(NSString *)qrCodeString forType:(NSString *)qrCodeType{

    NSString *aSelectorName = [_selectorDictionary valueForKey:qrCodeType];
    SEL selector = NSSelectorFromString(aSelectorName);
    
    [self performSelector:selector withObject:qrCodeString];
    
}

-(void)performActionForWIFITypeWithQRCode:(NSString *)qrCodeString{


    [Flurry logEvent:@"Scanned WIFI QRCode" timed:NO];
    
    NSString *msg = @"This is a Wi-Fi login for Android devices.\n Do you want to see the credentials in text format ?";
    
    
    WifiParser *wifiParser = [[WifiParser alloc] initWithQRScanResult:qrCodeString];
    

    NSString *formattedResult = [wifiParser getFormattedDetail];
    NSString *title = @"Wi-Fi Login";
    
    [self setHistoryForLink:qrCodeString withHeading:title subHeading:kHistoryWifi type:kQRCodeWifi];
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
    
    [alert setNOButtonWithBlock:NULL];
    [alert setYESButtonWithBlock:^{
        
        TextViewController *textVC = [[TextViewController alloc] initByAppendingDeviceNameWithTitle:kTextTitle];
        textVC.text = formattedResult;
        
        
        [self pushController:textVC];
        
    }];
    
    [alert show];

}


-(void)performActionForTextTypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned Text QRCode" timed:NO];
    TextViewController *textVC = [[TextViewController alloc] initByAppendingDeviceNameWithTitle:kTextTitle];
    textVC.text = qrCodeString;
    
    
    [self setHistoryForLink:qrCodeString withHeading:qrCodeString subHeading:kHistoryText type:kQRCodeText];
    
    [self pushController:textVC];
    
}

-(void)performActionForCalendarTypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned Event QRCode" timed:NO];
    
    _eventParser = [[EventParser alloc] initWithQRScanResult:qrCodeString];
    NSDictionary *eventDict = [_eventParser getEventDictionary];
    
    NSString *heading = [eventDict valueForKey:@"summary"];
    
    _eventVC = [[EventViewController alloc] init];

    [_eventVC displayEventViewForEvent:[_eventParser getEvent] withEventStore:[_eventParser getEventStore]];
    
    [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistoryEvent type:kQRCodeCalender];
    
    
}

-(void)performActionForiTunesTypeWithQRCode:(NSString *)qrCodeString{
  
    [Flurry logEvent:@"Scanned iTunes QRCode" timed:NO];
    
    [self setHistoryForLink:qrCodeString withHeading:qrCodeString subHeading:kHistoryiTunes type:kQRCodeiTunes];
    
    qrCodeString = [qrCodeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

   
    NSURL *url = [NSURL URLWithString:qrCodeString];
    
    [[UIApplication sharedApplication] openURL:url];
    
    }
    
}


-(void)performActionForvCardTypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned vCard QRCode" timed:NO];
    
    contactController = [[ContactController alloc] initWithVCardString:qrCodeString];
    
    NSString *heading =[contactController getName];
    
    [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistoryvCard type:kQRCodevCard];
    
    [contactController setDelegate:self];
    [contactController displayContactView];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)performActionFormeCardypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned meCard QRCode" timed:NO];
    
    contactController = [[ContactController alloc] initWithmeCardString:qrCodeString];
    NSString *heading =[contactController getName];
    
    [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistorymeCard type:kQRCodemeCard];
    
    [contactController setDelegate:self];
    [contactController displayContactView];
    [self.navigationController setNavigationBarHidden:NO];

}

-(void)performActionForBookmarkTypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned Bookmark QRCode" timed:NO];

    BookmarkParser *bookmark = [[BookmarkParser alloc] initWithQRScanResult:qrCodeString];
    
    NSString *heading = [[bookmark getTitle] capitalizedString];
    NSString *url = [bookmark getUrl];
    
    [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistoryBookmark type:kQRCodeBookmark];
    
    NSString *msg = [NSString stringWithFormat:@"Bookmark is not yet supported\nDo you want to open the link\n%@",url];
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
    
    [alert setNOButtonWithBlock:NULL];
    [alert setYESButtonWithBlock:^{
        
        if (![UIDevice isInternetReachable]) {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            
            [alert show];
            
            
        }else{
            
            
            WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:heading];
            webVC.urlString = url;
            
            [self pushController:webVC];
        }

    }];
    
    [alert show];
    
}

-(void)performActionForWebTypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned Website QRCode" timed:NO];
    [self setHistoryForLink:qrCodeString withHeading:qrCodeString subHeading:kHistoryWeb type:kQRCodeWeb];
    
    NSString *urlString = qrCodeString;
    NSString *title = urlString;//@"Loading...";//@"Website";
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    
    WebViewController *webVC = [[WebViewController alloc] initByAppendingDeviceNameWithTitle:title];
    webVC.urlString = urlString;
    
    [self pushController:webVC];
    }
}

-(void)performActionForPhoneTypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned Phone QRCode" timed:NO];
    
    NSString *heading = [qrCodeString stringByReplacingOccurrencesOfString:@"TEL:" withString:@""];
    heading = [heading stringByReplacingOccurrencesOfString:@"tel:" withString:@""];
    heading = [heading trim];
    
    [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistoryPhone type:kQRCodePhone];
    
    UIWebView *phoneCallWebview = [[UIWebView alloc] init];
    NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",qrCodeString]];
    
    if ([[UIApplication sharedApplication] canOpenURL:callURL]) {
        
        [phoneCallWebview loadRequest:[NSURLRequest requestWithURL:callURL]];
        
        [self.view addSubview:phoneCallWebview];
    
    }else{
    
        [[[UIAlertView alloc] initWithTitle:nil message:@"Calling is not supported by this device" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
    }
    
    
}

-(void)performActionForSMSTypeWithQRCode:(NSString *)qrCodeString{
    
   [Flurry logEvent:@"Scanned SMS QRCode" timed:NO];
    
    SMSParser *smsParser = [[SMSParser alloc] initWithQRScanResult:qrCodeString];
    
    NSString *heading = [smsParser getNumber];
     [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistorySMS type:kQRCodeSMS];
    
    MFMessageComposeViewController *controller = [smsParser getSMSController];
	if([MFMessageComposeViewController canSendText])
	{
		controller.messageComposeDelegate = self;
        [controller.navigationBar setBarStyle:UIBarStyleDefault];
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        
        [self.navigationController presentModalViewController:controller animated:YES];
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        [[_app navigationController] presentViewController:controller animated:YES completion:nil];
        
        
        //[[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        [controller.navigationBar setBarStyle:UIBarStyleDefault];
        
        
	}
    else{
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"SMS is not supported by this device" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
    }

    
    
}

-(void)performActionForMail1TypeWithQRCode:(NSString *)qrCodeString{
   
    [Flurry logEvent:@"Scanned Mail QRCode" timed:NO];
    
    MailParser *mailParser =[[MailParser alloc] initWithMail1QRScanResult:qrCodeString] ;
    
    NSString *heading = [mailParser getEmail];
    
    [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistoryMail type:kQRCodeMail1];
    
    _picker = [mailParser getMailController];
    
    
    
    [self performActionForMailType];
    
}

-(void)performActionForMail2TypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned Mail QRCode" timed:NO];
    
    MailParser *mailParser = [[MailParser alloc] initWithMail2QRScanResult:qrCodeString];
    
    NSString *heading = [mailParser getEmail];
    
    [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistoryMail type:kQRCodeMail2];
    
    _picker = [mailParser getMailController];
    
    
    
    [self performActionForMailType];
    
}

-(void)performActionForMailType{

    if ([MFMailComposeViewController canSendMail]) {
        
        _picker.mailComposeDelegate = self;
        
        _picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
        
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        [[_app navigationController] presentModalViewController:_picker animated:YES];
        
        
       // [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        [_picker.navigationBar setBarStyle:UIBarStyleDefault];
        
    }
    else{
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Email not configured in this device" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
    }


}


-(void)performActionForMapTypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned Map QRCode" timed:NO];
    
    NSString *latlonString = [qrCodeString stringByReplacingOccurrencesOfString:@"GEO:" withString:@""];
    
    latlonString = [latlonString stringByReplacingOccurrencesOfString:@"geo:" withString:@""];
    
    latlonString = [latlonString trim];
    
    float lat = [[[latlonString componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
    float lng = [[[latlonString componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
    

    NSString *heading = [NSString stringWithFormat:@"%f,%f",lat,lng];
    
    NSString *title = @"Geolocation";
    
    [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistoryGeolocation type:kQRCodeMap];
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{

    
    GoogleMapViewController *googleMaps = [[GoogleMapViewController alloc] initByAppendingDeviceNameWithTitle:title];
    
    googleMaps.latlonString = latlonString;
    
    
    [self pushController:googleMaps];
    }
}


-(void)performActionForAudioTypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned Audio QRCode" timed:NO];
    
    [self setHistoryForLink:qrCodeString withHeading:qrCodeString subHeading:kHistoryAudio type:kQRCodeAudio];
    
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{
    _audioVC = [[AudioViewController alloc] initByAppendingDeviceNameWithTitle:kAudioTitle];
    
    _audioVC.urlString = qrCodeString;
    
    [self pushController:_audioVC];
    }
}

-(void)performActionForDocumenTypeWithQRCode:(NSString *)qrCodeString{
    
    [Flurry logEvent:@"Scanned Document QRCode" timed:NO];
    
    NSString *type = kQRCodeDocOTH;
    NSString *ext = [[[[[qrCodeString lastPathComponent] componentsSeparatedByString:@"."] lastObject] trim] lowercaseString];
    
    if ([ext isEqualToString:@"pdf"]) {
        type = kQRCodeDocPDF;
    }else if ([ext isEqualToString:@"doc"]) {
        type = kQRCodeDocDOC;
    }else if ([ext isEqualToString:@"ppt"]) {
        type = kQRCodeDocPPT;
    }else if ([ext isEqualToString:@"xls"]) {
        type = kQRCodeDocXLS;
    }
    
    
    [self setHistoryForLink:qrCodeString withHeading:qrCodeString subHeading:kHistoryDocument type:type];
    
    if (![UIDevice isInternetReachable]) {
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:kNoInternetAvailable];
        [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        
        [alert show];
        
        
    }else{
        
        NSString *documentURL = qrCodeString;
        
        if (![documentURL beginsWithString:@"http://"] && ![documentURL beginsWithString:@"https://"]) {
            
            documentURL = [NSString stringWithFormat:@"http://%@",documentURL];
        }
        
        documentURL = [documentURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        documentURL = [documentURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        DocumentViewController *documentVC = [[DocumentViewController alloc] initByAppendingDeviceNameWithTitle:kDocumentTitle];
        documentVC.documentURLString = documentURL;
        
        [self pushController:documentVC];
    }
    
    
}

-(void)performActionForBBMTypeWithQRCode:(NSString *)qrCodeString{

    [Flurry logEvent:@"Scanned BBM QRCode" timed:NO];
    
    NSString *bbg = @"bbg:";
    
    NSString *heading = @"BBM Invite";
    
    if ([qrCodeString hasPrefix:bbg]) {
        heading = @"BBM Group Invite";
    }
    
    [self setHistoryForLink:qrCodeString withHeading:heading subHeading:kHistoryBBM type:kQRCodeBBM];
    
    
    NSString *msg = @"BBM QRCode not supported";
    
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:msg];
    
    
    [alert addButtonWithTitle:@"Open BBM app" imageIdentifier:@"yellow" block:^{
        
        NSURL *bbmURL = [NSURL URLWithString:@"bbm://"];
        //NSURL *bbmURL = [NSURL URLWithString:@"bbm:?pin:75d3a497"];
        
        if ([[UIApplication sharedApplication] canOpenURL:bbmURL]) {
            [[UIApplication sharedApplication] openURL:bbmURL];
        }
        else{
        
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"No BBM app found"];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
        }
    }];
    
    [alert addButtonWithTitle:@"Dismiss" imageIdentifier:@"red" block:^{
        
    }];
    
    [alert show];
    
    

}


-(void)setHistoryForLink:(NSString *)link withHeading:(NSString *)heading subHeading:(NSString *)subheading type:(NSString *)type{

    BOOL shouldSave = [[NSUserDefaults standardUserDefaults] boolForKey:@"savetodb"];
    if (!shouldSave) return;
    
    [[DBManager new] saveLink:link withHeading:heading subHeading:subheading type:type fromLocation:nil onDate:nil];
}

-(void)pushController:(UIViewController *)viewController{

    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] navigationController] pushViewController:viewController animated:YES];

}

-(void)presentController:(id)viewController{
    
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] navigationController] presentViewController:viewController animated:YES completion:NULL];
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{

	switch (result) {
		case MessageComposeResultCancelled:
			DLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Sending Failed - Unknown Error"];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            [alert show];
		}
			break;
		case MessageComposeResultSent:
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"SMS Sent"];
            [alert setOKButtonWithBlock:NULL];
            [alert show];
			
        }
			break;
		default:
			break;
	}
    

    
	[controller dismissViewControllerAnimated:YES completion:NULL];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
        {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Mail Saved"];
            [alert setOKButtonWithBlock:NULL];
            [alert show];
            
        }
            break;
            
        case MFMailComposeResultSent:
        {
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Mail Sent"];
            [alert setOKButtonWithBlock:NULL];
            [alert show];
        }
            break;
            
        case MFMailComposeResultFailed:
        {
           
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Sending Failed - Unknown Error"];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            [alert show];
            
        }
            break;
            
        default:
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Sending Failed - Unknown Error"];
            [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
            [alert show];
            
        }
            
            break;
    }
    
    [_picker dismissViewControllerAnimated:YES completion:NULL];
    //[self dismissViewControllerAnimated:YES completion:NULL];
   // [controller dismissViewControllerAnimated:YES completion:NULL];
    //[[[_app navigationController] topViewController] dismissViewControllerAnimated:YES completion:NULL];
}




@end
