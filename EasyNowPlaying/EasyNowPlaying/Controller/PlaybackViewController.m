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

@interface PlaybackViewController () {
    
    NSTimer *sliderTimer;
}
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet MusicDataView *musicDataView;
@property (weak, nonatomic) IBOutlet OperationButtonsView *operationButtonsView;

@end

@implementation PlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.operationButtonsView.operationButtonsViewDelegate = self;
    
    // 受け取る処理（オブザーバの登録）と受け取った後の処理
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [self firstSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // KVO監視を始める
    [[ModelLocator sharedInstance].playbackViewModel addObserver:self forKeyPath:kCompleteLoadData options:0 context:nil];
    [[ModelLocator sharedInstance].playbackViewModel loadMusicPlayerData];
    
    sliderTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(reloadSlider) userInfo:nil repeats:YES];
    [sliderTimer fire];
}

- (void)dealloc{
    // 通知センターを削除する
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (void)firstSetting {
    
    // 初期設定
    id addAppTag = [Utility loadUserDefaults:kAddAppTag];
    if (addAppTag == nil) {
        [Utility saveUserDefaults:[NSNumber numberWithBool:YES] key:kAddAppTag];
    }
    id addAlbumTag = [Utility loadUserDefaults:kAddAlbumTag];
    if (addAlbumTag == nil) {
        [Utility saveUserDefaults:[NSNumber numberWithBool:YES] key:kAddAlbumTag];
    }
    id postImage= [Utility loadUserDefaults:kPostImageKey];
    if (postImage == nil) {
        [Utility saveUserDefaults:[NSNumber numberWithBool:YES] key:kPostImageKey];
    }
}

- (void)applicationDidBecomeActive{
    
    [self reloadViews];
    if (![sliderTimer isValid]) {
        sliderTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(reloadSlider) userInfo:nil repeats:YES];
        [sliderTimer fire];
    }
}

