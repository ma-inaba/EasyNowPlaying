//
//  ArtistDataViewController.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/04.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "ArtistDataViewController.h"
#import "AlbumDataViewController.h"
#import "PlaylistDataViewController.h"
#import "ArtistDataTableView.h"

@interface ArtistDataViewController ()
@property (weak, nonatomic) IBOutlet ArtistDataTableView *artistDataTableView;

@end

@implementation ArtistDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavigationBar];
    self.artistDataTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity addObserver:self forKeyPath:kArtistDataArray options:0 context:nil];
    [[ModelLocator sharedInstance].playbackViewModel acquisitionArtistData];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    if (![self.navigationController.viewControllers containsObject:self]) {
        [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kArtistDataArray];
    } else {
        [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kArtistDataArray];
        [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeAlbum];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingNavigationBar {
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationItem.backBarButtonItem = barButton;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             kArtist,
                                             kPlaylist,
                                             nil]];
    [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 180, 25);
    segmentedControl.selectedSegmentIndex = 0;
    
    [self.navigationItem setTitleView:segmentedControl];
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        
    } else {
        sender.selectedSegmentIndex = 0;
        [[ModelLocator sharedInstance].playbackViewModel saveSelectedMode:SelectedModePlaylist];

        PlaylistDataViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"PlaylistDataViewController"];
        [self.navigationController pushViewController:controller animated:NO];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kArtistDataArray]) {
        [self.artistDataTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *artistName = [[ModelLocator sharedInstance].playbackViewModel loadArtistNameForArtistDataArraywithIndex:indexPath.row];
    [[ModelLocator sharedInstance].playbackViewModel saveSelectedArtistName:artistName];

    AlbumDataViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"AlbumDataViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
