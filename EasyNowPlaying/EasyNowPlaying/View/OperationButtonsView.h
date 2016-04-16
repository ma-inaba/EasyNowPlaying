//
//  OperationButtonsView.h
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/30.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OperationButtonsViewDelegate <NSObject>

- (void)onTweetButton;

@end

@interface OperationButtonsView : UIView

@property (weak, nonatomic) id<OperationButtonsViewDelegate>operationButtonsViewDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@end
