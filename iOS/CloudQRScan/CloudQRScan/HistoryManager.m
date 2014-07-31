//
//  HistoryManager.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 21/05/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "HistoryManager.h"
#import "DBManager.h"
#import "FMDatabase.h"

@implementation HistoryManager

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(void)deleteLink:(NSString *)link{

    [[DBManager new] deleteLink:link];
}

-(void)saveLink:(NSString *)link withHeading:(NSString *)heading subHeading:(NSString *)subheading type:(NSString *)type fromLocation:(NSString *)location onDate:(NSString *)dateStr{
    
    [[DBManager new] saveLink:link withHeading:heading subHeading:subheading type:type fromLocation:location onDate:dateStr];
    
}

-(void)saveEncryptedLink:(NSString *)link fromUser:(NSString *)username fromLocation:(NSString *)location onDate:(NSString *)dateStr{
    
    [[DBManager new] saveEncryptedLink:link fromUser:username fromLocation:location onDate:dateStr];
    
}

-(void)saveProductLink:(NSString *)link forProduct:(NSString *)product fromLocation:(NSString *)location onDate:(NSString *)dateStr{

    [[DBManager new] saveProductLink:link forProduct:product fromLocation:location onDate:dateStr];

}

-(void)updateSyncDate{

    [[DBManager new] updateSyncDate];
}

