//
//  TwitterIconImageView.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "TwitterIconImageView.h"
#import "UIImage+Ex.h"

@implementation TwitterIconImageView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // TODO: コード整備
        UIImage *image = [UIImage imageNamed:@"image"];
        self.image = [image imageWithCornerRadius:120];
    }
    return self;
}

@end
