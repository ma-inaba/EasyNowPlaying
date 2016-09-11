//
//  PlaylistDataTableView.m
//  EasyNowPlaying
//
//  Created by InabaMasaya on 2016/09/11.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import "PlaylistDataTableView.h"
#import "AllMusicDataTableViewPlaylistCell.h"

@implementation PlaylistDataTableView

- (void)awakeFromNib {
    
    self.dataSource = self;
    
    UINib *playlistCellNib = [UINib nibWithNibName:kMusicDataTablePlaylistCell bundle:nil];
    [self registerNib:playlistCellNib forCellReuseIdentifier:kMusicDataTablePlaylistCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.playlistDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewPlaylistCell *cell = [self allMusicDataTableViewPlaylistCell:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (AllMusicDataTableViewPlaylistCell *)allMusicDataTableViewPlaylistCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicDataTablePlaylistCell];
    
    if (!cell) {
        cell = [[AllMusicDataTableViewPlaylistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMusicDataTablePlaylistCell];
    }
    
    cell.playlistNameLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadPlaylistNameForPlaylistDataArraywithIndex:indexPath.row];
    cell.playlistNameLabel.textColor = kDefaultTextColor;
    cell.playlistNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];

    UIImage *artwork = [[ModelLocator sharedInstance].playbackViewModel loadPlaylistArtworkForPlaylistDataArraywithIndex:indexPath.row];
    if (artwork == nil) {
        artwork = [UIImage imageNamed:@"NonArtwork"];
    }
    cell.playlistImageView.image = artwork;
    
    NSString *songsTrack = [[ModelLocator sharedInstance].playbackViewModel loadSongsTrackCountForPlaylistDataArraywithIndex:indexPath.row];
    cell.songsTrackLabel.text = [NSString stringWithFormat:@"%@曲",songsTrack];
    cell.songsTrackLabel.textColor = [UIColor lightGrayColor];
    cell.songsTrackLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    
    return cell;
}
@end
