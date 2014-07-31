//
//  ContactParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 16/04/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ContactParser.h"

@interface ContactParser()

@property(nonatomic,assign)ABRecordRef contactPerson;

@end

@implementation ContactParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithUserInfo:(NSDictionary *)userInfoDictionary{
    
    self = [self init];
    [self parseContactWithuserInfoDictionary:userInfoDictionary];
    return self;
    
}

-(void)parseContactWithuserInfoDictionary:(NSDictionary *)userInfoDict{
    
    
    [self setUserInfoDictionary:userInfoDict];
}


-(void)setUserInfoDictionary:(NSDictionary *)userInfoDict{

   // NSLog(@"userInfoDict %@",userInfoDict);
    
    CFErrorRef error = NULL;
    
    _contactPerson = ABPersonCreate();
    
    if ([userInfoDict objectForKey:@"Image"]) {
     
        CFDataRef contactImage = (__bridge CFDataRef)UIImageJPEGRepresentation([userInfoDict valueForKey:@"Image"],1.0);
        ABPersonSetImageData(_contactPerson, contactImage, nil);
    }
    
    CFTypeRef firstName = (__bridge CFTypeRef) [userInfoDict valueForKey:@"FirstName"];
    CFTypeRef lastName  = (__bridge CFTypeRef) [userInfoDict valueForKey:@"LastName"];

    CFTypeRef companyName = (__bridge CFTypeRef) [userInfoDict valueForKey:@"CompanyName"];
    CFTypeRef jobTitle  = (__bridge CFTypeRef) [userInfoDict valueForKey:@"Designation"];

    CFTypeRef mobilePhone = (__bridge CFTypeRef) [userInfoDict valueForKey:@"ContactNumber"];
    CFTypeRef website  = (__bridge CFTypeRef) [userInfoDict valueForKey:@"Website"];

    CFTypeRef email = (__bridge CFTypeRef) [userInfoDict valueForKey:@"Email"];
    
    CFTypeRef note = (__bridge CFTypeRef) [userInfoDict valueForKey:@"Note"];
    
    
    

    ABRecordSetValue(_contactPerson, kABPersonFirstNameProperty, firstName, &error);
    CFRelease(firstName);

    ABRecordSetValue(_contactPerson, kABPersonLastNameProperty, lastName, &error);
    CFRelease(lastName);
    
    ABRecordSetValue(_contactPerson, kABPersonOrganizationProperty, companyName, &error);
    CFRelease(companyName);

    ABRecordSetValue(_contactPerson, kABPersonJobTitleProperty, jobTitle, &error);
    CFRelease(jobTitle);
    
    ABRecordSetValue(_contactPerson, kABPersonNoteProperty,note, &error);
    CFRelease(note);
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    // ABMultiValueAddValueAndLabel(multiPhone, companyPhone, kABPersonPhoneMainLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, mobilePhone, kABPersonPhoneMobileLabel, NULL);
    CFRelease(mobilePhone);
    
    ABRecordSetValue(_contactPerson, kABPersonPhoneProperty, multiPhone,nil);
    CFRelease(multiPhone);
    
    ABMutableMultiValueRef multiWeb = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiWeb, website, kABWorkLabel, NULL);
    CFRelease(website);
    
    ABRecordSetValue(_contactPerson, kABPersonURLProperty, multiWeb, &error);
    CFRelease(multiWeb);
    
    
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, email, kABWorkLabel, NULL);
    CFRelease(email);
    
    ABRecordSetValue(_contactPerson, kABPersonEmailProperty, multiEmail, &error);
    CFRelease(multiEmail);
    
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *street =  [userInfoDict valueForKey:@"Street"];
    NSString *city =  [userInfoDict valueForKey:@"City"];
    NSString *state =  [userInfoDict valueForKey:@"State"];
    NSString *country =  [userInfoDict valueForKey:@"Country"];
    NSString *zip =  [userInfoDict valueForKey:@"Zip"];
    
    
    if (![street isNullOrEmpty])[addressDictionary setObject:street forKey:(NSString *) kABPersonAddressStreetKey];
    
    if (![city isNullOrEmpty])[addressDictionary setObject:city forKey:(NSString *)kABPersonAddressCityKey];
    
    if (![state isNullOrEmpty])[addressDictionary setObject:state forKey:(NSString *)kABPersonAddressStateKey];
    
    if (![country isNullOrEmpty])[addressDictionary setObject:country forKey:(NSString *)kABPersonAddressCountryKey];
    
    if (![zip isNullOrEmpty])[addressDictionary setObject:zip forKey:(NSString *)kABPersonAddressZIPKey];
    
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
    ABRecordSetValue(_contactPerson, kABPersonAddressProperty, multiAddress,&error);
    
    CFRelease(multiAddress);
    
    ABMutableMultiValueRef multiChatAccount = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    /*
     const CFStringRef aol = (CFStringRef)@"AOL";
     const CFStringRef gtalk = (CFStringRef)@"Gtalk";
     const CFStringRef mirc = (CFStringRef)@"mIRC";
     const CFStringRef qq = (CFStringRef)@"QQ";
     const CFStringRef skype = (CFStringRef)@"Skype";
     */
    
    NSDictionary *IMDictionary = [userInfoDict valueForKey:@"InstantMessaging"];
    
    for (NSString *key in [IMDictionary allKeys]) {

        NSMutableDictionary *IMAcctount = [NSMutableDictionary new];
        
        NSString *userName = [IMDictionary valueForKey:key];
        NSString *IMAcctountType = key;
        
        [IMAcctount setObject:userName forKey:(NSString *) kABPersonInstantMessageUsernameKey];
        [IMAcctount setObject:IMAcctountType forKey:(NSString *) kABPersonInstantMessageServiceKey];
        
        ABMultiValueAddValueAndLabel(multiChatAccount, (__bridge CFTypeRef)(IMAcctount), kABWorkLabel, NULL);
        
    }
    
    ABRecordSetValue(_contactPerson, kABPersonInstantMessageProperty, multiChatAccount,&error);
    CFRelease(multiChatAccount);
    
}


