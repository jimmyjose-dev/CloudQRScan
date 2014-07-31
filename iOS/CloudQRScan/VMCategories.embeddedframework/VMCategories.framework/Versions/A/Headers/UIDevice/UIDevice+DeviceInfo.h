//
//  UIDevice+DeviceInfo.h
//  VMCategories
//
//  Created by Jimmy on 30/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DeviceInfo)

/** Query the device name

 Possible values - iPhone/iPhone5/iPad
 
 */

+(NSString *)currentDeviceName;


/** Query if device is an iPhone
 
 Possible values - YES/NO
 */

+(BOOL)isiPhone;


/** Query if device is an iPhone5
 
 Possible values - YES/NO
 */

+(BOOL)isiPhone5;


/** Query if device is an iPad
 
 Possible values - YES/NO
 */

+(BOOL)isiPad;


/** Query if device has retina display
 
 Possible values - YES/NO
 */

+(BOOL)hasRetinaDisplay;


/** Query if device has camera
 
 Possible values - YES/NO
 */

+(BOOL)hasCamera;


/** Query the scale factor for current device
 
 */

+(float)scale;


/** Query device unique identifier
 
 Possible value - Generated using Yann Lechelle's OpenUDID
 */

+(NSString *)UDID;

/** Query device internet connectivity
 
 Possible value - YES/NO
 */
+ (BOOL)isInternetReachable;

@end
