//
//  MusicDataTableView.m
//  EasyNowPlaying
//
//  Created by Masaya on 2016/04/16.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import "MusicDataTableView.h"
#import "AllMusicDataTableViewMusicCell.h"

@implementation MusicDataTableView

- (void)awakeFromNib {
    
    self.dataSource = self;
    
    UINib *musicCellNib = [UINib nibWithNibName:kMusicDataTableMusicCell bundle:nil];
    [self registerNib:musicCellNib forCellReuseIdentifier:kMusicDataTableMusicCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.songsDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicDataTableViewMusicCell *cell = [self allMusicDataTableViewMusicCell:tableView cellForRowAtIndexPath:indexPath];
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