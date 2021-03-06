//
//  PlaybackViewModel.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "PlaybackViewModel.h"

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
        // コンピレーションアルバムの対策で先にアーティストを見てからnilの場合はアルバムアーティストを見に行く。(実際に歌っているアーティスト名を取得したいため)
        NSString *artistName = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
        if (artistName == nil) {
            artistName = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
            if (artistName == nil) {
                artistName = kUnknownArtist;
            }
        }
        self.musicDataEntity.artistName = artistName;
        // トラックナンバー
        self.musicDataEntity.nowTrackNumber = [[mediaItem valueForProperty:MPMediaItemPropertyAlbumTrackNumber] unsignedIntegerValue];

        // アートワーク（ジャケット写真）
        MPMediaItemArtwork *artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(artwork.bounds.size.width, artwork.bounds.size.height)];
        self.musicDataEntity.artworkImage = artworkImage;
        
        // 総再生時間
        self.musicDataEntity.duration = [[mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];

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
    UIImage *albumArtwork = [UIImage alloc];
    if (self.musicDataEntity.artistDataArray) {
        MPMediaItemCollection *albumCollection = [self.musicDataEntity.artistDataArray objectAtIndex:row];
        MPMediaItemArtwork *artwork = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyArtwork];
        albumArtwork = [artwork imageWithSize:artwork.bounds.size];
    }
    return albumArtwork;
}

// アーティストのアルバム数の読み込み
- (NSString *)loadAlbumTrackCountForArtistDataArraywithIndex:(NSInteger)row {
    
    MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
    
    NSString *artistName = [self loadArtistNameForArtistDataArraywithIndex:row];
    // アーティスト名を指定
    [albumsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:artistName forProperty: MPMediaItemPropertyAlbumArtist]];
    return [NSString stringWithFormat:@"%lu",[[albumsQuery collections] count]];
}

#pragma mark - プレイリストデータの取得
- (void)acquisitionPlaylistData {
    
    MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
    
    self.musicDataEntity.playlistDataArray = [playlistsQuery collections];
}

#pragma mark プレイリストデータの操作
// 名前の読み込み
- (NSString *)loadPlaylistNameForPlaylistDataArraywithIndex:(NSInteger)row {
    
    NSString *playlistName;
    if (self.musicDataEntity.playlistDataArray) {
        MPMediaPlaylist *mediaPlaylist = [self.musicDataEntity.playlistDataArray objectAtIndex:row];
        playlistName = [mediaPlaylist valueForProperty:MPMediaPlaylistPropertyName];
    }
    return playlistName;
}

// アートワークの読み込み
- (UIImage *)loadPlaylistArtworkForPlaylistDataArraywithIndex:(NSInteger)row {
    
    UIImage *playlistArtwork = [UIImage alloc];
    if (self.musicDataEntity.playlistDataArray) {
        MPMediaItemCollection *albumCollection = [self.musicDataEntity.playlistDataArray objectAtIndex:row];
        MPMediaItemArtwork *artwork = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyArtwork];
        playlistArtwork = [artwork imageWithSize:artwork.bounds.size];
    }
    return playlistArtwork;
}

// プレイリストの曲数の読み込み
- (NSString *)loadSongsTrackCountForPlaylistDataArraywithIndex:(NSInteger)row {
    
    MPMediaQuery *playlistsSongsQuery = [MPMediaQuery songsQuery];
    
    NSString *playlistTitle = [self loadPlaylistNameForPlaylistDataArraywithIndex:row];
    // アルバム名を指定
    [playlistsSongsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:playlistTitle forProperty: MPMediaPlaylistPropertyName]];
    return [NSString stringWithFormat:@"%lu",[[playlistsSongsQuery collections] count]];
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
        MPMediaItemCollection *albumCollection = [self.musicDataEntity.albumDataArray objectAtIndex:row];
        albumName = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
        if ([albumName isEqualToString:@""]) {
            albumName = kUnknownAlbum;
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

// アルバムの曲数の読み込み
- (NSString *)loadSongsTrackCountForArtistDataArraywithIndex:(NSInteger)row {
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    
    NSString *albumTitle = [self loadAlbumNameForArtistDataArraywithIndex:row];
    // アルバム名を指定
    [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:albumTitle forProperty: MPMediaItemPropertyAlbumTitle]];
    return [NSString stringWithFormat:@"%lu",[[songsQuery collections] count]];
}

