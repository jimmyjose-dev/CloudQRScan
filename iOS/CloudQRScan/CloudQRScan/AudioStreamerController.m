//
//  AudioStreamerController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 22/06/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "AudioStreamerController.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@interface AudioStreamerController ()<AudioStreamerDelegate>


@property(nonatomic,retain)NSString *audioFilename;
//@property(nonatomic,retain)AudioStreamer *streamer;
@property(nonatomic,retain)NSTimer *timer;

@end

@implementation AudioStreamerController
@synthesize streamer,audioFilename;


-(id)init{

    self = [super init];
    return self;

}

-(id)initWithAudioFileName:(NSString *)audioFile{

    self = [self init];
    
    audioFilename = audioFile;
    [self createStreamer];
    
    return self;

}

- (void)destroyStreamer
{
	if (streamer)
	{
		[streamer stop];

		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
   
    NSString *escapedValue = [audioFilename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkPlayerState) userInfo:nil repeats:YES];
	
}

-(void)playAudio{

    [streamer start];
    
}

-(void)pauseAudio{

    [streamer pause];
}

-(int)getPlayerState{


    return [streamer state];

}

-(void)checkPlayerState{

    int state= [streamer state];
    
    if (state == AS_PAUSED) {
        [_delegate audioPaused];
    }else if (state == AS_PLAYING){
    
        [_delegate audioPlaying];
    }else if (state == AS_STOPPED){
    
        [_delegate audioStopped];
    }
    else if (state == AS_AUDIO_DATA_NOT_FOUND){
    
        [_delegate audioError];
    }
    
    


}

-(void)stopAudio{

    [streamer stop];

}

- (BOOL)isAudioPlaying{

    return [streamer isPlaying];

}
- (BOOL)isAudioPaused{

    return [streamer isPaused];
}
- (BOOL)isAudioWaiting{

    return [streamer isWaiting];
}
- (BOOL)isAudioIdle{

    return [streamer isIdle];
}



@end
