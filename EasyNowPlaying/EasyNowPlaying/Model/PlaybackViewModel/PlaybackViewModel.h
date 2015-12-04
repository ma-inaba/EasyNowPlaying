//
//  PlaybackViewModel.h
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicDataEntity.h"

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
// アルバムデータの取得
- (void)acquisitionAlbumDataWithArtistName:(NSString *)artistName;

// アーティスト一覧配列からアーティスト名を取り出す
- (NSString *)loadArtistNameForArtistDataArraywithIndex:(NSInteger)row;
// アーティスト一覧配列からアーティストアートワークを取り出す
- (UIImage *)loadArtistArtworkForArtistDataArraywithIndex:(NSInteger)row;
// アルバム一覧配列からアルバム名を取り出す
- (NSString *)loadAlbumNameForArtistDataArraywithIndex:(NSInteger)row;
// アルバム一覧配列からアルバムアートワークを取り出す
- (UIImage *)loadAlbumArtworkForArtistDataArraywithIndex:(NSInteger)row;



// 選択したアーティストの名前を保持しておく(画面遷移後に保持したアーティストの名前でアルバムを検索するため)
- (void)saveSelectedArtistName:(NSString *)artistName;

- (void)loadMusicPlayerData;
- (void)switchPlayStatus;
- (void)skipToPreviousMusic;
- (void)skipToNextMusic;
@end
