//
//  AlbumDataTableView.m
//  EasyNowPlaying
//
//  Created by Masaya on 2016/04/16.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import "AlbumDataTableView.h"
#import "AllMusicDataTableViewAlbumCell.h"

@implementation AlbumDataTableView

- (void)awakeFromNib {
    
    self.dataSource = self;
    
    UINib *albumCellNib = [UINib nibWithNibName:kMusicDataTableAlbumCell bundle:nil];
    [self registerNib:albumCellNib forCellReuseIdentifier:kMusicDataTableAlbumCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.albumDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewAlbumCell *cell = [self allMusicDataTableViewAlbumCell:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (AllMusicDataTableViewAlbumCell *)allMusicDataTableViewAlbumCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicDataTableAlbumCell];
    
    if (!cell) {
        cell = [[AllMusicDataTableViewAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMusicDataTableAlbumCell];
    }
    
    cell.albumNameLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadAlbumNameForArtistDataArraywithIndex:indexPath.row];
    cell.albumNameLabel.textColor = kDefaultTextColor;
    cell.albumNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    UIImage *artwork = [[ModelLocator sharedInstance].playbackViewModel loadAlbumArtworkForArtistDataArraywithIndex:indexPath.row];
    if (artwork == nil) {
            // TODO: artworkに画像ない人用の画像をいれる
    }
    cell.albumImageView.image = [[ModelLocator sharedInstance].playbackViewModel loadAlbumArtworkForArtistDataArraywithIndex:indexPath.row];
    
    NSString *songsTrack = [[ModelLocator sharedInstance].playbackViewModel loadSongsTrackCountForArtistDataArraywithIndex:indexPath.row];
    cell.songsTrackLabel.text = [NSString stringWithFormat:@"%@曲",songsTrack];
    cell.songsTrackLabel.textColor = [UIColor lightGrayColor];
    cell.songsTrackLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    
    return cell;
}

@end