-(NSDictionary *)getDBDataOLD{
    
    
    NSMutableArray *mutArrayHeading     = [[NSMutableArray alloc] init];
    NSMutableArray *mutArraySubHeading  = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayImage       = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayTag         = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayValue       = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayType        = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayDate        = [[NSMutableArray alloc] init];
    
    NSMutableArray *mutTempHeading        = [[NSMutableArray alloc] init];
    NSMutableArray *mutTempSubHeading         = [[NSMutableArray alloc] init];
    NSMutableArray *mutQRProduct        = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *mutDictQRProfile = [NSMutableDictionary new];
    
    
    NSString *heading    = nil;
    NSString *subHeading = nil;
    NSString *image      = nil;
    NSString *tag        = nil;
    NSString *value      = nil;
    NSString *type       = nil;
    NSString *date       = nil;
    NSString *updates    = nil;
    
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //NSMutableDictionary *dictKeyValue = [[NSMutableDictionary alloc] init];
    FMDatabase *database = [FMDatabase databaseWithCustomPath];
    [database open];
    
   // NSMutableDictionary *testDict = [NSMutableDictionary new];
   // NSMutableArray *testArray = [NSMutableArray new];
    
    //int updatesBadgeCount = 0;
    
    FMResultSet *resultcloudqr = [database executeQuery:@"select * from cloudqr ORDER BY cloudqrid DESC"];
    
    while([resultcloudqr next]) {
        
        
     //   if ([[resultcloudqr stringForColumn:@"updates"] isEqualToString:@"1"]) ++updatesBadgeCount;
        
        heading = [NSString stringWithString:[resultcloudqr stringForColumn:@"heading"]];
        subHeading = [NSString stringWithString:[resultcloudqr stringForColumn:@"subheading"]];
        
        //DLog(@"%@ %@",heading,subHeading);
        
        
        NSString *deviceName = @"_iPhone";
        if ([UIDevice isiPad]) {
            deviceName = @"_iPad";
        }
        
        tag = [NSString stringWithString:[resultcloudqr stringForColumn:@"tag"]];
        
        if ([tag isEqualToString:@"others"] || [tag isEqualToString:@"qrlocker"]
             || [tag isEqualToString:@"qrproduct"]) {

            NSString *otherImageName = [NSString  stringWithFormat:@"%@%@",[resultcloudqr stringForColumn:@"image"],deviceName];
            
            image = [[NSBundle mainBundle] pathForResource:otherImageName ofType:@"png"];
            
            //BOOL fileexists = [[NSFileManager defaultManager] fileExistsAtPath:image];
            
           // NSLog(@"%@\n%@\nexists %d",otherImageName,image,fileexists);
            [mutArrayImage addObject:image];
            
            [mutArrayType addObject:[resultcloudqr stringForColumn:@"tag"]];
        }
        else {
            //[mutArrayImage addObject:[documentsDirectory stringByAppendingPathComponent:[resultcloudqr stringForColumn:@"image"]]];
            
            image = [resultcloudqr stringForColumn:@"image"];
            
            [mutArrayImage addObject:image];
            
            [mutArrayType addObject:@"CloudQRScan"];
            
        }
        
       
        
        [mutArrayHeading addObject:heading];
        [mutArraySubHeading addObject:subHeading];
        
        [mutArrayTag addObject:tag];
        [mutArrayValue addObject:[resultcloudqr stringForColumn:@"value"]];
        [mutArrayDate addObject:[resultcloudqr stringForColumn:@"date"]];
        
        type = [NSString stringWithString:[resultcloudqr stringForColumn:@"tag"]];
        value = [NSString stringWithString:[resultcloudqr stringForColumn:@"value"]];
        date = [NSString stringWithString:[resultcloudqr stringForColumn:@"date"]];
        updates = [NSString stringWithString:[resultcloudqr stringForColumn:@"updates"]];
        
        /*
        [testDict setObject:heading forKey:@"heading"];
        [testDict setObject:subHeading forKey:@"subheading"];
        [testDict setObject:tag forKey:@"tag"];
        [testDict setObject:type forKey:@"type"];
        [testDict setObject:value forKey:@"value"];
        [testDict setObject:date forKey:@"date"];
        [testDict setObject:updates forKey:@"updates"];
        
        [testArray addObject:testDict];
        */
        
        
        /*
         DDLogInfo(@"heading %@",heading);
         DDLogInfo(@"subheading %@",subHeading);
         DDLogInfo(@"tag %@",tag);
         DDLogInfo(@"image %@",image);
        DDLogInfo(@"value %@",value);
         DDLogInfo(@"date %@",date);
        // DDLogInfo(@"updates %@",updates);
         //DDLogInfo(@"location %@",location);
         DDLogInfo(@"value %@",value);
        */
        
       // NSString *dictValue = [NSString stringWithFormat:@"%@_-_%@_-_%@_-_%@_-_%@_-_%@_-_%@",heading,subHeading,tag,image,value,date,updates];
        //NSString *dictKey = [NSString stringWithFormat:@"%@/%@",date,value];
        
       // [dictKeyValue setObject:dictValue forKey:dictKey];
        
        // DLog(@"-------\n\n");
        // DLog(@"dictValue %@ dictKey %@",dictValue,dictKey);
        
        
    }
    
   /*
    NSDictionary *tempdict1 = [NSDictionary dictionaryWithObjectsAndKeys:testArray,@"profile",testArray,@"qrlocker",testArray,@"product", nil];
    NSString *tempString = [[NSJSONSerialization dataWithJSONObject:tempdict1
                                                            options:nil
                                                              error:nil] stringUTF8];
    NSLog(@"json %@",tempString);
        
    */
    [database close];
    
    
    NSMutableDictionary *dateDict = [[NSMutableDictionary alloc] init];
    [dateDict setObject:@"no" forKey:@"no"];
   /*
    NSMutableArray *array;
    NSString *key = @"";
    int size = [mutArrayDate count];
    NSArray *allKey = [NSArray  arrayWithArray:[[dictKeyValue allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    for (int i=0; i<size; ++i) {
        
        // NSArray *tmp = [[mutArrayDate objectAtIndex:i] componentsSeparatedByString:@"/"];
        NSArray *tmp = [[allKey objectAtIndex:i] componentsSeparatedByString:@"/"];
      //  if (![key isEqualToString:[NSString stringWithFormat:@"%@_%@",[tmp objectAtIndex:1],[tmp objectAtIndex:2]]]) {
            
            array = [[NSMutableArray alloc] init];
            
            key = [NSString stringWithFormat:@"%@_%@",[tmp objectAtIndex:1],[tmp objectAtIndex:2]];
            
        //}
        
        // [array addObject:[mutArrayDate objectAtIndex:i]];
        //DLog(@"key - %@\nValue - %@",key,[dictKeyValue valueForKey:[allKey objectAtIndex:i]]);
        [array addObject:[dictKeyValue valueForKey:[allKey objectAtIndex:i]]];
        
        [dateDict setObject:array forKey:key];
        
    }
    
    
   */
    
    NSDictionary *dictionaryHistory = [[NSDictionary alloc]
                                       initWithObjectsAndKeys:mutArrayHeading,@"heading",
                                       mutArraySubHeading,@"subheading",
                                       mutArrayImage,@"image",
                                       mutArrayTag,@"tag",
                                       mutArrayValue,@"value",
                                       mutArrayType,@"type",
                                       dateDict,@"date",
                                       nil];
    //dont use value of datedict or fix it above
    // DLog(@"dictionaryHistory %@",dictionaryHistory);
    return dictionaryHistory;
    
}


