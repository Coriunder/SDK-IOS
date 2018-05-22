//
//  DownloadViewPlayer.m
//  Mahala
//
//  Created by Vitaliy Stepanov on 15.08.14.
//  Copyright (c) 2014 Udi Azulay. All rights reserved.
//

#import "DownloadViewPlayer.h"
#import "Base64.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "Coriunder.h"
#import "UserSession.h"

#define UPDATE_TIME_INTERVAL 1.0

@interface DownloadViewPlayer () {
    BOOL songLoaded;
    BOOL imageSet;
}

@end

@implementation DownloadViewPlayer

- (id)init
{
    self = [super initWithNibName:@"DownloadViewPlayer" bundle:[NSBundle mainBundle]];
    songLoaded = YES;
    if (!self) return nil;
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.streaming) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(toggling_Playback)                                                  name:@"TogglePlayPause"
                                                   object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    imageSet = NO;
    if (self.streaming) {
        self.downloadButton.enabled = YES;
        self.sliderTime.maximumValue = 100;
        [self setButtonImageNamed:@"play-icon.png"];
    } else {
        self.downloadButton.enabled = NO;
        self.sliderTime.maximumValue = 1;
    }
    self.sliderTime.userInteractionEnabled = !self.streaming;
    if (self.streaming) {
        self.songBanner = [UIImage imageNamed:@"mp3-"];
    }
    self.songImage.image = self.songBanner;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.streaming) {
        [streamer stop];
        
        if ((streamer && ![streamer isDownloaded]) || !self.downloaded) {
            NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject]
                                  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.MP3", [self.Array_PathPlayingFiles objectAtIndex:self.itemNumber]]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error;
            [fileManager removeItemAtPath:fileName error:&error];
        }
        
        [self updateCurrentTimeSliderAndLable];
    } else {
        [self stop];
    }
    self.songBanner = [UIImage imageNamed:@"mp3-"];
    [super viewWillDisappear:animated];
}

#pragma mark - set Path create instance SetAudioToPlay
- (void)setAudioToPlay
{
    if (!self.streaming) {
        NSError *setCategoryErr = nil;
        NSError *activationErr = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                               error:&setCategoryErr];
        if (setCategoryErr != nil) {
            NSLog(@"Set category error: %@",[setCategoryErr localizedDescription]);
        }
        [[AVAudioSession sharedInstance] setActive:YES
                                             error:&activationErr];
        if (activationErr != nil) {
            NSLog(@"Make active error: %@",[activationErr localizedDescription]);
        }
        NSString *filePath = self.str_FilePath;
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:filePath];
        
        AVAsset *asset = [AVAsset assetWithURL:fileUrl];
        for (AVMetadataItem *metadataItem in asset.commonMetadata) {
            if ([metadataItem.commonKey isEqualToString:@"artwork"]){
                UIImage *image = nil;
                @try {
                    image = [UIImage imageWithData:(NSData *)metadataItem.value];
                }
                @catch (NSException *exception) {
                    image = [UIImage imageWithData:(NSData *)[(NSDictionary *)metadataItem.value objectForKey:@"data"]];
                }
                @finally {
                }
                if (image != nil) {
                    self.songBanner = image;
                } else {
                    self.songBanner = [UIImage imageNamed:@"mp3-"];
                }
            }
        }
        
        NSError *playerInitErr = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl
                                                             error:&playerInitErr];
        if (playerInitErr != nil) {
            NSLog(@"Error creating AVAudioPlayer instance: %@",[playerInitErr localizedDescription]);
        }
        self.player.delegate = self;
        duration = self.player.duration;
        [self.player prepareToPlay];
    }
}
- (IBAction)playPauseButtonPressed
{
    if (self.streaming) {
        if ([currentImageName isEqual:@"play-icon.png"]) {
            if (self.downloaded) {
                [self openSong:[self.Array_PathPlayingFiles objectAtIndex:self.itemNumber]];
            } else {
                [self createStreamer];
                streamer.itemID = [self.Array_PathPlayingFiles objectAtIndex:self.itemNumber];
                [self setButtonImageNamed:@"loadingbutton.png"];
                [streamer start];
            }
        } else if ([currentImageName isEqual:@"pause-icon.png"]) {
            [streamer pause];
            [self setButtonImageNamed:@"play-icon.png"];
        }/* else {
            [streamer stop];
        }*/
    } else {
        [self toggling_Playback];
    }
}

