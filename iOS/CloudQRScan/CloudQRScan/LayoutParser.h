//
//  LayoutParser.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutParser : NSObject
-(id)initWithCellIndex:(int)cellIdx andViewCount:(int)viewCount;
-(NSArray *)getViewPointsArray;
@end
