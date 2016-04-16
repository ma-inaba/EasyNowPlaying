//
//  OperationButtonsView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "OperationButtonsView.h"

@interface OperationButtonsView()
@property (weak, nonatomic) IBOutlet UIImageView *tweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *settingImageView;
@end

@implementation OperationButtonsView

- (void)drawRect:(CGRect)rect {
    
    self.tweetImageView.image = [self.tweetImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tweetImageView.tintColor = kDefaultTextColor;
    
    MPMusicPlaybackState state = [[ModelLocator sharedInstance].playbackViewModel nowPlaybackState];
    switch (state) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"Play");
            self.playImageView.image = [UIImage imageNamed:kPause];
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"Pause");
            self.playImageView.image = [UIImage imageNamed:kPlay];
            break;
        default:
            break;
    }
    
    self.playImageView.image = [self.playImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (state == MPMusicPlaybackStateStopped) {
//        NSLog(@"Pause");
        self.playImageView.tintColor = [UIColor lightGrayColor];
        self.playImageView.userInteractionEnabled = YES;
    } else {
//        NSLog(@"Play");
        self.playImageView.tintColor = kDefaultTextColor;
        self.playImageView.userInteractionEnabled = NO;
    }
    
    self.nextImageView.image = [self.nextImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.nextImageView.tintColor = kDefaultTextColor;
    self.backImageView.image = [self.backImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.backImageView.tintColor = kDefaultTextColor;
    self.settingImageView.image = [self.settingImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.settingImageView.tintColor = kDefaultTextColor;
}

- (IBAction)tweetAction:(id)sender {
    
    if ([self.operationButtonsViewDelegate respondsToSelector:@selector(onTweetButton)]) {
        [self.operationButtonsViewDelegate onTweetButton];
    }
}

- (IBAction)playAction:(id)sender {
    
    [[ModelLocator sharedInstance].playbackViewModel switchPlayStatus];
    
    MPMusicPlaybackState state = [[ModelLocator sharedInstance].playbackViewModel nowPlaybackState];
    switch (state) {
        case MPMusicPlaybackStatePlaying:
            self.playImageView.image = [UIImage imageNamed:kPlay];
            break;
        case MPMusicPlaybackStatePaused:
            self.playImageView.image = [UIImage imageNamed:kPause];
            break;
        case MPMusicPlaybackStateStopped:
            
            return;
            break;
        default:
            break;
    }

    self.playImageView.image = [self.playImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.playImageView.tintColor = kDefaultTextColor;
}

- (IBAction)nextAction:(id)sender {
    
    [[ModelLocator sharedInstance].playbackViewModel skipToNextMusic];
}

- (IBAction)backAction:(id)sender {
    
    [[ModelLocator sharedInstance].playbackViewModel skipToPreviousMusic];
}

- (IBAction)settingAction:(id)sender {
    
}

@end