- (IBAction)timeSliderTouchDown
{
    if (!self.streaming) {
        userChangingTimeSlider = YES;
    }
}

- (IBAction)timeSliderTouchUp
{
    if (self.streaming) {
        if (streamer.duration)
        {
            double newSeekTime = (self.sliderTime.value / 100.0) * streamer.duration;
            [streamer seekToTime:newSeekTime];
        }
    } else {
        self.player.currentTime = (self.sliderTime.value * duration);
        userChangingTimeSlider = NO;
    }
}

- (void)stop
{
    if (!self.streaming) {
        [self.player stop];
        [self updatePlayPauseImageOnBtn];
        self.player.currentTime = 0;
        [self updateCurrentTimeSliderAndLable];
    }
}

- (IBAction)previosButtonWasPressed {
    if (![self needSaveDialog:@"prev"]) [self previous];
}

- (IBAction)nextButtonWasPressed {
    if (![self needSaveDialog:@"next"])[self next];
}

- (void) next {
    if (self.streaming) {
        [self destroyStreamer];
        [self updateCurrentTimeSliderAndLable];
    } else {
        [self stop];
    }
    if (self.itemNumber == [self.Array_PathPlayingFiles count]-1) {
        self.itemNumber = 0;
    } else {
        self.itemNumber++;
    }
    while ([[self.Array_PathPlayingFiles objectAtIndex:self.itemNumber] isEqualToString:@""]) {
        if (self.itemNumber == [self.Array_PathPlayingFiles count]-1) {
            self.itemNumber = 0;
        } else {
            self.itemNumber++;
        }
    }
    
    NSString *itemID = [self.Array_PathPlayingFiles objectAtIndex:self.itemNumber];
    [self openSong:itemID];
}

- (void) previous {
    if (self.streaming) {
        [self destroyStreamer];
        [self updateCurrentTimeSliderAndLable];
    } else {
        [self stop];
    }
    if (self.itemNumber == 0) {
        self.itemNumber = [self.Array_PathPlayingFiles count]-1;
    } else {
        self.itemNumber--;
    }
    while ([[self.Array_PathPlayingFiles objectAtIndex:self.itemNumber] isEqualToString:@""]) {
        if (self.itemNumber == 0) {
            self.itemNumber = [self.Array_PathPlayingFiles count]-1;
        } else {
            self.itemNumber--;
        }
    }
    
    NSString *itemID = [self.Array_PathPlayingFiles objectAtIndex:self.itemNumber];
    [self openSong:itemID];
}

- (BOOL) needSaveDialog:(NSString*)skip {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject]
                          stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.MP3",
                                                          [self.Array_PathPlayingFiles objectAtIndex:self.itemNumber]]];
    if (![fileManager fileExistsAtPath:fileName] || (self.streaming && !self.downloaded)) {
        [self startDownload:NSLocalizedString(@"NO_SONG_DIALOG_TITLE_SKIP", nil)
                    message:NSLocalizedString(@"NO_SONG_DIALOG_MESSAGE_SKIP", nil)
                       skip:skip];
        return YES;
    } else {
        return NO;
    }
}

- (void)toggling_Playback
{
    if (!self.streaming) {
        if (songLoaded) {
            (self.player.isPlaying ? [self.player pause] : [self.player play]);
            [self updatePlayPauseImageOnBtn];          //start a timer to update time elapsed labels and time slider
            if (self.player.isPlaying && self.timerUpdate == nil)
            {
                self.timerUpdate = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL
                                                                    target:self
                                                                  selector:@selector(updateCurrentTimeSliderAndLable)                                                     userInfo:nil
                                                                   repeats:YES];
            }
        } else {
            NSString *itemID = [self.Array_PathPlayingFiles objectAtIndex:self.itemNumber];
            [self openSong:itemID];
        }
    }
}

- (void)updateCurrentTimeSliderAndLable {     //Update center time label with elapsed and remaining times
    if (!self.streaming || [streamer isIdle]) {
        NSString *elapsed = [self formatTimeString:self.player.currentTime
                                        asNegative:NO];
        NSString *remaining = [self formatTimeString:(duration - self.player.currentTime)
                                          asNegative:YES];
        if ([remaining isEqualToString:@"-00:00"])
        {                  [UIView beginAnimations:@"update slider"
                                           context:nil];
            [UIView setAnimationDuration:UPDATE_TIME_INTERVAL * 0.95f];
            self.player.currentTime = self.sliderTime.maximumValue;
            self.sliderTime.value = self.player.currentTime;
            [UIView commitAnimations];
            self.sliderTime.value = 1.00;
            self.player.currentTime = 0.0;
            [self audioPlayerDidFinishPlaying:self.player successfully:YES];
        }
        self.labelTimeElapsed.text=elapsed;
        self.labelTimeRemaining.text=[self formatTimeString:duration asNegative:NO];
        if (!userChangingTimeSlider)
        {
            [UIView beginAnimations:@"update slider"
                            context:nil];
            [UIView setAnimationDuration:UPDATE_TIME_INTERVAL * 0.95f];
            self.sliderTime.value = self.player.currentTime / duration;
            [UIView commitAnimations];
        }
    }
}