#pragma mark - 曲データの取得
- (void)acquisitionMusicDataWithAlbumName:(NSString *)albumName artistName:(NSString *)artistName {
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    // アルバム名を指定
    [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:albumName forProperty:MPMediaItemPropertyAlbumTitle]];
    [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:artistName forProperty:MPMediaItemPropertyAlbumArtist]];
    self.musicDataEntity.songsDataArray = [songsQuery items];
}

- (void)acquisitionMusicDataWithPlaylistName:(NSString *)playlistName {
    
    MPMediaQuery *playlistSongsQuery = [MPMediaQuery songsQuery];
    // プレイリスト名を指定
    [playlistSongsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:playlistName forProperty:MPMediaPlaylistPropertyName]];
    self.musicDataEntity.songsDataArray = [playlistSongsQuery items];
}

#pragma mark - 曲データの操作
// 曲のタイトルの読み込み
- (NSString *)loadMusicNameForsongsDataArraywithIndex:(NSInteger)row {
    
    NSString *musicName;
    if (self.musicDataEntity.songsDataArray) {
        MPMediaItemCollection *musicCollection = [self.musicDataEntity.songsDataArray objectAtIndex:row];
        musicName = [[musicCollection representativeItem] valueForProperty:MPMediaItemPropertyTitle];
        if ([musicName isEqualToString:@""]) {
            musicName = kUnknownTitle;
        }
    }
    return musicName;
}

// 曲の再生時間の読み込み
- (NSString *)loadMusicDurationForsongsDataArraywithIndex:(NSInteger)row {
    
    float musicDuration = 0;
    if (self.musicDataEntity.songsDataArray) {
        MPMediaItemCollection *musicCollection = [self.musicDataEntity.songsDataArray objectAtIndex:row];
        musicDuration = [[[musicCollection representativeItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
    }
    
    int duration = musicDuration;
    int secondTime = duration%60; //秒
    int minutTime = (duration/60)%60;  //分
    
    return [NSString stringWithFormat:@"%d:%02d", minutTime,secondTime];
}

- (NSTimeInterval)loadCurrentPlaybackTime {
    
    return player.currentPlaybackTime;
}

#pragma mark - その他
- (void)saveSelectedArtistName:(NSString *)artistName {
    
    self.musicDataEntity.selectedArtistName = artistName;
}

- (void)saveSelectedAlbumName:(NSString *)albumName {
    
    self.musicDataEntity.selectedAlbumName = albumName;
}

- (void)saveSelectedPlaylistName:(NSString *)playlistName {
    
    self.musicDataEntity.selectedPlaylistName = playlistName;
}

- (void)saveSelectedMode:(SelectedMode)selectedMode {
    
    self.musicDataEntity.selectedMode = selectedMode;
}

- (MPMusicPlaybackState)nowPlaybackState {
    
    return [player playbackState];
}

- (void)playSelectedMusicWithRow:(NSUInteger)row {
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    MPMediaItemCollection *albumCollection = [self.musicDataEntity.songsDataArray objectAtIndex:row];
    NSString *albumName = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];

    // アルバム名を指定
    [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:albumName forProperty:MPMediaItemPropertyAlbumTitle]];

    [player setQueueWithQuery:songsQuery];
    player.nowPlayingItem = songsQuery.items[row];
    [player play];
}

- (void)playSelectedMusicWithRowForPlaylist:(NSUInteger)row {
    
    MPMediaQuery *playlistSongsQuery = [MPMediaQuery songsQuery];
    NSString *playlistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.selectedPlaylistName;
    
    // プレイリスト名を指定
    [playlistSongsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:playlistName forProperty:MPMediaPlaylistPropertyName]];
    
    [player setQueueWithQuery:playlistSongsQuery];
    player.nowPlayingItem = playlistSongsQuery.items[row];
    [player play];
    
}

#pragma mark 各操作ボタン押下時の処理
- (void)switchPlayStatus {
    
    if([player playbackState] == MPMusicPlaybackStatePlaying){
        [player pause];
    } else if ([player playbackState] == MPMusicPlaybackStatePaused) {
        [player play];
    }
}

- (void)skipToPreviousMusic {
    
    [player skipToPreviousItem];
}

- (void)skipToNextMusic {
    
    [player skipToNextItem];
}
@end
