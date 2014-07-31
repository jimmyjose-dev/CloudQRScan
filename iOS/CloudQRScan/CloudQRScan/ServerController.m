//
//  ServerController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 04/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ServerController.h"


@interface ServerController (){

    ServerCallback callback;

}
@property(nonatomic,retain)NSString *service;
@property(nonatomic,retain)NSString *serverURL;
@property(nonatomic,retain)NSDictionary *postParameter;
@property(nonatomic,retain)NSDictionary *reponseFilterDictionary;
@property(nonatomic,copy)ServerCallback callback;
@end

@implementation ServerController
@synthesize callback;

-(id)init{

    self = [super init];
    
    return self;

}

-(id)initWithServerURL:(NSString *)serverURL andPostParameter:(NSDictionary *)postParameter forServiceType:(NSString *)service{

    self = [self init];

    _serverURL = serverURL;
    _postParameter = postParameter;
    _service = service;
    
    return self;

}

-(id)initWithServerURL:(NSString *)serverURL forServiceType:(NSString *)service{
    
    return [self initWithServerURL:serverURL andPostParameter:nil forServiceType:service];
    
}



-(void)connectUsingGetMethodWithCompletionBlock:(ServerCallback)completion{

    self.callback = completion;
    [self initGetServiceWithServerURL:_serverURL forServiceType:_service];
}

-(void)initGetServiceWithServerURL:(NSString *)serverURLString forServiceType:(NSString *)service{
    
    DLog(@"serverURLString %@",serverURLString);
    
    
    
    NSURL *serverURL = [NSURL URLWithString:serverURLString];
    
   /* NSURLRequest *request = [[NSURLRequest alloc] initWithURL:serverURL
                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                              timeoutInterval:kTimeoutInterval];
    */
    
    //Even though the cache policy was not
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:serverURL];
    [request setTimeoutInterval:kTimeoutInterval];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
        
        DLog(@"res %@",[data stringUTF8]);
        if (!error) {
            
            NSError *err = nil;
            id responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments error:&err];
            if (!err) {
                
                
                //DDLogVerbose(@"response %@",responseJSON);
            
                if (self.callback) {
                    self.callback(responseJSON,nil,service);
                }
                
            }
            else{
            
                if (self.callback) {
                    self.callback(nil,[err localizedDescription],service);
                }
            }
            
        }
        else{
        
            if (self.callback) {
                self.callback(nil,[error localizedDescription],service);
            }
        }
        
    }];
    

}


-(void)connectUsingPostMethodWithCompletionBlock:(ServerCallback)completion{
    
    self.callback = completion;
    [self initPostServiceWithServerURL:_serverURL andPostParameter:_postParameter forServiceType:_service];
}


-(void)initPostServiceWithServerURL:(NSString *)serverURL andPostParameter:(NSDictionary *)postParameter forServiceType:(NSString *)service{
    
    DLog(@"serverURLString %@",serverURL);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postParameter
                                                       options:nil
                                                         error:nil];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *urlString = serverURL;
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
        
        if (!error) {
            
            NSError *err = nil;
            id responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments error:&err];
            if (!err) {
                
                if (self.callback) {
                    self.callback(responseJSON,nil,service);
                }
                
            }
            else{
            
                if (self.callback) {
                    self.callback(nil,[err localizedDescription],service);
                }
            
            }
            
        }
        else{
        
            if (self.callback) {
                self.callback(nil,[error localizedDescription],service);
            }
        
        }
        
    }];

}


@end
