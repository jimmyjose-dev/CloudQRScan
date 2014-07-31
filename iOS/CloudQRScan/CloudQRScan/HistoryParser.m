//
//  HistoryParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 05/12/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "HistoryParser.h"
#import "DBManager.h"


@interface HistoryParser ()
@property(nonatomic,retain)NSDictionary *syncDataDict;

@end


@implementation HistoryParser



-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithSyncData:(NSDictionary *)syncDataDict{
    
    self = [self init];
    [self parseSyncData:syncDataDict];
    return self;
    
}

-(void)parseSyncData:(NSDictionary *)syncDataDict{
    
    _syncDataDict = [NSDictionary dictionaryWithDictionary:syncDataDict];
    //[self setSyncData:syncDataDict];
}



-(void)syncData{
    
    NSArray *syncDataArray = [_syncDataDict valueForKey:@"syncdata"];
    
    int size = [syncDataArray count];
    
    for (int i=0; i<size; ++i) {
        
        NSDictionary *syncDataDict = [NSDictionary dictionaryWithDictionary:[syncDataArray objectAtIndex:i]];
        
        NSString *heading     = [syncDataDict valueForKey:@"heading"];
        NSString *subHeading  = [syncDataDict valueForKey:@"subheading"];
        NSString *image       = [syncDataDict valueForKey:@"image"];
        NSString *value       = [syncDataDict valueForKey:@"value"];
        NSString *type        = [syncDataDict valueForKey:@"tag"];
        NSString *date        = [syncDataDict valueForKey:@"date"];
        NSString *loc         = [syncDataDict valueForKey:@"location"];
        
        
        
        
        if ([subHeading isEqualToString:@"qrprofile"]) {
            
            [[DBManager new] saveLink:value withHeading:heading subHeading:subHeading type:type andImagePath:image fromLocation:loc onDate:date];
            
        }else if ([subHeading isEqualToString:@"qrlocker"]) {
            
            [[DBManager new] saveEncryptedLink:value fromUser:heading fromLocation:loc onDate:date];
            
        }else if ([subHeading isEqualToString:@"qrproduct"]) {
            
            [[DBManager new] saveProductLink:value forProduct:heading fromLocation:loc onDate:date];
            
        }else{
            
            [[DBManager new] saveLink:value withHeading:heading subHeading:subHeading type:type fromLocation:loc onDate:date];
        }
        
        
        
    }
    
    [[DBManager new] updateSyncDate];
    
    
    
}



-(NSDictionary *)getSyncData{
    
    
    return _syncDataDict;
}


/*
-(void)syncData{
    
    NSArray *syncDataArray = [_syncDataDict valueForKey:@"syncdata"];
    
    NSArray *heading     = [_syncDataDict valueForKey:@"heading"];
    NSArray *subHeading  = [_syncDataDict valueForKey:@"subHeading"];
    NSArray *image       = [_syncDataDict valueForKey:@"image"];
    NSArray *value       = [_syncDataDict valueForKey:@"value"];
    NSArray *type        = [_syncDataDict valueForKey:@"type"];
    NSArray *date        = [_syncDataDict valueForKey:@"date"];
    NSArray *loc         = [_syncDataDict valueForKey:@"loc"];
    
    
    int size = [subHeading count];
    
    for (int i=0; i<size; ++i) {
        
        NSString *headingStr = [heading objectAtIndex:i];
        NSString *subHeadingStr = [subHeading objectAtIndex:i];
        NSString *imageStr = [image objectAtIndex:i];
        NSString *valueStr = [value objectAtIndex:i];
        NSString *typeStr = [type objectAtIndex:i];
        NSString *dateStr = [date objectAtIndex:i];
        NSString *locStr = [loc objectAtIndex:i];
        
        
        NSString *subheading = [[subHeading objectAtIndex:i] lowercaseString];
        
        if ([subheading isEqualToString:@"qrprofile"]) {
            
            [[DBManager new] saveLink:valueStr withHeading:headingStr subHeading:subHeadingStr type:typeStr andImagePath:imageStr fromLocation:locStr onDate:dateStr];
            
        }else if ([subheading isEqualToString:@"qrlocker"]) {
            
            [[DBManager new] saveEncryptedLink:valueStr fromUser:headingStr fromLocation:locStr onDate:dateStr];
            
        }else if ([subheading isEqualToString:@"qrproduct"]) {
            
            [[DBManager new] saveProductLink:valueStr forProduct:headingStr fromLocation:locStr onDate:dateStr];
            
        }else{
        
            [[DBManager new] saveLink:valueStr withHeading:headingStr subHeading:subHeadingStr type:typeStr fromLocation:locStr onDate:dateStr];
        }
        
        
        
    }
    
    [[DBManager new] updateSyncDate];
    
    
    
}



-(NSDictionary *)getSyncData{


    return _syncDataDict;
}
*/
 @end
