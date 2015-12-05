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
        self.tableViewMode = TableViewModeArtist;
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
        
//        MPMediaQuery *query = [[MPMediaQuery alloc] init];
//        // アルバム単位でグルーピング
//        query.groupingType = MPMediaGroupingAlbum;
//        // アーティスト名を指定
//        [query addFilterPredicate:
//         [MPMediaPropertyPredicate predicateWithValue:self.musicDataEntity.artistName
//                                          forProperty:MPMediaItemPropertyArtist]];
//        // 全てのトラック数
//        self.musicDataEntity.allTrackNumber = 0;
//        // 指定したアーティストの全てのアルバムを取得。配列の要素は MPMediaItemCollection
//        for (MPMediaItemCollection *albumCollection in [query collections]) {
//            
//            NSString *albumTitle = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
//            MPMediaQuery *query = [[MPMediaQuery alloc] init];
//            // アーティスト名を指定
//            NSString *artistNameProperty = MPMediaItemPropertyAlbumArtist;
//            NSString *artistName = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumArtist];
//            if (!artistName) {
//                artistNameProperty = MPMediaItemPropertyArtist;
//            }
//            [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.musicDataEntity.artistName forProperty:artistNameProperty]];
//            // アルバム名を指定
//            [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:albumTitle forProperty:MPMediaItemPropertyAlbumTitle]];
//            // 条件に一致する曲を取得。配列の要素は MPMediaItem
//            NSArray *songs = [query items];
//            self.musicDataEntity.allTrackNumber = self.musicDataEntity.allTrackNumber + [songs count];
//            [self.musicDataEntity.musicDataDict setObject:songs forKey:albumTitle];
//        }
        
        // データ取得完了フラグ
        self.completeLoadData = YES;
    }
}

#pragma mark - アーティストデータの取得
- (void)acquisitionArtistData {
    
    MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
    artistsQuery.groupingType = MPMediaGroupingAlbumArtist;
    
    self.musicDataEntity.artistDataArray = [artistsQuery collections];
}

#pragma mark アーティストデータの操作
// 名前の読み込み
- (NSString *)loadArtistNameForArtistDataArraywithIndex:(NSInteger)row {
    
    NSString *artistName;
    if (self.musicDataEntity.artistDataArray) {
        MPMediaItemCollection *albumCollection = [self.musicDataEntity.artistDataArray objectAtIndex:row];
        artistName = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumArtist];
    }
    return artistName;
}

// アートワークの読み込み
- (UIImage *)loadArtistArtworkForArtistDataArraywithIndex:(NSInteger)row {
    
    // アートワークについてはアルバムのアートワークを取得する。
    // TODO: 実装見込み次第アーティストのアートワークを取得する
    UIImage *albumArtwork = [UIImage alloc];
    if (self.musicDataEntity.artistDataArray) {
        MPMediaItemCollection *albumCollection = [self.musicDataEntity.artistDataArray objectAtIndex:row];
        MPMediaItemArtwork *artwork = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyArtwork];
        albumArtwork = [artwork imageWithSize:artwork.bounds.size];
    }
    return albumArtwork;
}

#pragma mark - アルバムデータの取得
- (void)acquisitionAlbumDataWithArtistName:(NSString *)artistName {
    
    MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
    // アーティスト名を指定
    [albumsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:artistName forProperty:MPMediaItemPropertyAlbumArtist]];
    self.musicDataEntity.albumDataArray = [albumsQuery collections];
}

#pragma mark - アルバムデータの操作
// 名前の読み込み
- (NSString *)loadAlbumNameForArtistDataArraywithIndex:(NSInteger)row {
    
    NSString *albumName;
    if (self.musicDataEntity.artistDataArray) {
        // TODO: 曲一覧をスクロールしながら画面を戻るとここでクラッシュ(rowの値が配列のindexpathを超えてる)
        MPMediaItemCollection *albumCollection = [self.musicDataEntity.albumDataArray objectAtIndex:row];
        albumName = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
        if ([albumName isEqualToString:@""]) {
            albumName = kUnknownArtist;
        }
    }
    return albumName;
}

// アートワークの読み込み
- (UIImage *)loadAlbumArtworkForArtistDataArraywithIndex:(NSInteger)row {
    
    UIImage *albumArtwork = [UIImage alloc];
    if (self.musicDataEntity.albumDataArray) {
        MPMediaItemCollection *albumCollection = [self.musicDataEntity.albumDataArray objectAtIndex:row];
        MPMediaItemArtwork *artwork = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyArtwork];
        albumArtwork = [artwork imageWithSize:artwork.bounds.size];
    }
    return albumArtwork;
}

#pragma mark - 曲データの取得
- (void)acquisitionMusicDataWithAlbumName:(NSString *)albumName {
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    // アルバム名を指定
    [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:albumName forProperty:MPMediaItemPropertyAlbumTitle]];
    self.musicDataEntity.songsDataArray = [songsQuery collections];
}

#pragma mark - 曲データの操作
// 曲のタイトルの読み込み
- (NSString *)loadMusicNameForsongsDataArraywithIndex:(NSInteger)row {
    
    NSString *musicName;
    if (self.musicDataEntity.songsDataArray) {
        MPMediaItemCollection *musicCollection = [self.musicDataEntity.songsDataArray objectAtIndex:row];
        musicName = [[musicCollection representativeItem] valueForProperty:MPMediaItemPropertyTitle];
    }
    return musicName;
}

#pragma mark - その他
- (void)saveSelectedArtistName:(NSString *)artistName {
    
    self.musicDataEntity.selectedArtistName = artistName;
}

- (void)saveSelectedAlbumName:(NSString *)albumName {
    
    self.musicDataEntity.selectedAlbumName = albumName;
}

- (BOOL)isNowPlayingState {
    if([player playbackState] == MPMusicPlaybackStatePlaying){
        return YES;
    } else {
        return NO;
    }
}

#pragma mark 各操作ボタン押下時の処理
- (void)switchPlayStatus
{
    if([player playbackState] == MPMusicPlaybackStatePlaying){
        [player pause];
    } else {
        [player play];
    }
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
