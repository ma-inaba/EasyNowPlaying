//
//  AllMusicDataTableView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "AllMusicDataTableView.h"
#import "ModelLocator.h"
#import "AllMusicDataTableViewArtistCell.h"
#import "AllMusicDataTableViewAlbumCell.h"
#import "AllMusicDataTableViewMusicCell.h"

@implementation AllMusicDataTableView

- (void)awakeFromNib {
    
    self.dataSource = self;
    
    UINib *artistCellNib = [UINib nibWithNibName:@"AllMusicDataTableViewArtistCell" bundle:nil];
    [self registerNib:artistCellNib forCellReuseIdentifier:@"AllMusicDataTableViewArtistCell"];
    UINib *albumCellNib = [UINib nibWithNibName:@"AllMusicDataTableViewAlbumCell" bundle:nil];
    [self registerNib:albumCellNib forCellReuseIdentifier:@"AllMusicDataTableViewAlbumCell"];
    UINib *musicCellNib = [UINib nibWithNibName:@"AllMusicDataTableViewMusicCell" bundle:nil];
    [self registerNib:musicCellNib forCellReuseIdentifier:@"AllMusicDataTableViewMusicCell"];
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
    
    AllMusicDataTableViewArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllMusicDataTableViewArtistCell"];
    
    if (!cell) {
        cell = [[AllMusicDataTableViewArtistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllMusicDataTableViewArtistCell"];
    }
    
    cell.artistNameLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadArtistNameForArtistDataArraywithIndex:indexPath.row];
    cell.artistNameLabel.textColor = [UIColor colorWithRed:0.98 green:0.99 blue:0.91 alpha:1.0];
    cell.artistNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    cell.artistImageView.image = [[ModelLocator sharedInstance].playbackViewModel loadArtistArtworkForArtistDataArraywithIndex:indexPath.row];

    return cell;
}

- (AllMusicDataTableViewAlbumCell *)allMusicDataTableViewAlbumCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllMusicDataTableViewAlbumCell"];
    
    if (!cell) {
        cell = [[AllMusicDataTableViewAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllMusicDataTableViewAlbumCell"];
    }
    
    cell.albumNameLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadAlbumNameForArtistDataArraywithIndex:indexPath.row];
    cell.albumNameLabel.textColor = [UIColor colorWithRed:0.98 green:0.99 blue:0.91 alpha:1.0];
    cell.albumNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    cell.albumImageView.image = [[ModelLocator sharedInstance].playbackViewModel loadAlbumArtworkForArtistDataArraywithIndex:indexPath.row];
    
    return cell;
}

- (AllMusicDataTableViewMusicCell *)allMusicDataTableViewMusicCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllMusicDataTableViewMusicCell"];
    
    if (!cell) {
        cell = [[AllMusicDataTableViewMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllMusicDataTableViewMusicCell"];
    }
    
    cell.musicNoLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    cell.musicNoLabel.textColor = [UIColor whiteColor];
    
    cell.musicTitleLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadMusicNameForsongsDataArraywithIndex:indexPath.row];
    cell.musicTitleLabel.textColor = [UIColor whiteColor];
    cell.musicTitleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    cell.musicDurationLabel.text = @"5:21";
    cell.musicDurationLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];    
    
    return cell;
}

@end
