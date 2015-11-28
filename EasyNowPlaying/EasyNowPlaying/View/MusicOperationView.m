//
//  MusicOperationView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "MusicOperationView.h"
#import "ModelLocator.h"

@interface MusicOperationView ()
@property (weak, nonatomic) IBOutlet UILabel *artistAlbumLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;

@end

@implementation MusicOperationView

- (void)reloadViewData {

    UIColor* backgroundColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.backgroundColor;
    UIColor* primaryTextColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;
    NSString *musicTitle = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.musicTitle;
    NSString *albumTitle = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.albumTitle;
    NSString *artistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artistName;
    NSString *albumAndArtistStr = [NSString stringWithFormat:@"%@ - %@",artistName,albumTitle];
    
    [self setBackgroundColor:backgroundColor];
    [self.artistAlbumLabel setTextColor:primaryTextColor];
    [self.musicTitleLabel setTextColor:primaryTextColor];
    
    [self.musicTitleLabel setText:musicTitle];
    [self.artistAlbumLabel setText:albumAndArtistStr];
    

}


@end
