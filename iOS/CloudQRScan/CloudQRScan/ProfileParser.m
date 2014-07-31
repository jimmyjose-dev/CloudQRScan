//
//  ProfileParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 19/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ProfileParser.h"

@interface ProfileParser ()

@property(nonatomic,retain)NSMutableDictionary *userInfoDictionary;
@property(nonatomic,retain)NSMutableDictionary *companyInfoDictionary;

@property(nonatomic,retain)NSArray *similarPeopleArray;
@property(nonatomic,retain)NSMutableDictionary *soundDictionary;

@property(nonatomic,retain)NSDictionary *socialMediaDictionary;
@property(nonatomic,retain)NSDictionary *instantMessagingDictionary;
@property(nonatomic,retain)NSArray *documentsArray;

@property(nonatomic,retain)NSArray *galleryArray;
@property(nonatomic,retain)NSArray *evernoteArray;
@property(nonatomic,retain)NSArray *videoArray;

@property(nonatomic,retain)NSMutableDictionary *selectorDictionary;

@property(nonatomic,retain)NSMutableDictionary *featureNameAndIconDictionary;

@property(nonatomic,retain)NSArray *displayOrderArray;

@property(nonatomic,retain)NSMutableDictionary *contactInfoDictionary;
@end

@implementation ProfileParser


-(id)init{

    self = [super init];
    
    return self;

}

-(id)initWithUserInfo:(NSDictionary *)userInfoDictionary{

    self = [self init];
    [self parseProfileWithuserInfoDictionary:userInfoDictionary];
    return self;

}

-(void)parseProfileWithuserInfoDictionary:(NSDictionary *)userInfoDict{

    _selectorDictionary = [NSMutableDictionary new];
    
    _featureNameAndIconDictionary = [NSMutableDictionary new];
    
    _contactInfoDictionary = [NSMutableDictionary new];
    
    [self setUserInfoDictionary:userInfoDict];
    [self setCompanyInfoDictionary:userInfoDict];
    [self setDocumentsArray:userInfoDict];

    [self setSimilarPeopleArray:userInfoDict];
    [self setSoundDictionary:userInfoDict];
    [self setSocialMediaDictionary:userInfoDict];
    [self setInstantMessagingDictionary:userInfoDict];
    
    [self setGalleryArray:userInfoDict];
    [self setEvernoteArray:userInfoDict];
    [self setVideoArray:userInfoDict];
    
    [self setDisplayOrder];
    
}


-(void)setUserInfoDictionary:(NSDictionary *)userInfoDict{
    
     _userInfoDictionary = [NSMutableDictionary new];
   
    NSString *firstName = [userInfoDict valueForKey:@"FirstName"];
    NSString *lastName = [userInfoDict valueForKey:@"LastName"];
    NSString *fullName = [userInfoDict valueForKey:@"FullName"];
    NSString *mobileNumber = [userInfoDict valueForKey:@"MobilePhone"];
    NSString *note = [userInfoDict valueForKey:@"Note"];
    NSURL *imageUrl = [NSURL URLWithString:[userInfoDict valueForKey:@"Image"]];
    NSString *accountID = [userInfoDict valueForKey:@"AccountId"];
    
    [_userInfoDictionary setValue:firstName forKey:@"FirstName"];
    [_userInfoDictionary setValue:lastName forKey:@"LastName"];
    [_userInfoDictionary setValue:fullName forKey:@"FullName"];
    [_userInfoDictionary setValue:mobileNumber forKey:@"ContactNumber"];
    [_userInfoDictionary setValue:imageUrl forKey:@"ImageURL"];
    [_userInfoDictionary setValue:accountID forKey:@"AccountId"];
    
    
    [_contactInfoDictionary setValue:firstName forKey:@"FirstName"];
    [_contactInfoDictionary setValue:lastName forKey:@"LastName"];
    [_contactInfoDictionary setValue:fullName forKey:@"FullName"];
    [_contactInfoDictionary setValue:mobileNumber forKey:@"ContactNumber"];
    [_contactInfoDictionary setValue:imageUrl forKey:@"ImageURL"];
    [_contactInfoDictionary setValue:note forKey:@"Note"];
    
    NSString *selectorName = @"contactDetailsButtonPressed";
   
    NSString *keyName = @"Contact Details";
    UIImage *image = [UIImage imageByAppendingDeviceName:@"icon_profile"];
    
    [self setSelectorName:selectorName addKey:keyName andValue:image];

}

