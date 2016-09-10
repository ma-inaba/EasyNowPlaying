//
//  SettingTableViewFormatCell.m
//  EasyNowPlaying
//
//  Created by InabaMasaya on 2016/09/09.
//  Copyright © 2016年 inaba masaya. All rights reserved.
//

#import "SettingTableViewFormatCell.h"
#import "FormatCollectionViewCell.h"

@interface SettingTableViewFormatCell ()

@property (weak, nonatomic) IBOutlet UICollectionView *formatCollectionView;
@property (nonatomic) NSMutableArray *formatStrArray;

@end

@implementation SettingTableViewFormatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.formatCollectionView.delegate = self;
    self.formatCollectionView.dataSource = self;
    UINib *nibFirst = [UINib nibWithNibName:kFormatCollectionViewCell bundle:nil];
    [self.formatCollectionView registerNib:nibFirst forCellWithReuseIdentifier:kFormatCollectionViewCell];
    
    [self settingGesture];
    [self settingData];
}

- (void)settingGesture {
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGesture.delegate = self;
    longPressGesture.delaysTouchesBegan = YES;
    [self.formatCollectionView addGestureRecognizer:longPressGesture];
}

- (void)settingData {
    
    NSString *tagStr = [Utility loadUserDefaults:kPostTagKey];
    if (!tagStr) {
        tagStr = kPostDefaultTag;
    }
    self.formatStrArray = [NSMutableArray arrayWithObjects:tagStr, kPostNPbotTag, @"Title", @"Artist", @"Album", nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (CGSize)formatStrCGSize:(NSIndexPath *)indexPath {
    
    NSString *tagStr = [Utility loadUserDefaults:kPostTagKey];
    if (!tagStr) {
        tagStr = kPostDefaultTag;
    }
    NSString *str = [self.formatStrArray objectAtIndex:indexPath.row];
    if ([str isEqualToString:tagStr]) {
        return CGSizeMake(90, 44);
    } else if ([str isEqualToString:kPostNPbotTag]) {
        return CGSizeMake(60, 44);
    } else {
        return CGSizeMake(50, 44);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self formatStrCGSize:indexPath];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FormatCollectionViewCell *cell = (FormatCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kFormatCollectionViewCell forIndexPath:indexPath];
    
    cell.label.text = [self.formatStrArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString *str = [self.formatStrArray objectAtIndex:sourceIndexPath.item];
    [self.formatStrArray removeObjectAtIndex:sourceIndexPath.item];
    [self.formatStrArray insertObject:str atIndex:destinationIndexPath.item];
    
    [self.formatCollectionView reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            NSIndexPath *selectedIndexPath = [self.formatCollectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:(self.formatCollectionView)]];
            [self.formatCollectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
        }
        case UIGestureRecognizerStateChanged:
            [self.formatCollectionView updateInteractiveMovementTargetPosition:[gestureRecognizer locationInView:(gestureRecognizer.view)]];
            break;
        case UIGestureRecognizerStateEnded:
            [self.formatCollectionView endInteractiveMovement];
            break;
        default:
            [self.formatCollectionView cancelInteractiveMovement];
            break;
    }
}
@end
