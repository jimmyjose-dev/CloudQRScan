//
//  BookmarkParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 27/09/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "BookmarkParser.h"

@interface BookmarkParser ()
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *url;

@end

@implementation BookmarkParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithQRScanResult:(NSString *)qrScanString{
    
    self = [self init];
    [self parseForBookmarkWithQRScanResult:qrScanString];
    return self;
    
}

-(void)parseForBookmarkWithQRScanResult:(NSString *)qrScanString{
    
    [self setBookmarkDataWithQRScanResult:qrScanString];
}

-(void)setBookmarkDataWithQRScanResult:(NSString *)qrScanString{
    
    qrScanString = [qrScanString lowercaseString];
    
    
    qrScanString = [qrScanString stringByReplacingOccurrencesOfString:@"mebkm:title:" withString:@""];
    
    NSArray *bookmarkData = [qrScanString componentsSeparatedByString:@";url:"];
    
    NSString *title = [bookmarkData firstObject];
    NSString *url = [bookmarkData lastObject];
    
    _title = [title trim];
    _url = [url trim];
    
}

-(NSString *)getTitle{

    return _title;
}

-(NSString *)getUrl{

    return _url;
}



@end
