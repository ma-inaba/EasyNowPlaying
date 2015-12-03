//
//  MusicDataView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "MusicDataView.h"
#import "ModelLocator.h"

@interface MusicDataView()
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistAlbumLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicDurationLabel;
@end

@implementation MusicDataView

- (void)drawRect:(CGRect)rect {
    
    self.musicTitleLabel.text = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.musicTitle;
    
    NSString *artistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artistName;
    NSString *albumTitle = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.albumTitle;
    NSString *artistAlbumStr = [NSString stringWithFormat:@"%@ - %@",artistName, albumTitle];
    self.artistAlbumLabel.text = artistAlbumStr;
    
    int duration = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.duration;
    int secondTime = duration%60; //秒
    int minutTime = (duration/60)%60;  //分

    self.musicDurationLabel.text = [NSString stringWithFormat:@"%d:%d", minutTime,secondTime];
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 0.5;
}

@end
