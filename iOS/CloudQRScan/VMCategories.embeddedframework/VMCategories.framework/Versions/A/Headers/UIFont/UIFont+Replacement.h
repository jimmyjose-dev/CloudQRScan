//
//  UIFont+Replacement.h
//  FontReplacer
//
//  Created by Cédric Luthi on 2011-08-08.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Replacement)

/*
 
 Create a replacement dictionary in your Info.plist with the ReplacementFonts key, for example
 
 ReplacementFonts = {
 "ArialMT" = "CaviarDreams";
 "Arial-ItalicMT" = "CaviarDreams-Italic";
 "Arial-BoldMT" = "CaviarDreams-Bold";
 "Arial-BoldItalicMT" = "CaviarDreams-BoldItalic";
 };
 
 Use Arial in your nibs everywhere you want Caviar Dreams
 
 If you want more control, you can use the +[UIFont setReplacementDictionary:] method instead of defining the ReplacementFonts Info.plist key. Make sure to call this early enough, before any font is deserialized from a nib.
 
 */

+ (NSDictionary *) replacementDictionary;
+ (void) setReplacementDictionary:(NSDictionary *)aReplacementDictionary;

@end