-(NSDictionary *)getDBData{
    
    
    NSMutableArray *mutArrayHeading     = [[NSMutableArray alloc] init];
    NSMutableArray *mutArraySubHeading  = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayImage       = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayTag         = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayValueGlobal       = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayType        = [[NSMutableArray alloc] init];
    NSMutableArray *mutArrayDate        = [[NSMutableArray alloc] init];
    
    NSMutableArray *mutTempHeading        = [[NSMutableArray alloc] init];
    NSMutableArray *mutTempSubHeading         = [[NSMutableArray alloc] init];
    NSMutableArray *mutTempImage        = [[NSMutableArray alloc] init];
    NSMutableArray *mutTempValue        = [[NSMutableArray alloc] init];
    NSMutableArray *mutTempDate        = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *mutDictQRProfile = [NSMutableDictionary new];
    NSMutableDictionary *mutDictQRProduct = [NSMutableDictionary new];
    NSMutableDictionary *mutDictQRLocker = [NSMutableDictionary new];
    
    
    NSString *heading    = nil;
    NSString *subHeading = nil;
    NSString *image      = nil;
    NSString *tag        = nil;
    NSString *value      = nil;
    NSString *type       = nil;
    NSString *date       = nil;
    NSString *updates    = nil;
    
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //NSMutableDictionary *dictKeyValue = [[NSMutableDictionary alloc] init];
    FMDatabase *database = [FMDatabase databaseWithCustomPath];
    [database open];
    
    // NSMutableDictionary *testDict = [NSMutableDictionary new];
    // NSMutableArray *testArray = [NSMutableArray new];
    
    //int updatesBadgeCount = 0;
    //order by convert(datetime, date, 103) ASC
    //FMResultSet *resultcloudqr = [database executeQuery:@"select * from cloudqr ORDER BY cloudqrid DESC"];
    FMResultSet *resultcloudqr = [database executeQuery:@"select * from cloudqr ORDER BY datetime(date) DESC"];
    
    while([resultcloudqr next]) {
        
        //NSLog(@"date %@",[resultcloudqr stringForColumn:@"date"]);
        //   if ([[resultcloudqr stringForColumn:@"updates"] isEqualToString:@"1"]) ++updatesBadgeCount;
        
        heading = [[NSString stringWithString:[resultcloudqr stringForColumn:@"heading"]] trim];
        subHeading = [NSString stringWithString:[resultcloudqr stringForColumn:@"subheading"]];
        
        //DLog(@"%@ %@",heading,subHeading);
        
        
        NSString *deviceName = @"_iPhone";
        if ([UIDevice isiPad]) {
            deviceName = @"_iPad";
        }
        
        tag = [NSString stringWithString:[resultcloudqr stringForColumn:@"tag"]];
        
        if ([tag isEqualToString:@"others"] || [tag isEqualToString:@"qrlocker"]
            || [tag isEqualToString:@"qrproduct"]) {
            
            NSString *otherImageName = [NSString  stringWithFormat:@"%@%@",[resultcloudqr stringForColumn:@"image"],deviceName];
            
            image = [[NSBundle mainBundle] pathForResource:otherImageName ofType:@"png"];
            
            //BOOL fileexists = [[NSFileManager defaultManager] fileExistsAtPath:image];
            
            // NSLog(@"%@\n%@\nexists %d",otherImageName,image,fileexists);
            [mutArrayImage addObject:image];
            
            [mutArrayType addObject:[resultcloudqr stringForColumn:@"tag"]];
        }
        else {
            //[mutArrayImage addObject:[documentsDirectory stringByAppendingPathComponent:[resultcloudqr stringForColumn:@"image"]]];
            
            image = [resultcloudqr stringForColumn:@"image"];
            
            [mutArrayImage addObject:image];
            
            [mutArrayType addObject:@"CloudQRScan"];
            
        }
        
        //Add array elements as normal check if it sqrprofile make a dct with it
        
        if ([subHeading isEqualToString:@"QRLocker"]) {
            
            
            if (![mutDictQRLocker objectForKey:heading]) {
                
                NSMutableArray *mutArrayHeading     = [[NSMutableArray alloc] init];
                NSMutableArray *mutArraySubHeading  = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayImage       = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayTag         = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayValue       = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayType        = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayDate        = [[NSMutableArray alloc] init];
                
                [mutArrayHeading addObject:heading];
                [mutArraySubHeading addObject:subHeading];
                
                [mutArrayTag addObject:tag];
                [mutArrayValue addObject:[resultcloudqr stringForColumn:@"value"]];
                [mutArrayValueGlobal addObject:[resultcloudqr stringForColumn:@"value"]];
                
                NSArray *dateArray = [[[[resultcloudqr stringForColumn:@"date"] componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"];
                
                NSString *date = [NSString stringWithFormat:@"%@/%@/%@",[dateArray lastObject],[dateArray objectAtIndex:1],[dateArray firstObject]];
                
                [mutArrayDate addObject:date];
                
                
                NSString *otherImageName = [NSString  stringWithFormat:@"%@%@",[resultcloudqr stringForColumn:@"image"],deviceName];
                
                NSString *image = [[NSBundle mainBundle] pathForResource:otherImageName ofType:@"png"];
                
                //BOOL fileexists = [[NSFileManager defaultManager] fileExistsAtPath:image];
                
                // NSLog(@"%@\n%@\nexists %d",otherImageName,image,fileexists);
                [mutArrayImage addObject:image];
                
                [mutArrayType addObject:[resultcloudqr stringForColumn:@"tag"]];
                
                
                
                NSDictionary *qrlocker = [[NSDictionary alloc]
                                                initWithObjectsAndKeys:mutArrayHeading,@"heading",
                                                mutArraySubHeading,@"subheading",
                                                mutArrayImage,@"image",
                                                mutArrayTag,@"tag",
                                                mutArrayValue,@"value",
                                                mutArrayType,@"type",
                                                mutArrayDate,@"date",
                                                nil];
                
                [mutDictQRLocker setObject:qrlocker forKey:heading];
                
                [mutTempHeading addObject:heading];
                [mutTempSubHeading addObject:subHeading];
                [mutTempImage addObject:image];
                
                
                
            }
            else{
                
                NSMutableArray *mutArrayHeading     = [[mutDictQRLocker objectForKey:heading] valueForKey:@"heading"];
                NSMutableArray *mutArraySubHeading  = [[mutDictQRLocker objectForKey:heading] valueForKey:@"subheading"];
                NSMutableArray *mutArrayImage       = [[mutDictQRLocker objectForKey:heading] valueForKey:@"image"];
                NSMutableArray *mutArrayTag         = [[mutDictQRLocker objectForKey:heading] valueForKey:@"tag"];
                NSMutableArray *mutArrayValue       = [[mutDictQRLocker objectForKey:heading] valueForKey:@"value"];
                NSMutableArray *mutArrayType        = [[mutDictQRLocker objectForKey:heading] valueForKey:@"type"];
                NSMutableArray *mutArrayDate        = [[mutDictQRLocker objectForKey:heading] valueForKey:@"date"];
                
                [mutArrayHeading addObject:heading];
                [mutArraySubHeading addObject:subHeading];
                
                [mutArrayTag addObject:tag];
                [mutArrayValue addObject:[resultcloudqr stringForColumn:@"value"]];
                
                NSArray *dateArray = [[[[resultcloudqr stringForColumn:@"date"] componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"];
                
                NSString *date = [NSString stringWithFormat:@"%@/%@/%@",[dateArray lastObject],[dateArray objectAtIndex:1],[dateArray firstObject]];
                
                [mutArrayDate addObject:date];

              
                
                NSString *otherImageName = [NSString  stringWithFormat:@"%@%@",[resultcloudqr stringForColumn:@"image"],deviceName];
                
                NSString *image = [[NSBundle mainBundle] pathForResource:otherImageName ofType:@"png"];
                
                
                [mutArrayImage addObject:image];
                
                [mutArrayType addObject:[resultcloudqr stringForColumn:@"tag"]];
                
                
                NSDictionary *qrlocker = [[NSDictionary alloc]
                                                initWithObjectsAndKeys:mutArrayHeading,@"heading",
                                                mutArraySubHeading,@"subheading",
                                                mutArrayImage,@"image",
                                                mutArrayTag,@"tag",
                                                mutArrayValue,@"value",
                                                mutArrayType,@"type",
                                                mutArrayDate,@"date",
                                                nil];
                
                [mutDictQRLocker setObject:qrlocker forKey:heading];
                
                
            }
            
            
            
            
        }

        else if ([subHeading isEqualToString:@"QRProduct"]) {
            
            if (![mutDictQRProduct objectForKey:heading]) {
                
                NSMutableArray *mutArrayHeading     = [[NSMutableArray alloc] init];
                NSMutableArray *mutArraySubHeading  = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayImage       = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayTag         = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayValue       = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayType        = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayDate        = [[NSMutableArray alloc] init];
                
                [mutArrayHeading addObject:heading];
                [mutArraySubHeading addObject:subHeading];
                
                [mutArrayTag addObject:tag];
                [mutArrayValue addObject:[resultcloudqr stringForColumn:@"value"]];
                [mutArrayValueGlobal addObject:[resultcloudqr stringForColumn:@"value"]];
               
                NSArray *dateArray = [[[[resultcloudqr stringForColumn:@"date"] componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"];
                
                NSString *date = [NSString stringWithFormat:@"%@/%@/%@",[dateArray lastObject],[dateArray objectAtIndex:1],[dateArray firstObject]];
                
                [mutArrayDate addObject:date];

                
                
                NSString *otherImageName = [NSString  stringWithFormat:@"%@%@",[resultcloudqr stringForColumn:@"image"],deviceName];
                
                NSString *image = [[NSBundle mainBundle] pathForResource:otherImageName ofType:@"png"];
                
                //BOOL fileexists = [[NSFileManager defaultManager] fileExistsAtPath:image];
                
                // NSLog(@"%@\n%@\nexists %d",otherImageName,image,fileexists);
                [mutArrayImage addObject:image];
                
                [mutArrayType addObject:[resultcloudqr stringForColumn:@"tag"]];
                
                
                
                NSDictionary *qrproduct = [[NSDictionary alloc]
                                                initWithObjectsAndKeys:mutArrayHeading,@"heading",
                                                mutArraySubHeading,@"subheading",
                                                mutArrayImage,@"image",
                                                mutArrayTag,@"tag",
                                                mutArrayValue,@"value",
                                                mutArrayType,@"type",
                                                mutArrayDate,@"date",
                                                nil];
                
                [mutDictQRProduct setObject:qrproduct forKey:heading];
                
                [mutTempHeading addObject:heading];
                [mutTempSubHeading addObject:subHeading];
                [mutTempImage addObject:image];
                
                
                
            }
            else{
                
                NSMutableArray *mutArrayHeading     = [[mutDictQRProduct objectForKey:heading] valueForKey:@"heading"];
                NSMutableArray *mutArraySubHeading  = [[mutDictQRProduct objectForKey:heading] valueForKey:@"subheading"];
                NSMutableArray *mutArrayImage       = [[mutDictQRProduct objectForKey:heading] valueForKey:@"image"];
                NSMutableArray *mutArrayTag         = [[mutDictQRProduct objectForKey:heading] valueForKey:@"tag"];
                NSMutableArray *mutArrayValue       = [[mutDictQRProduct objectForKey:heading] valueForKey:@"value"];
                NSMutableArray *mutArrayType        = [[mutDictQRProduct objectForKey:heading] valueForKey:@"type"];
                NSMutableArray *mutArrayDate        = [[mutDictQRProduct objectForKey:heading] valueForKey:@"date"];
                
                [mutArrayHeading addObject:heading];
                [mutArraySubHeading addObject:subHeading];
                
                [mutArrayTag addObject:tag];
                [mutArrayValue addObject:[resultcloudqr stringForColumn:@"value"]];
                
               NSArray *dateArray = [[[[resultcloudqr stringForColumn:@"date"] componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"];
                
                NSString *date = [NSString stringWithFormat:@"%@/%@/%@",[dateArray lastObject],[dateArray objectAtIndex:1],[dateArray firstObject]];
                
                [mutArrayDate addObject:date];

                
                NSString *otherImageName = [NSString  stringWithFormat:@"%@%@",[resultcloudqr stringForColumn:@"image"],deviceName];
                
                NSString *image = [[NSBundle mainBundle] pathForResource:otherImageName ofType:@"png"];
                
                
                [mutArrayImage addObject:image];
                
                [mutArrayType addObject:[resultcloudqr stringForColumn:@"tag"]];
                
                
                
                NSDictionary *qrproduct = [[NSDictionary alloc]
                                                initWithObjectsAndKeys:mutArrayHeading,@"heading",
                                                mutArraySubHeading,@"subheading",
                                                mutArrayImage,@"image",
                                                mutArrayTag,@"tag",
                                                mutArrayValue,@"value",
                                                mutArrayType,@"type",
                                                mutArrayDate,@"date",
                                                nil];
                
                [mutDictQRProduct setObject:qrproduct forKey:heading];
                
                
            }
            
            
            
            
        }
        else if ([subHeading isEqualToString:@"QRProfile"]) {
            
            if (![mutDictQRProfile objectForKey:heading]) {
                
                NSMutableArray *mutArrayHeading     = [[NSMutableArray alloc] init];
                NSMutableArray *mutArraySubHeading  = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayImage       = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayTag         = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayValue       = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayType        = [[NSMutableArray alloc] init];
                NSMutableArray *mutArrayDate        = [[NSMutableArray alloc] init];
                
                [mutArrayHeading addObject:heading];
                [mutArraySubHeading addObject:subHeading];
                
                [mutArrayTag addObject:tag];
                [mutArrayValue addObject:[resultcloudqr stringForColumn:@"value"]];
                [mutArrayValueGlobal addObject:[resultcloudqr stringForColumn:@"value"]];
                
                NSArray *dateArray = [[[[resultcloudqr stringForColumn:@"date"] componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"];
                
                NSString *date = [NSString stringWithFormat:@"%@/%@/%@",[dateArray lastObject],[dateArray objectAtIndex:1],[dateArray firstObject]];
                
                [mutArrayDate addObject:date];

                
                
                NSString *image = image = [resultcloudqr stringForColumn:@"image"];
                
                [mutArrayImage addObject:image];
                
                [mutArrayType addObject:@"CloudQRScan"];
                
                
                
                NSDictionary *qrprofile = [[NSDictionary alloc]
                                                initWithObjectsAndKeys:mutArrayHeading,@"heading",
                                                mutArraySubHeading,@"subheading",
                                                mutArrayImage,@"image",
                                                mutArrayTag,@"tag",
                                                mutArrayValue,@"value",
                                                mutArrayType,@"type",
                                                mutArrayDate,@"date",
                                                nil];
                
                [mutDictQRProfile setObject:qrprofile forKey:heading];
                
                [mutTempHeading addObject:heading];
                [mutTempSubHeading addObject:subHeading];
                [mutTempImage addObject:image];
                
                
                
            }
            else{
                
                NSMutableArray *mutArrayHeading     = [[mutDictQRProfile objectForKey:heading] valueForKey:@"heading"];
                NSMutableArray *mutArraySubHeading  = [[mutDictQRProfile objectForKey:heading] valueForKey:@"subheading"];
                NSMutableArray *mutArrayImage       = [[mutDictQRProfile objectForKey:heading] valueForKey:@"image"];
                NSMutableArray *mutArrayTag         = [[mutDictQRProfile objectForKey:heading] valueForKey:@"tag"];
                NSMutableArray *mutArrayValue       = [[mutDictQRProfile objectForKey:heading] valueForKey:@"value"];
                NSMutableArray *mutArrayType        = [[mutDictQRProfile objectForKey:heading] valueForKey:@"type"];
                NSMutableArray *mutArrayDate        = [[mutDictQRProfile objectForKey:heading] valueForKey:@"date"];
                
                [mutArrayHeading addObject:heading];
                [mutArraySubHeading addObject:subHeading];
                
                [mutArrayTag addObject:tag];
                [mutArrayValue addObject:[resultcloudqr stringForColumn:@"value"]];
                
                NSArray *dateArray = [[[[resultcloudqr stringForColumn:@"date"] componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"];
                
                NSString *date = [NSString stringWithFormat:@"%@/%@/%@",[dateArray lastObject],[dateArray objectAtIndex:1],[dateArray firstObject]];
                
                [mutArrayDate addObject:date];

                
                NSString *image = [resultcloudqr stringForColumn:@"image"];
                
                [mutArrayImage addObject:image];
                
                [mutArrayType addObject:@"CloudQRScan"];
                
                
                NSDictionary *qrprofilevlaue = [[NSDictionary alloc]
                                                initWithObjectsAndKeys:mutArrayHeading,@"heading",
                                                mutArraySubHeading,@"subheading",
                                                mutArrayImage,@"image",
                                                mutArrayTag,@"tag",
                                                mutArrayValue,@"value",
                                                mutArrayType,@"type",
                                                mutArrayDate,@"date",
                                                nil];
                
                [mutDictQRProfile setObject:qrprofilevlaue forKey:heading];
                
                
            }
            
            
            
            
        }
        else{
        
            [mutTempHeading addObject:heading];
            [mutTempSubHeading addObject:subHeading];
            [mutTempImage addObject:image];
            //[mutTempValue addObject:[resultcloudqr stringForColumn:@"value"]];
            [mutArrayValueGlobal addObject:[resultcloudqr stringForColumn:@"value"]];
            
        }

        
        [mutArrayHeading addObject:heading];
        [mutArraySubHeading addObject:subHeading];
        
        [mutArrayTag addObject:tag];
        //[mutArrayValue addObject:[resultcloudqr stringForColumn:@"value"]];
        NSArray *dateArray = [[[[resultcloudqr stringForColumn:@"date"] componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"];
        
        date = [NSString stringWithFormat:@"%@/%@/%@",[dateArray lastObject],[dateArray objectAtIndex:1],[dateArray firstObject]];
        
        [mutArrayDate addObject:date];

        
        type = [NSString stringWithString:[resultcloudqr stringForColumn:@"tag"]];
        value = [NSString stringWithString:[resultcloudqr stringForColumn:@"value"]];
        //date = [NSString stringWithString:[resultcloudqr stringForColumn:@"date"]];
        updates = [NSString stringWithString:[resultcloudqr stringForColumn:@"updates"]];
        
       
        
    }
    
   
    [database close];
    
    
    NSMutableDictionary *dateDict = [[NSMutableDictionary alloc] init];
    [dateDict setObject:@"no" forKey:@"no"];
    
    
    NSDictionary *dictionaryHistory = [[NSDictionary alloc]
                                       initWithObjectsAndKeys:mutArrayHeading,@"heading",
                                       mutArraySubHeading,@"subheading",
                                       mutArrayImage,@"image",
                                       mutArrayTag,@"tag",
                                       mutArrayValueGlobal,@"value",
                                       mutArrayType,@"type",
                                       dateDict,@"date",
                                       mutTempHeading ,@"temphead",
                                       mutTempSubHeading,@"tempsub",
                                       mutTempImage,@"tempimage",
                                       mutDictQRProfile,@"qrprofile",
                                       mutDictQRProduct,@"qrproduct",
                                       mutDictQRLocker,@"qrlocker",
                                       nil];
    //dont use value of datedict or fix it above
    // DLog(@"dictionaryHistory %@",dictionaryHistory);
    return dictionaryHistory;
    
}


-(NSDictionary *)getDBDataForSync{
    
    NSDictionary *syncDBDict = [NSDictionary new];
    
    NSMutableArray *syncData = [[NSMutableArray alloc] init];
    
    NSString *lastSyncDate = nil;
    
    FMDatabase *database = [FMDatabase databaseWithCustomPath];
    [database open];
    
    
    FMResultSet *resultcloudqr = [database executeQuery:@"select * from cloudqr where sync=0"];
    
    while([resultcloudqr next]) {
        
        
        NSString *heading    = nil;
        NSString *subHeading = nil;
        NSString *image      = nil;
        NSString *tag        = nil;
        NSString *value      = nil;
        NSString *type       = nil;
        NSString *date       = nil;
        NSString *updates    = nil;
        NSString *location   = nil;
    
        heading = [NSString stringWithString:[resultcloudqr stringForColumn:@"heading"]];
        subHeading = [NSString stringWithString:[resultcloudqr stringForColumn:@"subheading"]];
        location = [NSString stringWithString:[resultcloudqr stringForColumn:@"location"]];
        
        
        tag = [NSString stringWithString:[resultcloudqr stringForColumn:@"tag"]];
        
        image = [resultcloudqr stringForColumn:@"image"];
        
        
        type = [NSString stringWithString:[resultcloudqr stringForColumn:@"tag"]];
        value = [NSString stringWithString:[resultcloudqr stringForColumn:@"value"]];
        date = [NSString stringWithString:[resultcloudqr stringForColumn:@"date"]];
        updates = [NSString stringWithString:[resultcloudqr stringForColumn:@"updates"]];
        
        NSDictionary *dictionaryHistory = [[NSDictionary alloc]
                                           initWithObjectsAndKeys:heading,@"heading",
                                           subHeading,@"subheading",
                                           image,@"image",
                                           tag,@"tag",
                                           value,@"value",
                                           date,@"date",
                                           location,@"location",
                                           nil];
        
        [syncData addObject:dictionaryHistory];
        
    }
    
    
    FMResultSet *resultSync = [database executeQuery:@"select * from sync"];
    
    while([resultSync next]) {
        
        lastSyncDate = [NSString stringWithString:[resultcloudqr stringForColumn:@"date"]];
        
    }
    
    if (!lastSyncDate) {
       /*
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSDate *todayDate = [NSDate date];
        lastSyncDate = [dateFormatter stringFromDate:todayDate];
        */
        lastSyncDate = @"0";
    }
    
    
    [database close];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:kUserIDKey];
    
    syncDBDict = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"AccountId",
                                                            lastSyncDate,@"syncdate",
                                                            syncData,@"syncdata",nil];
    
    NSLog(@"syncDBDict %@",syncDBDict);
   
    
    return syncDBDict;
    
}




@end
