//
//  mCardParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "mCardParser.h"

@interface mCardParser ()
@property(nonatomic,assign)ABRecordRef person;
@end

@implementation mCardParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithQRScanResult:(NSString *)qrScanString{
    
    self = [self init];
    [self parseFormCardWithQRScanResult:qrScanString];
    return self;
    
}

-(void)parseFormCardWithQRScanResult:(NSString *)qrScanString{

    [self setEventDataWithQRScanResult:qrScanString];
}

-(void)setEventDataWithQRScanResult:(NSString *)mCardString{
    
    NSString *mcardStr = [mCardString substringFromIndex:7];
    DLog(@"mcardStr %@",mcardStr);
    
    NSArray *arry = [mcardStr componentsSeparatedByString:@";"];
    
    NSMutableDictionary* mecardDict =[[NSMutableDictionary alloc] init];
    for (int i =0; i<[arry count]; ++i) {
        
        NSArray *arr = [[arry objectAtIndex:i] componentsSeparatedByString:@":"];
        if ([arr count]>1) {
            [mecardDict setValue:[arr objectAtIndex:1] forKey:[[arr objectAtIndex:0] lowercaseString]];
            DLog(@"%@  %@",[[arr objectAtIndex:0] lowercaseString],[arr objectAtIndex:1]);
        }
        
    }
    NSArray *nameArray = [[mecardDict valueForKey:@"n"] componentsSeparatedByString:@","];
    NSString *firstName = nil;
    if ([nameArray count]>1) {
        firstName =[nameArray objectAtIndex:1];
    }
    
    
    
    NSString *lastName = [nameArray objectAtIndex:0];
    DLog(@"Last Name %@",lastName);
    
    CFErrorRef error = NULL;
    // ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    
    if (firstName !=nil) {
        ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), &error);
    }
    
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), &error);
    
    NSString *note = [mecardDict valueForKey:@"note"];
    
    if (note!=nil) {
        
        DLog(@"notes %@",note);
        ABRecordSetValue(newPerson, kABPersonNoteProperty, (__bridge CFTypeRef)(note), nil);
        
    }
    
    NSString *companyPhone = [mecardDict valueForKey:@"tel"];
    
    if (companyPhone !=nil) {
        DLog(@"telephone %@",companyPhone);
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(companyPhone), kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
        
    }
    
    NSString *website = [mecardDict valueForKey:@"url"];
    if (website != nil) {
        
        DLog(@"website %@",website);
        
        ABMutableMultiValueRef multiWeb = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiWeb, (__bridge CFTypeRef)(website), kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonURLProperty, multiWeb, &error);
        CFRelease(multiWeb);
        
    }
    
    NSString *emailAddress = [mecardDict valueForKey:@"email"];
    if (emailAddress != nil) {
        
        DLog(@"email %@",emailAddress);
        
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(emailAddress), kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
        CFRelease(multiEmail);
        
    }
    
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    
    if ([mecardDict valueForKey:@"adr"] !=nil) {
        
        
        
        NSArray *addressArray = [[mecardDict valueForKey:@"adr"] componentsSeparatedByString:@","];
        DLog(@"address %@",addressArray);
       
    
        
        if ([addressArray count]==1) {//support for Redlaser type contact info
            [addressDictionary setObject:[[addressArray objectAtIndex:0] trim] forKey:(NSString *) kABPersonAddressStreetKey];
            
        }
        
        else {
            
            
            [addressDictionary setObject:[[addressArray objectAtIndex:0] trim] forKey:(NSString *) kABPersonAddressStreetKey];
            [addressDictionary setObject:[[addressArray objectAtIndex:1] trim] forKey:(NSString *)kABPersonAddressCityKey];
            
            if ([addressArray count]>4) {
                [addressDictionary setObject:[[addressArray objectAtIndex:2] trim] forKey:(NSString *)kABPersonAddressStateKey];
                
                /*
                NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                
                NSString *cityOrZip = [[addressArray objectAtIndex:3] trim];
                
                if ([cityOrZip rangeOfCharacterFromSet:notDigits].location == NSNotFound)
                {
                    NSLog(@"if %@",cityOrZip);
                    [addressDictionary setObject:cityOrZip forKey:(NSString *)kABPersonAddressZIPKey];
                }
                else{
                
                    NSLog(@"in else %@",cityOrZip);
                    [addressDictionary setObject:cityOrZip forKey:(NSString *)kABPersonAddressCityKey];
                }
                
                */
                
                
                [addressDictionary setObject:[[addressArray objectAtIndex:3] trim] forKey:(NSString *)kABPersonAddressZIPKey];
                [addressDictionary setObject:[[addressArray objectAtIndex:4] trim] forKey:(NSString *)kABPersonAddressCountryKey];
                
            }else {
                
                [addressDictionary setObject:[[addressArray objectAtIndex:2] trim] forKey:(NSString *)kABPersonAddressZIPKey];
                
                [addressDictionary setObject:[[addressArray objectAtIndex:3] trim] forKey:(NSString *)kABPersonAddressCountryKey];
                
            }
            
        }
        
        
        ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress,&error);
        CFRelease(multiAddress);
        
    }

    _person = newPerson;
    
}

-(ABRecordRef)getmCardPerson{
    
    return _person;
    
}

@end
