//
//  Define.h
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/05.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#ifndef Define_h
#define Define_h


#endif /* Define_h */

// 汎用
#define kOK @"OK"
#define kCancel @"キャンセル"
#define kArtist @"アーティスト"
#define kAlbum @"アルバム"
#define kMusic @"ミュージック"
#define kUnknownTitle @"不明なタイトル"
#define kUnknownArtist @"不明なアーティスト"
#define kUnknownAlbum @"不明なアルバム"
#define kPostDefaultTag @"#nowplaying"
#define kPostNPbotTag @"#NPbot"
#define kDefaultTextColor [UIColor colorWithRed:0.98 green:0.99 blue:0.91 alpha:1.0];

// ユーザーデフォルト
#define kPostTagKey @"PostTagKey"
#define kPostImageKey @"PostImageKey"
#define kAddAppTag @"AddAppTag"

// 音楽表示ビュー
#define kNotPlayMusicNow @"ミュージックを再生したらここに表示されます"

// 画像のファイル名
#define kPause @"Pause"
#define kPlay @"Play"

// KVO監視しているプロパティ
#define kArtistDataArray @"artistDataArray"
#define kAlbumDataArray @"albumDataArray"
#define kSongsDataArray @"songsDataArray"
#define kCompleteLoadData @"completeLoadData"

// 設定テーブルのヘッダー
#define kSettingTableHeaderTag @"Tag"
#define kSettingTableHeaderArtwork @"Artwork"
#define kSettingTableHeaderFormat @"Format"
#define kSettingTableHeaderCreator @"Creator"

// 設定テーブルのセル
#define kSettingTableViewTagCell @"SettingTableViewTagCell"
#define kSettingTableViewAppNameTagCell @"SettingTableViewAppNameTagCell"
#define kSettingTableViewFormatCell @"SettingTableViewFormatCell"
#define kSettingTableViewImageCell @"SettingTableViewImageCell"
#define kSettingTableViewProfileCell @"SettingTableViewProfileCell"
#define kSettingTableViewMessageCell @"SettingTableViewMessageCell"

// 設定テーブル内のフォーマットコレクションビューのセル
#define kFormatCollectionViewCell @"FormatCollectionViewCell"

// 設定テーブルのアラート
#define kSettingTableViewAlertTitle @"タグ"
#define kSettingTableViewAlertMessage @"タグの定型文を登録できます"
#define kSettingTableViewAlertPlaceholder @"タグを入力"

// 音楽データテーブルのセル
#define kMusicDataTableArtistCell @"AllMusicDataTableViewArtistCell"
#define kMusicDataTableAlbumCell @"AllMusicDataTableViewAlbumCell"
#define kMusicDataTableMusicCell @"AllMusicDataTableViewMusicCell"