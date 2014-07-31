//
//  CustomTableViewCell.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 19/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTableViewCellDelegate <NSObject>

@optional
-(void)imageViewFailedToLoadImage:(EGOImageView *)imageView error:(NSError *)error;
-(void)imageViewLoadedImage:(EGOImageView *)imageView;
@end

@class EGOImageView;
@interface CustomTableViewCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UIImageView *placeHolderImgVW;
@property(nonatomic,retain)IBOutlet EGOImageView *imgVW;
@property(nonatomic,retain)IBOutlet UILabel *title;
@property(nonatomic,retain) id <CustomTableViewCellDelegate> delegate;
+(int)heigthForCell;
@end
