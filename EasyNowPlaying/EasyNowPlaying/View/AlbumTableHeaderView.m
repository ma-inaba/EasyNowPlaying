//
//  AlbumTableHeaderView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/03.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "AlbumTableHeaderView.h"
#import "ModelLocator.h"

@interface AlbumTableHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *artistAndTrackCountLabel;
@end

@implementation AlbumTableHeaderView

- (void)drawRect:(CGRect)rect {

    NSString *artistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artistName;
    NSString *text = [NSString stringWithFormat:@"%@ - %lu曲",artistName, (unsigned long)[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.allTrackNumber];
    self.artistAndTrackCountLabel.text = text;
    
    self.layer.shadowOffset = CGSizeMake(0, -5);
    self.layer.shadowOpacity = 0.5;
}

@end
