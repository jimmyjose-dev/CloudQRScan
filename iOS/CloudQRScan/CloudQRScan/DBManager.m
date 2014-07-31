//
//  DBManager.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 05/04/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@implementation DBManager

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(BOOL)entryExistsForLink:(NSString *)link inTableName:(NSString *)tableName{
    
    FMDatabase *databases = [FMDatabase databaseWithCustomPath];
    
    [databases open];
    
    FMResultSet *result = [databases executeQuery:[NSString stringWithFormat:@"select * from %@",tableName]];
    
    BOOL entryExists = NO;
    
    while([result next]) {
        
        NSString *dbValue = [result stringForColumn:@"value"];
        
        if ([dbValue isEqualToString:link]) {
            entryExists = YES;
            break;
        }
    }
    
    [databases close];
    
    return entryExists;
    
}

-(FMDatabase *)getDatabase{

    return [FMDatabase databaseWithCustomPath];
}



-(BOOL)entryExistsInCloudQRTableForLink:(NSString *)link{
    
    return [self entryExistsForLink:link inTableName:@"cloudqr"];
    
}

-(void)saveLink:(NSString *)link withHeading:(NSString *)heading subHeading:(NSString *)subheading type:(NSString *)type andImagePath:(NSString *)imagePathName fromLocation:(NSString *)location onDate:(NSString *)dateStr{


    NSString *value = link;
    NSString *tag = kQRProfile;
    subheading = kHistoryQRProfile;
    [self saveLink:link withHeading:heading subHeading:subheading type:type andValue:value isEncrypted:NO andImagePath:imagePathName withTag:tag fromLocation:location onDate:dateStr];
}


-(void)saveLink:(NSString *)link withHeading:(NSString *)heading subHeading:(NSString *)subheading type:(NSString *)type fromLocation:(NSString *)location onDate:(NSString *)dateStr{
    
    NSString *value = link;
    NSString *tag = @"others";
    NSString *imagePathName = [NSString stringWithFormat:@"icon_history_%@",type];
    
    [self saveLink:link withHeading:heading subHeading:subheading type:type andValue:value isEncrypted:NO andImagePath:imagePathName withTag:tag fromLocation:location onDate:dateStr];
}

-(void)saveEncryptedLink:(NSString *)link fromUser:(NSString *)username fromLocation:(NSString *)location onDate:(NSString *)dateStr{
    
    
    NSString *heading = username;
    NSString *subheading = kHistoryQRLocker;
    NSString *value = link;
    NSString *type = @"qrlocker";
    NSString *tag = @"qrlocker";
    
    NSString *imagePathName = [NSString stringWithFormat:@"icon_history_%@",type];
    
    [self saveLink:link withHeading:heading subHeading:subheading type:type andValue:value isEncrypted:YES andImagePath:imagePathName withTag:tag fromLocation:location onDate:dateStr];
}

-(void)saveProductLink:(NSString *)link forProduct:(NSString *)product fromLocation:(NSString *)location onDate:(NSString *)dateStr{
    
    
    NSString *heading = product;
    NSString *subheading = kHistoryQRProduct;
    NSString *value = link;
    NSString *type = @"qrproduct";
    NSString *tag = @"qrproduct";
    
    NSString *imagePathName = [NSString stringWithFormat:@"icon_history_%@",type];
    
    [self saveLink:link withHeading:heading subHeading:subheading type:type andValue:value isEncrypted:YES andImagePath:imagePathName withTag:tag fromLocation:location onDate:dateStr];
}



-(void)saveLink:(NSString *)link withHeading:(NSString *)heading subHeading:(NSString *)subheading type:(NSString *)type andValue:(NSString *)value isEncrypted:(BOOL)isEncrypted andImagePath:(NSString *)imagePathName withTag:(NSString *)tag fromLocation:(NSString *)location onDate:(NSString *)dateStr{
    
    
    NSString *imageName = imagePathName;//[NSString stringWithFormat:@"icon_history_%@",type];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    if (!dateStr) {
    
        NSDate *todayDate = [NSDate date];
        dateStr = [dateFormatter stringFromDate:todayDate];
    }
    
    
    NSString *latitude  = nil;
    NSString *longitude = nil;
    
    if (!location) {
        
    
        if ([[LocationManagerDelegate sharedInstance] hasFoundLocation]) {
            
            latitude = [[LocationManagerDelegate sharedInstance] latitude];
            longitude = [[LocationManagerDelegate sharedInstance] longitude];
        }
        else{
        
            latitude  = @"0";
            longitude = @"0";
        }
        
        location = [NSString stringWithFormat:@"%@,%@",latitude,longitude];
    }
        
        NSString *updates = @"0";
    
        NSString *lastSync = @"0";
    
    
    [Flurry logEvent:@"QRCode Scanned Info" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:subheading,@"type",location,@"scanned location", nil]];
    
        FMDatabase *databases = [FMDatabase databaseWithCustomPath];
        
        [databases open];
        
        [databases executeUpdateWithFormat:@"delete from cloudqr where value =%@",link];
        
        [databases executeUpdate:@"insert into cloudqr(heading, subheading, tag, image, value, date,location,updates,sync) values(?,?,?,?,?,?,?,?,?)", heading,subheading,tag,imageName,value,dateStr,location,updates,lastSync,nil];
        [databases close];

}

