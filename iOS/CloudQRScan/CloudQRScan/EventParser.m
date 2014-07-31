//
//  EventParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "EventParser.h"
#import <EventKit/EventKit.h>

@interface EventParser ()
@property(nonatomic,retain)NSMutableDictionary *eventDict;
@property(nonatomic,retain)EKEvent *event;
@property(nonatomic,retain)EKEventStore *eventStore;
@end

@implementation EventParser
@synthesize eventDict;

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithQRScanResult:(NSString *)qrScanString{
    
    self = [self init];
    [self parseForEvenWithQRScanResult:qrScanString];
    return self;
    
}

-(void)parseForEvenWithQRScanResult:(NSString *)qrScanString{

    [self setEventDataWithQRScanResult:qrScanString];
}

-(void)setEventDataWithQRScanResult:(NSString *)eventString{

    eventString = [eventString stringByReplacingOccurrencesOfString:@";charset=utf-8" withString:@""];
    eventString = [eventString stringByReplacingOccurrencesOfString:@";CHARSET=utf-8" withString:@""];
    NSArray *arry = [eventString componentsSeparatedByString:@"\n"];
    
    eventDict =[[NSMutableDictionary alloc] init];
    for (int i =0; i<[arry count]; ++i) {
        
        NSArray *arr = [[arry objectAtIndex:i] componentsSeparatedByString:@":"];
        if ([arr count]>1) {
            
            NSString *key = [[arr objectAtIndex:0] lowercaseString];
            NSString *value = [arr objectAtIndex:1];
            
            for (int j=2; j<[arr count]; ++j) {
                value = [value stringByAppendingString:[arr objectAtIndex:j]];
            }
            value = [value trim];
            [eventDict setValue:value forKey:key];
        }
        
    }
   
    
    NSString *startDateStr = [[[eventDict valueForKey:@"dtstart"] capitalizedString] trim] ;
    NSString *endDateStr = [[[eventDict valueForKey:@"dtend"] capitalizedString] trim] ;
    
    //NSArray *sepratorArray = [NSArray arrayWithObjects:@"-",@"-",@":",@":", nil];

    NSMutableString *mutStr = [[NSMutableString alloc] initWithString:startDateStr];

    [mutStr insertString:@"-" atIndex:4];

    [mutStr insertString:@"-" atIndex:7];
 
    BOOL justDate = YES;
    if (startDateStr.length>8) {
        justDate = NO;
 
        [eventDict setValue:@"0" forKey:@"jsutdate"];
        [mutStr insertString:@":" atIndex:13];
 
        [mutStr insertString:@":" atIndex:16];

    }
    
    
    
    NSMutableString *mutEndStr = [[NSMutableString alloc] initWithString:endDateStr];
    
    [mutEndStr insertString:@"-" atIndex:4];
    [mutEndStr insertString:@"-" atIndex:7];
    
    if (endDateStr.length>8) {
        [mutEndStr insertString:@":" atIndex:13];
    
        [mutEndStr insertString:@":" atIndex:16];
    
    }
    
    
    
    NSString *startStr = [[NSString alloc] initWithFormat:@"%@",mutStr];
    NSString *endStr = [[NSString alloc] initWithFormat:@"%@",mutEndStr];
    
    startStr = [startStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    endStr = [endStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    DLog(@"start date %@\nend date %@",startStr,endStr);
    
    NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
    
    if (!justDate) {
        [formatterDate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
 
    }else{
    
        [formatterDate setDateFormat:@"yyyy-MM-dd'T'"];
    }
    
    formatterDate.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    

    //NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    //formatterDate.timeZone = timeZone;
    formatterDate.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    formatterDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    
    NSDate *startDay = [formatterDate dateFromString:startStr];
    NSDate *endDay = [formatterDate dateFromString:endStr];
    
   
    formatterDate.dateStyle = NSDateFormatterShortStyle;
    formatterDate.timeStyle = NSDateFormatterShortStyle;
   
    
    [eventDict setObject:[formatterDate stringFromDate:startDay] forKey:@"dtstart"];
    [eventDict setObject:[formatterDate stringFromDate:endDay] forKey:@"dtend"];
    
     //[eventDict setObject:startDay forKey:@"dtstart"];
     //[eventDict setObject:endDay forKey:@"dtend"];
    NSString *title = [eventDict valueForKey:@"summary"];
    NSString *location = [eventDict valueForKey:@"location"];
    NSString *description = [eventDict valueForKey:@"description"];
    NSString *website = [eventDict valueForKey:@"url"];
    
    if (![website hasPrefix:@"http://"] && ![website hasPrefix:@"https://"]) {
        website = [website stringByAppendingString:@"http://"];
    }
    
    NSURL *url = [NSURL URLWithString:website];
    NSDate *startDate = [formatterDate dateFromString:[eventDict objectForKey:@"dtstart"]];
    
    NSDate *endDate = [formatterDate dateFromString:[eventDict objectForKey:@"dtend"]];

    
    
    _eventStore = [[EKEventStore alloc] init];
   
    
    _event  = [EKEvent eventWithEventStore:_eventStore];

    if (title && title.length) {
    _event.title  = title;
    }
    
    if (location && location.length) {
        _event.location = location;
    }
    
    if (startDateStr && startDateStr.length && startDate) {
       _event.startDate = startDate;
    }
    
    if (endDate && endDateStr && endDateStr.length) {
       _event.endDate =  endDate;
    }
    
    if (description && description.length) {
       
        _event.notes= description;
    }
    
    if (url) {
    
        _event.URL = url;
    }
    
    
    

}


-(EKEvent *)getEvent{


    return _event;
}

-(EKEventStore *)getEventStore{

    return _eventStore;

}

-(NSString *)eventHeading{

    return @"";
}

-(NSDictionary *)getEventDictionary{

    return eventDict;
}

@end
