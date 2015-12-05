//
//  SettingTableView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/02.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "SettingTableView.h"
#import "SettingTableViewTagCell.h"
#import "SettingTableViewImageCell.h"
#import "SettingTableViewProfileCell.h"

@implementation SettingTableView

- (void)awakeFromNib {
    
    self.delegate = self;
    self.dataSource = self;
    
    UINib *tagNib = [UINib nibWithNibName:kSettingTableViewTagCell bundle:nil];
    [self registerNib:tagNib forCellReuseIdentifier:kSettingTableViewTagCell];
    UINib *imageNib = [UINib nibWithNibName:kSettingTableViewImageCell bundle:nil];
    [self registerNib:imageNib forCellReuseIdentifier:kSettingTableViewImageCell];
    UINib *profileNib = [UINib nibWithNibName:kSettingTableViewProfileCell bundle:nil];
    [self registerNib:profileNib forCellReuseIdentifier:kSettingTableViewProfileCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        return 100;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kSettingTableHeaderTag;
    } else if (section == 1) {
        return kSettingTableHeaderArtwork;
    } else {
        return kSettingTableHeaderCreator;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SettingTableViewTagCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewTagCell];
        
        return cell;
    } else if (indexPath.section == 1) {
        SettingTableViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewImageCell];
        
        return cell;
    } else {
        SettingTableViewProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewProfileCell];
        
        return cell;
    }
}

@end
