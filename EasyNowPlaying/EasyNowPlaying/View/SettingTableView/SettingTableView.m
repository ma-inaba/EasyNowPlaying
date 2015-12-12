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
    
    self.dataSource = self;
    
    UINib *tagNib = [UINib nibWithNibName:kSettingTableViewTagCell bundle:nil];
    [self registerNib:tagNib forCellReuseIdentifier:kSettingTableViewTagCell];
    UINib *imageNib = [UINib nibWithNibName:kSettingTableViewImageCell bundle:nil];
    [self registerNib:imageNib forCellReuseIdentifier:kSettingTableViewImageCell];
    UINib *profileNib = [UINib nibWithNibName:kSettingTableViewProfileCell bundle:nil];
    [self registerNib:profileNib forCellReuseIdentifier:kSettingTableViewProfileCell];
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
        NSString *tagStr = [Utility loadUserDefaults:kPostTagKey];
        if (!tagStr) {
            tagStr = kPostDefaultTag;
        }
        cell.tagLabel.text =tagStr;
        
        return cell;
    } else if (indexPath.section == 1) {
        SettingTableViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewImageCell];
        BOOL isPostImage = [[Utility loadUserDefaults:kPostImageKey] boolValue];
        cell.addImageSwitch.on = isPostImage;
        [cell.addImageSwitch addTarget:self action:@selector(changeSwitchState:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    } else {
        SettingTableViewProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewProfileCell];
        
        return cell;
    }
}

- (void)changeSwitchState:(id)sender {
    
    BOOL state = [sender isOn];
    [Utility saveUserDefaults:[NSNumber numberWithBool:state] key:kPostImageKey];
}

@end
