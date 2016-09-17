//
//  PlaybackViewModel.h
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicDataEntity.h"
#import <MediaPlayer/MediaPlayer.h>


typedef enum {
    TableViewModeArtist,
    TableViewModeAlbum,
    TableViewModeMusic
}TableViewMode;

@interface PlaybackViewModel : NSObject

@property BOOL completeLoadData;
@property TableViewMode tableViewMode;
@property MusicDataEntity *musicDataEntity;

// アーティストデータの取得
- (void)acquisitionArtistData;
// プレイリストデータの取得
- (void)acquisitionPlaylistData;
// アルバムデータの取得
- (void)acquisitionAlbumDataWithArtistName:(NSString *)artistName;
// 曲データの取得
- (void)acquisitionMusicDataWithAlbumName:(NSString *)albumName artistName:(NSString *)artistName;
// プレイリストの曲データ取得
- (void)acquisitionMusicDataWithPlaylistName:(NSString *)playlistName;
// アーティスト一覧配列からアーティスト名を取り出す
- (NSString *)loadArtistNameForArtistDataArraywithIndex:(NSInteger)row;
// アーティスト一覧配列からアーティストアートワークを取り出す
- (UIImage *)loadArtistArtworkForArtistDataArraywithIndex:(NSInteger)row;
// アーティスト一覧配列からアルバムのトラック数を取り出す
- (NSString *)loadAlbumTrackCountForArtistDataArraywithIndex:(NSInteger)row;
// プレイリスト一覧配列からプレイリスト名を取り出す
- (NSString *)loadPlaylistNameForPlaylistDataArraywithIndex:(NSInteger)row;
// プレイリスト一覧配列からプレイリストアートワークを取り出す
- (UIImage *)loadPlaylistArtworkForPlaylistDataArraywithIndex:(NSInteger)row;
// プレイリスト一覧配列から曲数を取り出す
- (NSString *)loadSongsTrackCountForPlaylistDataArraywithIndex:(NSInteger)row;
// アルバム一覧配列からアルバム名を取り出す
- (NSString *)loadAlbumNameForArtistDataArraywithIndex:(NSInteger)row;
// アルバム一覧配列からアルバムアートワークを取り出す
- (UIImage *)loadAlbumArtworkForArtistDataArraywithIndex:(NSInteger)row;
// アルバム一覧配列から曲数を取り出す
- (NSString *)loadSongsTrackCountForArtistDataArraywithIndex:(NSInteger)row;
// 曲一覧配列から曲のタイトルの読み込み
- (NSString *)loadMusicNameForsongsDataArraywithIndex:(NSInteger)row;
// 曲一覧配列から曲の再生時間の読み込み
- (NSString *)loadMusicDurationForsongsDataArraywithIndex:(NSInteger)row;
// 曲の現在の再生時間の読み込み
- (NSTimeInterval)loadCurrentPlaybackTime;

// 選択したアーティストの名前を保持しておく(画面遷移後に保持したアーティストの名前でアルバムを検索するため)
- (void)saveSelectedArtistName:(NSString *)artistName;
// 選択したアルバムの名前を保持しておく(画面遷移後に保持したアルバムの名前で曲を検索するため)
- (void)saveSelectedAlbumName:(NSString *)albumName;
// 選択したプレイリストの名前を保持しておく(画面遷移後に保持したプレイリストの名前で曲を検索するため)
- (void)saveSelectedPlaylistName:(NSString *)playlistName;
// 選択したモードを保持しておく(画面遷移後に保持したモードで表示を切り替えるため)
- (void)saveSelectedMode:(SelectedMode)selectedMode;
// 現在再生中かどうか
- (MPMusicPlaybackState)nowPlaybackState;
// 指定された曲を再生
- (void)playSelectedMusicWithRow:(NSUInteger)row;
// 指定された曲を再生（プレイリスト）
- (void)playSelectedMusicWithRowForPlaylist:(NSUInteger)row;

- (void)loadMusicPlayerData;
- (void)switchPlayStatus;
- (void)skipToPreviousMusic;
- (void)skipToNextMusic;
@end
