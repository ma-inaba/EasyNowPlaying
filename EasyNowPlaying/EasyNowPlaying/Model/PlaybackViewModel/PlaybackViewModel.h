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

// アーティスト一覧配列からアーティスト名を取り出す
- (NSString *)loadArtistNameForArtistDataArraywithIndex:(NSInteger)row;
// アーティスト一覧配列からアーティストアートワークを取り出す
- (UIImage *)loadArtistArtworkForArtistDataArraywithIndex:(NSInteger)row;

- (void)loadMusicPlayerData;
- (void)switchPlayStatus;
- (void)skipToPreviousMusic;
- (void)skipToNextMusic;
@end