-(void)deleteLink:(NSString *)link{

    FMDatabase *databases = [FMDatabase databaseWithCustomPath];
    
    [databases open];
    
    [databases executeUpdateWithFormat:@"delete from cloudqr where value =%@",link];
    
    [databases close];
}

-(void)updateSyncDate{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *todayDate = [NSDate date];
    NSString *dateStr = [dateFormatter stringFromDate:todayDate];

    NSString *latitude  = nil;
    NSString *longitude = nil;
    
    
    if ([[LocationManagerDelegate sharedInstance] hasFoundLocation]) {
        
        latitude = [[LocationManagerDelegate sharedInstance] latitude];
        longitude = [[LocationManagerDelegate sharedInstance] longitude];
    }
    else{
        
        latitude  = @"0";
        longitude = @"0";
    }
    
    NSString *location = [NSString stringWithFormat:@"%@,%@",latitude,longitude];

    
    FMDatabase *databases = [FMDatabase databaseWithCustomPath];
    
    [databases open];
    
    [databases executeUpdateWithFormat:@"UPDATE cloudqr SET sync = %@",dateStr];
    
    [databases executeUpdate:@"insert into sync(date,location) values(?,?)", dateStr,location,nil];
    
    [databases close];
    
}

-(void)createDirectoryForSharing{
    
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *shareFolder = [documentsPath stringByAppendingPathComponent:@"CloudQRScanDocs"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSError *error;
    
    BOOL success;
    
    // Create a folder
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:shareFolder])
        
    {
        success = [[NSFileManager defaultManager] createDirectoryAtPath:shareFolder  withIntermediateDirectories:NO attributes:nil error:&error];
        
        if (!success)
            
        {
            DLog(@"Error creating test folder: %@", error.localizedFailureReason);
            
            [prefs setValue:@"no" forKey:@"sharefolder"];
            return;
            
        }
        
        [prefs setValue:shareFolder forKey:@"sharefolder"];
        
    }
    
    
}

- (void)copyDB{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;

    
    NSString *writableDBPath = [FMDatabase cqrsDatabasePath];
    

    NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"DBCloudQRScan" ofType:@"sqlite"];
    
    
    int resourceDBVersion = 0;
    int deviceDBVersion = 0;
    
    BOOL shouldCopy = YES;
    
    FMDatabase *resourceDB = [FMDatabase databaseWithPath:defaultDBPath];
    
    [resourceDB open];
    
    FMResultSet *resultResourceDBVersion = [resourceDB executeQuery:@"select * from version"];
    
    while([resultResourceDBVersion next]) {resourceDBVersion = [resultResourceDBVersion intForColumn:@"version"]; }
    [resourceDB close];
    
    //DLog(@"Resource DB version %d",resourceDBVersion);
    
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success){
   
        FMDatabase *deviceDB = [FMDatabase databaseWithPath:writableDBPath];
        [deviceDB open];
        FMResultSet *resultDeviceDBVersion = [deviceDB executeQuery:@"select * from version"];
        while([resultDeviceDBVersion next]) {deviceDBVersion = [resultDeviceDBVersion intForColumn:@"version"]; }
        [deviceDB close];
        
       // DLog(@"Device DB Version %d",deviceDBVersion);
        if(deviceDBVersion!=0 && resourceDBVersion !=0){
            
            if (resourceDBVersion <= deviceDBVersion) {
                shouldCopy = NO;
            }
        }
        
    }//outer if
    
    if (success && shouldCopy) {
        [fileManager removeItemAtPath:writableDBPath error:&error];
        [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
       // DLog(@"Deleting previous version Copying DB from Resource to Device");
    }
    
    if (!success) {
        
        //DLog(@"Copying DB from Resource to Device");
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
        
    }
}



@end
