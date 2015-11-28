//
//  PlaybackViewController.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/27.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "PlaybackViewController.h"
#import "ModelLocator.h"
#import "MusicOperationView.h"
#import "ArtworkAndTwitterDataView.h"

@interface PlaybackViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *artworkBlurImageView;

@property (weak, nonatomic) IBOutlet ArtworkAndTwitterDataView *artworkAndTwitterDataView;
@property (weak, nonatomic) IBOutlet MusicOperationView *musicOperationView;

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
        [self.musicOperationView reloadViewData];
        
        self.artworkBlurImageView.image = [self.artworkBlurImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.artworkBlurImageView.tintColor = self.musicOperationView.backgroundColor;
        
        // TODO: twitterアカウント取得時に以下コードを移動
        // ※このメソッドが呼ばれた後にtwitterアカウント取得を行う事
        [self.artworkAndTwitterDataView reloadViewData];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchPlayStatus:(id)sender {

    [[ModelLocator sharedInstance].playbackViewModel switchPlayStatus];
}
- (IBAction)skipToNextMusic:(id)sender {
    
    [[ModelLocator sharedInstance].playbackViewModel skipToNextMusic];
}
- (IBAction)skipToPreviousMusic:(id)sender {
    
    [[ModelLocator sharedInstance].playbackViewModel skipToPreviousMusic];
}
@end
