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
#import "SettingTableViewAlbumTagCell.h"
#import "settingtableviewFormatCell.h"
#import "SettingTableViewImageCell.h"
#import "SettingTableViewProfileCell.h"
#import "SettingTableViewMessageCell.h"

@implementation SettingTableView

- (void)awakeFromNib {
    
    self.dataSource = self;
    
    UINib *tagNib = [UINib nibWithNibName:kSettingTableViewTagCell bundle:nil];
    [self registerNib:tagNib forCellReuseIdentifier:kSettingTableViewTagCell];
    UINib *appNameTagNib = [UINib nibWithNibName:kSettingTableViewAppNameTagCell bundle:nil];
    [self registerNib:appNameTagNib forCellReuseIdentifier:kSettingTableViewAppNameTagCell];
    UINib *albumTagNib = [UINib nibWithNibName:kSettingTableViewAlbumTagCell bundle:nil];
    [self registerNib:albumTagNib forCellReuseIdentifier:kSettingTableViewAlbumTagCell];
    UINib *formatNib = [UINib nibWithNibName:kSettingTableViewFormatCell bundle:nil];
    [self registerNib:formatNib forCellReuseIdentifier:kSettingTableViewFormatCell];
    UINib *imageNib = [UINib nibWithNibName:kSettingTableViewImageCell bundle:nil];
    [self registerNib:imageNib forCellReuseIdentifier:kSettingTableViewImageCell];
    UINib *profileNib = [UINib nibWithNibName:kSettingTableViewProfileCell bundle:nil];
    [self registerNib:profileNib forCellReuseIdentifier:kSettingTableViewProfileCell];
    UINib *messageNib = [UINib nibWithNibName:kSettingTableViewMessageCell bundle:nil];
    [self registerNib:messageNib forCellReuseIdentifier:kSettingTableViewMessageCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    }
    
    if (section == 3) {
        return 2;
    }
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(screenSize.width == 320.0 && screenSize.height == 568.0) {
        return nil;
    }
    
    if (section == 0) {
        return kSettingTableHeaderTag;
    } else if (section == 1) {
        return kSettingTableHeaderFormat;
    } else if (section == 2) {
        return kSettingTableHeaderArtwork;
    } else if (section == 3) {
        return kSettingTableHeaderCreator;
    } else {
        return nil;
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
        } else if (indexPath.row == 1) {
            SettingTableViewAppNameTagCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewAppNameTagCell];
            cell.tagLabel.text =kPostNPbotTag;
            cell.descriptionLabel.text = kSettingTableViewOnAppTag;
            
            BOOL isAddAppTag = [[Utility loadUserDefaults:kAddAppTag] boolValue];
            cell.addTagSwitch.on = isAddAppTag;
            [cell.addTagSwitch addTarget:self action:@selector(changeAddAppTagSwitchState:) forControlEvents:UIControlEventValueChanged];
            return cell;
        } else {
            SettingTableViewAlbumTagCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewAlbumTagCell];
            cell.albumTagLabel.text = kSettingTableViewOnAlbumTag;
            
            BOOL isAddAlbumTag = [[Utility loadUserDefaults:kAddAlbumTag] boolValue];
            cell.addTagSwitch.on = isAddAlbumTag;
            [cell.addTagSwitch addTarget:self action:@selector(changeAddAlbumTagSwitchState:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        SettingTableViewFormatCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewFormatCell];
        [cell reloadFormatTags];
        return cell;
        
    } else if (indexPath.section == 2) {
        SettingTableViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewImageCell];
        BOOL isPostImage = [[Utility loadUserDefaults:kPostImageKey] boolValue];
        cell.addImageSwitch.on = isPostImage;
        [cell.addImageSwitch addTarget:self action:@selector(changeAddImageSwitchState:) forControlEvents:UIControlEventValueChanged];
        cell.messageLabel.text = kSettingTableViewPostImage;
        return cell;
    } else {
        if (indexPath.row == 0) {
            SettingTableViewProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewProfileCell];
            return cell;
        } else {
            SettingTableViewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewMessageCell];
            return cell;
        }
    }
}

- (void)changeAddImageSwitchState:(id)sender {
    
    BOOL state = [sender isOn];
    [Utility saveUserDefaults:[NSNumber numberWithBool:state] key:kPostImageKey];
}

- (void)changeAddAppTagSwitchState:(id)sender {
    
    BOOL state = [sender isOn];
    [Utility saveUserDefaults:[NSNumber numberWithBool:state] key:kAddAppTag];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[Utility loadUserDefaults:kFormatStrArrayKey]];

    if (state) {
        // #NPbotを追加
        [array insertObject:kPostNPbotTag atIndex:1];
    } else {
        // #NPbotを削除
        NSUInteger row =[array indexOfObject:kPostNPbotTag];
        if (row != NSNotFound) {
            [array removeObjectAtIndex:row];
        }
    }
    
    [Utility saveUserDefaults:array key:kFormatStrArrayKey];
    [ModelLocator sharedInstance].settingViewModel.settingDataEntity.formatStrArray = array;

    SettingTableViewFormatCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell reloadFormatTags];
}

- (void)changeAddAlbumTagSwitchState:(id)sender {

    BOOL state = [sender isOn];
    [Utility saveUserDefaults:[NSNumber numberWithBool:state] key:kAddAlbumTag];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[Utility loadUserDefaults:kFormatStrArrayKey]];
    
    if (state) {
        // Albumを追加
        [array addObject:@"Album"];
    } else {
        // Albumを削除
        NSUInteger row =[array indexOfObject:@"Album"];
        if (row != NSNotFound) {
            [array removeObjectAtIndex:row];
        }
    }
    
    [Utility saveUserDefaults:array key:kFormatStrArrayKey];
    [ModelLocator sharedInstance].settingViewModel.settingDataEntity.formatStrArray = array;
    
    SettingTableViewFormatCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell reloadFormatTags];
}
@end
