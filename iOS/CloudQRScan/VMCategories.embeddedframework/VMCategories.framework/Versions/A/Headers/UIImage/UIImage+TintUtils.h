//
//  UIImage+Tint.h
//
//  VMCategories
//
//  Created by Jimmy on 30/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (TintUtils)

/* Function already exist in UsefulBits
 
- (UIImage *)imageTintedWithColor:(UIColor *)color;
 
*/

- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;
+ (UIImage *)imageWithColor:(UIColor *)color forSize:(CGSize)size;
+ (UIImage *)imageWithRed:(CGFloat)redColor green:(CGFloat)greenColor blue:(CGFloat)blueColor andAlpha:(CGFloat)alpha forSize:(CGSize)size;

@end
