//
//  newController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "newController.h"
#import "newViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YHUtils.h"
#import "YHSharePresentView.h"
#import "YHActionSheet.h"
#import "messageDetailController.h"
#import "newStatusModel.h"
#import "AFNetworking.h"
#import "menuListModel.h"
#import "SBJson.h"
#import "menuListModel.h"
#import "YHRefreshTableView.h"
#import "newDetailController.h"
#import "commentController.h"
#import "messageDetailController.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import <UShareUI/UShareUI.h>
#import "ETMessageView.h"
#import "CommonSheet.h"
#import "sendController.h"
#import "atttionViewController.h"
#import "loginMessageController.h"

#import "XMNetWorkHelpManager.h"
#import "newVideoController.h"
#import "newVideoTableViewController.h"

@interface newController ()<UITableViewDelegate,UITableViewDataSource,newCellDelegate,UIActionSheetDelegate,CommonSheetDelegate,ZFPlayerDelegate>{
    
    AFHTTPRequestOperationManager *_manager;
    NSIndexPath *currentIndexPath;
    BOOL isSmallScreen;
}

@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,assign) NSString *createDate; //请求的时间
@property (nonatomic,strong) menuListModel *menuModel;
@property (nonatomic,strong) YHActionSheet *asheet;
@property (nonatomic,strong) CommonSheet *sheet;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,strong) newViewCell *newcell;
@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong) NSMutableArray *noCheckArray;
@property (nonatomic,strong) NSMutableArray *checkArray;
@property (nonatomic,strong) NSMutableArray *stickListArray;
@property (nonatomic,assign) BOOL loadNew;
@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态
@property (nonatomic,strong) NSString *netWifiOr4G;
@property (nonatomic,strong) NSString *netState;//是否是4g

/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation newController
static NSString *taskId;
static NSString *target_uid;
static NSString *userId;
static NSString *contentStr;
static NSString *pictureStr;
static NSString *shareTaskId;
static NSString *imgStr;
static NSString *titleStr;
static NSString *from_uid;
static NSString *nickStr;
static NSString *detailCollect;
static NSString *detailLike;
static NSString *managerStr;//管理员的userId;
static NSString *status;//是否取消屏蔽
static NSString *messageStr;
static NSString *roleStr;
static NSString *tokenStr;
static NSString *maskStatus;//屏蔽所有人
static NSString *videoStr;//视频
static NSString *videoImg;//视频封面
static NSString *showString;//是否显示屏蔽信息
static NSString *stickStr;//置顶的标记
static NSDate *lastDate;
static int collectNumber;
static int collectStatus;
static int collectNumber;

- (void)viewDidLoad{
    
    [self initUI];
    [self createHttpRequest];
    [self creatNavigationItem];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    DDLog(@"userId:%@",userId);

    [self loadManagerData];
    
    self.loadNew = YES;
    
    if (iOS11) {
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];

    NSString *userStr = [NSString stringWithFormat:@"%@",userId];
    NSString *token = [NSString stringWithFormat:@"%@",tokenStr];
    DDLog(@"rrrrr%@",tokenStr);
    DDLog(@"userId:%@",userId);
    NSDictionary *param = @{@"userId":userStr,@"createDate":@"",@"token":token};
    [self loadDataWithparam:param];
    
    [self.tableView registerClass:[newViewCell class] forCellReuseIdentifier:@"newViewCell"];
    
    //注册接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSeleted) name:@"parentRefresh" object:nil];
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
//  记录这一次选中的索引
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
    
    YYReachability *reachablity = [YYReachability reachability];
    NSString *string = [NSString stringWithFormat:@"%lu",(unsigned long)reachablity.status];
    if ([string isEqualToString:@"2"]) {
        
        _netWifiOr4G = @"wifi";
        self.netStatus1 = YES;
    }else if ([string isEqualToString:@"1"]){
        
        _netWifiOr4G = @"4G";//4G
        self.netStatus1 = YES;
    }else{
        
        _netWifiOr4G = @"noNet";
        self.netStatus1 = NO;
    }
}

-(void)dealloc{
    
//  移除通知
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.playerView resetPlayer];
}

