//
//  PlaylistDataViewController.m
//  EasyNowPlaying
//
//  Created by InabaMasaya on 2016/09/11.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import "PlaylistDataViewController.h"
#import "PlaylistDataTableView.h"
#import "MusicDataViewController.h"

@interface PlaylistDataViewController ()
@property (weak, nonatomic) IBOutlet PlaylistDataTableView *playlistDataTableView;

@end

@implementation PlaylistDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingNavigationBar];
    self.playlistDataTableView.delegate = self;
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity addObserver:self forKeyPath:kPlaylistDataArray options:0 context:nil];
    [[ModelLocator sharedInstance].playbackViewModel acquisitionPlaylistData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kPlaylistDataArray];
    } else {
        [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kPlaylistDataArray];
        [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeArtist];
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
    segmentedControl.selectedSegmentIndex = 1;
    
    [self.navigationItem setTitleView:segmentedControl];
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        [[ModelLocator sharedInstance].playbackViewModel saveSelectedMode:SelectedModeArtist];
        [self.navigationController popViewControllerAnimated:NO];
    } else {

    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kArtistDataArray]) {
        [self.playlistDataTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *playlistName = [[ModelLocator sharedInstance].playbackViewModel loadPlaylistNameForPlaylistDataArraywithIndex:indexPath.row];
    [[ModelLocator sharedInstance].playbackViewModel saveSelectedPlaylistName:playlistName];
    
    MusicDataViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"MusicDataViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
