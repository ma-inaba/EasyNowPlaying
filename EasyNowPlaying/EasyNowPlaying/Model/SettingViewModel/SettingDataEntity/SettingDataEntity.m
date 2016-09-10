//
//  SettingDataEntity.m
//  EasyNowPlaying
//
//  Created by InabaMasaya on 2016/09/10.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import "SettingDataEntity.h"

@implementation SettingDataEntity

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.formatStrArray = [NSMutableArray array];
    }
    return self;
}

@end
