//
//  vCardParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "vCardParser.h"

@interface vCardParser ()
@property(nonatomic,assign)ABRecordRef person;
@end

@implementation vCardParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithQRScanResult:(NSString *)qrScanString{
    
    self = [self init];
    [self parseForvCardWithQRScanResult:qrScanString];
    return self;
    
}

-(void)parseForvCardWithQRScanResult:(NSString *)qrScanString{

    [self setEventDataWithQRScanResult:qrScanString];
}

-(void)setEventDataWithQRScanResult:(NSString *)vCardString{
    
    CFDataRef vCardData = (__bridge CFDataRef)[vCardString dataUsingEncoding:NSUTF8StringEncoding];
    ABAddressBookRef book = ABAddressBookCreate();
    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
    CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
    
    _person = CFArrayGetValueAtIndex(vCardPeople, 0);
    
}

-(ABRecordRef)getvCardPerson{

    return _person;

}
@end
