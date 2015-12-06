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
@property (weak, nonatomic) IBOutlet UILabel *musicDurationLabel;
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
    
    NSString *artistAlbumStr = [NSString stringWithFormat:@"%@ - %@",artistName, albumTitle];
    if (!artistName && !albumTitle) {
        artistAlbumStr = kNotPlayMusicNow;
    }

    
    int duration = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.duration;
    int secondTime = duration%60; //秒
    int minutTime = (duration/60)%60;  //分

    self.musicTitleLabel.text = musicTitle;
    self.artistAlbumLabel.text = artistAlbumStr;
    self.musicDurationLabel.text = [NSString stringWithFormat:@"%d:%02d", minutTime,secondTime];

    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 0.5;    
}

@end
