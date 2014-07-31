//
//  EventViewController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 12/06/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
@interface EventViewController : UIViewController
@property(nonatomic,retain)NSDictionary *eventDict;
@end
*/
@class EKEvent,EKEventStore;
@interface EventViewController : NSObject
-(void)displayEventViewForEvent:(EKEvent *)event withEventStore:(EKEventStore *)eventStore;
@end
