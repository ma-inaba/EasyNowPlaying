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
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *settingImageView;
@end

@implementation OperationButtonsView

- (void)drawRect:(CGRect)rect {
    
    self.tweetImageView.image = [self.tweetImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tweetImageView.tintColor = kDefaultTextColor;
    
    MPMusicPlaybackState state = [[ModelLocator sharedInstance].playbackViewModel nowPlaybackState];
    switch (state) {
        case MPMusicPlaybackStatePlaying:
            self.playImageView.image = [UIImage imageNamed:kPause];
            break;
        case MPMusicPlaybackStatePaused:
            self.playImageView.image = [UIImage imageNamed:kPlay];
            break;
        default:
            break;
    }
    
    self.playImageView.image = [self.playImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (state == MPMusicPlaybackStateStopped) {
        self.playImageView.tintColor = [UIColor lightGrayColor];
        self.playButton.userInteractionEnabled = NO;
        self.tweetImageView.tintColor = [UIColor lightGrayColor];
        self.tweetButton.userInteractionEnabled = NO;
        self.nextImageView.tintColor = [UIColor lightGrayColor];
        self.nextButton.userInteractionEnabled = NO;
        self.backImageView.tintColor = [UIColor lightGrayColor];
        self.backButton.userInteractionEnabled = NO;
    } else {
        self.playImageView.tintColor = kDefaultTextColor;
        self.playButton.userInteractionEnabled = YES;
        self.tweetImageView.tintColor = kDefaultTextColor;
        self.tweetButton.userInteractionEnabled = YES;
        self.nextImageView.tintColor = kDefaultTextColor;
        self.nextButton.userInteractionEnabled = YES;
        self.backImageView.tintColor = kDefaultTextColor;
        self.backButton.userInteractionEnabled = YES;
    }
    
    self.nextImageView.image = [self.nextImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.backImageView.image = [self.backImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.settingImageView.image = [self.settingImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.settingImageView.tintColor = kDefaultTextColor;
}

- (IBAction)tweetAction:(id)sender {
    
    [self invalidationWhenStopped];
    [self buttonPushAnimation:self.tweetImageView];
    
    if ([self.operationButtonsViewDelegate respondsToSelector:@selector(onTweetButton)]) {
        [self.operationButtonsViewDelegate onTweetButton];
    }
}

- (IBAction)playAction:(id)sender {
    
    [self invalidationWhenStopped];
    [self buttonPushAnimation:self.playImageView];
    
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
    
    [self invalidationWhenStopped];
    [self buttonPushAnimation:self.nextImageView];

    [[ModelLocator sharedInstance].playbackViewModel skipToNextMusic];
    
    if ([self.operationButtonsViewDelegate respondsToSelector:@selector(onNextButton)]) {
        [self.operationButtonsViewDelegate onNextButton];
    }
}

- (IBAction)backAction:(id)sender {
    
    [self invalidationWhenStopped];
    [self buttonPushAnimation:self.backImageView];

    [[ModelLocator sharedInstance].playbackViewModel skipToPreviousMusic];
    
    if ([self.operationButtonsViewDelegate respondsToSelector:@selector(onBackButton)]) {
        [self.operationButtonsViewDelegate onBackButton];
    }
}

- (IBAction)settingAction:(id)sender {
    
    [self buttonPushAnimation:self.settingImageView];
}

- (void)invalidationWhenStopped {
    
    MPMusicPlaybackState state = [[ModelLocator sharedInstance].playbackViewModel nowPlaybackState];
    if (state == MPMusicPlaybackStateStopped) {
        return;
    }
}

- (void)buttonPushAnimation:(UIImageView *)imageView {
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
        imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL compilation) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
            imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL compilation) {
        }];
    }];
}

@end
