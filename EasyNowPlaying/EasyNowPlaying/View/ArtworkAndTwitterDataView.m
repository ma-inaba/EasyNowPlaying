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
    
    // twitterアイコンを使用する
    UIImage *image = [UIImage imageNamed:@"image"];
    image = [image imageWithCornerRadius:120];

    self.twitterIDLabel.textColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.primaryTextColor;

    self.twitterIconImageView.layer.cornerRadius = self.twitterIconImageView.frame.size.width * 0.5f;
    self.twitterIconImageView.clipsToBounds = YES;
    self.twitterIconImageView.image = image;
    //枠線
    self.twitterIconImageView.layer.borderWidth = 3.0f;
    //枠線の色
    self.twitterIconImageView.layer.borderColor = [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity.backgroundColor CGColor];
}

@end
