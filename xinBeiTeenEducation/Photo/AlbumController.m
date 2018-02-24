//
//  AlbumController.m
//  Bike
//
//  Created by yizheming on 16/4/12.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "AlbumController.h"
#import "AppDelegate.h"
#import "PhotoItem.h"
#import "ETPhotoUtil.h"
#import "UIImage+FixOrientation.h"
#import "PreviewController.h"
#import "CommonAlert.h"
@interface AlbumController ()<UICollectionViewDataSource,UICollectionViewDelegate,PhotoItemDelegate,PreviewControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *naviTitleItem;
@property (weak, nonatomic) IBOutlet UIView *bottomSelBg;
@property (weak, nonatomic) IBOutlet UILabel *bottomSelLab;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (nonatomic, assign) BOOL firstIn;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation AlbumController
static NSString *signStr;

- (instancetype)init{
    self = [super init];
    if (self) {
        _remainNum = 9;
        _firstIn = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

  
    [self setCollectionViewFlowLayout];

    @weakify(self);
    [ETPhotoUtil getImagesFromALAssetsLibraryCompletion:^{
        //设置collectionView
        weak_self.allGroups = [[ETPhotoUtil sharedInstance] allPhotos];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weak_self.naviTitleItem.title = [[ETPhotoUtil sharedInstance] cameraRoll];
            [weak_self.collectionView reloadData];
            if ([weak_self.allGroups count]==0) {
                [self isAuthorizationStatus];
            }
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.allGroups.count>0&&_firstIn) {
//        NSIndexPath *indexPath= [NSIndexPath indexPathForRow:(self.allGroups.count -1) inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
//        _firstIn = NO;
//    }

    signStr = @"1";
}

- (BOOL)prefersStatusBarHidden {
    
    return  YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - *************Main Method*************
- (NSMutableArray *)tempSet{
    if (!_tempSet) {
        _tempSet = [NSMutableArray arrayWithCapacity:9];
        
    }
    return _tempSet;
}

- (void)setCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth -20)*.25,(kScreenWidth -20)*.25);
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight -44) collectionViewLayout:layout];
    self.collectionView.backgroundColor = MainColor;
    [self.collectionView registerClass:[PhotoItem class] forCellWithReuseIdentifier:@"collectionView"];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate =self;
    
    if (iOS11) {

        self.collectionView.contentInset = UIEdgeInsetsMake(24, 0, 0, 0);
    }else{

       self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    
    [self.view insertSubview:self.collectionView atIndex:0];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)completedAction:(id)sender {

    NSMutableArray *images = [NSMutableArray array];
    [images safelyAddObjectsFromArray:self.tempSet];
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedImagesFinished:)]) {
            [self.delegate selectedImagesFinished:images];
        }
    }];    
}

- (IBAction)previewAction:(id)sender {
    
    PreviewController *preVC = [[PreviewController alloc]init];
    preVC.delegate = self;
    preVC.isPreview = YES;
    [self.navigationController pushViewController:preVC animated:YES];
}

#pragma  mark - **********ALAssetsGroup DataSource*************
- (void)isAuthorizationStatus{
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        // 展示提示语
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleName"];

        CommonAlert * alertView  = [[CommonAlert alloc]initWithMessage:[NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName] withBtnTitles:@[@"知道了"]];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    }
}

#pragma mark - *************UICollectionViewDelegate*************

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.allGroups.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
    
    if ([signStr isEqualToString:@"1"]) {
     
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:self.allGroups.count - 1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        signStr = @"2";
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ALAsset *alaset = [self.allGroups objectSafetyAtIndex:indexPath.row];
        //获取到相片、视频的缩略图
        CGImageRef cgImage = [alaset aspectRatioThumbnail];
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        
        //获取到媒体的类型
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.imageView.image=image;
            cell.delegate = self;
            cell.indexPath = indexPath;
            //设置选中状态
            if ([self.tempSet containsObject:alaset]) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        });
    });
    return cell;
}

#pragma mark - **********PhotoItemDelegate***********
- (void)cellDidClickedWithIndexPath:(NSIndexPath *)indexPath{
    PreviewController *preVC = [[PreviewController alloc]init];
    preVC.delegate = self;
    preVC.isPreview = NO;
    preVC.remainNum = _remainNum;
    preVC.indexPath = indexPath;
    [self.navigationController pushViewController:preVC animated:YES];
}

- (void)selectedPhotoItem:(UIButton *)button{
    if (button.selected) {
        if([self.tempSet count]==0){
            //当最选中第一个图时
            self.previewBtn.enabled = YES;
            self.completeBtn.enabled = YES;
            self.bottomSelBg.hidden = NO;
            self.bottomSelLab.hidden = NO;
        }
        [ETPhotoUtil springAnimation:self.bottomSelBg];
        [self.tempSet addObject:[self.allGroups objectSafetyAtIndex:button.tag]];
        _bottomSelLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.tempSet count]];
        _remainNum -=1;

    }else{
        
        if ([self.tempSet containsObject:[self.allGroups objectSafetyAtIndex:button.tag]]) {
            [self.tempSet removeObject:[self.allGroups objectSafetyAtIndex:button.tag]];

            if ([self.tempSet count]==0) {
                //当最后一个选中的图片被取消
                self.previewBtn.enabled = NO;
                self.completeBtn.enabled = NO;
                self.bottomSelBg.hidden = YES;
                self.bottomSelLab.hidden = YES;
            }else{
                [ETPhotoUtil springAnimation:self.bottomSelBg];
                _bottomSelLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.tempSet count]];
            }
            _remainNum +=1;
        }
    }
}

- (void)cannotSelectedAnyMore{
//    CommonAlert * alertView  = [[CommonAlert alloc]initWithMessage:[NSString stringWithFormat:@"你最多只能选择%lu张照片", (unsigned long)[self.tempSet count]] withBtnTitles:@[@"知道了"]];
//    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    [self showAlertWithMessage:[NSString stringWithFormat:@"你最多只能选择%lu张照片", (unsigned long)[self.tempSet count]]];
}

#pragma mark - **********PreviewControllerDelegate***********
- (void)selectedPhotoFinished:(NSMutableArray *)images{
    
    _remainNum += _tempSet.count - images.count;
    _tempSet = images;
    [self.collectionView reloadData];
    
    if ([self.tempSet count]==0) {
        //当最后一个选中的图片被取消
        self.previewBtn.enabled = NO;
        self.completeBtn.enabled = NO;
        self.bottomSelBg.hidden = YES;
        self.bottomSelLab.hidden = YES;
    }else{
        //当最选中第一个图时
        self.previewBtn.enabled = YES;
        self.completeBtn.enabled = YES;
        self.bottomSelBg.hidden = NO;
        self.bottomSelLab.hidden = NO;
    }
    _bottomSelLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.tempSet count]];

}

- (void)completedPreviewFinished:(NSMutableArray *)images{
    _tempSet = images;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedImagesFinished:)]) {
        [self.delegate selectedImagesFinished:images];
    }
}


- (void)dealloc{
    self.delegate = nil;
    [_collectionView removeAllSubviews];
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    [_collectionView removeFromSuperview];
    _collectionView = nil;
}
@end
