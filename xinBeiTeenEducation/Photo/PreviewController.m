//
//  PreviewController.m
//  Bike
//
//  Created by yizheming on 16/5/10.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "PreviewController.h"
#import "AlbumController.h"
#import "PreviewItem.h"
#import "ETPhotoUtil.h"
@interface PreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PreviewItemDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIImageView *selectBg;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIView *labelBg;

@property (nonatomic, strong) NSMutableArray *allGroups;
@property (nonatomic, strong) NSMutableArray *tempSet;
@property (nonatomic, strong) NSMutableArray *selectedArr;
@end

@implementation PreviewController
- (void)setup{
    //1.图片组合
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth+15, kScreenHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth+15, kScreenHeight) collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    _collectionView.backgroundColor = BlackColor;
    [_collectionView registerClass:[PreviewItem class] forCellWithReuseIdentifier:@"collectionView"];
    _collectionView.dataSource = self;
    _collectionView.delegate =self;
    [self.view insertSubview:_collectionView atIndex:0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self setup];
    AlbumController *albumVC = (AlbumController *)self.delegate;
    _allGroups = albumVC.allGroups;
    _tempSet = [NSMutableArray arrayWithArray:albumVC.tempSet];
    _selectedArr = [NSMutableArray arrayWithArray:albumVC.tempSet];
    [_collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isPreview) {
        [self.collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else{
        _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [self updateBottomStatus];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedPhotoFinished:)]) {
        [self.delegate selectedPhotoFinished:_selectedArr];
    }
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

#pragma mark - *************Main Method*************
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectionAction:(UIButton *)sender {
    
    
    ALAsset *alaset = nil;
    if (!_isPreview) {
        alaset = [_allGroups objectSafetyAtIndex:_indexPath.row];
    }else{
        alaset = [_tempSet objectSafetyAtIndex:_indexPath.row];
    }
    if (sender.selected) {
        
        if ([_selectedArr containsObject:alaset]) {
            [_selectedArr removeObject:alaset];
            [self setItemSelected:NO];
            _remainNum += 1;
        }
    }else{
        if (_remainNum ==0) {
            [self cannotSelectedAnyMore];
            return;
        }
        [self setItemSelected:YES];
        [ETPhotoUtil springAnimation:_selectBg];
        [_selectedArr safelyAddObject:alaset];
        _remainNum -= 1;
        
    }
    [self updateBottomStatus];
}

- (IBAction)completeAction:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(completedPreviewFinished:)]) {
            [self.delegate completedPreviewFinished:_selectedArr];
        }
    }];
}


- (void)cannotSelectedAnyMore{
    CommonAlert * alertView  = [[CommonAlert alloc]initWithMessage:[NSString stringWithFormat:@"你最多只能选择%lu张照片", (unsigned long)[self.selectedArr count]] withBtnTitles:@[@"知道了"]];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
}

- (void)updateBottomStatus{
    if ([self.selectedArr count]==0) {
        self.numLab.hidden = YES;
        self.labelBg.hidden = YES;
    }else{
        self.numLab.hidden = NO;
        self.labelBg.hidden = NO;
        [ETPhotoUtil springAnimation:self.labelBg];
        self.numLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.selectedArr count]];
    }
}
#pragma mark - *************UICollectionViewDelegate*************
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!_isPreview) {
        return _allGroups.count;
    }
    return _tempSet.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PreviewItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
    cell.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ALAsset *alaset = nil;
        if (!_isPreview) {
            alaset = [_allGroups objectSafetyAtIndex:indexPath.row];
        }else{
            alaset = [_tempSet objectSafetyAtIndex:indexPath.row];
        }
        //获取到相片、视频的缩略图
        ALAssetRepresentation *representation = [alaset defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
        //获取到媒体的类型
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setItemImage:image];
            //设置选中状态
            if ([self.selectedArr containsObject:alaset]) {
                [self setItemSelected:YES];
            }else{
                [self setItemSelected:NO];
            }
        });
    });
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
    PreviewItem *item = (PreviewItem *)cell;
    if([item respondsToSelector:@selector(resizeAction)]){
        [item resizeAction];
    }
    NSIndexPath *firstIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    if(firstIndexPath)
        _indexPath = firstIndexPath;
}

- (void)setItemSelected:(BOOL)selected{
    _selectBtn.selected = selected;
    NSString *imgName = selected?@"find_image_on.png":@"find_image_off.png";
    _selectBg.image = [UIImage imageBundleNamed:imgName];
    
}

#pragma mark - **************PreviewItemDelegate******************
- (void)tapGestureAction{
    
    self.bottomBar.hidden = !self.bottomBar.hidden;
    self.topBar.hidden = !self.topBar.hidden;
}

- (void)dealloc{
    _selectBg.image = nil;
    [_selectBg removeFromSuperview];
    _selectBg = nil;
    self.delegate = nil;
    [self.collectionView removeAllSubviews];
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
}

@end
