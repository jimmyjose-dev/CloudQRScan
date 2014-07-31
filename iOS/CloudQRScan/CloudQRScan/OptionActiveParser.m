//
//  OptionActiveParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 25/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "OptionActiveParser.h"

@interface OptionActiveParser ()
@property(nonatomic,retain)NSMutableDictionary *optionsActiveDictionary;
@end

@implementation OptionActiveParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithOptionObject:(id)optionObject andOptionType:(NSString *)optionType{
    
    self = [self init];
    [self parseOptionWithObject:optionObject andOptionType:optionType];
    return self;
    
}

-(void)parseOptionWithObject:(id)optionObject andOptionType:(NSString *)optionType{
    
    _optionsActiveDictionary = [NSMutableDictionary new];
    [self setOptionsActiveWithObject:optionObject andOptionType:optionType];
}

-(void)setOptionsActiveWithObject:(id)optionObject andOptionType:(NSString *)optionType{
    
    NSDictionary *selectorDictionary = [NSDictionary  dictionaryWithObjectsAndKeys:@"similarpeople",@"similarPeopleActiveButtonPressed",
                                        @"sound",@"soundActiveButtonPressed",
                                        @"instantmessaging",@"instantMessagingActiveButtonPressed",
                                        @"documents",@"ActiveButtonPressed",
                                        @"socialmedia",@"socialMediaActiveButtonPressed",
                                        @"video",@"videoActiveButtonPressed",
                                        @"evernote",@"evernoteActiveButtonPressed",
                                        nil];
    NSString *aSelector = [selectorDictionary valueForKey:optionType];
    
    if ([optionObject isKindOfClass:[NSDictionary class]]) {
        
    }else
    {
    
        [_optionsActiveDictionary setValue:aSelector forKey:@"selector"];
        //[_optionsActiveDictionary setValue:optionArray forKey:@"value"];
    }
    
    
    
}

-(NSDictionary *)getOptionsActiveWithDictionary{

    return _optionsActiveDictionary;
    
}
@end
