//
//  AlbumTableView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "AlbumTableView.h"
#import "ModelLocator.h"

@implementation AlbumTableView

- (void)awakeFromNib {
    
    self.delegate = self;
    self.dataSource = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 30.0f)];
    headerLabel.backgroundColor = tableView.backgroundColor;
    NSString *albumTitle = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.albumTitle;
    NSString *text = [NSString stringWithFormat:@"%@ - %lu曲",albumTitle, (unsigned long)[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.allTrackNumber];
    headerLabel.text = text;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];

    return headerLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.allTrackNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = @"Music Title";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];

    cell.detailTextLabel.text = @"5:21";
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];

    return cell;
}

@end