#pragma mark - Update UI
- (void)updatePlayPauseImageOnBtn
{
    NSString *imageName;
    if (self.player.isPlaying)
    {
        imageName = @"pause-icon";
    } else {
        imageName = @"play-icon";
    }
    [self.playPauseButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
#pragma mark -
#pragma mark Utility events
- (NSString *)formatTimeString:(NSTimeInterval)s asNegative:(BOOL)negative
{
    int seconds = (int) s; int hours = seconds / 3600; seconds -= (hours * 3600);
    int mins = seconds / 60; seconds -= (mins * 60);
    NSString *sign = (negative ? @"-" : @"");
    if (self.streaming) {
        sign = @"";
    }
    if (hours > 0)
    {
        return [NSString stringWithFormat:@"%@%i:%02d:%02d", sign, hours, mins, seconds];
    } else {
        return [NSString stringWithFormat:@"%@%02d:%02d", sign, mins, seconds];
    }
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    if (!self.streaming) {
        [self.player stop];
        [self nextButtonWasPressed];
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"Interruption began");
}

//Note: this form is only for iOS >= 4.0. See docs for pre-4.0.
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    NSLog(@"Interruption ended");     //restart playback if flag indicates we should resume
    if (flags & AVAudioSessionInterruptionFlags_ShouldResume)
    {
        [self toggling_Playback];
    }
}

- (void)openSong:(NSString*)itemID
{
    imageSet = NO;
    self.downloaded = NO;
    self.songImage.image = [UIImage imageNamed:@"mp3-"];
    //Check whether file exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject]
                          stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.MP3", itemID]];
    BOOL openStreamer;
    if (![fileManager fileExistsAtPath:fileName]) {
        openStreamer = YES;
    } else {
        openStreamer = NO;
        //get real file size
        NSDictionary *fileDict = [[NSFileManager defaultManager] fileAttributesAtPath:fileName traverseLink:YES];
        long realSize = [fileDict fileSize];
        
        //get required file size
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:itemID];
        if (value && value != nil && ![value isEqual:@""]) {
            if (!(([value intValue] - realSize) < 10000 && ([value intValue] - realSize) > -10000)) {
                openStreamer = YES;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error;
                [fileManager removeItemAtPath:fileName error:&error];
            }
        }
    }
    
    
    if (openStreamer) {
        self.downloadButton.enabled = YES;
        self.str_FilePath = fileName;
        self.streaming = YES;
        self.sliderTime.userInteractionEnabled = NO;
        [self setButtonImageNamed:@"play-icon.png"];
        self.sliderTime.maximumValue = 100;
        [self createStreamer];
        [self playPauseButtonPressed];
        
        /*[[AppWindow current] alertTitle:NSLocalizedString(@"NO_SONG_DIALOG_TITLE", nil)
         alertMessage:NSLocalizedString(@"NO_SONG_DIALOG_MESSAGE", nil)
         buttonFirstTitle:NSLocalizedString(@"DOWNLOAD_DIALOG_CANCEL", nil)
         firstButtonType:SIAlertViewButtonTypeDestructive
         buttonSecondTitle:NSLocalizedString(@"NO_SONG_DIALOG_OK", nil)
         secondButtonType:0
         completion:^(BOOL accepted) {
         
         if (accepted) {
         //Get base64 data for the file
         GDataXMLElement *itemData = [[AppWindow current].ServiceCon Download:itemID asPlainData:false];
         NSString *baseString = [itemData childAtIndex:0].XMLString;
         NSData *readyData = [Base64 decode:baseString];
         
         //Create directory if there is no required directory
         NSError *error = nil;
         if (![fileManager createDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject] withIntermediateDirectories:YES attributes:nil error:&error]) {
         NSLog(@"FAILED");
         }
         
         //Save file
         [[NSFileManager defaultManager] createFileAtPath:fileName contents:readyData attributes:nil];
         
         //Open or remove file
         NSDictionary *fileDict = [[NSFileManager defaultManager] fileAttributesAtPath:fileName traverseLink:YES];
         if ([fileDict fileSize] > 0) {
         self.str_FilePath = fileName;
         songLoaded = YES;
         [self setAudioToPlay];
         [self toggling_Playback];
         } else {
         NSError *error;
         [fileManager removeItemAtPath:fileName error:&error];
         }
         } else {
         self.str_FilePath = nil;
         songLoaded = NO;
         }
         }];*/
    } else {
        //Open file
        self.downloadButton.enabled = NO;
        self.str_FilePath = fileName;
        self.sliderTime.maximumValue = 1;
        songLoaded = YES;
        self.streaming = NO;
        self.sliderTime.userInteractionEnabled = YES;
        [self setAudioToPlay];
        self.songImage.image = self.songBanner;
        [self toggling_Playback];
    }
}

