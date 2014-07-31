//
//  ProfileParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 19/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileParser : NSObject
-(id)initWithUserInfo:(NSDictionary *)userInfoDictionary;
-(NSDictionary *)getUserInfo;
-(NSDictionary *)getCompanyInfo;
-(NSArray *)getSimilarPeople;
-(NSDictionary *)getSound;
-(NSDictionary *)getSocialMedia;
-(NSDictionary *)getInstantMessaging;
-(NSArray *)getDocuments;
-(NSArray *)getGallery;
-(NSArray *)getEvernote;
-(NSArray *)getVideos;
-(NSDictionary *)getFeatureNameAndIconDictionary;
-(NSDictionary *)getSelectorDictionary;
-(NSArray *)getDisplayOrder;
-(NSDictionary *)getContactInfo;
-(void)setImageDataFromImage:(UIImage *)image;
@end
