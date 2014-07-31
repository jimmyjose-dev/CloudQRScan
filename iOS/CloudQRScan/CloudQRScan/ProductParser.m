//
//  ProductParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 04/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ProductParser.h"

@interface ProductParser ()
@property(nonatomic,retain)NSDictionary *productDictionary;
@end
@implementation ProductParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithServerResponseDictionary:(NSDictionary *)serverResponseDictionary{
    
    self = [self init];
    _productDictionary = [NSDictionary new];
    [self parseQRProduct:serverResponseDictionary];
    return self;
    
}


-(void)parseQRProduct:(NSDictionary *)serverResponseDictionary{

    _productDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      [[serverResponseDictionary valueForKey:kProductDocumentKey] objectAtIndex:0] ,kProductDocumentKey,
                      [serverResponseDictionary valueForKey:kProductVideoKey],kProductVideoKey,
                      [serverResponseDictionary valueForKey:kProductImageKey],kProductImageKey,
                      [serverResponseDictionary valueForKey:kProductLikesKey],kProductLikesKey,
                      [serverResponseDictionary valueForKey:kProductPriceKey],kProductPriceKey,
                      [serverResponseDictionary valueForKey:kProductEmailKey],kProductEmailKey,
                      [serverResponseDictionary valueForKey:kProductPhoneKey],kProductPhoneKey,
                      [serverResponseDictionary valueForKey:kProductBuyNowKey],kProductBuyNowKey,nil];
    

}

-(NSDictionary *)getProductDictionary{

    return _productDictionary;

}


@end
