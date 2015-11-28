//
//  MusicDataEntity.h
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MusicDataEntity : NSObject

// アートワーク
@property UIImage *artworkImage;
// アートワークから取得した使用されている色
@property UIColor *backgroundColor;
@property UIColor *primaryTextColor;
@property UIColor *secondaryTextColor;

// 曲情報
@property (nonatomic, strong) NSString *musicTitle;
@property (nonatomic, strong) NSString *albumTitle;
@property (nonatomic, strong) NSString *artistName;
@property NSUInteger nowTrackNumber;
@property NSUInteger allTrackNumber;
@property float duration;   // 再生時間

@end
