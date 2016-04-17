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
    
    NSTimer *timer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(reloadSlider) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)reloadSlider {
    
    [self.musicDataView reloaddurationSlider];
    [self.musicDataView setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // KVO監視を解除する
    [[ModelLocator sharedInstance].playbackViewModel removeObserver:self forKeyPath:kCompleteLoadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([keyPath isEqualToString:kCompleteLoadData]) {
            BOOL complete = [[object valueForKey:keyPath] boolValue];
            if (complete) {
                self.artworkImageView.image = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artworkImage;
                [self.musicDataView setNeedsDisplay];
                [self.operationButtonsView setNeedsDisplay];
            }
        }
    });
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
        NSString *tagString = [Utility loadUserDefaults:kPostTagKey];
        
        MPMusicPlaybackState state = [[ModelLocator sharedInstance].playbackViewModel nowPlaybackState];
        if (state == MPMusicPlaybackStateStopped) {
            musicTitle = @"";
            artistName = @"";
        }
        
        if (!tagString) {
            tagString = kPostDefaultTag;
        }
        NSString *postString = [NSString stringWithFormat:@"%@ %@ - %@",tagString, musicTitle, artistName];
        UIImage *postImage = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artworkImage;
        
        [controller setInitialText:postString];
        
        BOOL isPostImage = [[Utility loadUserDefaults:kPostImageKey] boolValue];
        if (isPostImage) {
            [controller addImage:postImage];
        }
        
        [self presentViewController:controller
                           animated:NO
                         completion:NULL];
    }
}

@end