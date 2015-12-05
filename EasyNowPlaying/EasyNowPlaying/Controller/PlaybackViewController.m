//
//  PlaybackViewController.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/27.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "PlaybackViewController.h"
#import "MusicDataView.h"
#import <Social/Social.h>

@interface PlaybackViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet MusicDataView *musicDataView;
@property (weak, nonatomic) IBOutlet OperationButtonsView *operationButtonsView;

@end

@implementation PlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.operationButtonsView.operationButtonsViewDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // KVO監視を始める
    [[ModelLocator sharedInstance].playbackViewModel addObserver:self forKeyPath:kCompleteLoadData options:0 context:nil];
    [[ModelLocator sharedInstance].playbackViewModel loadMusicPlayerData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // KVO監視を解除する
    [[ModelLocator sharedInstance].playbackViewModel removeObserver:self forKeyPath:kCompleteLoadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kCompleteLoadData]) {
        self.artworkImageView.image = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artworkImage;
        [self.musicDataView setNeedsDisplay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onTweetButton {
    
    NSString *serviceType = SLServiceTypeTwitter;
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                //投稿成功時の処理
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