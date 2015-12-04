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
#import "AllMusicDataTableViewMusicCell.h"

@implementation AllMusicDataTableView

- (void)awakeFromNib {
    
    self.delegate = self;
    self.dataSource = self;
    
    UINib *musicCellNib = [UINib nibWithNibName:@"AllMusicDataTableViewMusicCell" bundle:nil];
    [self registerNib:musicCellNib forCellReuseIdentifier:@"AllMusicDataTableViewMusicCell"];
    UINib *artistCellNib = [UINib nibWithNibName:@"AllMusicDataTableViewArtistCell" bundle:nil];
    [self registerNib:artistCellNib forCellReuseIdentifier:@"AllMusicDataTableViewArtistCell"];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([ModelLocator sharedInstance].playbackViewModel.tableViewMode == TableViewModeArtist) {
        return 65.0f;
    }
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artistDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([ModelLocator sharedInstance].playbackViewModel.tableViewMode == TableViewModeArtist) {
        AllMusicDataTableViewArtistCell *cell = [self allMusicDataTableViewArtistCell:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else if ([ModelLocator sharedInstance].playbackViewModel.tableViewMode == TableViewModeAlbum) {
        AllMusicDataTableViewMusicCell *cell = [self allMusicDataTableViewMusicCell:tableView cellForRowAtIndexPath:indexPath];
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
    cell.artistNameLabel.textColor = [UIColor whiteColor];
    cell.artistNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    cell.artistImageView.image = [[ModelLocator sharedInstance].playbackViewModel loadArtistArtworkForArtistDataArraywithIndex:indexPath.row];

    return cell;
}

- (AllMusicDataTableViewMusicCell *)allMusicDataTableViewMusicCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllMusicDataTableViewMusicCell"];
    
    if (!cell) {
        cell = [[AllMusicDataTableViewMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllMusicDataTableViewMusicCell"];
    }
    
    cell.musicNoLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    cell.musicNoLabel.textColor = [UIColor whiteColor];
    
    cell.musicTitleLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadArtistNameForArtistDataArraywithIndex:indexPath.row];
    cell.musicTitleLabel.textColor = [UIColor whiteColor];
    cell.musicTitleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    cell.musicDurationLabel.text = @"5:21";
    cell.musicDurationLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];    
    
    return cell;
}

@end
