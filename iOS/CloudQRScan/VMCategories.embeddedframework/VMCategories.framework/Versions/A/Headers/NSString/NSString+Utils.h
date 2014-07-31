//
//  NSString+Utils.h
//  VMCategories
//
//  Created by Jimmy on 14/03/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h> 
#import "NSStringHelper.h"

@interface NSString (Utils)

- (NSString *)stringByTrimmingWhitespaceCharactersInString;
- (NSString *)stringByTrimmingWhitespaceAndNewlineCharactersInString;

- (BOOL)isNumeric;

- (NSInteger)countOccurrencesOfSubstring:(NSString *)substring caseSensitive:(BOOL)isCaseSensitive;

- (NSString *)flattenHTML;

-(NSString *)stringByReplacingOccurrencesOfStrings:(NSString *)target withString:(NSString *)replacement;

-(NSString *)stringByRemovingOccurrencesOfStrings:(NSString *)target;

-(NSString *)stringbyRemovingCharactersForPhoneDialing;


-(BOOL)isBlank;

-(BOOL)isNullOrEmpty;

-(BOOL)isEmailAddress;

-(BOOL)contains:(NSString *)string;

-(NSArray *)splitOnChar:(NSString *)ch;

-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;

-(NSString *)trim;

+ (NSString *)stringWithPascalString:(Str255)aString encoding:(CFStringEncoding)encoding;
- (id)initWithPascalString:(Str255)aString encoding:(CFStringEncoding)encoding;
- (int)convertToPascalStringInBuffer:(StringPtr)strBuffer size:(int)bufSize encoding:(CFStringEncoding)encoding;

- (int)occurencesOfSubstring:(NSString *)substr;
- (int)occurencesOfSubstring:(NSString *)substr options:(int)opt;

- (NSArray *)tokensSeparatedByCharactersFromSet:(NSCharacterSet *) separatorSet;
- (NSArray *)objCTokens; //(and C tokens too) a contiguous body of non-'punctuation' characters.

//skips quotes, -, +, (), {}, [], and the like.

- (NSArray *)words; //roman-alphabet words
- (int)howManyWords;

- (BOOL) containsCharacterFromSet:(NSCharacterSet *)set;
- (NSString *)stringWithSubstitute:(NSString *)subs forCharactersFromSet:(NSCharacterSet *)set;

- (NSArray *)linesSortedByLength; - (NSComparisonResult)compareLength:(NSString *)otherString;

- (BOOL)smartWriteToFile:(NSString *)path atomically:(BOOL)atomically;
//won't write to file if nothing has changed. //(may be slow for large amounts of text)

- (unsigned)lineCount; // count lines/paragraphs

- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag;

- (BOOL)beginsWithString:(NSString *)aString;
- (BOOL)beginsWithString:(NSString *)aString ignoringCase:(BOOL)flag;
- (BOOL)endsWithString:(NSString *)aString;
- (BOOL)endsWithString:(NSString *)aString ignoringCase:(BOOL)flag;

-(NSArray *) splitToSize:(unsigned)size;
//returns NSArray of <= size character strings
-(NSString *)removeTabsAndReturns;
-(NSString *)newlineToCR;

-(NSString *)removeString:(NSString *)aString;
-(NSString *)safeFilePath;

-(NSRange)whitespaceRangeForRange:(NSRange) characterRange;
//returns the range of characters around characterRange, extended out to the nearest whitespace

- (NSString *)substringBeforeRange:(NSRange)range;
- (NSString *)substringAfterRange:(NSRange)range;


- (BOOL)isValidURL;
- (NSString *)stringSafeForXML;
- (NSArray *)keyPathComponents;
- (NSString *)lastKeyPathComponent;
+ (NSString *)stringWithKeyPathComponents:(NSString *)component, ... ;
- (NSString *)stringByAppendingKeyPath:(NSString *)keyPath;
//I Will fix it later
//- (NSString *)stringByRemovingKeyPathComponentAtIndex:(NSUInteger)index;
//- (NSString *)stringByRemovingLastKeyPathComponent;

- (NSData *)dataASCII;
- (NSData *)dataUTF8;
- (NSData *)dataUTF16;
- (NSData *)dataUTF32;
+ (NSString *)stringByAppendingDeviceName:(NSString *)forString;
- (NSData *) md5;
- (NSString *)MD5String;
+ (NSString *)stringWithData:(NSData *)data usingEncoding:(CFStringEncoding)encoding;
+ (NSString *)stringWithDataUsingASCIIEncoding:(NSData *)data;
+ (NSString *)stringWithDataUsingUTF8Encoding: (NSData *)data;
+ (NSString *)stringWithDataUsingUTF16Encoding:(NSData *)data;
+ (NSString *)stringWithDataUsingUTF32Encoding:(NSData *)data;


@end
