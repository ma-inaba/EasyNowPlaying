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
    [self settingNavigationBar];
    self.allMusicDataTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // KVO監視を始めてデータを取得する
    [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity addObserver:self forKeyPath:@"artistDataArray" options:0 context:nil];
    [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity addObserver:self forKeyPath:@"albumDataArray" options:0 context:nil];

    switch ([ModelLocator sharedInstance].playbackViewModel.tableViewMode) {
        case TableViewModeArtist:
            [[ModelLocator sharedInstance].playbackViewModel acquisitionArtistData];
            break;
        case TableViewModeAlbum:{
            NSString *artistName = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.selectedArtistName;
            [[ModelLocator sharedInstance].playbackViewModel acquisitionAlbumDataWithArtistName:artistName];
            break;
        }
        case TableViewModeMusic:
            break;
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    // KVO監視を解除する
    [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:@"artistDataArray"];
    [[ModelLocator sharedInstance].playbackViewModel.musicDataEntity removeObserver:self forKeyPath:@"albumDataArray"];
    if (![self.navigationController.viewControllers containsObject:self]) {
        switch ([ModelLocator sharedInstance].playbackViewModel.tableViewMode) {
            case TableViewModeArtist:
                break;
            case TableViewModeAlbum:
                [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeArtist];
                break;
            case TableViewModeMusic:
                [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeAlbum];
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
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationItem.backBarButtonItem = barButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"artistDataArray"]) {
        [self.allMusicDataTableView reloadData];
    }
    if ([keyPath isEqualToString:@"albumDataArray"]) {
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
            [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeAlbum];
            break;
        }
        case TableViewModeAlbum:
            //  曲一覧取得処理が完成次第コメントアウトをはずす
//            [[ModelLocator sharedInstance].playbackViewModel setTableViewMode:TableViewModeMusic];
            break;
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
