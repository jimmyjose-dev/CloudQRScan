//
//  WebLinkParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "WebLinkParser.h"

@interface WebLinkParser ()
@property(nonatomic,retain)NSString *webLink;
@property(nonatomic,retain)NSString *type;
@end

@implementation WebLinkParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithQRScanResult:(NSString *)qrScanString{
    
    self = [self init];
    [self parseForWebLinkWithQRScanResult:qrScanString];
    return self;
    
}

-(void)parseForWebLinkWithQRScanResult:(NSString *)qrScanString{

    [self setWebLinkDataWithQRScanResult:qrScanString];
}

-(void)setWebLinkDataWithQRScanResult:(NSString *)qrScanString{
    
    _webLink = qrScanString;
    [self setType:qrScanString];
    
}

-(NSString *)getWebLink{

    return _webLink;
}

-(NSString *)getType{

    return _type;
}

-(void)setType:(NSString *)weblink{

    NSString *type = [self detectType:weblink];
    
    _type = type;

}


-(NSString *)detectType:(NSString *)weblink{

    NSString *type = nil;
    
    weblink = [weblink removeString:@"http://"];
    weblink = [weblink removeString:@"https://"];
    weblink = [weblink removeString:@"www."];
    
    NSArray *typeArray = [NSArray arrayWithObjects:@"facebook",@"twitter",@"youtube",@"maps.google", nil];
    
    for (NSString *header in typeArray) {
        
        if ([weblink beginsWithString:header]) {
            
            type = header;
            break;
        }

        
    }
    
    return type;

}

@end
