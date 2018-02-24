//
//  ePictureController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ePictureController.h"
#import "pictureTopView.h"
#import "eBookPictureModel.h"
#import "UIImage+ImageEffects.h"
#import "LSYCatalogViewController.h"
#import "AppDelegate.h"

#define AnimationDelay 0.3
@interface ePictureController ()<UIGestureRecognizerDelegate,topViewDelete,UIScrollViewDelegate,LSYCatalogViewControllerDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) pictureTopView *topView;
@property (nonatomic,strong) LSYCatalogViewController *catalogVC;   //侧边栏
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
@property (nonatomic,assign) CGFloat imageHeight;
@property (nonatomic,strong) NSMutableArray *imgArray;//图片
@property (nonatomic,strong) NSMutableArray *chapterCountArray;//章节数
@property (nonatomic,strong) NSMutableArray *chapterArray;//章节
@property (nonatomic,assign) int scrollWith;
@property (nonatomic,strong) UIView * catalogView;  //侧边栏背景
@property (nonatomic,assign) int changePage;  //页数
@property (nonatomic,assign) int changeChapter;  //章节数

@end

@implementation ePictureController
static NSString *userId;
static NSString *pageStr;//页数
static NSString *colorStr;//修改背景色
static CGFloat startOffsetX;
static CGFloat willEndContentOffsetX;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //发送通知
    NSDictionary *dict = @{@"bookId":self.bookIdStr};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"1" object:nil userInfo:dict];
}

-(void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.scrollView];
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
        tap.delegate = self;
        tap;
    })];
    [self.view addSubview:self.topView];

    [self.view addSubview:self.catalogView];
    [self addChildViewController:self.catalogVC];
    [self.catalogView addSubview:self.catalogVC.view];
    
    [self createHttpRequest];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSDictionary *param = @{@"userId":userId,@"bookId":self.bookIdStr};
    [self loadPictureDataWithParam:param];
    
    //背景色
//    pageStr = [userDefaults objectForKey:@"page"];
    colorStr = [userDefaults objectForKey:@"color"];
    if ([colorStr isEqualToString:@"3"]) {
        
        self.view.backgroundColor = RGB(190, 182, 162);
    }else if ([colorStr isEqualToString:@"2"]){
        
        self.view.backgroundColor = RGB(188, 178, 190);
    }else{
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
//    //页数
//    self.changePage = [pageStr intValue];
//    if (self.changePage == 0) {
//
//        self.changePage = 1;
//    }else{
//
//     DDLog(@"%d",self.changePage);
//     [self.scrollView setContentOffset:CGPointMake(ScreenWidth*self.changePage, 0) animated:NO];
//    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(colorClick:) name:@"color" object:nil];
}

-(void)colorClick:(NSNotification*)noti{
    
    colorStr = [NSString stringWithFormat:@"%@",noti.userInfo[@"color"]];
    if ([colorStr isEqualToString:@"1"]) {
        
        self.view.backgroundColor = [UIColor whiteColor];
    }else if ([colorStr isEqualToString:@"2"]){
        
       self.view.backgroundColor = RGB(188, 178, 190);
    }else{
        
        self.view.backgroundColor = RGB(190, 182, 162);
    }
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"color"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorStr forKey:@"color"];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"page"];
//
//    DDLog(@"fffffff%d",self.changePage);
//    NSString * pageStr = [NSString stringWithFormat:@"%d",self.changePage];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:pageStr forKey:@"page"];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(UIImageView *)imageView{
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"book_background"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

-(UIScrollView*)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(pictureTopView *)topView{
    
    if (!_topView) {
        
        _topView = [[pictureTopView alloc]init];
        _topView.delegate = self;
        _topView.hidden = YES;
    }
    return _topView;
}

-(NSMutableArray *)imgArray{
    if (!_imgArray) {
        
        _imgArray = [[NSMutableArray alloc]init];
    }
    return _imgArray;
}

-(NSMutableArray *)chapterCountArray{
    if (!_chapterCountArray) {
        
        _chapterCountArray = [[NSMutableArray alloc]init];
    }
    return _chapterCountArray;
}

-(NSMutableArray *)chapterArray{
    if (!_chapterArray) {
        
        _chapterArray = [[NSMutableArray alloc]init];
    }
    return _chapterArray;
}

