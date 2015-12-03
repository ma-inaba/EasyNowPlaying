//
//  OperationButtonsView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "OperationButtonsView.h"
#import "ModelLocator.h"
@interface OperationButtonsView()
@property (weak, nonatomic) IBOutlet UIImageView *tweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *settingImageView;
@end
@implementation OperationButtonsView


- (void)drawRect:(CGRect)rect {
    self.tweetImageView.image = [self.tweetImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tweetImageView.tintColor = [UIColor whiteColor];
    self.playImageView.image = [self.playImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.playImageView.tintColor = [UIColor whiteColor];
    self.nextImageView.image = [self.nextImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.nextImageView.tintColor = [UIColor whiteColor];
    self.backImageView.image = [self.backImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.backImageView.tintColor = [UIColor whiteColor];
    self.settingImageView.image = [self.settingImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.settingImageView.tintColor = [UIColor whiteColor];
}

- (IBAction)tweetAction:(id)sender {
    
    if ([self.operationButtonsViewDelegate respondsToSelector:@selector(onTweetButton)]) {
        [self.operationButtonsViewDelegate onTweetButton];
    }
}

- (IBAction)playAction:(id)sender {
    
    [[ModelLocator sharedInstance].playbackViewModel switchPlayStatus];
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
