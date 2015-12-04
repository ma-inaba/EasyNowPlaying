//
//  MusicDataEntity.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "MusicDataEntity.h"

@implementation MusicDataEntity

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.artistDataArray = [NSMutableArray array];
    }
    return self;
}

@end
