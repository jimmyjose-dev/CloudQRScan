//
//  UIFont+Utils.h
//  VMCategories
//
//  Created by Jimmy on 02/04/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Utils)

/**---------------------------------------------------------------------------------------
 * @name A name under which this method appears under "Tasks"
 *  ---------------------------------------------------------------------------------------
 */

/** This is the first super-awesome method.
 
 You can also add lists, but have to keep an empty line between these blocks.
 
 - One
 - Two
 - Three
 
 @param string A parameter that is passed in.
 @return Whatever it returns.
 */

+(void)printAllFontNames;
+(void)printAllFontBeginningWithName:(NSString *)fontName;
+(void)printAllFontBeginningWithName:(NSString *)fontName ignoreCase:(BOOL)ignoreCase;
+(void)printAllFontEndingWithName:(NSString *)fontName;
+(void)printAllFontEndingWithName:(NSString *)fontName ignoreCase:(BOOL)ignoreCase;
@end