-(void)setImageDataFromImage:(UIImage *)image{

    [_userInfoDictionary setObject:image forKey:@"Image"];
    [_contactInfoDictionary setObject:image forKey:@"Image"];


}

-(void)setCompanyInfoDictionary:(NSDictionary *)userInfoDict{

    _companyInfoDictionary = [NSMutableDictionary new];
    
    NSString *address = [userInfoDict valueForKey:@"Address"];
    NSString *city = [userInfoDict valueForKey:@"City"];
    NSString *country = [userInfoDict valueForKey:@"Country"];
    NSString *state = [userInfoDict valueForKey:@"State"];
    NSString *maplocation = [userInfoDict valueForKey:@"MapLocation"];
    NSString *zip = [userInfoDict valueForKey:@"Zip"];
    
    NSString *companyName = [userInfoDict valueForKey:@"Company"];
    NSString *designation = [userInfoDict valueForKey:@"Designation"];
    NSString *companyPhone = [userInfoDict valueForKey:@"MobilePhone"];
    //NSString *companyPhone = [userInfoDict valueForKey:@"CompanyPhone"];
    
    NSString *email = [userInfoDict valueForKey:@"Email"];
    NSURL *logoUrl = [NSURL URLWithString:[userInfoDict valueForKey:@"Logo"]];
    NSString *website = [userInfoDict valueForKey:@"Website"];
    
    NSString *fullAddress = address;
    if (city) {
        fullAddress = [fullAddress stringByAppendingFormat:@", %@",city];
    }
    
    if (state) {
        fullAddress = [fullAddress stringByAppendingFormat:@", %@",state];
    }
    
    if (country) {
        fullAddress = [fullAddress stringByAppendingFormat:@", %@",country];
    }
    
    if (zip) {
        fullAddress = [fullAddress stringByAppendingFormat:@", %@",zip];
    }
    
    [_companyInfoDictionary setValue:address forKey:@"Address"];
    [_companyInfoDictionary setValue:city forKey:@"City"];
    [_companyInfoDictionary setValue:country forKey:@"Country"];
    [_companyInfoDictionary setValue:state forKey:@"State"];
    [_companyInfoDictionary setValue:zip forKey:@"Zip"];
    [_companyInfoDictionary setValue:maplocation forKey:@"MapLocation"];
    [_companyInfoDictionary setValue:fullAddress forKey:@"FullAddress"];
    [_companyInfoDictionary setValue:companyName forKey:@"CompanyName"];
    [_companyInfoDictionary setValue:designation forKey:@"Designation"];
    [_companyInfoDictionary setValue:companyPhone forKey:@"ContactNumber"];
    [_companyInfoDictionary setValue:email forKey:@"Email"];
    [_companyInfoDictionary setValue:logoUrl forKey:@"Logo"];
    [_companyInfoDictionary setValue:website forKey:@"Website"];
    
    
    [_contactInfoDictionary setValue:address forKey:@"Street"];
    [_contactInfoDictionary setValue:city forKey:@"City"];
    [_contactInfoDictionary setValue:state forKey:@"State"];
    [_contactInfoDictionary setValue:zip forKey:@"Zip"];
    [_contactInfoDictionary setValue:country forKey:@"Country"];
    [_contactInfoDictionary setValue:companyName forKey:@"CompanyName"];
    [_contactInfoDictionary setValue:designation forKey:@"Designation"];
    //[_contactInfoDictionary setValue:companyPhone forKey:@"ContactNumber"];
    [_contactInfoDictionary setValue:email forKey:@"Email"];
    [_contactInfoDictionary setValue:website forKey:@"Website"];
    
    
}

-(void)setSimilarPeopleArray:(NSDictionary *)userInfoDict{

    _similarPeopleArray = [NSArray arrayWithArray:[userInfoDict valueForKey:@"SimilarPeople"]];
    
    if ([_similarPeopleArray count]) {
        NSString *selectorName = @"similarPeopleButtonPressed";
        
        NSString *keyName = @"Team";
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_people_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];

    }

}

