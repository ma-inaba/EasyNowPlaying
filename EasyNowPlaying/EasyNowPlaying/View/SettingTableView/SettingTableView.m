//
//  SettingTableView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/02.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "SettingTableView.h"
#import "SettingTableViewTagCell.h"
#import "SettingTableViewAppNameTagCell.h"
#import "SettingTableViewImageCell.h"
#import "SettingTableViewProfileCell.h"

@implementation SettingTableView

- (void)awakeFromNib {
    
    self.dataSource = self;
    
    UINib *tagNib = [UINib nibWithNibName:kSettingTableViewTagCell bundle:nil];
    [self registerNib:tagNib forCellReuseIdentifier:kSettingTableViewTagCell];
    UINib *appNameTagNib = [UINib nibWithNibName:kSettingTableViewAppNameTagCell bundle:nil];
    [self registerNib:appNameTagNib forCellReuseIdentifier:kSettingTableViewAppNameTagCell];
    UINib *imageNib = [UINib nibWithNibName:kSettingTableViewImageCell bundle:nil];
    [self registerNib:imageNib forCellReuseIdentifier:kSettingTableViewImageCell];
    UINib *profileNib = [UINib nibWithNibName:kSettingTableViewProfileCell bundle:nil];
    [self registerNib:profileNib forCellReuseIdentifier:kSettingTableViewProfileCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
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
        if (indexPath.row == 0) {
            SettingTableViewTagCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewTagCell];
            NSString *tagStr = [Utility loadUserDefaults:kPostTagKey];
            if (!tagStr) {
                tagStr = kPostDefaultTag;
            }
            cell.tagLabel.text =tagStr;
            
            return cell;
        } else {
            SettingTableViewAppNameTagCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewAppNameTagCell];
            cell.tagLabel.text =kPostNPbotTag;
            cell.descriptionLabel.text = @"アプリ名のタグを追加 (オンで開発者が喜びます)";
            
            BOOL isAddAppTag = [[Utility loadUserDefaults:kAddAppTag] boolValue];
            cell.addTagSwitch.on = isAddAppTag;
            [cell.addTagSwitch addTarget:self action:@selector(changeAddAppTagSwitchState:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        SettingTableViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewImageCell];
        BOOL isPostImage = [[Utility loadUserDefaults:kPostImageKey] boolValue];
        cell.addImageSwitch.on = isPostImage;
        [cell.addImageSwitch addTarget:self action:@selector(changeAddImageSwitchState:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    } else {
        SettingTableViewProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewProfileCell];
        
        return cell;
    }
}

- (void)changeAddImageSwitchState:(id)sender {
    
    BOOL state = [sender isOn];
    [Utility saveUserDefaults:[NSNumber numberWithBool:state] key:kPostImageKey];
}

- (void)changeAddAppTagSwitchState:(id)sender {
    
    BOOL state = [sender isOn];
    [Utility saveUserDefaults:[NSNumber numberWithBool:state] key:kAddAppTag];
}
@end
