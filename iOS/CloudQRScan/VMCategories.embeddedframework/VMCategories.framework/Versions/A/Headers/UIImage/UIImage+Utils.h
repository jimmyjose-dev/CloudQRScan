//
//  UIImage+Utils.h
//
//  VMCategories
//
//  Created by Jimmy on 30/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (Utils)

- (id)initWithContentsOfURL:(NSURL *)theURL;
+ (id)imageWithContentsOfURL:(NSURL *)theURL;
+ (id)imageByAppendingDeviceName:(NSString *)forImageName;

@end
