//
//  PlaybackViewModel.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "PlaybackViewModel.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation PlaybackViewModel
{
    MPMusicPlayerController *player;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.musicDataEntity = [[MusicDataEntity alloc] init];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        player = [MPMusicPlayerController systemMusicPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNowPlayingItemChanged:)
                                                     name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                   object:player];
    }
    return self;
}

- (void)loadMusicPlayerData {
    
    [player endGeneratingPlaybackNotifications];
    [player beginGeneratingPlaybackNotifications];
}

- (void)onNowPlayingItemChanged:(NSNotification*)ntf {
    
    self.completeLoadData = NO;

    MPMediaItem *mediaItem = [player nowPlayingItem];
    NSInteger mediaType = [[mediaItem valueForProperty:MPMediaItemPropertyMediaType] integerValue];
    if (mediaType == MPMediaTypeMusic) {
        // 曲名
        self.musicDataEntity.musicTitle = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
        // アルバム名
        self.musicDataEntity.albumTitle = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        // アーティスト名
        self.musicDataEntity.artistName = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
        // トラックナンバー
        self.musicDataEntity.nowTrackNumber = [[mediaItem valueForProperty:MPMediaItemPropertyAlbumTrackNumber] unsignedIntegerValue];
        // 全てのトラック数
//        self.musicDataEntity.allTrackNumber = [[mediaItem valueForProperty:MPMediaItemPropertyAlbumTrackCount] unsignedIntegerValue];

        // アートワーク（ジャケット写真）
        MPMediaItemArtwork *artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(artwork.bounds.size.width, artwork.bounds.size.height)];
        self.musicDataEntity.artworkImage = artworkImage;
        
        // 再生時間
        self.musicDataEntity.duration = [[mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
     
//        MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
//        NSArray *artists = [artistsQuery collections];
//        for (MPMediaItemCollection *artistCollection in artists) {
//            NSString *artistName = [[artistCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist];
//            if ([artistName isEqualToString:self.musicDataEntity.artistName]) {
//                self.musicDataEntity.artistSongs = artistCollection.items;
//            }
//        }
        MPMediaQuery *query = [[MPMediaQuery alloc] init];
        
        // アーティスト名を指定
        [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.musicDataEntity.artistName forProperty:MPMediaItemPropertyArtist]];
        // 条件に一致する曲を取得。配列の要素は MPMediaItem
        self.musicDataEntity.artistSongs = [query items];
        
        // データ取得完了フラグ
        self.completeLoadData = YES;
    }
}

- (void)switchPlayStatus
{
    if( [player playbackState] == MPMusicPlaybackStatePlaying ){
        [player pause];
    }
    else{
        [player play];
    }
    
    // TODO: 戻り値で変更後のステータスを返してボタンのデザインを変更する
}

- (void)skipToPreviousMusic
{
    [player skipToPreviousItem];
}

- (void)skipToNextMusic
{
    [player skipToNextItem];
}
@end
