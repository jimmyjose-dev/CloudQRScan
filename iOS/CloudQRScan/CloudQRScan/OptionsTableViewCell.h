//
//  OptionsTableViewCell.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface OptionsTableViewCell : UITableViewCell
@property(nonatomic,retain)IBOutlet EGOImageView *optionImageView;
@property(nonatomic,retain)IBOutlet UILabel *optionTitleLabel;
@end
