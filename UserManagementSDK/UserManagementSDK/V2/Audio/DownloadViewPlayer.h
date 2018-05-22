//
//  DownloadViewPlayer.h
//  Mahala
//
//  Created by Vitaliy Stepanov on 15.08.14.
//  Copyright (c) 2014 Udi Azulay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AudioStreamer;

@interface DownloadViewPlayer : UIViewController<AVAudioPlayerDelegate>
{
    BOOL  userChangingTimeSlider;
    NSTimeInterval  duration;
    NSMutableArray *Array_PathPlayingFiles;
    NSString *str_FilePath;
    NSInteger CurrentIndexOfArray;
    AudioStreamer *streamer;
    NSString *currentImageName;
    NSTimer *progressUpdateTimer;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSTimer *timerUpdate;
@property (nonatomic, retain) NSString *str_FilePath;
@property (nonatomic, retain) NSMutableArray *Array_PathPlayingFiles;
@property (nonatomic) long itemNumber;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) IBOutlet UISlider *sliderTime;
@property (nonatomic, retain) IBOutlet UILabel  *labelTimeElapsed ,*labelTimeRemaining;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *previosButton;
@property (nonatomic, retain) IBOutlet UIImageView *songImage;
@property (nonatomic) BOOL streaming;
@property (nonatomic) BOOL downloaded;
@property (nonatomic, retain) UIImage *songBanner;

- (void)setAudioToPlay;
- (void)startDownload:(NSString*)title message:(NSString*)message skip:(NSString*)skip;
//- (void)updatePlayPauseImageOnBtn;
- (void)updateCurrentTimeSliderAndLable;
- (void)toggling_Playback;
- (IBAction)playPauseButtonPressed;
- (NSString *)formatTimeString:(NSTimeInterval)s asNegative:(BOOL)negative;
- (IBAction)timeSliderTouchDown;
- (IBAction)timeSliderTouchUp;
- (IBAction)nextButtonWasPressed;
- (IBAction)previosButtonWasPressed;
- (IBAction)download;

/* - (IBAction)buttonPressed:(id)sender;
 - (void)spinButton;
 - (void)updateProgress:(NSTimer *)aNotification;
 - (IBAction)sliderMoved:(UISlider *)aSlider;*/

@end