-(void)tabBarSeleted{
    
    // 如果本控制器的view显示在最前面，就下拉刷新
    if ([self isShowingOnKeyWindow]) { // 判断一个view是否显示在根窗口上，该方法在UIView的分类中实现
    
        //获取单击的NavigationController
        NSDate *date = [NSDate date];
//        if (date.timeIntervalSince1970 - lastDate.timeIntervalSince1970 < 0.5) {
            //完成一次双击后，重置第一次单击的时间，区分3次或多次的单击
            lastDate = [NSDate dateWithTimeIntervalSince1970:0];
            [self.tableView setContentOffset:CGPointMake(0,-64)];
            [self.tableView.mj_header beginRefreshing];
//    }
        lastDate = date;
    }
}

-(void)noNetStatus{

    if (self.dataArray.count == 0) {
       
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lian"]];
        _imageView.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/5, 115, 73);
        
        _btnImage = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/5 + 10 +73, SCREEN_WIDTH, 44)];
        [_btnImage.titleLabel setTextColor:[UIColor blackColor]];
        [_btnImage setTitle:@"网络不佳，请点击屏幕重试" forState:UIControlStateNormal];
        [_btnImage addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnImage setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnImage.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.tableView addSubview:_imageView];
        [self.tableView addSubview:_btnImage];
    }
    self.netStatus1 = NO;
    _netWifiOr4G = @"noNet";//没网
}

-(void)netStatus{

    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    self.netStatus1 = YES;
    _netWifiOr4G = @"4G";//4G
    if (self.dataArray.count == 0&& _netStatus1 == YES) {
    
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"token":tokenStr};
        [self loadDataWithparam:param];
    }
    if ([self.netState isEqualToString:@"1"]) {
        
        [self.playerView pause];
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"你正在使用流量进行播放视频，是否继续播放？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.playerView resetPlayer];
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.playerView autoPlayTheVideo];
        }];
        
        [alertControl addAction:action];
        [alertControl addAction:action1];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

-(void)netStatuswifi{

    self.netStatus1 = YES;
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    _netWifiOr4G = @"wifi";//wifi
   
    if (self.dataArray.count == 0&& _netStatus1 == YES) {
        
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"token":tokenStr};
        [self loadDataWithparam:param];
    }
}

