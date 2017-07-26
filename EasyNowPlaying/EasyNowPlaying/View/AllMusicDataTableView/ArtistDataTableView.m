//
//  ArtistDataTableView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "ArtistDataTableView.h"
#import "AllMusicDataTableViewArtistCell.h"

@implementation ArtistDataTableView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.dataSource = self;
    
    UINib *artistCellNib = [UINib nibWithNibName:kMusicDataTableArtistCell bundle:nil];
    [self registerNib:artistCellNib forCellReuseIdentifier:kMusicDataTableArtistCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artistDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewArtistCell *cell = [self allMusicDataTableViewArtistCell:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (AllMusicDataTableViewArtistCell *)allMusicDataTableViewArtistCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicDataTableArtistCell];
    
    if (!cell) {
        cell = [[AllMusicDataTableViewArtistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMusicDataTableArtistCell];
    }
    
    cell.artistNameLabel.text = [[ModelLocator sharedInstance].playbackViewModel loadArtistNameForArtistDataArraywithIndex:indexPath.row];
    cell.artistNameLabel.textColor = kDefaultTextColor;
    cell.artistNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    UIImage *artwork = [[ModelLocator sharedInstance].playbackViewModel loadArtistArtworkForArtistDataArraywithIndex:indexPath.row];
    
    if (artwork == nil) {
        artwork = [UIImage imageNamed:@"NonArtwork"];
    }
    cell.artistImageView.image = artwork;
    
    NSString *albumTrack = [[ModelLocator sharedInstance].playbackViewModel loadAlbumTrackCountForArtistDataArraywithIndex:indexPath.row];
    cell.albumTrackLabel.text = [NSString stringWithFormat:@"%@枚のアルバム",albumTrack];
    cell.albumTrackLabel.textColor = [UIColor lightGrayColor];
    cell.albumTrackLabel.font = [UIFont boldSystemFontOfSize:9.0f];

    return cell;
}

@end
