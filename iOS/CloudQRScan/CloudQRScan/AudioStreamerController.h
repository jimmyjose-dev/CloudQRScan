//
//  AudioStreamerController.h
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/06/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AudioStreamer;

@protocol AudioDelegate <NSObject>

@optional
-(void)audioStart;
-(void)audioPlaying;
-(void)audioPaused;
-(void)audioStopped;
-(void)audioIdle;
-(void)audioError;

@end

@interface AudioStreamerController : NSObject
-(id)initWithAudioFileName:(NSString *)audioFile;
-(void)playAudio;
-(void)pauseAudio;
-(int)getPlayerState;
-(void)stopAudio;
- (BOOL)isAudioPlaying;
- (BOOL)isAudioPaused;
- (BOOL)isAudioWaiting;
- (BOOL)isAudioIdle;
@property(nonatomic,retain)id <AudioDelegate>delegate;
@property(nonatomic,retain)AudioStreamer *streamer;

@end