- (void)startDownload:(NSString*)title message:(NSString*)message skip:(NSString*)skip {
    NSString *itemID = [self.Array_PathPlayingFiles objectAtIndex:self.itemNumber];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject]
                          stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.MP3", itemID]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Start" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        //[streamer stop];
        [self removeFile:skip filename:fileName];
        
        [self updateCurrentTimeSliderAndLable];
        songLoaded = YES;
        
        //Get base64 data for the file
// DOWNLOAD HERE
        /*GDataXMLElement *itemData = [[AppWindow current].ServiceCon Download:itemID asPlainData:false];
        NSString *baseString = [itemData childAtIndex:0].XMLString;*/
        NSData *readyData = [Base64 decode:@"baseString"];
        
        //Create directory if there is no required directory
        NSError *error = nil;
        if (![fileManager createDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject] withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"FAILED");
        }
        
        //Save file
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:readyData attributes:nil];
        
        //Open or remove file
        NSDictionary *fileDict = [[NSFileManager defaultManager] fileAttributesAtPath:fileName traverseLink:YES];
        if ([fileDict fileSize] > 0) {
            //Open file
            self.downloadButton.enabled = NO;
            self.str_FilePath = fileName;
            self.sliderTime.maximumValue = 1;
            self.streaming = NO;
            self.sliderTime.userInteractionEnabled = YES;
            [self setAudioToPlay];
            self.songImage.image = self.songBanner;
            [self toggling_Playback];
            
        } else {
            songLoaded = NO;
            NSError *error;
            [fileManager removeItemAtPath:fileName error:&error];
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        self.str_FilePath = nil;
        songLoaded = NO;
        if (skip != nil) {
            [self removeFile:skip filename:fileName];
        }
        if (skip != nil && [skip isEqual:@"next"]) {
            [self next];
        } else if (skip != nil && [skip isEqual:@"prev"]) {
            [self previous];
        }
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

//Remove saved part of the file
- (void)removeFile:(NSString*)skip filename:(NSString*)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ((streamer && self.streaming && ![streamer isDownloaded] && [fileManager fileExistsAtPath:fileName]) ||
        ([fileManager fileExistsAtPath:fileName] && skip != nil && [skip isEqual:@"error"])) {
        [streamer stop];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager removeItemAtPath:fileName error:&error];
    }
}

- (IBAction)download {
    [self startDownload:NSLocalizedString(@"NO_SONG_DIALOG_TITLE", nil)
                message:NSLocalizedString(@"NO_SONG_DIALOG_MESSAGE", nil)
                   skip:nil];
}

/****************** STREAMER SECTION ******************/

// Used to change the image on the playbutton.
- (void)setButtonImageNamed:(NSString *)imageName
{
    if (!imageName)imageName = @"play-icon";
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    [self.playPauseButton.layer removeAllAnimations];
    [self.playPauseButton setImage:image forState:0];
    
    if ([imageName isEqual:@"loadingbutton.png"])
    {
        [self spinButton];
    }
}

// Removes the streamer, the UI update timer and the change notification
- (void)destroyStreamer
{
    if (streamer)
    {
        self.downloaded = [streamer isDownloaded];
        if (self.downloaded) {
            self.downloadButton.enabled = NO;
        }
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
        [progressUpdateTimer invalidate];
        progressUpdateTimer = nil;
        
        [streamer stop];
        streamer = nil;
    } else {
        self.downloaded = NO;
    }
}

