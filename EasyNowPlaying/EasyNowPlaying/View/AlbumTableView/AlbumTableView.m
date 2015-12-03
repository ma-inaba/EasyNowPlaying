//
//  AlbumTableView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "AlbumTableView.h"
#import "ModelLocator.h"
#import "AlbumTableViewSongCell.h"

@implementation AlbumTableView

- (void)awakeFromNib {
    
    self.delegate = self;
    self.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"AlbumTableViewSongCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:@"Cell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.musicDataDict allKeys] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 30.0f)];
    headerLabel.backgroundColor = tableView.backgroundColor;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor colorWithRed:0.98 green:0.99 blue:0.91 alpha:1.0];
    headerLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    NSString *text = [NSString stringWithFormat:@"%@",[[[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.musicDataDict allKeys] objectAtIndex:section]];
    headerLabel.text = text;

    return headerLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.musicDataDict allKeys];
    return [[[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.musicDataDict objectForKey:[array objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumTableViewSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[AlbumTableViewSongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.musicNoLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    cell.musicNoLabel.textColor = [UIColor whiteColor];
    
    cell.musicTitleLabel.text = @"Music Title";
    cell.musicTitleLabel.textColor = [UIColor whiteColor];
    cell.musicTitleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];

    cell.musicDurationLabel.text = @"5:21";
    cell.musicDurationLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

@end
