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
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *settingImageView;
@end
@implementation OperationButtonsView

- (void)drawRect:(CGRect)rect {
    
    BOOL isPlayingState = [[ModelLocator sharedInstance].playbackViewModel isNowPlayingState];
    if (isPlayingState) {
        self.playImageView.image = [UIImage imageNamed:kPause];
    } else {
        self.playImageView.image = [UIImage imageNamed:kPlay];
    }
    
    self.tweetImageView.image = [self.tweetImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tweetImageView.tintColor = kDefaultTextColor;
    self.playImageView.image = [self.playImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.playImageView.tintColor = kDefaultTextColor;
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
    
    BOOL isPlayingState = [[ModelLocator sharedInstance].playbackViewModel isNowPlayingState];
    if (isPlayingState) {
        self.playImageView.image = [UIImage imageNamed:kPlay];
    } else {
        self.playImageView.image = [UIImage imageNamed:kPause];
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