-(void)loadPictureDataWithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:eBookPictURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSArray *typeListArray = dict[@"typeList"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            for ( NSDictionary *appDict in typeListArray) {
                
                eBookPictureModel *model = [[eBookPictureModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.chapterCountArray addObject:model.imgSum];
                
                NSMutableDictionary *dictType = [[NSMutableDictionary alloc]init];
                dictType = [NSMutableDictionary dictionaryWithObject:model.id forKey:model.typeImg];
                [weakSelf.chapterArray addObject:dictType];
                
//                if ([model.typeImg containsString:@"|"]) {
//
//                    NSArray *array = [model.typeImg componentsSeparatedByString:@"|"];
//                    [self.imgArray addObjectsFromArray:array];
//                }else{
                
                    [self.imgArray addObject:model.typeImg];
//                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [weakSelf createImage];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 目录章节跳转
-(void)catalog:(LSYCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page{
    
    int sum = 0;
    for (int i =0; i<chapter;i++) {
            
        sum = sum + [self.chapterCountArray[i] intValue];
    }
    self.changePage = sum;
    int intStr = self.scrollWith/ScreenWidth;

    DDLog(@"%d",intStr);
    DDLog(@"%d",sum);
    if (sum < (int)intStr) {

        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*sum, 0) animated:NO];
    }else{

        NSMutableArray *pictureArray = [[NSMutableArray alloc]init];
        for (int i = self.changeChapter+1 ; i <chapter+1; i++) {
            
            NSString *imgStr = self.imgArray[i];
            
            if ([imgStr containsString:@"|"]) {
                
                NSArray *array = [imgStr componentsSeparatedByString:@"|"];
                [pictureArray addObjectsFromArray:array];
            }else{
                
                [pictureArray addObject:self.imgArray[i]];
            }
        }

        for (int i =0; i< pictureArray.count; i++) {
            
            NSURL *obj = pictureArray[i];
            self.imageView = [[UIImageView alloc]init];
            [self.imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageNamed:@"book_background"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.imageView setFrame:CGRectMake(ScreenWidth*(i +intStr), 0, ScreenWidth, ScreenHeight)];
            [self.scrollView addSubview:self.imageView];
        }
    
        int count = self.changePage ;
        DDLog(@"%d",count);
        
//        self.changePage = [pageStr intValue];
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*(count +1), _scrollView.frame.size.height);
       
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*count, 0) animated:NO];
    }
    [self catalogShowState:NO];
}

#pragma mark -- 开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    startOffsetX = self.scrollView.contentOffset.x;
    int withInt = self.scrollWith/ScreenWidth - 1;
    
    if (withInt == self.changePage) {
        
        if (self.changeChapter < self.imgArray.count - 1) {
            
            self.changeChapter ++;
            NSMutableArray *pictureArray = [[NSMutableArray alloc]init];
            NSString *imgStr = self.imgArray[self.changeChapter];
            
            if ([imgStr containsString:@"|"]) {
                
                NSArray *array = [imgStr componentsSeparatedByString:@"|"];
                [pictureArray addObjectsFromArray:array];
            }else{
                
                [pictureArray addObject:self.imgArray[self.changeChapter]];
            }
            
            for (int i =0; i< pictureArray.count; i++) {
                
                NSURL *obj = pictureArray[i];
                self.imageView = [[UIImageView alloc]init];
                [self.imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageNamed:@"book_background"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
                }];
                
                [self.imageView setFrame:CGRectMake(ScreenWidth*(i+self.changePage +1), 0, ScreenWidth, ScreenHeight)];
                [self.scrollView addSubview:self.imageView];
            }
            
            int count = (int)pictureArray.count + self.changePage +1;
//            self.changePage = [pageStr intValue];
            
            self.scrollWith = _scrollView.frame.size.width*count;
            _scrollView.contentSize = CGSizeMake(self.scrollWith, _scrollView.frame.size.height);
        }
    }
}

#pragma mark -- 将要停止当前的坐标
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    willEndContentOffsetX = scrollView.contentOffset.x;
}

