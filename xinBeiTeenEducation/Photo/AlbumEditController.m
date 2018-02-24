//
//  AlbumEditController.m
//  Bike
//
//  Created by yizheming on 16/5/18.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "AlbumEditController.h"
#import "sendController.h"
#import "PreviewItem.h"
#import "CommonSheet.h"
#import "YYKit.h"


@interface AlbumEditController ()<UICollectionViewDataSource,UICollectionViewDelegate,PreviewItemDelegate,CommonSheetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *allGroups;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;

@end

@implementation AlbumEditController

- (void)setup{
    //1.图片组合
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.barHideOnTapGestureRecognizer.enabled =NO;
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
  
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
//    self.fd_interactivePopDisabled = YES;
    
    [self setup];
    sendController *issueVC = (sendController *)self.delegate;
    _allGroups = issueVC.selectedImgs;
    self.titleItem.title = [NSString stringWithFormat:@"%ld/%lu",_indexPath.row+1,(unsigned long)_allGroups.count];
    [_collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(editedImagesFinished:)]) {
        [self.delegate editedImagesFinished:_allGroups];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - *************Main Method*************
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deletePhotoAction:(id)sender {
    CommonSheet *sheet = [[CommonSheet alloc]initWithDelegate:self];
    sheet.itemColor = UIColorHex(008bfe);
    [sheet setupWithTitles:@[@"要删除这张照片么?",@"删除"]];
    [sheet showInView:self.view];
}

#pragma mark - *************UICollectionViewDelegate*************
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self isViewLoaded]){
        if (self.naviBar.top>-64) {
            [UIView animateWithDuration:0.5 animations:^{
                self.naviBar.top= -64;
            }];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allGroups.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PreviewItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
    cell.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = nil;
        id imageObj = [_allGroups objectSafetyAtIndex:indexPath.row];
        if ([imageObj isKindOfClass:[UIImage class]]) {
            image = imageObj;
        }
        if([imageObj isKindOfClass:[ALAsset class]]){
            //获取到相片、视频的缩略图
            ALAssetRepresentation *representation = [imageObj defaultRepresentation];
            image = [UIImage imageWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
        }
        //获取到媒体的类型
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setItemImage:image];
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
    if(firstIndexPath&&firstIndexPath.row<_allGroups.count){
        _indexPath = firstIndexPath;
    }else{
        _indexPath = [NSIndexPath indexPathForRow:(_allGroups.count-1) inSection:0];
    }
    self.titleItem.title = [NSString stringWithFormat:@"%ld/%lu",_indexPath.row+1,(unsigned long)_allGroups.count];
}

#pragma mark - **************PreviewItemDelegate******************
- (void)tapGestureAction{

    [UIView animateWithDuration:0.5 animations:^{
        self.naviBar.top= self.naviBar.top>-64?-64:0;
    }];
}


#pragma mark - ***********CommonSheetDelegate***********
- (void)commonSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag{
    
    switch ([index integerValue]) {
        case 0:{
            /* 删除 */
            [_allGroups removeObjectAtIndex:_indexPath.row];
            if (_allGroups.count==0) {
                [self backAction:nil];
            }else{
                [_collectionView reloadData];
                self.titleItem.title = [NSString stringWithFormat:@"%ld/%lu",_indexPath.row+1,(unsigned long)_allGroups.count];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)dealloc{
    self.delegate = nil;
    [self.collectionView removeAllSubviews];
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
}
@end
