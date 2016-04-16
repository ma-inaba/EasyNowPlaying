//
//  AlbumDataViewController.m
//  EasyNowPlaying
//
//  Created by Masaya on 2016/04/16.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import "AlbumDataViewController.h"
#import "MusicDataViewController.h"
#import "AlbumDataTableView.h"

@interface AlbumDataViewController ()

@property (weak, nonatomic) IBOutlet AlbumDataTableView *albumDataTableView;

@end

@implementation AlbumDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingNavigationBar];
    self.albumDataTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity addObserver:self forKeyPath:kAlbumDataArray options:0 context:nil];
    NSString *artistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.selectedArtistName;
    [[ModelLocator sharedInstance].playbackViewModel acquisitionAlbumDataWithArtistName:artistName];
 }

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kAlbumDataArray];
        [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeArtist];
    } else {
        [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kAlbumDataArray];
        [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeMusic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingNavigationBar {
    
    self.navigationItem.title = kAlbum;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationItem.backBarButtonItem = barButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kAlbumDataArray]) {
        [self.albumDataTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *albumName = [[ModelLocator sharedInstance].playbackViewModel loadAlbumNameForArtistDataArraywithIndex:indexPath.row];
    [[ModelLocator sharedInstance].playbackViewModel saveSelectedAlbumName:albumName];
    
    MusicDataViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"MusicDataViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
