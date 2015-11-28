//
//  ModelLocator.h
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaybackViewModel.h"

@interface ModelLocator : NSObject

+ (ModelLocator *)sharedInstance;
- (id)init UNAVAILABLE_ATTRIBUTE;

@property PlaybackViewModel *playbackViewModel;

@end
