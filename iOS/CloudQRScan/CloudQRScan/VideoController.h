//
//  VideoController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 24/06/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoController : UIViewController
- (id) initWithVideoLink:(NSString *)link;
- (void) playYouTubeVideo:(NSString *)link;
@end
