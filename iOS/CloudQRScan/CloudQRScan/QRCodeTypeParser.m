//
//  QRCodeTypeParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 20/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "QRCodeTypeParser.h"

@interface QRCodeTypeParser ()
@property (nonatomic,retain) NSString *qrCodeType;
@end

@implementation QRCodeTypeParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithQRCode:(NSString *)qrCodeString{
    
    self = [self init];
    _qrCodeType = [self detectTypeOfQRCode:qrCodeString];
    return self;
    
}

-(NSString *)detectTypeOfQRCode:(NSString *)qrCodeString{

    NSString *httpLink = @"http://";
    NSString *httpsLink = @"https://";
    NSString *wwwLink = @"www.";
    NSString *itunesLink1 = @"https://itunes";
    NSString *itunesLink2 = @"http://itunes";
    NSString *itunesLink3 = @"//itunes";

    
    NSString *telLink = @"tel:";
    NSString *smsLink = @"smsto:";
    NSString *emailLink1 = @"mailto:";
    NSString *emailLink2 = @"matmsg:";
    NSString *geoLink = @"geo:";
    NSString *eventLink1 = @"begin:vcalendar";
    NSString *eventLink2 = @"begin:vevent";
    NSString *vcardLink = @"begin:vcard";
    NSString *mecardLink = @"mecard:";
    NSString *bookmarkLink = @"mebkm:title:";
    NSString *wifiLink = @"wifi:t:";
    NSString *mp3Link = @".mp3";
    NSString *wmaLink = @".wma";
    NSString *wavLink = @".wav";
    NSString *pdfLink = @".pdf";
    NSString *docLink = @".doc";
    NSString *docxLink = @".docx";
    NSString *pptLink = @".ppt";
    NSString *xlsLink = @".xls";
    NSString *bbm = @"bbm:";
    NSString *bbmGroup = @"bbg:";
    
    NSString *type = kQRCodeText;
    
    qrCodeString = [qrCodeString lowercaseString];
    NSArray *numberOflines = [[qrCodeString trim] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    DLog(@"link %@ %@",qrCodeString,numberOflines);
    
    if      ([qrCodeString hasPrefix:eventLink1] ||
             [qrCodeString hasPrefix:eventLink2 ])  type = kQRCodeCalender;
    
    else if (([qrCodeString hasPrefix:itunesLink1] ||
             [qrCodeString hasPrefix:itunesLink2]  ||
             [qrCodeString hasPrefix:itunesLink3]) &&
             ([numberOflines count]<=1))    type = kQRCodeiTunes;
    
    else if ([qrCodeString hasPrefix:emailLink1]) type = kQRCodeMail1;
    
    else if ([qrCodeString hasPrefix:emailLink2 ]) type = kQRCodeMail2;
    
    
    else if ([qrCodeString hasPrefix:vcardLink])  type = kQRCodevCard;
    
    else if ([qrCodeString hasPrefix:mecardLink]) type = kQRCodemeCard;
    
    else if (([qrCodeString hasSuffix:mp3Link]  ||
             [qrCodeString hasSuffix:wmaLink]   ||
             [qrCodeString hasSuffix:wavLink])  &&
             ([numberOflines count]<=1))        type = kQRCodeAudio;
    
    else if (([qrCodeString hasSuffix:pdfLink]  ||
             [qrCodeString hasSuffix:docLink]   ||
             [qrCodeString hasSuffix:docxLink]  ||
             [qrCodeString hasSuffix:pptLink]   ||
             [qrCodeString hasSuffix:xlsLink])  &&
            ([numberOflines count]<=1))     type = kQRCodeDoc;
    
    
    else if (([qrCodeString hasPrefix:wwwLink]  ||
             [qrCodeString hasPrefix:httpLink]  ||
              [qrCodeString hasPrefix:httpsLink])  &&
             ([numberOflines count]<=1))    type = kQRCodeWeb;
    
    else if ([qrCodeString hasPrefix:telLink])    type = kQRCodePhone;
    
    
    else if ([qrCodeString hasPrefix:smsLink])    type = kQRCodeSMS;
    
    else if ([qrCodeString hasPrefix:geoLink])    type = kQRCodeMap;
    
    else if ([qrCodeString hasPrefix:bookmarkLink]) type = kQRCodeBookmark;
    
    else if ([qrCodeString hasPrefix:wifiLink]) type = kQRCodeWifi;
    
    else if ([qrCodeString hasPrefix:bbm]  ||
              [qrCodeString hasPrefix:bbmGroup])  type = kQRCodeBBM;
    
    
    

    
    
   /*
    if      ([qrCodeString hasPrefix:eventLink1] ||
             [qrCodeString containsString:eventLink2 ignoringCase:YES])  type = kQRCodeCalender;
    
    else if ([qrCodeString containsString:itunesLink ignoringCase:YES]) type = kQRCodeiTunes;
    
    else if ([qrCodeString containsString:emailLink1 ignoringCase:YES]) type = kQRCodeMail1;
    
    else if ([qrCodeString containsString:emailLink2 ignoringCase:YES]) type = kQRCodeMail2;
    
    
    else if ([qrCodeString containsString:vcardLink ignoringCase:YES])  type = kQRCodevCard;
        
    else if ([qrCodeString containsString:mecardLink ignoringCase:YES]) type = kQRCodemeCard;
    
    else if ([qrCodeString containsString:wwwLink ignoringCase:YES]  ||
             [qrCodeString containsString:httpLink ignoringCase:YES] ||
             [qrCodeString containsString:httpsLink ignoringCase:YES])  type = kQRCodeWeb;
        
    else if ([qrCodeString containsString:telLink ignoringCase:YES])    type = kQRCodePhone;
        

    else if ([qrCodeString containsString:smsLink ignoringCase:YES])    type = kQRCodeSMS;
        
    else if ([qrCodeString containsString:geoLink ignoringCase:YES])    type = kQRCodeMap;

    */
    
    return type;
    
}

-(NSString *)getQRCodeType{

    return _qrCodeType;
}

@end
