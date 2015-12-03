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
        // アルバムアーティストにするとコンピレーションと違うやつを混合できる
        self.musicDataEntity.artistName = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
        // トラックナンバー
        self.musicDataEntity.nowTrackNumber = [[mediaItem valueForProperty:MPMediaItemPropertyAlbumTrackNumber] unsignedIntegerValue];

        // アートワーク（ジャケット写真）
        MPMediaItemArtwork *artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(artwork.bounds.size.width, artwork.bounds.size.height)];
        self.musicDataEntity.artworkImage = artworkImage;
        
        // 再生時間
        self.musicDataEntity.duration = [[mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
     
//        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
//        [albumsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.musicDataEntity.artistName forProperty:MPMediaItemPropertyArtist]];
//        NSArray *albums = [albumsQuery collections];
//        for (MPMediaItemCollection *artistCollection in artists) {
//            NSString *artistName = [[artistCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist];
//            if ([artistName isEqualToString:self.musicDataEntity.artistName]) {
//                self.musicDataEntity.artistSongs = artistCollection.items;
//            }
//        }
        
//        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
//        // アーティスト名を指定
//        [albumsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.musicDataEntity.artistName forProperty:MPMediaItemPropertyArtist]];
//        // 条件に一致する曲を取得。配列の要素は MPMediaItem
//        self.musicDataEntity.artistSongs = [albumsQuery items];
        
        MPMediaQuery *query = [[MPMediaQuery alloc] init];
        // アルバム単位でグルーピング
        query.groupingType = MPMediaGroupingAlbum;
        // アーティスト名を指定
        [query addFilterPredicate:
         [MPMediaPropertyPredicate predicateWithValue:self.musicDataEntity.artistName
                                          forProperty:MPMediaItemPropertyArtist]];
        // 全てのトラック数
        self.musicDataEntity.allTrackNumber = 0;
        // 指定したアーティストの全てのアルバムを取得。配列の要素は MPMediaItemCollection
        for (MPMediaItemCollection *albumCollection in [query collections]) {
            
            NSString *albumTitle = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
            MPMediaQuery *query = [[MPMediaQuery alloc] init];
            // アーティスト名を指定
            NSString *artistNameProperty = MPMediaItemPropertyAlbumArtist;
            NSString *artistName = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumArtist];
            if (!artistName) {
                artistNameProperty = MPMediaItemPropertyArtist;
            }
            [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.musicDataEntity.artistName forProperty:artistNameProperty]];
            // アルバム名を指定
            [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:albumTitle forProperty:MPMediaItemPropertyAlbumTitle]];
            // 条件に一致する曲を取得。配列の要素は MPMediaItem
            NSArray *songs = [query items];
            self.musicDataEntity.allTrackNumber = self.musicDataEntity.allTrackNumber + [songs count];
            [self.musicDataEntity.musicDataDict setObject:songs forKey:albumTitle];
        }
        
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
