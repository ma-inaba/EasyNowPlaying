//
//  AllMusicDataViewController.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/04.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "AllMusicDataViewController.h"
#import "AllMusicDataTableView.h"
#import "ModelLocator.h"

@interface AllMusicDataViewController ()
@property (weak, nonatomic) IBOutlet AllMusicDataTableView *allMusicDataTableView;

@end

@implementation AllMusicDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch ([ModelLocator sharedInstance].playbackViewModel.tableViewMode) {
        case TableViewModeArtist:
            self.navigationItem.title = @"アーティスト";
            break;
        case TableViewModeAlbum:
            self.navigationItem.title = @"アルバム";
            break;
        case TableViewModeMusic:
            self.navigationItem.title = @"曲";
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // KVO監視を始める
    [[ModelLocator sharedInstance].playbackViewModel addObserver:self forKeyPath:@"completeLoadData" options:0 context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // KVO監視を解除する
    [[ModelLocator sharedInstance].playbackViewModel removeObserver:self forKeyPath:@"completeLoadData"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"completeLoadData"]) {
        [self.allMusicDataTableView reloadData];
    }
}
@end
