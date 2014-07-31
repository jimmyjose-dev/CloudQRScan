//
//  MailParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "MailParser.h"
#import <MessageUI/MessageUI.h>

@interface MailParser ()
@property(nonatomic,retain)MFMailComposeViewController *mailController;
@property(nonatomic,retain)NSString *email;
@end

@implementation MailParser
-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithMail1QRScanResult:(NSString *)qrcodeString{
    
    self = [self init];
    [self parseForMail1WithQRScanResult:qrcodeString];
    return self;
    
}

-(void)parseForMail1WithQRScanResult:(NSString *)qrcodeString{
    
    [self setMail1DataWithQRScanResult:qrcodeString];
}


-(void)setMail1DataWithQRScanResult:(NSString *)qrcodeString{

    NSArray *mailheader = [qrcodeString componentsSeparatedByString:@":"];
    qrcodeString = [[mailheader objectAtIndex:1] trim];
    NSString *to = [[mailheader objectAtIndex:1] trim];
    NSString *subject = @"";
    NSString *body = @"";
    
    NSArray *emailBody = [qrcodeString componentsSeparatedByString:@"?"];
    if (emailBody && [emailBody count]>1) {
        to = [[emailBody objectAtIndex:0] trim];
        subject = [[[[[emailBody objectAtIndex:1] componentsSeparatedByString:@"&"] objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
        
        body = [[[[[emailBody objectAtIndex:1] componentsSeparatedByString:@"&"] objectAtIndex:1] componentsSeparatedByString:@"="] objectAtIndex:1];
        
    }
    
    NSDictionary *mailContentDictionary = [NSDictionary dictionaryWithObjectsAndKeys:to,@"to",subject,@"sub",body,@"body", nil];
    
    [self setMailDataWithQRScanResult:mailContentDictionary];

}


-(id)initWithMail2QRScanResult:(NSString *)qrcodeString{
    
    self = [self init];
    [self parseForMail2WithQRScanResult:qrcodeString];
    return self;
    
}

-(void)parseForMail2WithQRScanResult:(NSString *)qrcodeString{
    
    [self setMail2DataWithQRScanResult:qrcodeString];
}

-(void)setMail2DataWithQRScanResult:(NSString *)qrcodeString{

    BOOL toStatus = NO;
    NSArray *array = [qrcodeString componentsSeparatedByString:@";"];
    
    NSMutableDictionary *mailContentDictionary = [[NSMutableDictionary alloc] init];
    for (int i=0; i< [array count]; ++i) {
        NSArray *valKey = [[array objectAtIndex:i] componentsSeparatedByString:@":"];
        
        if (i==0) {
            
            toStatus = YES;
            
            [mailContentDictionary setValue:[[valKey objectAtIndex:2] trim] forKey:[[[valKey objectAtIndex:1] lowercaseString] trim]];
        }else {
            if ([valKey count]>1) {
                [mailContentDictionary setValue:[[valKey objectAtIndex:1] trim] forKey:[[[valKey objectAtIndex:0] lowercaseString] trim]];
            }
        }
        
        
    }
    
    
    [self setMailDataWithQRScanResult:mailContentDictionary];
    
}




-(void)setMailDataWithQRScanResult:(NSDictionary *)mailContentDictionary{
    
    DLog(@"mailContentDictionary %@",mailContentDictionary);
    _mailController = [MFMailComposeViewController new];
    
    NSString *emailTo = [mailContentDictionary valueForKey:@"to"];
    NSString *emailBody = [mailContentDictionary valueForKey:@"body"];
    NSString *emailSubject = [mailContentDictionary valueForKey:@"sub"];
    
    if (emailTo && [emailTo length]) {
        
        _email = emailTo;
        [_mailController setToRecipients:[NSArray arrayWithObject:emailTo]];
        
    }
    
    if (emailSubject && [emailSubject length]) {
        
        [_mailController setSubject:emailSubject];
    }
    else{
        [_mailController setSubject:[NSString stringWithFormat:@""]];
    }
    
    // Fill out the email body text
    
    if (emailBody && [emailBody length]) {
        
        [_mailController setMessageBody:emailBody isHTML:NO]; // depends. Mostly YES, unless you want to send
    }
    else{
        NSString *emailBody = @"";
        
        [_mailController setMessageBody:emailBody isHTML:NO]; // depends. Mostly YES, unless you want to send it as plain text (boring)
    }
    
    
   // _mailController.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
    
    
    //[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    
   // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    //[_mailController.navigationBar setBarStyle:UIBarStyleDefault];
    
}

-(MFMailComposeViewController *)getMailController{
    
    return _mailController;
}

-(NSString *)getEmail{

    return _email;

}

@end
