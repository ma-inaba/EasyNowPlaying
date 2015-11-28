//
//  PlaybackViewController.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/27.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "PlaybackViewController.h"
#import "ModelLocator.h"
#import "MusicTableView.h"

@interface PlaybackViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *artworkBlurImageView;
@property (weak, nonatomic) IBOutlet MusicTableView *tableView;

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
        self.tableView.backgroundColor = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.backgroundColor;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end