//
//  AllMusicDataTableBaseView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/04.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "AllMusicDataTableBaseView.h"

@implementation AllMusicDataTableBaseView

- (void)drawRect:(CGRect)rect {
    
    self.layer.shadowOffset = CGSizeMake(0, -5);
    self.layer.shadowOpacity = 0.5;
}

@end
