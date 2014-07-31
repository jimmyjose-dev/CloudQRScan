//
//  CustomTableViewCell.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 19/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "CustomTableViewCellWithSubHeading.h"


@interface CustomTableViewCellWithSubHeading()<EGOImageViewDelegate>
@property(nonatomic,assign)int height;

@end

@implementation CustomTableViewCellWithSubHeading

@synthesize imgVW,placeHolderImgVW,title,subTitle;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    imgVW.delegate = self;
      
       // UIFont *font = [UIFont fontWithName:@"TitilliumText25L-999wt" size:17];
       // title.font = font;
        
        
    }
    
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


    

    // Configure the view for the selected state
}


+(int)heigthForCell{

    
    return 74;

}

-(void)imageViewFailedToLoadImage:(EGOImageView *)imageView error:(NSError *)error{

    if ([_delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)]) {
                [_delegate imageViewFailedToLoadImage:imageView error:error];
    }
    

}

-(void)imageViewLoadedImage:(EGOImageView *)imageView{

    if ([_delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
                [_delegate imageViewLoadedImage:imageView];
    }

}


-(void)layoutSubviews{

    [super layoutSubviews];
    imgVW.delegate = self;
    
   CGRect bounds = [[self contentView] bounds];
    _height = bounds.size.height;
    UIFont *titleFont = [UIFont fontWithName:kCellHeadingFont size:kCellHeadingFontSize];
    UIFont *subTitleFont = [UIFont fontWithName:kCellSubHeadingFont size:kCellSubHeadingFontSize];
    title.font = titleFont;
    subTitle.font = subTitleFont;
    
    //Gotham-Light

}

@end
