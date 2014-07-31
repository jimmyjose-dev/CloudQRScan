//
//  AudioViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 15/11/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "AudioViewController.h"
#import "AudioStreamer.h"
#import "AudioStreamerController.h"


@interface AudioViewController ()<AudioDelegate,AudioStreamerDelegate,EGOImageViewDelegate>{
    
    BOOL isPlaying;
    int count;
    
}

@property(nonatomic,retain)IBOutlet EGOImageView *userImageView;
@property(nonatomic,retain)IBOutlet UILabel *lblUsername;
@property(nonatomic,retain)IBOutlet UILabel *lblFilename;
@property(nonatomic,retain)IBOutlet UIButton *btnPlay;
@property(nonatomic,retain)IBOutlet UIButton *btnStop;
@property(nonatomic,retain)IBOutlet UILabel *lblStartTime;
@property(nonatomic,retain)IBOutlet UILabel *lblStopTime;
@property(nonatomic,retain)IBOutlet UISlider *sldProgress;

@property (nonatomic, retain) AudioStreamerController *audioStreamer;
@property (nonatomic, retain) AudioStreamer *audio;

@property (nonatomic, retain) NSTimer *tmrSlider;



@end

@implementation AudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    count = 0;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [Flurry logEvent:@"Audio Player" timed:YES];
    
    UIImage *backButtonImage = [UIImage imageByAppendingDeviceName:@"btn_back"];
    
    CGRect backButtonFrame = CGRectZero;
    backButtonFrame.origin.x += 5;
    backButtonFrame.size = backButtonImage.size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:backButtonFrame];
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = back;
    
    [self resetAudio];
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self audioStopped];
    [Flurry endTimedEvent:@"Audio Player" withParameters:nil];
}

