//
//  SettingTableView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "MusicTableView.h"
#import "HeadCell.h"
#import "TweetTagCell.h"
#import "MusicDataCell.h"
#import "ChoiceAddImageCell.h"
#import "ModelLocator.h"

static const CGFloat kDefaultCellHeight = 46.0f;     // セルの高さ

@implementation MusicTableView

- (void)awakeFromNib {
    
    self.delegate = self;
    self.dataSource = self;
    
    UINib *headCellNib = [UINib nibWithNibName:@"HeadCell" bundle:nil];
    [self registerNib:headCellNib forCellReuseIdentifier:@"HeadCell"];
    UINib *tweetTagCell = [UINib nibWithNibName:@"TweetTagCell" bundle:nil];
    [self registerNib:tweetTagCell forCellReuseIdentifier:@"TweetTagCell"];
    UINib *choiceAddImageCell = [UINib nibWithNibName:@"ChoiceAddImageCell" bundle:nil];
    [self registerNib:choiceAddImageCell forCellReuseIdentifier:@"ChoiceAddImageCell"];
    UINib *musicDataCell = [UINib nibWithNibName:@"MusicDataCell" bundle:nil];
    [self registerNib:musicDataCell forCellReuseIdentifier:@"MusicDataCell"];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height;
    if (indexPath.row == 3) {
        height = self.frame.size.height - kDefaultCellHeight - kDefaultCellHeight - kDefaultCellHeight;
    } else {
        height = kDefaultCellHeight;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        HeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell"];
        headCell.tweetButton.tintColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;
        return headCell;
    } else if (indexPath.row == 1){
        TweetTagCell *tweetTagCell = [tableView dequeueReusableCellWithIdentifier:@"TweetTagCell"];
        tweetTagCell.tagLabel.text = @"#nowplaying";
        tweetTagCell.tagLabel.textColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;
        return tweetTagCell;
    } else if (indexPath.row == 2) {
        ChoiceAddImageCell *choiceAddImageCell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceAddImageCell"];
        choiceAddImageCell.postArtworkLabel.text = @"Post Artwork";
        choiceAddImageCell.postArtworkLabel.textColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;
        choiceAddImageCell.postArtworkSwitch.onTintColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;
        return choiceAddImageCell;
    } else {
        MusicDataCell *musicDataCell = [tableView dequeueReusableCellWithIdentifier:@"MusicDataCell"];
        musicDataCell.artistNameLabel.text = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artistName;
        musicDataCell.artistNameLabel.textColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;
        musicDataCell.albumNameLabel.text = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.albumTitle;
        musicDataCell.albumNameLabel.textColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;
        
        NSUInteger nowTrack = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.nowTrackNumber;
        NSUInteger allTrack = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.allTrackNumber;
        NSString *track = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)nowTrack, (unsigned long)allTrack];
        musicDataCell.trackNumberLabel.text = track;
        musicDataCell.trackNumberLabel.textColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;
        musicDataCell.musicTitleLabel.text = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.musicTitle;
        musicDataCell.musicTitleLabel.textColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;

        musicDataCell.volumeSlider.tintColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;

        return musicDataCell;
    }
}

@end