-(void)setSoundDictionary:(NSDictionary *)userInfoDict{

    _soundDictionary = [NSDictionary dictionaryWithObject:[userInfoDict valueForKey:@"Audio"] forKey:@"Audio"];
    
    if ([[_soundDictionary allValues] count]) {
        NSString *selectorName = @"soundButtonPressed";
        
        NSString *keyName = @"Sound";
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_sound_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];
    }

}

-(void)setSocialMediaDictionary:(NSDictionary *)userInfoDict{

    _socialMediaDictionary = [NSDictionary dictionaryWithDictionary:[[userInfoDict valueForKey:@"Social"] objectAtIndex:0]];
    
    /*
    NSLog(@"%@ %d",[_socialMediaDictionary allKeys],[[_socialMediaDictionary allValues] count]);
    if ([[_socialMediaDictionary allValues] count]) {
        NSString *selectorName = @"sociaMediaButtonPressed";
        
        NSString *keyName = @"Social Media";
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_social_media_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];
    }
    
    */
    
    NSMutableDictionary *socialMediaDictionary = [NSMutableDictionary new];
    
    [_socialMediaDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *_value = (NSString *)obj;
        NSString *_key = (NSString *)key;
        if (_value.trim.length) {
            [socialMediaDictionary setValue:_value forKey:_key];
        }
    }];
    
    if ([[socialMediaDictionary allValues] count]) {
        NSString *selectorName = @"sociaMediaButtonPressed";
        
        NSString *keyName = @"Social Media";
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_social_media_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];
        _socialMediaDictionary = [NSDictionary new];
        _socialMediaDictionary = [NSDictionary dictionaryWithDictionary:socialMediaDictionary];
        
    }

}

-(void)setInstantMessagingDictionary:(NSDictionary *)userInfoDict{

     _instantMessagingDictionary = [NSDictionary dictionaryWithDictionary:[[userInfoDict valueForKey:@"Chat"] objectAtIndex:0]];
   
    /*
    if ([[_instantMessagingDictionary allValues] count]) {
        NSString *selectorName = @"instantMessagingButtonPressed";
        
        NSString *keyName = @"Instant Messaging";
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_instant_messaging_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];
    }
     */
    
    NSMutableDictionary *instantMessagingDictionary = [NSMutableDictionary new];
    
    [_instantMessagingDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        NSString *_value = (NSString *)obj;
        NSString *_key = (NSString *)key;
        if (_value.trim.length) {
            [instantMessagingDictionary setValue:_value forKey:_key];
        }
    }];
    
    if ([[instantMessagingDictionary allValues] count]) {
        NSString *selectorName = @"instantMessagingButtonPressed";
        
        NSString *keyName = @"Instant Messaging";
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_instant_messaging_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];
        
        [_contactInfoDictionary setObject:instantMessagingDictionary forKey:@"InstantMessaging"];
        _instantMessagingDictionary = [NSDictionary new];
        _instantMessagingDictionary = [NSDictionary dictionaryWithDictionary:instantMessagingDictionary];
        

    }
    
   
    
}

-(void)setDocumentsArray:(NSDictionary *)userInfoDict{

    _documentsArray = [NSArray arrayWithArray:[userInfoDict valueForKey:@"Documents"]];
    
    __block NSMutableArray *tempDocArray = [NSMutableArray new];
    
    [_documentsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj valueForKey:@"DocumentURL"] length]) {
            [tempDocArray addObject:obj];
        }
    }];
    
    if ([tempDocArray count]) {
        
        _documentsArray = [NSArray arrayWithArray:tempDocArray];
        
        NSString *selectorName = @"documentsButtonPressed";
        
        NSString *keyName = @"Documents";
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_documents_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];
    }

}


-(void)setGalleryArray:(NSDictionary *)userInfoDict{
    
    _galleryArray = [NSArray arrayWithArray:[userInfoDict valueForKey:@"Gallery"]];
    
    __block NSMutableArray *tempGalleryArray = [NSMutableArray new];
    
    [_galleryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        if ([[obj valueForKey:@"CoverPhotoURL"] length]) {
         
            [tempGalleryArray addObject:obj];
        }
        
    }];
    
    if ([tempGalleryArray count]) {
        
        _galleryArray = [NSArray arrayWithArray:tempGalleryArray];
        
        NSString *selectorName = @"galleryButtonPressed";
        
        NSString *keyName = @"Gallery";
        
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_gallery_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];
    }

}