/*
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.view.frame fromView:self.view.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.view.isHidden && self.view.alpha > 0.01 && self.view.window == keyWindow && intersects;
}

- (void)initUI{
    
    _taskArray = [[NSMutableArray alloc]init];
    
    self.tableView = [[YHRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView setEnableLoadNew:YES];
    [self.tableView setEnableLoadMore:YES];
    
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.tableView registerClass:[newViewCell class] forCellReuseIdentifier:NSStringFromClass([newViewCell class])];
}

-(void) creatNavigationItem{

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"家长圈";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"add_pass"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 , 10, 20, 19)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"appear"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick1) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

#pragma mark - Lazy Load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)noCheckArray{
    if (!_noCheckArray) {
        
        _noCheckArray = [NSMutableArray array];
    }
    return _noCheckArray;
}

-(NSMutableArray *)stickListArray{
    if (!_stickListArray) {
        
        _stickListArray = [NSMutableArray array];
    }
    return _stickListArray;
}

-(void)createHttpRequest{

    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadDataWithparam:(NSDictionary *)param{
    
    newStatusModel *newStaus = [[newStatusModel alloc]init];
    _status = newStaus.status;
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:adressURl parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int tokenStuts = [dict[@"tokenStatus"]intValue];
        DDLog(@"%d",tokenStuts);
        showString = [NSString stringWithFormat:@"%@",dict[@"dynamincStatus"]];
        NSArray *menuList = dict[@"menuList"];
        NSArray *stickList = dict[@"stickNamicfoList"];
        if (_status == 0) {
            
            NSDictionary *dateDic = [menuList lastObject];
            _createDate = dateDic[@"createDate"];
            if (self.loadNew) {
                
                [self.dataArray removeAllObjects];
            }
            
            for (NSDictionary *stickDict in stickList) {

                menuListModel *model = [[menuListModel alloc]init];
                [model yy_modelSetWithDictionary:stickDict];
                [weakSelf.dataArray addObject:model];
            }
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *appDict in menuList) {
                
                menuListModel *model =[[menuListModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [array addObject:model];
                [weakSelf.taskArray addObject:model.taskId];
                [weakSelf.dataArray addObject:model];
                
                target_uid = model.from_uid;
                nickStr = model.nickName;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (tokenStuts == 2) {
                    
                    loginMessageController *login = [[loginMessageController alloc]init];
                    login.loginStatus = @"1";
                    login.hidesBottomBarWhenPushed=YES;
                    [self presentViewController:login animated:NO completion:^{
                        
                    }];
                    self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时
                }
                
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 置顶
-(void)loadStickMessageWithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:newStickURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);

        if (_status == 0) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView.mj_header beginRefreshing];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 网络请求
- (void)requestDataLoadNew:(BOOL)loadNew{
    
    YHRefreshType refreshType;
    [self.tableView loadBegin:refreshType];
    
    self.loadNew = loadNew;
    if (loadNew) {
        //请求参数
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"token":tokenStr};
        [self loadDataWithparam:param];
        refreshType = YHRefreshType_LoadNew;
        [self.tableView setNoMoreData:NO];
    }
    else{
        if (_createDate) {
            DDLog(@"_createDate:%@",_createDate);
            NSDictionary *param = @{@"userId":userId,@"createDate":_createDate,@"token":tokenStr};
            [self loadDataWithparam:param];
            refreshType = YHRefreshType_LoadMore;
        }else{
            
            [self.tableView setNoData:YES];
            [self.tableView setNoMoreData:YES];
        }
    }
    
    [self.tableView loadFinish:refreshType];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    newViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"newViewCell"];
    if (!cell) {
        cell = [[newViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newViewCell"];
        }
    menuListModel *model = self.dataArray[indexPath.row];
    cell = (newViewCell *)cell;
    cell.indexPath = indexPath;
    cell.menuListModel = model;
    cell.delegate = self;
    
    if (model.collectStatus == 0) {
        
        cell.viewBottom.btnLike.selected = YES;
        if (model.isLike) {
            
        cell.viewBottom.btnLike.selected = NO;
        }
    }

        __block newViewCell *weakCell     = cell;
        __block NSIndexPath *weakIndexPath = indexPath;
        __weak typeof(self)  weakSelf      = self;
        // 点击播放的回调
    
    cell.playBlock = ^(UIButton *btn) {
        
            DDLog(@"%@",_netWifiOr4G);
            if ([_netWifiOr4G isEqualToString:@"4G"]) {
                
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"你正在使用流量进行播放视频，是否继续播放？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    [weakSelf.playerView resetPlayer];
                }];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    menuListModel *model = weakSelf.dataArray[weakCell.indexPath.row];
                    weakCell.menuListModel = model;
                    
                    if ([model.sort isEqualToString:@"2"]) {
                        
                        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                        playerModel.fatherViewTag    = weakCell.backImageView.tag;
                        playerModel.title            = model.title;
                        NSString *URLstring = [NSString stringWithFormat:@"%@",model.imgs];
                        NSURL * url = [NSURL URLWithString:URLstring];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                           playerModel.videoURL         = url;
                        });
                        
                        playerModel.scrollView       = weakSelf.tableView;
                        playerModel.indexPath        = weakIndexPath;
                        // player的父视图tag
                        playerModel.fatherViewTag    = weakCell.backImageView.tag;
                        // weakCell.backImageView.userInteractionEnabled = YES;
                        
                        // 设置播放控制层和model
                        [weakSelf.playerView playerControlView:nil playerModel:playerModel];
                        // 下载功能
                        weakSelf.playerView.hasDownload = NO;
                        // 自动播放
                        [weakSelf.playerView autoPlayTheVideo];
                        weakSelf.netState = @"2";
                    }
                }];
                
                [alertControl addAction:action];
                [alertControl addAction:action1];
                [self presentViewController:alertControl animated:YES completion:nil];
            }else if([_netWifiOr4G isEqualToString:@"wifi"]){
                
                currentIndexPath = [NSIndexPath indexPathForRow:cell.indexPath.row inSection:0];
                menuListModel *model = self.dataArray[weakCell.indexPath.row];
                weakCell.menuListModel = model;
                if ([model.sort isEqualToString:@"2"]) {
                    
                    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                    playerModel.fatherViewTag    = weakCell.backImageView.tag;
                    playerModel.title            = model.title;
                    NSString *URLstring = [NSString stringWithFormat:@"%@",model.imgs];
                    NSURL * url = [NSURL URLWithString:URLstring];
                    
                    playerModel.videoURL         = url;
                    playerModel.scrollView       = weakSelf.tableView;
                    playerModel.indexPath        = weakIndexPath;
                    // player的父视图tag
                    playerModel.fatherViewTag    = weakCell.backImageView.tag;
                    weakCell.backImageView.userInteractionEnabled = YES;
                    
                    // 设置播放控制层和model
                    [weakSelf.playerView playerControlView:nil playerModel:playerModel];
                    // 下载功能
                    weakSelf.playerView.hasDownload = NO;
                    // 自动播放
                    [weakSelf.playerView autoPlayTheVideo];
                    self.netState = @"1";
                }
            }else{
                    self.netState = @"1";
                [self showAlertWithMessage:@"网络不佳，请稍后尝试"];
            }
        };
        return cell;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
//         当cell划出屏幕的时候停止播放
//         _playerView.stopPlayWhileCellNotVisable = YES;
//        （可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
//         _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
//         静音
//         _playerView.mute = YES;
//         移除屏幕移除player
//         _playerView.stopPlayWhileCellNotVisable = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
     
    }
    return _controlView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar

    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {

    return ZFPlayerShared.isStatusBarHidden;
}

-(void)btnClick{

    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"token":tokenStr};
    [self loadDataWithparam:param];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row < self.dataArray.count) {
            
            return [self.tableView fd_heightForCellWithIdentifier:@"newViewCell" configuration:^(newViewCell *cell) {
                [self configureOriCell:cell atIndexPath:indexPath];
            }];
        }
    return 0;
}

- (void)configureOriCell:(newViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = NO;
    if (indexPath.row < _dataArray.count) {
        cell.menuListModel = _dataArray[indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     newViewCell *cell = [[newViewCell alloc]init];
     cell.indexPath = indexPath;
     menuListModel *model = self.dataArray[cell.indexPath.row];
     cell.menuListModel = model;

    if (self.netStatus1 == YES) {
        
        if ([model.sort isEqualToString:@"2"]) {
            
            newVideoController *video = [[newVideoController alloc]init];
            video.hidesBottomBarWhenPushed=YES;
            video.URLString = model.imgs;
            video.titleStr = model.title;
            video.from_uid = userId;
            video.taskId = model.taskId;
            video.contentStr = model.content;
            video.faceImage = model.imgs;
            video.videoImg = model.voideImg;
            video.is4GOrNot = self.netWifiOr4G;
            [self.navigationController pushViewController:video animated:NO];
            self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，tabBar会恢复正常显示
        }else{
            
            newDetailController *newDetail = [[newDetailController alloc]init];
            newDetail.hidesBottomBarWhenPushed = YES;
            newDetail.taskId = model.taskId;
            newDetail.from_uid = userId;
            newDetail.titleStr = model.title;
            newDetail.contentStr = model.content;
            newDetail.faceImage = model.imgs;
            newDetail.fromStr = @"1";
            NSString *remarkStr = [NSString stringWithFormat:@"%@",model.remarkName];
            if ([ETRegularUtil isEmptyString:remarkStr]) {
                
                newDetail.userName = model.nickName;
                DDLog(@"%@",newDetail.userName);
            }else{
                
                newDetail.userName = model.remarkName;
                DDLog(@"%@",newDetail.userName);
            }
            [self.navigationController pushViewController:newDetail animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

#pragma mark - YHRefreshTableViewDelegate
- (void)refreshTableViewLoadNew:(YHRefreshTableView*)view{
    [self requestDataLoadNew:YES];
}

- (void)refreshTableViewLoadmore:(YHRefreshTableView*)view{
    [self requestDataLoadNew:NO];
}

#pragma mark - newViewCellDelegate
- (void)onAvatarInCell:(newViewCell *)cell{
    
    if (self.netStatus1 == YES) {
    
        menuListModel *model = self.dataArray[cell.indexPath.row];
        messageDetailController *detail =[[messageDetailController alloc]init];
        detail.hidesBottomBarWhenPushed=YES;
        detail.target_uid = model.from_uid;
        [self.navigationController pushViewController:detail animated:NO];
        self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，tabBar会恢复正常显示
    }else{
    
     [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

- (void)onMoreInCell:(newViewCell *)cell{
    DDLog(@"查看详情");
    if (cell.indexPath.row < [self.dataArray count]) {
        menuListModel *model = self.dataArray[cell.indexPath.row];
        model.isOpening = !model.isOpening;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)onCommentInCell:(newViewCell *)cell{
    
        menuListModel *model = self.dataArray[cell.indexPath.row];
        NSString *commentCount = [NSString stringWithFormat:@"%d",model.comment_count];
    
    if (self.netStatus1 == YES) {
    
    if ([commentCount isEqualToString:@"0"]) {
        
        commentController *comment = [[commentController alloc]init];
        comment.hidesBottomBarWhenPushed = YES;
        comment.commentTaskId = model.taskId;
        [self.navigationController pushViewController:comment animated:NO];
        self.hidesBottomBarWhenPushed = NO;
    }else{
    
        NSString *sortStr = [NSString stringWithFormat:@"%@",model.sort];
        if ([sortStr isEqualToString:@"2"]){
        
            newVideoController *newDetail = [[newVideoController alloc]init];
            newDetail.hidesBottomBarWhenPushed = YES;
            menuListModel *model = self.dataArray[cell.indexPath.row];
            newDetail.taskId = model.taskId;
            newDetail.from_uid = userId;
            newDetail.titleStr = model.title;
            newDetail.contentStr = model.content;
            
            newDetail.URLString = model.imgs;
            newDetail.contentStr = model.content;
            newDetail.faceImage = model.imgs;
            newDetail.videoImg = model.voideImg;
            
            NSString *remarkStr = [NSString stringWithFormat:@"%@",model.remarkName];
            if ([ETRegularUtil isEmptyString:remarkStr]) {
                
                newDetail.userName = model.nickName;
                DDLog(@"%@",newDetail.userName);
            }else{
                
                newDetail.userName = model.remarkName;
                DDLog(@"%@",newDetail.userName);
            }
            
            [self.navigationController pushViewController:newDetail animated:YES];
            self.hidesBottomBarWhenPushed = NO;

        }else{
            newDetailController *newDetail = [[newDetailController alloc]init];
            newDetail.hidesBottomBarWhenPushed = YES;
            menuListModel *model = self.dataArray[cell.indexPath.row];
            newDetail.taskId = model.taskId;
            newDetail.from_uid = userId;
            newDetail.titleStr = model.title;
            newDetail.contentStr = model.content;
            newDetail.faceImage = model.imgs;
            newDetail.fromStr = @"2";
            NSString *remarkStr = [NSString stringWithFormat:@"%@",model.remarkName];
            if ([ETRegularUtil isEmptyString:remarkStr]) {
                
                newDetail.userName = model.nickName;
                DDLog(@"%@",newDetail.userName);
            }else{
                
                newDetail.userName = model.remarkName;
                DDLog(@"%@",newDetail.userName);
            }
            [self.navigationController pushViewController:newDetail animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

-(void)onPulldownInCell:(newViewCell *)cell{
    
    self.newcell = cell;
    __weak typeof(self)weakSelf = self;
    menuListModel *model = weakSelf.dataArray[cell.indexPath.row];
    taskId = model.taskId;
    from_uid = model.from_uid;
    status = model.status;
    maskStatus = model.maskStatus;
    stickStr = model.stickStatus;
 
    DDLog(@"xxxxxxxx%@",maskStatus);
    
    NSString *newStickStr;
    if ([stickStr isEqualToString:@"0"]) {
        
        newStickStr = @"取消置顶";
    }else{
        
        newStickStr = @"置顶";
    }
    
    NSString *newScreenStr;
    if ([showString isEqualToString:@"1"]) {
        
        newScreenStr = @"隐藏屏蔽的信息";
    }else{
        
        newScreenStr = @"显示屏蔽的信息";
    }
    
    NSString *userStr = [NSString stringWithFormat:@"%@",userId];
    if ([[NSString stringWithFormat:@"%@",model.from_uid] isEqualToString:userStr]) {
        
        if ([roleStr isEqualToString:@"1"]) {
            
            // 1是屏蔽 0是取消屏蔽
            //maskStatus 1是屏蔽所有 0是取消屏蔽所有
            _sheet = [[CommonSheet alloc]initWithDelegate:self];
            [_sheet setupWithTitles:@[@"",@"删除"]];
        }else{
            
            DDLog(@"%@",status);
            NSString *string = [NSString stringWithFormat:@"%@",status];
            if ([string isEqualToString:@"1"]) {
                
                NSString *string1 = [NSString stringWithFormat:@"%@",maskStatus];
                if ([string1 isEqualToString:@"0"]) {
                    
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",newStickStr,@"删除",@"取消屏蔽本条信息",@"屏蔽所有信息",newScreenStr]];
                }else{
                    
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",newStickStr,@"删除",@"取消屏蔽本条信息",@"取消屏蔽所有信息",newScreenStr]];
                }
            }else{
                
                NSString *string1 = [NSString stringWithFormat:@"%@",maskStatus];
                if ([string1 isEqualToString:@"0"]) {
                    
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",newStickStr,@"删除",@"屏蔽本条信息",@"屏蔽所有信息",newScreenStr]];
                }else{
                
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",newStickStr,@"删除",@"屏蔽本条信息",@"取消屏蔽所有信息",newScreenStr]];
                }
            }
        }
    }else{
        
        //类似于管理员身份
        DDLog(@"%@",managerStr);
        DDLog(@"%@",roleStr);
        if ([roleStr isEqualToString:@"2"]) {
            NSString *string = [NSString stringWithFormat:@"%@",status];
            if ([string isEqualToString:@"1"]) {

                NSString *string1 = [NSString stringWithFormat:@"%@",maskStatus];
                if ([string1 isEqualToString:@"0"]) {
                    
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",newStickStr,@"加入黑名单",@"取消屏蔽本条信息",@"屏蔽所有信息",newScreenStr]];
                    
                }else{
                
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",newStickStr,@"加入黑名单",@"取消屏蔽本条信息",@"取消屏蔽所有信息",newScreenStr]];
                }
            }else{
                
                NSString *string1 = [NSString stringWithFormat:@"%@",maskStatus];
                if ([string1 isEqualToString:@"0"]) {
                    
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",newStickStr,@"加入黑名单",@"屏蔽本条信息",@"屏蔽所有信息",newScreenStr]];
                }else{
                    
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",newStickStr,@"加入黑名单",@"屏蔽本条信息",@"取消屏蔽所有信息",newScreenStr]];
                }
            }
        }else{
            
            _sheet = [[CommonSheet alloc]initWithDelegate:self];
            [_sheet setupWithTitles:@[@"",@"加入黑名单"]];
        }
    }
    [_sheet show];
}

#pragma mark - ***********CommonSheetDelegate***********
- (void)commonSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag{
    

    NSString *userStr = [NSString stringWithFormat:@"%@",userId];
    if ([[NSString stringWithFormat:@"%@",from_uid] isEqualToString:userStr]) {
        
        if ([roleStr isEqualToString:@"2"]) {
            
            switch ([index integerValue]) {
                    
                case 0:{
                    
                    NSDictionary *param = @{@"taskId":taskId};
                    [self loadStickMessageWithParam:param];
                }
                    break;
                    
                case 1:{
                    
                    NSDictionary *param = @{@"userId":userId,@"taskId":taskId};
                    [self loadDeteDatawithparam:param];
                }
                    break;
                case 2:{
                    
                    [self loadPingBiData];
                }
                    break;
                case 3:{
                    
                    [self loadPingBiAllMessage];
                }
                    break;
                case 4:{
                    
                    [self loadHideOrShowData];
                }
                    break;
                default:
                    break;
            }
            
        }else{
        
            switch ([index integerValue]) {
                case 0:{
                    
                    NSDictionary *param = @{@"userId":userId,@"taskId":taskId};
                    [self loadDeteDatawithparam:param];
                }
                    break;
                default:
                    break;
            }
        }
    }else{
        
        //类似于管理员身份
        DDLog(@"%@",roleStr);
        DDLog(@"%@",managerStr);
        if ([roleStr isEqualToString:@"2"]) {
            switch ([index integerValue]) {
                    
                case 0:{
                    
                    NSDictionary *param = @{@"taskId":taskId};
                    [self loadStickMessageWithParam:param];
                }
                    break;
                    
                case 1:{
                    
                    [self loadBlackListData];
                }
                    break;
                case 2:{
                    
                    [self loadPingBiData];
                }
                    break;
                case 3:{
                    
                    [self loadPingBiAllMessage];
                }
                    break;
                case 4:{
                    
                    [self loadHideOrShowData];
                }
                    break;
                default:
                    break;
            }
        }else{
            
            switch ([index integerValue]) {
                case 0:{
                    
                    [self loadBlackListData];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark -- 显示或隐藏屏蔽的消息
-(void)loadHideOrShowData{

    NSDictionary *param = @{@"userId":userId};
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:newHideOrShowURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_header beginRefreshing];
                
                if (iOS11) {
                    
                    [self.tableView setContentOffset:CGPointMake(0,-64)];
                }
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 屏蔽1条信息
-(void)loadPingBiData{

    //status 为1是屏蔽 为0是取消屏蔽
    __weak typeof(self) weakSelf = self;
    DDLog(@"%@",userId);
    DDLog(@"%@",taskId); 
    NSString *status1 = [NSString stringWithFormat:@"%@",status];
    DDLog(@"%@",status1);
    NSDictionary *param = @{@"userId":userId,@"taskId":taskId,@"status":status1};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:isPingBiURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
       int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_header beginRefreshing];
                
                if (iOS11) {
                    [self.tableView setContentOffset:CGPointMake(0,-64)];
                }
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 屏蔽所有信息
-(void)loadPingBiAllMessage{

    //status 为1是屏蔽 为0是取消屏蔽
    __weak typeof(self) weakSelf = self;
    DDLog(@"%@",userId);
    DDLog(@"%@",from_uid);
    
    NSDictionary *param = @{@"userId":userId,@"fromUserId":from_uid};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:newPingBiAllURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_header beginRefreshing];
                
                if (iOS11) {
                    
                    [self.tableView setContentOffset:CGPointMake(0,-64)];
                }
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//管理员
-(void)loadManagerData{
    
    //请求参数
    
    NSString *userStr = [NSString stringWithFormat:@"%@",userId];
//  NSString *token = [NSString stringWithFormat:@"%@",tokenStr];
    NSDictionary *param = @{@"userId":userStr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:mineURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);

        int status = [dict[@"status"]intValue];
        NSDictionary *menuDict = dict[@"menuList"];
        if (status == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *str = menuDict[@"role"];
                roleStr = [NSString stringWithFormat:@"%@",str];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark -- 加入黑名单
-(void)loadBlackListData{

    __weak typeof(self) weakSelf = self;
    DDLog(@"%@",userId);
    DDLog(@"%@",from_uid);
    NSDictionary *param = @{@"userId":userId,@"target_uid":from_uid};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:parentBlackCircleURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_header beginRefreshing];
                
                if (iOS11) {
                    [self.tableView setContentOffset:CGPointMake(0,-64)];
                }
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 删除
-(void)loadDeteDatawithparam:(NSDictionary *)param{

    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:newDeleteURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.dataArray removeObjectAtIndex:self.newcell.indexPath.row];
                [weakSelf.tableView deselectRowAtIndexPath:self.newcell.indexPath animated:YES];
                [weakSelf.tableView reloadData];
            });
    }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 收藏
-(void)createLikeData{

//    __weak typeof(self) weakSelf = self;

    DDLog(@"%d",collectNumber);
    NSDictionary *param = @{@"userId":userId,@"taskId":taskId,@"type":@"1",@"status":[NSString stringWithFormat:@"%d",collectNumber]};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:collectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        if (_status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:self.newcell.indexPath.row inSection:0];
                
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

- (void)onLikeInCell:(newViewCell *)cell{

    self.newcell = cell;
    
    menuListModel *model = self.dataArray[cell.indexPath.row];
    taskId = model.taskId;
    collectStatus = model.collectStatus;
    if (cell.indexPath.row < [self.dataArray count]) {
        menuListModel *model = self.dataArray[cell.indexPath.row];
        BOOL isLike = !model.isLike;
        model.isLike = isLike;
        if (model.collectStatus ==0) {
            
            if (isLike) {
                
                model.collect_count -= 1;
                cell.viewBottom.btnLike.selected = NO;
                collectNumber = 0;
            }else{
                
                model.collect_count += 1;
                cell.viewBottom.btnLike.selected = YES;
                collectNumber = 1;
            }
        }else{
            if (isLike) {
                
                model.collect_count += 1;
                cell.viewBottom.btnLike.selected = YES;
                collectNumber = 1;
            }else{
                
                model.collect_count -= 1;
                cell.viewBottom.btnLike.selected = NO;
                collectNumber = 0;
            }
        }
    }
    
    [self createLikeData];
}

- (void)onShareInCell:(newViewCell *)cell{
    
    if (self.netStatus1 == YES) {
    
    if (cell.indexPath.row < [self.dataArray count]){
        [self _shareWithCell:cell];
    }
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

- (void)onDeleteInCell:(newViewCell *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
    }
}

#pragma mark - private
- (void)_deleteDynAtIndexPath:(NSIndexPath *)indexPath dynamicId:(NSString *)dynamicId{
    
    WeakSelf
    [YHUtils showAlertWithTitle:@"删除动态" message:@"您确定要删除此动态?" okTitle:@"确定" cancelTitle:@"取消" inViewController:self dismiss:^(BOOL resultYes) {
        
    if (resultYes){
        
            DDLog(@"delete row is %ld",(long)indexPath.row);
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }];
}

- (void)_shareWithCell:(UITableViewCell *)cell{
    
    newViewCell *cell1   = nil;
    cell1 = (newViewCell *)cell;
    menuListModel *model = [menuListModel new];
    model = cell1.menuListModel;
    contentStr = model.content;
    shareTaskId = model.taskId;
    titleStr = model.title;
    
    NSArray *picViews =[model.imgs componentsSeparatedByString:@"|"];
    imgStr = [picViews firstObject];
    DDLog(@"%@",imgStr);
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
     if ([model.sort isEqualToString:@"2"]) {
         
         videoStr = model.imgs;
         videoImg = model.voideImg;
         [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
             
             [self shareVedioToPlatformType:platformType];
         }];
         
     }else{
     
         [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
             
             [self shareWebPageToPlatformType:platformType];
         }];
     }
}

#pragma mark -- 分享的数
-(void)shareData{

    DDLog(@"%@",shareTaskId);
    __weak typeof(self) weakSelf = self;
    //1.动态内容 2.考证 3.热文
    NSDictionary *param = @{@"taskId":shareTaskId,@"type":@"1"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:shareTaskIdURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        if (_status == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self refreshTableViewLoadNew:self.tableView];
            [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 分享视频
- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:titleStr  descr:contentStr thumImage:[UIImage imageNamed:videoImg]];
    //设置视频网页播放地址
    shareObject.videoUrl = videoStr;
    //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            [self shareData];
            NSLog(@"response data is %@",data);
        }
    }];
}

//图片
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    DDLog(@"%@",imgStr);
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]];
    UIImage *thumImage = [UIImage imageWithData:data];
    
    if (!thumImage) {
        
        thumImage = [UIImage imageNamed:@"lianjie"];
    }
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:contentStr thumImage:thumImage];
    
    //设置网页地址
     NSString *baseStr1 = [NSString stringWithFormat:@"http://www.uujz.me:8082/neworld/user/143?taskId=%@",shareTaskId];
    
     NSString *baseStr2 = [NSString stringWithFormat:@"&userId=%@",userId];
     NSString *str = [baseStr1 stringByAppendingString:baseStr2];
     DDLog(@"%@",str);
    
    shareObject.webpageUrl = str;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                [self shareData];   
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            
        }
    }];
}

#pragma mark -- 判断是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL ||[string isEqualToString:@""]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)rightBtnClick1{
    
    if (self.netStatus1 == YES) {
        
        self.hidesBottomBarWhenPushed=YES;
        sendController *sendVC =[[sendController alloc]init];
        [self.navigationController pushViewController:sendVC animated:NO];
        self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，tabBar会恢复正常显示
    }else{
    
         [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

-(void)presentLeftMenuViewController:(UIViewController*)viewController{
    
    atttionViewController *attention =[[atttionViewController alloc]init];
    attention.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:attention animated:NO];
    self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，tabBar会恢复正常显示
}

@end
