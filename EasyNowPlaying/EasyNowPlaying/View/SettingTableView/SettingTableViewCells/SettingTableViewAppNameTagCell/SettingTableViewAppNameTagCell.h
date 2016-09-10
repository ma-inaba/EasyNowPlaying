//
//  SettingTableViewAppNameTagCell.h
//  EasyNowPlaying
//
//  Created by Masaya on 2016/04/23.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewAppNameTagCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *addTagSwitch;

@end