-(void)setEvernoteArray:(NSDictionary *)userInfoDict{
    
    _evernoteArray = [NSArray arrayWithArray:[userInfoDict valueForKey:@"Evernotes"]];
    
    __block NSMutableArray *tempEvernoteArray = [NSMutableArray new];
    
    [_evernoteArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj valueForKey:@"Link"] length]>5) {
            [tempEvernoteArray addObject:obj];
        }
    }];
    
    if ([tempEvernoteArray count]) {
        
        _evernoteArray = [NSArray arrayWithArray:tempEvernoteArray];
        
        NSString *selectorName = @"evernoteButtonPressed";
        
        NSString *keyName = @"Evernote";
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_evernote_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];
    }

}

-(void)setVideoArray:(NSDictionary *)userInfoDict{
    
    __block NSMutableArray *tempVDArray = [NSMutableArray new];
    _videoArray = [NSArray arrayWithArray:[userInfoDict valueForKey:@"Youtube"]];
    
    [_videoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[obj valueForKey:@"YoutubeLink"] length]) {
            [tempVDArray addObject:obj];
        }
        
    }];
    
    if ([tempVDArray count]) {
        
        _videoArray = [NSArray arrayWithArray:tempVDArray];
        
        NSString *selectorName = @"videoButtonPressed";
        
        NSString *keyName = @"Video";
        UIImage *image = [UIImage imageByAppendingDeviceName:@"btn_video_menu"];
        
        [self setSelectorName:selectorName addKey:keyName andValue:image];
    }
}


-(void)setSelectorName:(NSString *)selectorName addKey:(NSString *)keyName andValue:(UIImage *)image{
    
    [_selectorDictionary setObject:selectorName forKey:keyName];
    
    [_featureNameAndIconDictionary setObject:image forKey:keyName];
    
}

-(void)setDisplayOrder{
    
    NSString *order1 = @"Contact Details";
    NSString *order2 = @"Team";
   // NSString *order3 = @"Sound";
    NSString *order4 = @"Instant Messaging";
    NSString *order5 = @"Social Media";
    NSString *order6 = @"Documents";
    NSString *order7 = @"Gallery";
    NSString *order8 = @"Evernote";
    NSString *order9 = @"Video";
    
    _displayOrderArray = [NSArray arrayWithObjects:order1,order2,order4,order5,
                          order6,order7,order8,order9, nil];
    
}


//getters

-(NSDictionary *)getUserInfo{

    return _userInfoDictionary;
}

-(NSDictionary *)getCompanyInfo{

    return _companyInfoDictionary;
}


-(NSArray *)getSimilarPeople{

    return _similarPeopleArray;
}

-(NSDictionary *)getSound{

    return _soundDictionary;
}

-(NSDictionary *)getSocialMedia{

    return _socialMediaDictionary;

}

-(NSDictionary *)getInstantMessaging{

    return _instantMessagingDictionary;
}

-(NSArray *)getDocuments{

    return _documentsArray;
}

-(NSArray *)getGallery{

    return _galleryArray;
}

-(NSArray *)getEvernote{

    return _evernoteArray;
}

-(NSArray *)getVideos{

    return _videoArray;
}

-(NSDictionary *)getSelectorDictionary{

    return _selectorDictionary;
}

-(NSDictionary *)getFeatureNameAndIconDictionary{

    return _featureNameAndIconDictionary;

}

-(NSArray *)getDisplayOrder{

    NSMutableArray *newDisplayOrderArray = [NSMutableArray new];
    NSDictionary *accessableUserInfoDict = [self getSelectorDictionary];
    
    for (NSString *name in _displayOrderArray) {
        if ([accessableUserInfoDict objectForKey:name]) {
            [newDisplayOrderArray addObject:name];
        }
    }
    
    return newDisplayOrderArray;

}

-(NSDictionary *)getContactInfo{

    return _contactInfoDictionary;
}

@end
