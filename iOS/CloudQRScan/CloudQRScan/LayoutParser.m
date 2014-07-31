//
//  LayoutParser.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "LayoutParser.h"

@interface LayoutParser ()
@property(nonatomic,retain)NSMutableArray *layoutPointArray;
@end

@implementation LayoutParser

-(id)init{
    
    self = [super init];
    
    return self;
    
}

-(id)initWithCellIndex:(int)cellIdx andViewCount:(int)viewCount{
    
    self = [self init];
    [self parseLayoutWithCellIndex:cellIdx andViewCount:viewCount];
    return self;
    
}

-(void)parseLayoutWithCellIndex:(int)cellIdx andViewCount:(int)viewCount{

    [self setViewPointsWithCellIndex:cellIdx andViewCount:viewCount];
}

-(void)setViewPointsWithCellIndex:(int)cellIdx andViewCount:(int)viewCount{

    _layoutPointArray = [NSMutableArray new];
    
    int xCord = 300;
    int yCord = 74;
    
    switch (cellIdx) {
        case 0:
            for (int idx = 1; idx <= viewCount; ++idx) {
                CGPoint point = {xCord,yCord*idx};
                NSValue *value = [NSValue valueWithCGPoint:point];
                [_layoutPointArray addObject:value];
            }
            break;
            
        default:
            break;
    }
    

}

-(NSArray *)getViewPointsArray{

    return _layoutPointArray;

}

@end