-(id)initWithmeCard:(NSString *)qrcodeString{
    
    self = [self init];
    [self parsemeCardWithQRCodeString:qrcodeString];
    return self;
    
}

-(void)parsemeCardWithQRCodeString:(NSString *)qrcodeString{
    
    
    [self setmeCardInfo:qrcodeString];
}


-(void)setmeCardInfo:(NSString *)qrcodeString{
    
    NSString *mcardStr = [qrcodeString substringFromIndex:7];
   // DLog(@"mcardStr %@",mcardStr);
    
    NSArray *arry = [mcardStr componentsSeparatedByString:@";"];
    
    NSMutableDictionary* mecardDict =[[NSMutableDictionary alloc] init];
    for (int i =0; i<[arry count]; ++i) {
        
        NSArray *arr = [[arry objectAtIndex:i] componentsSeparatedByString:@":"];
        if ([arr count]>1) {
            
            NSString *key =[[arr objectAtIndex:0] lowercaseString];
            NSString *value= [arr objectAtIndex:1];
            if ([key isEqualToString:@"url"]) {
                if ([arr count]>2) {
                    value = [value stringByAppendingFormat:@":%@",[arr objectAtIndex:2]];
                }
            }
            
            [mecardDict setValue:value forKey:key];
            //DLog(@"%@  %@",key,value);
        }
        
    }
    NSArray *nameArray = [[mecardDict valueForKey:@"n"] componentsSeparatedByString:@","];
    NSString *firstName = nil;
    if ([nameArray count]>1) {
        firstName =[nameArray objectAtIndex:1];
    }
    
    
    
    NSString *lastName = [nameArray objectAtIndex:0];
    
    
    CFErrorRef error = NULL;
    // ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    _contactPerson = ABPersonCreate();
    
    if (firstName !=nil) {
        ABRecordSetValue(_contactPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), &error);
    }
    
    ABRecordSetValue(_contactPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), &error);
    
    NSString *note = [mecardDict valueForKey:@"note"];
    
    if (note!=nil) {
        
        //DLog(@"notes %@",note);
        ABRecordSetValue(_contactPerson, kABPersonNoteProperty, (__bridge CFTypeRef)(note), nil);
        
    }
    
    NSString *companyPhone = [mecardDict valueForKey:@"tel"];
    
    if (companyPhone !=nil) {
        //DLog(@"telephone %@",companyPhone);
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(companyPhone), kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(_contactPerson, kABPersonPhoneProperty, multiPhone,nil);
        
    }
    
    NSString *website = [mecardDict valueForKey:@"url"];
    if (website != nil) {
        
        //DLog(@"website %@",website);
        
        ABMutableMultiValueRef multiWeb = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiWeb, (__bridge CFTypeRef)(website), kABWorkLabel, NULL);
        ABRecordSetValue(_contactPerson, kABPersonURLProperty, multiWeb, &error);
        CFRelease(multiWeb);
        
    }
    
    NSString *emailAddress = [mecardDict valueForKey:@"email"];
    if (emailAddress != nil) {
        
        //DLog(@"email %@",emailAddress);
        
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(emailAddress), kABWorkLabel, NULL);
        ABRecordSetValue(_contactPerson, kABPersonEmailProperty, multiEmail, &error);
        CFRelease(multiEmail);
        
    }
    
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    
    if ([mecardDict valueForKey:@"adr"] !=nil) {
        
        
        
        NSArray *addressArray = [[mecardDict valueForKey:@"adr"] componentsSeparatedByString:@","];
       // DLog(@"address %@",addressArray);
        
       // for (int i =0; i<[addressArray count]; ++i) {
            //NSLog(@"%d %@",i,[addressArray objectAtIndex:i]);
        //}
        
        
        if ([addressArray count]==1) {//support for Redlaser type contact info
            [addressDictionary setObject:[addressArray objectAtIndex:0] forKey:(NSString *) kABPersonAddressStreetKey];
            
        }
        
        else {
            
            
            [addressDictionary setObject:[addressArray objectAtIndex:0] forKey:(NSString *) kABPersonAddressStreetKey];
            [addressDictionary setObject:[addressArray objectAtIndex:1] forKey:(NSString *)kABPersonAddressCityKey];
            
            if ([addressArray count]>4) {
                [addressDictionary setObject:[addressArray objectAtIndex:2] forKey:(NSString *)kABPersonAddressStateKey];
                
                NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                
                 NSString *cityOrZip = [[addressArray objectAtIndex:3] trim];
                 
                 if ([cityOrZip rangeOfCharacterFromSet:notDigits].location == NSNotFound)
                 {
                
                 [addressDictionary setObject:cityOrZip forKey:(NSString *)kABPersonAddressZIPKey];
                 }
                 else{
                 
               
                 [addressDictionary setObject:cityOrZip forKey:(NSString *)kABPersonAddressCityKey];
                 }
                 
                 

                
               // [addressDictionary setObject:[addressArray objectAtIndex:3] forKey:(NSString *)kABPersonAddressZIPKey];
                
                [addressDictionary setObject:[addressArray objectAtIndex:4] forKey:(NSString *)kABPersonAddressCountryKey];
                
            }else {
                
                //[addressDictionary setObject:[addressArray objectAtIndex:2] forKey:(NSString *)kABPersonAddressZIPKey];
                
                NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                
                NSString *cityOrZip = [[addressArray objectAtIndex:2] trim];
                
                if ([cityOrZip rangeOfCharacterFromSet:notDigits].location == NSNotFound)
                {
                    [addressDictionary setObject:cityOrZip forKey:(NSString *)kABPersonAddressZIPKey];
                }
                else{
                    
                    [addressDictionary setObject:cityOrZip forKey:(NSString *)kABPersonAddressCityKey];
                }

                
                [addressDictionary setObject:[addressArray objectAtIndex:3] forKey:(NSString *)kABPersonAddressCountryKey];
                
            }
            
        }
        
        
        
        ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
        ABRecordSetValue(_contactPerson, kABPersonAddressProperty, multiAddress,&error);
        CFRelease(multiAddress);
        
    }
    
}

-(ABRecordRef)getContactPerson{

    return _contactPerson;
}



    

@end
