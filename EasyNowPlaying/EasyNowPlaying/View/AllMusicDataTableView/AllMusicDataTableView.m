//
//  AllMusicDataTableView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "AllMusicDataTableView.h"
#import "AllMusicDataTableViewArtistCell.h"
#import "AllMusicDataTableViewAlbumCell.h"
#import "AllMusicDataTableViewMusicCell.h"

@implementation AllMusicDataTableView

- (void)awakeFromNib {
    
    self.dataSource = self;
    
    UINib *artistCellNib = [UINib nibWithNibName:kMusicDataTableArtistCell bundle:nil];
    [self registerNib:artistCellNib forCellReuseIdentifier:kMusicDataTableArtistCell];
    UINib *albumCellNib = [UINib nibWithNibName:kMusicDataTableAlbumCell bundle:nil];
    [self registerNib:albumCellNib forCellReuseIdentifier:kMusicDataTableAlbumCell];
    UINib *musicCellNib = [UINib nibWithNibName:kMusicDataTableMusicCell bundle:nil];
    [self registerNib:musicCellNib forCellReuseIdentifier:kMusicDataTableMusicCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([ModelLocator sharedInstance].playbackViewModel.tableViewMode == TableViewModeArtist) {
        return [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artistDataArray count];
    } else if ([ModelLocator sharedInstance].playbackViewModel.tableViewMode == TableViewModeAlbum) {
        return [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.albumDataArray count];
    } else {
        return [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.songsDataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([ModelLocator sharedInstance].playbackViewModel.tableViewMode == TableViewModeArtist) {
        AllMusicDataTableViewArtistCell *cell = [self allMusicDataTableViewArtistCell:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else if ([ModelLocator sharedInstance].playbackViewModel.tableViewMode == TableViewModeAlbum) {
        AllMusicDataTableViewAlbumCell *cell = [self allMusicDataTableViewAlbumCell:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else {
        AllMusicDataTableViewMusicCell *cell = [self allMusicDataTableViewMusicCell:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
}

- (AllMusicDataTableViewArtistCell *)allMusicDataTableViewArtistCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicDataTableArtistCell];
    
    if (!cell) {
        cell = [[AllMusicDataTableViewArtistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMusicDataTableArtistCell];
    }
    
    cell.artistNameLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadArtistNameForArtistDataArraywithIndex:indexPath.row];
    cell.artistNameLabel.textColor = kDefaultTextColor;
    cell.artistNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    cell.artistImageView.image = [[ModelLocator sharedInstance].playbackViewModel loadArtistArtworkForArtistDataArraywithIndex:indexPath.row];
    
    NSString *albumTrack = [[ModelLocator sharedInstance].playbackViewModel loadAlbumTrackCountForArtistDataArraywithIndex:indexPath.row];
    cell.albumTrackLabel.text = [NSString stringWithFormat:@"%@枚のアルバム",albumTrack];
    cell.albumTrackLabel.textColor = [UIColor lightGrayColor];
    cell.albumTrackLabel.font = [UIFont boldSystemFontOfSize:9.0f];

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
    
    cell.albumImageView.image = [[ModelLocator sharedInstance].playbackViewModel loadAlbumArtworkForArtistDataArraywithIndex:indexPath.row];
    
    NSString *songsTrack = [[ModelLocator sharedInstance].playbackViewModel loadSongsTrackCountForArtistDataArraywithIndex:indexPath.row];
    cell.songsTrackLabel.text = [NSString stringWithFormat:@"%@曲",songsTrack];
    cell.songsTrackLabel.textColor = [UIColor lightGrayColor];
    cell.songsTrackLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    
    return cell;
}

- (AllMusicDataTableViewMusicCell *)allMusicDataTableViewMusicCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicDataTableMusicCell];
    
    if (!cell) {
        cell = [[AllMusicDataTableViewMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMusicDataTableMusicCell];
    }
    
    cell.musicNoLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    cell.musicNoLabel.textColor = kDefaultTextColor;
    
    cell.musicTitleLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadMusicNameForsongsDataArraywithIndex:indexPath.row];
    cell.musicTitleLabel.textColor = kDefaultTextColor;
    cell.musicTitleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    cell.musicDurationLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadMusicDurationForsongsDataArraywithIndex:indexPath.row];
    cell.musicDurationLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];    
    
    return cell;
}

@end
