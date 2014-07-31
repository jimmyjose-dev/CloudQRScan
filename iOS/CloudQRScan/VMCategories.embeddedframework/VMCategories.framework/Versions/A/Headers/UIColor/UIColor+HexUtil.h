//
//  UIColor+Hex.h
//  VMCategories
//
//  Created by Jimmy on 14/03/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexUtil)

/**
 
 Convert Hex to UIColor
 @param hex in the form "FFFFFF" 
 
 */

+ (UIColor *)colorWithHex:(uint)hex;


+ (UIColor *)colorWithRGBA:(NSUInteger)color;

+ (UIColor *)randomColor;

+ (UIColor *)colorForIndex:(NSInteger)idx;

- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha;

- (UIColor *)colorByDarkeningColor;

+ (UIColor *)colorWithImageName:(NSString *)imageName;

+ (UIColor *)colorWithRedInt: (NSInteger)red greenInt: (NSInteger)green blueInt: (NSInteger)blue alpha: (CGFloat) alpha;


/**
 * Fades between firstColor and secondColor at the specified ratio:
 *
 *    @ ratio 0.0 - fully firstColor
 *    @ ratio 0.5 - halfway between firstColor and secondColor
 *    @ ratio 1.0 - fully secondColor
 *
 */

+ (UIColor *)colorForFadeBetweenFirstColor:(UIColor *)firstColor
                               secondColor:(UIColor *)secondColor
                                   atRatio:(CGFloat)ratio;

/**
 * Same as above, but allows turning off the color space comparison
 * for a performance boost.
 */

+ (UIColor *)colorForFadeBetweenFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor atRatio:(CGFloat)ratio compareColorSpaces:(BOOL)compare;

/**
 * An array of [steps] colors starting with firstColor, continuing with linear interpolations
 * between firstColor and lastColor and ending with lastColor.
 */
+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor
                                  lastColor:(UIColor *)lastColor
                                    inSteps:(NSUInteger)steps;

/**
 * An array of [steps] colors starting with firstColor, continuing with interpolations, as specified
 * by the equation block, between firstColor and lastColor and ending with lastColor. The equation block
 * must take a float as an input, and return a float as an output. Output will be santizied to be between
 * a ratio of 0.0 and 1.0. Passing nil for the equation results in a linear relationship.
 */
+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor
                                  lastColor:(UIColor *)lastColor
                          withRatioEquation:(float (^)(float))equation
                                    inSteps:(NSUInteger)steps;


/**
 * Convert UIColor to RGBA colorspace. Used for cross-colorspace interpolation.
 */
+ (UIColor *)colorConvertedToRGBA:(UIColor *)colorToConvert;

@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat alpha;

+ (UIColor *)colorWithString:(NSString *)string;
+ (UIColor *)colorWithRGBValue:(int32_t)rgb;
+ (UIColor *)colorWithRGBAValue:(uint32_t)rgba;
- (UIColor *)initWithString:(NSString *)string;
- (UIColor *)initWithRGBValue:(int32_t)rgb;
- (UIColor *)initWithRGBAValue:(uint32_t)rgba;

- (int32_t)RGBValue;
- (uint32_t)RGBAValue;
- (NSString *)stringValue;

- (BOOL)isMonochromeOrRGB;
- (BOOL)isEquivalent:(id)object;
- (BOOL)isEquivalentToColor:(UIColor *)color;


@end
