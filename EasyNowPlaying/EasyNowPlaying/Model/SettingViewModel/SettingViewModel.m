//
//  SettingViewModel.m
//  EasyNowPlaying
//
//  Created by InabaMasaya on 2016/09/10.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import "SettingViewModel.h"


@implementation SettingViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.settingDataEntity = [[SettingDataEntity alloc] init];
    }
    return self;
}

@end
