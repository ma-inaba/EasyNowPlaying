//
//  PlaybackViewController.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/27.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "PlaybackViewController.h"
#import "ModelLocator.h"
#import <Social/Social.h>

@interface PlaybackViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *artworkBlurImageView;

@end

@implementation PlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // KVO監視を始める
    [[ModelLocator sharedInstance].playbackViewModel addObserver:self forKeyPath:@"completeLoadData" options:0 context:nil];
    [[ModelLocator sharedInstance].playbackViewModel loadMusicPlayerData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // KVO監視を解除する
    [[ModelLocator sharedInstance].playbackViewModel removeObserver:self forKeyPath:@"completeLoadData"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"completeLoadData"]) {
        self.artworkImageView.image = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artworkImage;
        
        self.artworkBlurImageView.image = [self.artworkBlurImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.artworkBlurImageView.tintColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.backgroundColor;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 再生ストップ切り替えボタンのアクション
- (IBAction)switchPlayStatus:(id)sender {

    [[ModelLocator sharedInstance].playbackViewModel switchPlayStatus];
}

// 次の曲ボタンのアクション
- (IBAction)skipToNextMusic:(id)sender {
    
    [[ModelLocator sharedInstance].playbackViewModel skipToNextMusic];
}

// 前の曲ボタンのアクション
- (IBAction)skipToPreviousMusic:(id)sender {
    
    [[ModelLocator sharedInstance].playbackViewModel skipToPreviousMusic];
}

// ツイート投稿ボタンのアクション
- (IBAction)postTweet:(id)sender {
    
    NSString *serviceType = SLServiceTypeTwitter;
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                //投稿成功時の処理
                NSLog(@"%@での投稿に成功しました", serviceType);
            }
        }];
        
        NSString *musicTitle = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.musicTitle;
        NSString *artistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artistName;
        NSString *postString = [NSString stringWithFormat:@"#nowplaying %@ - %@",musicTitle, artistName];
        UIImage *postImage = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artworkImage;
        [controller setInitialText:postString];
        [controller addImage:postImage];
        
        [self presentViewController:controller
                           animated:NO
                         completion:NULL];
    }
}
@end