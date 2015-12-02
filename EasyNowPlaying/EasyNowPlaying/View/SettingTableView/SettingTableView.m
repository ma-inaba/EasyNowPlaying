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
    
    UINib *tagNib = [UINib nibWithNibName:@"SettingTableViewTagCell" bundle:nil];
    [self registerNib:tagNib forCellReuseIdentifier:@"SettingTableViewTagCell"];
    UINib *imageNib = [UINib nibWithNibName:@"SettingTableViewImageCell" bundle:nil];
    [self registerNib:imageNib forCellReuseIdentifier:@"SettingTableViewImageCell"];
    UINib *profileNib = [UINib nibWithNibName:@"SettingTableViewProfileCell" bundle:nil];
    [self registerNib:profileNib forCellReuseIdentifier:@"SettingTableViewProfileCell"];
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
        return @"Tag";
    } else if (section == 1) {
        return @"Artwork";
    } else {
        return @"Creator";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SettingTableViewTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewTagCell"];
        cell.tagLabel.textColor = [UIColor whiteColor];
        
        return cell;
    } else if (indexPath.section == 1) {
        SettingTableViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewImageCell"];
        cell.messageLabel.textColor = [UIColor whiteColor];
        
        return cell;
    } else {
        SettingTableViewProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewProfileCell"];
        
        return cell;
    }
}

@end
