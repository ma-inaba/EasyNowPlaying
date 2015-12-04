//
//  AlbumTableViewSongCell.h
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/01.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllMusicDataTableViewMusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *musicNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicDurationLabel;

@end
