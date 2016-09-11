//
//  AllMusicDataTableViewPlaylistCell.h
//  EasyNowPlaying
//
//  Created by InabaMasaya on 2016/09/11.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllMusicDataTableViewPlaylistCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *playlistImageView;
@property (weak, nonatomic) IBOutlet UILabel *playlistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *songsTrackLabel;

@end