- (void)applicationDidEnterBackground {
    
    if ([sliderTimer isValid]) {
        [sliderTimer invalidate];
    }
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
                UIImage *artwork = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.artworkImage;
                if (artwork == nil) {
                    artwork = [UIImage imageNamed:@"NonArtwork"];
                }
                self.artworkImageView.image = artwork;
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
        NSString *albumTitle = [ModelLocator sharedInstance].playbackViewModel.musicDataEntity.albumTitle;
        
        MPMusicPlaybackState state = [[ModelLocator sharedInstance].playbackViewModel nowPlaybackState];
        if (state == MPMusicPlaybackStateStopped) {
            musicTitle = @"";
            artistName = @"";
        }
        
        NSString *postString = [self createTweetTextWithMusicTitle:musicTitle artistName:artistName albumTitle:albumTitle];
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

- (NSString *)createTweetTextWithMusicTitle:(NSString *)musicTitle artistName:(NSString *)artistName albumTitle:(NSString *)albumTitle {

    NSString *postString = @"もしこのメッセージが表示された際には設定画面のスクリーンショットと共に開発までお問い合わせください。\n手っ取り早く治すなら再インストールしてFORMATを変更せずに試してみて下さい。\nそれでもダメなようなら曲情報がダメみたいです。";

    /* 常に実行される */
    @try {
        BOOL isAddAppTag = [[Utility loadUserDefaults:kAddAppTag] boolValue];
        BOOL isAddAlbumTag = [[Utility loadUserDefaults:kAddAlbumTag] boolValue];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[Utility loadUserDefaults:kFormatStrArrayKey]];
        
        int forCount;
        if (isAddAppTag) {
            if (isAddAlbumTag) {
                forCount = 5;
            } else {
                forCount = 4;
            }
        } else {
            if (isAddAlbumTag) {
                forCount = 4;
            } else {
                forCount = 3;
            }
        }
        
        NSMutableArray *addHyphenRowArray = [NSMutableArray array];
        for (int i = 0; i < forCount; i++) {
            NSString *str = [array objectAtIndex:i];
            if ([str isEqualToString:@"Title"] || [str isEqualToString:@"Artist"] || [str isEqualToString:@"Album"]) {
                if (i == forCount-1) {
                    // 最後は必要ないので抜ける
                    break;
                }
                NSString *nextStr = [array objectAtIndex:i+1];
                if ([nextStr isEqualToString:@"Title"] || [nextStr isEqualToString:@"Artist"] || [nextStr isEqualToString:@"Album"]) {
                    // iのつぎに-をいれる
                    [addHyphenRowArray addObject:[NSNumber numberWithInt:i+1]];
                }
            }
        }
        
        if ([addHyphenRowArray count] == 1) {
            [array insertObject:@"-" atIndex:[[addHyphenRowArray objectAtIndex:0] intValue]];
        } else if ([addHyphenRowArray count] == 2) {
            NSUInteger addRow = [[addHyphenRowArray objectAtIndex:0] intValue];
            [array insertObject:@"-" atIndex:addRow];
            [array insertObject:@"-" atIndex:addRow+2];
        } else {
            
        }
        
        //title name albumがnilか@""だった場合は不明な◯◯に変更
        if (!musicTitle || [musicTitle isEqualToString:@""]) {
            [self replaceUnknownData:array beforeStr:@"Title" afterStr:kUnknownTitle];
        }
        if (!artistName || [artistName isEqualToString:@""]) {
            [self replaceUnknownData:array beforeStr:@"Artist" afterStr:kUnknownArtist];
        }
        if (!albumTitle || [albumTitle isEqualToString:@""]) {
            [self replaceUnknownData:array beforeStr:@"Album" afterStr:kUnknownAlbum];
        }
        
        
        NSUInteger titleRow =[array indexOfObject:@"Title"];
        NSUInteger artistRow =[array indexOfObject:@"Artist"];
        
        if(titleRow != NSNotFound){
            [array replaceObjectAtIndex:titleRow withObject:musicTitle];
        }
        
        if(artistRow != NSNotFound){
            [array replaceObjectAtIndex:artistRow withObject:artistName];
        }
        
        
        if (isAddAlbumTag) {
            NSUInteger albumRow =[array indexOfObject:@"Album"];
            if(albumRow != NSNotFound){
                [array replaceObjectAtIndex:albumRow withObject:albumTitle];
            }
        }
        
        if (!isAddAppTag && !isAddAlbumTag && [addHyphenRowArray count] == 0) {
            postString = [NSString stringWithFormat:@"%@ %@ %@",[array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2]];
        } else if ((isAddAppTag && !isAddAlbumTag && [addHyphenRowArray count] == 0) || (!isAddAppTag && isAddAlbumTag && [addHyphenRowArray count] == 0) || (!isAddAppTag && !isAddAlbumTag && [addHyphenRowArray count] == 1)) {
            postString = [NSString stringWithFormat:@"%@ %@ %@ %@",[array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2], [array objectAtIndex:3]];
        } else if ((!isAddAppTag && isAddAlbumTag && [addHyphenRowArray count] == 1) || (isAddAppTag && !isAddAlbumTag && [addHyphenRowArray count] == 1) || (isAddAppTag && isAddAlbumTag && [addHyphenRowArray count] == 0)) {
            postString = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2], [array objectAtIndex:3], [array objectAtIndex:4]];
        } else if ((!isAddAppTag && isAddAlbumTag && [addHyphenRowArray count] == 2) || (isAddAppTag && !isAddAlbumTag && [addHyphenRowArray count] == 2) || (isAddAppTag && isAddAlbumTag && [addHyphenRowArray count] == 1)) {
            postString = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2], [array objectAtIndex:3], [array objectAtIndex:4], [array objectAtIndex:5]];
        } else if (isAddAppTag && isAddAlbumTag && [addHyphenRowArray count] == 2) {
            postString = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@",[array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2], [array objectAtIndex:3], [array objectAtIndex:4], [array objectAtIndex:5], [array objectAtIndex:6]];
        } else {
            postString = @"もしこのメッセージが表示された際には設定画面のスクリーンショットと共に開発までお問い合わせください。\n手っ取り早く治すなら再インストールしてFORMATを変更せずに試してみて下さい。\nそれでもダメなようなら曲情報がダメみたいです。";
        }
    }
    
    /* 例外が起きると実行される */
    @catch (NSException *exception) {
        
    }
    
    /* 常に実行される */
    @finally {
    
    }

    return postString;
}

- (void)onBackButton {
    
    [self reloadViews];
}

- (void)onNextButton {
    
    [self reloadViews];
}

- (void)reloadViews {
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        MPMusicPlaybackState state = [[ModelLocator sharedInstance].playbackViewModel nowPlaybackState];
        if (state == MPMusicPlaybackStateStopped) {
            self.artworkImageView.image = [UIImage imageNamed:@"NonArtwork"];
            [self.musicDataView setNeedsDisplay];
            [self.operationButtonsView setNeedsDisplay];
        }
    });
}

// 配列から引数のデータを検索して見つかった場合は「不明な◯◯」に変更する
- (void)replaceUnknownData:(NSMutableArray *)array beforeStr:(NSString *)beforeStr afterStr:(NSString *)afterStr {
    NSUInteger row =[array indexOfObject:beforeStr];
    if(row != NSNotFound){
        [array replaceObjectAtIndex:row withObject:afterStr];
    }
}
@end