// Creates or recreates the AudioStreamer object.
- (void)createStreamer
{
    if (streamer) return;
    
    [self destroyStreamer];
    NSString *string = [NSString stringWithFormat:@"https://webservices.mahala.us/shop.asmx/Download?applicationToken=%@&walletCredentials=%@&itemId=%@&asPlainData=true", [[Coriunder new] getAppToken], [UserSession getInstance].credentialsToken, [self.Array_PathPlayingFiles objectAtIndex:self.itemNumber]];
    CFStringRef urlString = (__bridge CFStringRef) string;
    
    NSString *escapedValue = [NSString stringWithFormat:@"%@", CFURLCreateStringByAddingPercentEscapes(nil, urlString,
                                                         //@"http://2mp3.primemusic.ru/dl2/YA2nA0yiYMU_8vUsz74qVQ/1418067458/2014/10/Papa_Roach_feat._Royce_Da_5_9_-_Warriors_(PrimeMusic.ru).mp3",
                                                         //@"http://shoutmedia.abc.net.au:10326",
                                                        NULL, NULL, kCFStringEncodingUTF8)];
    
    NSURL *url = [NSURL URLWithString:escapedValue];
    streamer = [[AudioStreamer alloc] initWithURL:url];
    
    progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.1
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
}

// Shows the spin button when the audio is loading.
- (void)spinButton
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGRect frame = [self.playPauseButton frame];
    self.playPauseButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.playPauseButton.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    animation.delegate = self;
    [self.playPauseButton.layer addAnimation:animation forKey:@"rotationAnimation"];
    
    [CATransaction commit];
}

// Restarts the spin animation on the button when it ends.
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
    if (finished && self.streaming)
    {
        [self spinButton];
    }
}

// Invoked when the AudioStreamer reports that its playback status has changed.
- (void)playbackStateChanged:(NSNotification *)aNotification
{
    if ([streamer isWaiting])
    {
        [self setButtonImageNamed:@"loadingbutton.png"];
    }
    else if ([streamer isPlaying])
    {
        [self setButtonImageNamed:@"pause-icon.png"];
        
        if (!imageSet) {
            NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:self.str_FilePath];
            AVAsset *asset = [AVAsset assetWithURL:fileUrl];
            for (AVMetadataItem *metadataItem in asset.commonMetadata) {
                if ([metadataItem.commonKey isEqualToString:@"artwork"]){
                    UIImage *image = nil;
                    @try {
                        image = [UIImage imageWithData:(NSData *)metadataItem.value];
                    }
                    @catch (NSException *exception) {
                        image = [UIImage imageWithData:(NSData *)[(NSDictionary *)metadataItem.value objectForKey:@"data"]];
                    }
                    @finally {
                    }
                    if (image != nil) {
                        self.songBanner = image;
                    } else {
                        self.songBanner = [UIImage imageNamed:@"mp3-"];
                    }
                    self.songImage.image = self.songBanner;
                    imageSet = YES;
                }
            }
            [streamer saveSongData];
        }
    }
    else if ([streamer isIdle])
    {
        [self destroyStreamer];
        if (self.streaming) {
            [self setButtonImageNamed:@"play-icon.png"];
        }
    }
}

// Invoked when the AudioStreamer reports that its playback progress has changed.
- (void)updateProgress:(NSTimer *)updatedTimer
{
    if (streamer.bitRate != 0.0)
    {
        int progress = streamer.progress;
        int durationStream = streamer.duration;
        
        if (durationStream > 0)
        {
            [self.labelTimeElapsed setText:[NSString stringWithFormat:@"%02d:%02d", (progress/60)%60, progress%60]];
            [self.labelTimeRemaining setText:[NSString stringWithFormat:@"%02d:%02d", (durationStream/60)%60, durationStream%60]];
            [self.sliderTime setEnabled:YES];
            [self.sliderTime setValue:100 * progress / durationStream];
        }
        else
        {
            [self.sliderTime setEnabled:NO];
        }
    }
    else
    {
        self.labelTimeElapsed.text = @"00:00";
        self.labelTimeRemaining.text = @"00:00";
    }
}

// Dismiss the text field when done is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
    if (self.streaming) {
        [sender resignFirstResponder];
        [self createStreamer];
    }
    return YES;
}

- (void)dealloc
{
    if (self.streaming) {
        [self destroyStreamer];
        if (progressUpdateTimer)
        {
            [progressUpdateTimer invalidate];
            progressUpdateTimer = nil;
        }
    }
}

@end
