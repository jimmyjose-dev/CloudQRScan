//
//  ContactController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 17/04/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ContactControllerDelegate <NSObject>

@optional
-(void)resetView;

@end

@interface ContactController : UIViewController
-(id)initWithVCardString:(NSString *)vCardString;
-(id)initWithmeCardString:(NSString *)meCardString;
-(id)initWithUserInfo:(NSDictionary *)userInfoDictionary;
-(void)displayContactView;
-(NSString *)getName;
@property(nonatomic,retain)id<ContactControllerDelegate>delegate;
@end
