//
//  PlaybackViewModel.h
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicDataEntity.h"

@interface PlaybackViewModel : NSObject

@property BOOL completeLoadData;
@property MusicDataEntity *musicDataEntity;

- (void)loadMusicPlayerData;
- (void)switchPlayStatus;
- (void)skipToPreviousMusic;
- (void)skipToNextMusic;
@end