-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *fileName = [[_urlString lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    [_lblFilename setText:fileName];
    
    NSString *audioFilename = _urlString;//@"http://www.tonycuffe.com/mp3/pipershut_lo.mp3";//
    audioFilename = [audioFilename stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    //audioFilename = [audioFilename stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    DLog(@"audioFilename %@\nurlstring %@",audioFilename,_urlString);
    
        _audioStreamer = [[AudioStreamerController alloc] initWithAudioFileName:audioFilename];
        _audioStreamer.delegate = self;
        _audioStreamer.streamer.delegate = self;
    
    count = 0;
    
    float colorValue = 86.0/255.0;
    
    UIColor *customGreyColor = [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1.0];
    
    
    UIColor *progressColor = [UIColor colorWithRed:76.0/255.0 green:166.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    _sldProgress.value = 0.0;
    _sldProgress.minimumTrackTintColor = progressColor;
    _sldProgress.maximumTrackTintColor = customGreyColor;//[UIColor whiteColor];
    _userImageView.delegate = self;
    
    //_userImageView.placeholderImage = [UIImage imageByAppendingDeviceName:@"img_profile_loading"];
    //_userImageView.image = [UIImage imageByAppendingDeviceName:@"img_profile_loading"];
}

-(void)imageViewFailedToLoadImage:(EGOImageView *)imageView error:(NSError *)error{

    UIImage *image = [UIImage imageByAppendingDeviceName:@""];
    [imageView setImage:image];
}

-(IBAction)seekTime:(UISlider *)slider{

    [_audioStreamer.streamer seekToTime:slider.value];
    count = slider.value;

}

-(IBAction)playButtonPressed:(id)sender{
 
    UIImage *buttonImage = nil;
    
    /*
    if (!_audioStreamer) {
        _audioStreamer = [[AudioStreamerController alloc] initWithAudioFileName:audioFilename];
        _audioStreamer.delegate = self;
        _audioStreamer.streamer.delegate = self;
        
        DLog(@"Audio streamer object recreated");
    }
     */

   
    DLog(@"state %d",[_audioStreamer isAudioPlaying]);
    
    if (![_audioStreamer isAudioPlaying]) {
        
        buttonImage = [UIImage imageByAppendingDeviceName:@"btn_pause"];
        
        DLog(@"play");
        [_audioStreamer playAudio];
        
        
        [MMProgressHUD showWithTitle:@"Buffering..."
                              status:@"Double tap to cancel"
                 confirmationMessage:@"Tap to Cancel"
                         cancelBlock:^{
                             DLog(@"Task was cancelled!");
                             [_audioStreamer stopAudio];
                             [self resetAudio];
                             //_audioStreamer = nil;
                             UIImage *buttonImage  = [UIImage imageByAppendingDeviceName:@"btn_play"];
                             [_btnPlay setImage:buttonImage forState:UIControlStateNormal];
                         }];
        
        
    }
    else{
        
        DLog(@"pause");
        buttonImage = [UIImage imageByAppendingDeviceName:@"btn_play"];
        
        @try {
            DLog(@"going to crash %@ %@",_audioStreamer,_audioStreamer.streamer);
            [_audioStreamer stopAudio];
           // [_audioStreamer.streamer pause];
        }
        @catch (NSException *exception) {
            DLog(@"exception in audio %@",[exception debugDescription]);
        }
        @finally {
            
            [_btnPlay setImage:buttonImage forState:UIControlStateNormal];
        }
    }
    
    [_btnPlay setImage:buttonImage forState:UIControlStateNormal];
    

    
}

-(IBAction)stopButtonPressed:(id)sender{
    
    [_audioStreamer stopAudio];
    [self resetAudio];
    //_audioStreamer = nil;
    UIImage *buttonImage  = [UIImage imageByAppendingDeviceName:@"btn_play"];
    [_btnPlay setImage:buttonImage forState:UIControlStateNormal];
    
}


-(void)audioPlaying{
    
    
    if (!_tmrSlider) {
        
        _tmrSlider = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        
    }
    

    //NSString *progress = [NSString stringWithFormat:@"%05.2f",_audioStreamer.streamer.progress/60.0];
    NSString *duration = [self timeInMinutesAndSecondsWithSeconds:_audioStreamer.streamer.duration];
    
    
    
    //[_lblStartTime setText:progress];
    [_lblStopTime setText:duration];
    
    [MMProgressHUD dismiss];
}

-(void)updateTimer{
    
    if (![_audioStreamer isAudioWaiting]) {
        
    [MMProgressHUD dismiss];
    _sldProgress.maximumValue = _audioStreamer.streamer.duration;
    _sldProgress.value = _audioStreamer.streamer.progress;

    
    NSString *progress = [self timeInMinutesAndSecondsWithSeconds:_audioStreamer.streamer.progress];
    
    [_lblStartTime setText:progress];
    
    }
    else if(_audioStreamer.streamer.state == 0 || _audioStreamer.streamer.state == 7 || _audioStreamer.streamer.state == 8 )
    {
        [MMProgressHUD dismiss];
        [self resetAudio];
        
    }
    else if([_audioStreamer isAudioWaiting]){
    
        [MMProgressHUD showWithTitle:@"Buffering..."
                              status:@"Double tap to cancel"
                 confirmationMessage:@"Tap to Cancel"
                         cancelBlock:^{
                             DLog(@"Task was cancelled!");
                             [_audioStreamer stopAudio];
                             [self resetAudio];
                             //_audioStreamer = nil;
                             UIImage *buttonImage  = [UIImage imageByAppendingDeviceName:@"btn_play"];
                             [_btnPlay setImage:buttonImage forState:UIControlStateNormal];
                         }];

    }

}

-(NSString *)timeInMinutesAndSecondsWithSeconds:(float)seconds{

    float minutes = 0;
    
    seconds = (int)seconds;
    
    if (seconds>=60) {
        
        minutes = seconds/60.0;
    }
    
    if (minutes>=60) {
        
    //    hours = minutes/60.0;
    }
    
    
    // NSString *progress = [NSString stringWithFormat:@"%05.2f",++count/60.0];
    NSString *progress = [NSString stringWithFormat:@"%02.0f:%02.0f",minutes,seconds];
    
    DLog(@"progress %@ %d",progress,_audioStreamer.streamer.state);
    
    return progress;
}

-(void)audioError{
    
    
    [MMProgressHUD dismiss];
    
}

-(void)audioStopped{
    
    DLog(@"pause");
    UIImage *buttonImage = [UIImage imageByAppendingDeviceName:@"btn_play"];
    [_btnPlay setImage:buttonImage forState:UIControlStateNormal];
    
    @try {
        [_audioStreamer stopAudio];
        [self resetAudio];
        //_audioStreamer = nil;
        //[_audioStreamer pauseAudio];
    }
    @catch (NSException *exception) {
        DLog(@"exception in audio %@",[exception debugDescription]);
    }
    @finally {
        
        [_btnPlay setImage:buttonImage forState:UIControlStateNormal];
    }
    
    
}


-(void)resetAudio{
    
    isPlaying = NO;
    if (_audioStreamer) {
        if ([_audioStreamer isAudioPlaying]) {
            [_audioStreamer stopAudio];
           // _audioStreamer = nil;
        }
        
    }
    
    NSString *progress = @"00:00";
    NSString *duration = @"00:00";
    
    [_lblStartTime setText:progress];
    [_lblStopTime setText:duration];
    [_tmrSlider invalidate];
    _tmrSlider = nil;
    
    _sldProgress.value = 0.0;
    
    UIImage *buttonImage = [UIImage imageByAppendingDeviceName:@"btn_play"];
    [_btnPlay setImage:buttonImage forState:UIControlStateNormal];
    
    
    DLog(@"timer invalidated")
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
