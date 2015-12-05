//
//  AllMusicDataViewController.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/04.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "AllMusicDataViewController.h"
#import "AllMusicDataTableView.h"

@interface AllMusicDataViewController ()
@property (weak, nonatomic) IBOutlet AllMusicDataTableView *allMusicDataTableView;

@end

@implementation AllMusicDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingNavigationBar];
    self.allMusicDataTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    switch ([ModelLocator sharedInstance].playbackViewModel.tableViewMode) {
        case TableViewModeArtist:
            [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity addObserver:self forKeyPath:kArtistDataArray options:0 context:nil];
            [[ModelLocator sharedInstance].playbackViewModel acquisitionArtistData];
            break;
        case TableViewModeAlbum:{
            [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity addObserver:self forKeyPath:kAlbumDataArray options:0 context:nil];
            NSString *artistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.selectedArtistName;
            [[ModelLocator sharedInstance].playbackViewModel acquisitionAlbumDataWithArtistName:artistName];
            break;
        }
        case TableViewModeMusic:{
            [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity addObserver:self forKeyPath:kSongsDataArray options:0 context:nil];
            NSString *albumName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.selectedAlbumName;
            [[ModelLocator sharedInstance].playbackViewModel acquisitionMusicDataWithAlbumName:albumName];
            break;
        }
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    if (![self.navigationController.viewControllers containsObject:self]) {
        switch ([ModelLocator sharedInstance].playbackViewModel.tableViewMode) {
            case TableViewModeArtist:
                [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kArtistDataArray];
                break;
            case TableViewModeAlbum:
                [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kAlbumDataArray];
                [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeArtist];
                break;
            case TableViewModeMusic:
                [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kSongsDataArray];
                [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeAlbum];
                break;
            default:
                break;
        }
    } else {
        switch ([ModelLocator sharedInstance].playbackViewModel.tableViewMode) {
            case TableViewModeArtist:
                [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kArtistDataArray];
                [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeAlbum];
                break;
            case TableViewModeAlbum:
                [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kAlbumDataArray];
                [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeMusic];
                break;
            case TableViewModeMusic:
                [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:kSongsDataArray];
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingNavigationBar {
    
    switch ([ModelLocator sharedInstance].playbackViewModel.tableViewMode) {
        case TableViewModeArtist:
            self.navigationItem.title = kArtist;
            break;
        case TableViewModeAlbum:
            self.navigationItem.title = kAlbum;
            break;
        case TableViewModeMusic:
            self.navigationItem.title = kMusic;
            break;
        default:
            break;
    }
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationItem.backBarButtonItem = barButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kArtistDataArray]) {
        [self.allMusicDataTableView reloadData];
    }
    if ([keyPath isEqualToString:kAlbumDataArray]) {
        [self.allMusicDataTableView reloadData];
    }
    if ([keyPath isEqualToString:kSongsDataArray]) {
        [self.allMusicDataTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([ModelLocator sharedInstance].playbackViewModel.tableViewMode == TableViewModeArtist) {
        return 65.0f;
    } else if ([ModelLocator sharedInstance].playbackViewModel.tableViewMode == TableViewModeAlbum) {
        return 65.0f;        
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch ([ModelLocator sharedInstance].playbackViewModel.tableViewMode) {
        case TableViewModeArtist:{
            NSString *artistName = [[ModelLocator sharedInstance].playbackViewModel loadArtistNameForArtistDataArraywithIndex:indexPath.row];
            [[ModelLocator sharedInstance].playbackViewModel saveSelectedArtistName:artistName];
            break;
        }
        case TableViewModeAlbum:{
            NSString *albumName = [[ModelLocator sharedInstance].playbackViewModel loadAlbumNameForArtistDataArraywithIndex:indexPath.row];
            [[ModelLocator sharedInstance].playbackViewModel saveSelectedAlbumName:albumName];
            break;
        }
        case TableViewModeMusic:
            return;
            break;
        default:
            break;
    }

    AllMusicDataViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"AllMusicDataViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
