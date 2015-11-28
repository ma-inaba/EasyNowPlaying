//
//  ArtworkAndTwitterDataView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "ArtworkAndTwitterDataView.h"
#import "ModelLocator.h"
#import "UIImage+Ex.h"

@interface ArtworkAndTwitterDataView ()

@property (weak, nonatomic) IBOutlet UIImageView *twitterIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *twitterIDLabel;
@end

@implementation ArtworkAndTwitterDataView

- (void)reloadViewData {
    
    // TODO: コード整備
    UIImage *image = [UIImage imageNamed:@"image"];
    self.twitterIconImageView.image = [image imageWithCornerRadius:120];
    self.twitterIDLabel.textColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;
}

@end
