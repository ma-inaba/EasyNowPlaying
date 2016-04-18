//
//  MusicDataView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "MusicDataView.h"

@interface MusicDataView()
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistAlbumLabel;
@property (weak, nonatomic) IBOutlet UILabel *minimumMusicDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicDurationLabel;
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;

@end

@implementation MusicDataView

- (void)drawRect:(CGRect)rect {
    
    NSString *musicTitle = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.musicTitle;
    NSString *artistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artistName;
    NSString *albumTitle = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.albumTitle;
    
    if ([musicTitle isEqualToString:@""]) {
        musicTitle = kUnknownTitle;
    }
    
    if ([artistName isEqualToString:@""]) {
        artistName = kUnknownArtist;
    }
    
    if ([albumTitle isEqualToString:@""]) {
        albumTitle = kUnknownAlbum;
    }
    
    MPMusicPlaybackState state = [[ModelLocator sharedInstance].playbackViewModel nowPlaybackState];
    NSString *artistAlbumStr = [NSString stringWithFormat:@"%@ - %@",artistName, albumTitle];
    if ((!artistName && !albumTitle) || state == MPMusicPlaybackStateStopped) {
        artistAlbumStr = kNotPlayMusicNow;
        musicTitle = @"";
    }

    int duration = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.duration;
    int secondTime = duration%60; //秒
    int minutTime = (duration/60)%60;  //分

    self.musicTitleLabel.text = musicTitle;
    self.artistAlbumLabel.text = artistAlbumStr;
    self.musicDurationLabel.text = [NSString stringWithFormat:@"%d:%02d", minutTime,secondTime];

    [self.durationSlider setThumbImage:[UIImage imageNamed:@"PlayLine"] forState:UIControlStateNormal];
    [self reloaddurationSlider];
}

- (void)reloaddurationSlider {
    
    self.durationSlider.maximumValue = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.duration;
    self.durationSlider.value = [ModelLocator sharedInstance].playbackViewModel.loadCurrentPlaybackTime;
  
    int duration = self.durationSlider.value;
    int secondTime = duration%60; //秒
    int minutTime = (duration/60)%60;  //分
    
    self.minimumMusicDurationLabel.text = [NSString stringWithFormat:@"%d:%02d", minutTime,secondTime];
}

@end
