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
    if (section == 0 || section == 3) {
        return 2;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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
        SettingTableViewFormatCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewFormatCell];
        [cell reloadFormatTags];
        return cell;
        
    } else if (indexPath.section == 2) {
        SettingTableViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewImageCell];
        BOOL isPostImage = [[Utility loadUserDefaults:kPostImageKey] boolValue];
        cell.addImageSwitch.on = isPostImage;
        [cell.addImageSwitch addTarget:self action:@selector(changeAddImageSwitchState:) forControlEvents:UIControlEventValueChanged];
        cell.messageLabel.text = @"ツイートに画像を添付";
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
        
    // UserDefaultにタグを含めたarrayを保存する(上書きも含む)
//    NSString *tagStr = [Utility loadUserDefaults:kPostTagKey];
//    if (!tagStr) {
//        tagStr = kPostDefaultTag;
//    }
//    if (state) {
//        NSArray *formatStrArray = [NSArray arrayWithObjects:tagStr, kPostNPbotTag, @"Title", @"Artist", @"Album", nil];
//    } else {
//        NSArray *formatStrArray = [NSArray arrayWithObjects:tagStr, kPostNPbotTag, @"Title", @"Artist", @"Album", nil];
//    }
//    NSArray *formatStrArray = [NSArray arrayWithObjects:text, kPostNPbotTag, @"Title", @"Artist", @"Album", nil];
//    [Utility saveUserDefaults:formatStrArray key:kFormatStrArrayKey];
}
@end
