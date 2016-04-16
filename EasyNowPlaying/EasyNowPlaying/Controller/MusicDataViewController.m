//
//  MusicDataViewController.m
//  EasyNowPlaying
//
//  Created by Masaya on 2016/04/16.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import "MusicDataViewController.h"
#import "MusicDataTableView.h"

@interface MusicDataViewController ()

@property (weak, nonatomic) IBOutlet MusicDataTableView *musicDataTableView;

@end

@implementation MusicDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingNavigationBar];
    self.musicDataTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity addObserver:self forKeyPath:kSongsDataArray options:0 context:nil];
    NSString *albumName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.selectedAlbumName;
    NSString *artistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.selectedArtistName;
    if ([albumName isEqualToString:kUnknownAlbum]) {
        albumName = @"";
    }
    [[ModelLocator sharedInstance].playbackViewModel acquisitionMusicDataWithAlbumName:albumName artistName:artistName];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kSongsDataArray];
        [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeAlbum];
    } else {
        [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kSongsDataArray];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingNavigationBar {
    
    self.navigationItem.title = kMusic;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationItem.backBarButtonItem = barButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:kSongsDataArray]) {
        [self.musicDataTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[ModelLocator sharedInstance].playbackViewModel playSelectedMusicWithRow:indexPath.row];
}
@end