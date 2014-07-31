//
//  ProfileTableView.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileTableViewDelegate<NSObject>
-(void)tableViewTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface ProfileTableView : UITableView
@property (nonatomic, weak) id<ProfileTableViewDelegate> profileTVDelegate;
@end