#pragma mark -- 减速停止
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat endContentOffsetX = scrollView.contentOffset.x;
    
    //ScrollView中根据滚动距离来判断当前页数
    self.changePage = (int)scrollView.contentOffset.x/ScreenWidth;
    
    if (endContentOffsetX < willEndContentOffsetX && willEndContentOffsetX < startOffsetX) { //前一页
        
        
        
    } else if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startOffsetX) {//后一页
    }
    
}

-(void)createImage{
    
    self.changePage = 1;
    self.changeChapter = 0;
    NSMutableArray *pictureArray = [[NSMutableArray alloc]init];
    NSString *imgStr = self.imgArray[self.changeChapter];
    
    if ([imgStr containsString:@"|"]) {
     
        NSArray *array = [imgStr componentsSeparatedByString:@"|"];
        [pictureArray addObjectsFromArray:array];
    }else{
        
        pictureArray = self.imgArray[self.changeChapter];
    }
    
    DDLog(@"%@",pictureArray);
    for (int i =0; i< pictureArray.count; i++) {
        
        NSURL *obj = pictureArray[i];
        self.imageView = [[UIImageView alloc]init];
        self.imageView.tag = i;
        [self.imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageNamed:@"book_background"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageView setFrame:CGRectMake(i*_scrollView.frame.size.width, 0, ScreenWidth, ScreenHeight)];
        [self.scrollView addSubview:self.imageView];
    }
    
//    self.changePage = [pageStr intValue];
    self.scrollWith = _scrollView.frame.size.width*pictureArray.count;
    _scrollView.contentSize = CGSizeMake(self.scrollWith, _scrollView.frame.size.height);
}

#pragma mark -- 显示顶部的工具栏
-(void)showToolMenu{
    
    [UIView animateWithDuration:0 animations:^{
        
        _topView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self.topView showAnimation:YES];
    } completion:^(BOOL finished) {
        
    }];
}

-(LSYCatalogViewController *)catalogVC
{
    if (!_catalogVC) {
        _catalogVC = [[LSYCatalogViewController alloc] init];
//      _catalogVC.readModel = _model;
        _catalogVC.catalogDelegate = self;
    }
    return _catalogVC;
}

-(UIView *)catalogView{
    
    if (!_catalogView) {
        _catalogView = [[UIView alloc] init];
        _catalogView.backgroundColor = [UIColor clearColor];
        _catalogView.hidden = YES;
        [_catalogView addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCatalog)];
            tap.delegate = self;
            tap;
        })];
    }
    return _catalogView;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

-(void)menuViewInvokeCatalog:(pictureTopView *)menu{

    [self.topView hiddenAnimation:YES];
    [self catalogShowState:YES];
}

-(void)hiddenCatalog{
    
    [self catalogShowState:NO];
}

-(BOOL)prefersStatusBarHidden
{
    return !_showBar;
}

#pragma mark - Privite Method
-(void)catalogShowState:(BOOL)show
{
    show?({
        _catalogView.hidden = !show;
        [UIView animateWithDuration:AnimationDelay animations:^{
            _catalogView.frame = CGRectMake(0, 0,2*ViewSize(self.view).width, ViewSize(self.view).height);
            
        } completion:^(BOOL finished) {
            [_catalogView insertSubview:[[UIImageView alloc] initWithImage:[self blurredSnapshot]] atIndex:0];
        }];
    }):({
        if ([_catalogView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            [_catalogView.subviews.firstObject removeFromSuperview];
        }
        [UIView animateWithDuration:AnimationDelay animations:^{
            _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
        } completion:^(BOOL finished) {
            _catalogView.hidden = !show;
            
        }];
    });
}

- (UIImage *)blurredSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1.0f);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}

-(void)menuViewDidHidden:(pictureTopView *)menu{
    
    _showBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)){
       
        _catalogVC.view.frame = CGRectMake(0, 0, ViewSize(self.view).width-100, ViewSize(self.view).height);
        _pageViewController.view.frame = self.view.frame;
    } else {
        
        _pageViewController.view.frame = self.view.frame;
        _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
        _catalogVC.view.frame = CGRectMake(0, 0, ViewSize(self.view).width-100, ViewSize(self.view).height);
    }
    [_catalogVC reload];
}

@end
