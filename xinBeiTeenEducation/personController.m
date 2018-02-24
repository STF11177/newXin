//
//  personController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/21.
//  Copyright © 2017年 user. All rights reserved.
//

#import "personController.h"
#import "newViewCell.h"
#import "UITableView+FDTemplateLayoutCellDebug.h"
#import "YHRefreshTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "newController.h"
#import "YHUtils.h"
#import "menuListModel.h"
#import "messageDetailController.h"
#import "commentController.h"
#import "newDetailController.h"
#import <UShareUI/UShareUI.h>
#import "ETRegularUtil.h"
#import "ETMessageView.h"
#import "newVideoController.h"
#import "ZFPlayerView.h"

@interface personController ()<newCellDelegate,UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
{

    AFHTTPRequestOperationManager *_manager;
//    WMPlayer *wmPlayer;
    NSIndexPath *currentIndexPath;
    BOOL isSmallScreen;
    
}

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UIImageView *headImg;

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *headLab;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *sepeView;
@property (nonatomic,assign) int stus;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,assign) BOOL isRefreshing;
@property (nonatomic,assign) BOOL loadNew;
@property (nonatomic,assign) NSString *createDate; //请求的时间
@property (nonatomic,strong) menuListModel *personMdoel;

@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态
@property (nonatomic,strong) NSString *netWifiOr4G;
@property (nonatomic,strong) NSString *netState;//是否是4g

@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation personController

static NSString  *managerCellId = @"newViewCell";
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
static NSString *remarkStr;
static NSString *detailCollect;
static NSString *detailLike;
static NSString *faceImg;
static NSString *tokenStr;
static NSString *videoStr;//视频
static NSString *videoImg;//视频封面
static int collectNumber;
static int collectStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createHttpRequest];
    
    self.hidesBottomBarWhenPushed = YES;
//    self.fd_interactivePopDisabled = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];
    
    DDLog(@"%@",userId);
    DDLog(@"%@",self.target_uid);
    NSDictionary *param = @{@"userId":userId,@"target_uid":self.target_uid,@"createDate":@""};
    [self loadDataWithParam:param];
    
    [self crateView];
    [self creatNavigationItem];
    [self.refreshTableView registerClass:[newViewCell class] forCellReuseIdentifier:managerCellId];
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    YYReachability *reachablity = [YYReachability reachability];
    NSString *string = [NSString stringWithFormat:@"%lu",(unsigned long)reachablity.status];
    if ([string isEqualToString:@"2"]) {
        
        _netWifiOr4G = @"wifi";
    }else if ([string isEqualToString:@"1"]){
        
        _netWifiOr4G = @"4G";//4G
    }else{
        
        _netWifiOr4G = @"noNet";
    }
    DDLog(@"%@",_netWifiOr4G);
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [self.playerView resetPlayer];
}

-(void)noNetStatus{
    
    if (self.personArray.count == 0) {
        
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lian"]];
        _imageView.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/5, 115, 73);
        
        _btnImage = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/5 + 10 +73, SCREEN_WIDTH, 44)];
        [_btnImage.titleLabel setTextColor:[UIColor blackColor]];
        [_btnImage setTitle:@"网络不佳，请点击屏幕重试" forState:UIControlStateNormal];
        [_btnImage addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnImage setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnImage.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.refreshTableView addSubview:_imageView];
        [self.refreshTableView addSubview:_btnImage];
        _netStatus1 = YES;
    }
    
    _netWifiOr4G = @"noNet";//没网
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)btnClick{
    
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"token":tokenStr};
    [self loadDataWithParam:param];
}

-(void)netStatus{
    
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    
    _netWifiOr4G = @"4G";//4G
    if (self.personArray.count == 0&& _netStatus1 == YES) {
        
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"token":tokenStr};
        [self loadDataWithParam:param];
    }
}

-(void)netStatuswifi{
    
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    _netWifiOr4G = @"wifi";//wifi
    if (self.personArray.count == 0&& _netStatus1 == YES) {
        
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"token":tokenStr};
        [self loadDataWithParam:param];
    }
}

-(void) creatNavigationItem{
    
    self.navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    self.navTitle.textAlignment = NSTextAlignmentCenter;
    self.navTitle.text = self.titleStr;
    self.navTitle.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    self.navTitle.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.navTitle;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)crateView{
    
    self.refreshTableView = [[YHRefreshTableView alloc] initWithFrame:CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height +44) style:UITableViewStyleGrouped];
    self.refreshTableView.delegate   = self;
    self.refreshTableView.dataSource = self;
    self.refreshTableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableView.tableHeaderView = self.headView;
    if (iOS11) {
        
        self.refreshTableView.estimatedRowHeight = 0;
        self.refreshTableView.estimatedSectionHeaderHeight = 0;
        self.refreshTableView.estimatedSectionFooterHeight = 0;
        self.refreshTableView.sectionFooterHeight = 0.1f;
    }
    
    [self.view addSubview:self.refreshTableView];
    [self.refreshTableView setEnableLoadNew:YES];
    [self.refreshTableView setEnableLoadMore:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        UIView *headView = [[UIView alloc]init];
        self.headView = headView;
        self.headView.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc]init];
        self.imgView.layer.cornerRadius = 32.5;
        self.imgView.layer.masksToBounds = YES;
        self.imgView.userInteractionEnabled = YES;
        [self.headView addSubview:self.imgView];
        
        self.headLab = [[UILabel alloc]init];
        self.headLab.textAlignment = NSTextAlignmentCenter;
        [self.headView addSubview:self.headLab];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [self.headView addSubview:self.lineView];
        
        self.nameLable = [[UILabel alloc]init];
        [self.headView addSubview:self.nameLable];
        
        self.sepeView = [[UIView alloc]init];
        self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [self.headView addSubview:self.sepeView];
        
        self.nameLable.text = [NSString stringWithFormat:@"文章(%@)",_artCount];
        DDLog(@"%@",_personMdoel);
        
        if ([ETRegularUtil isEmptyString:remarkStr]) {
            
            self.headLab.text = [NSString stringWithFormat:@"%@",nickStr];
        }else{
            
            self.headLab.text =[NSString stringWithFormat:@"%@",remarkStr];
        }
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:faceImg]placeholderImage:[UIImage imageNamed:@"background"]];
        
        [self layoutPersonUI];
        return self.headView;
    }else{
    
        return 0;
    }
}

#pragma mark - Lazy Load
- (NSMutableArray *)personArray{
    if (!_personArray) {
        
        _personArray = [NSMutableArray array];
    }
    return _personArray;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadDataWithParam:(NSDictionary *)param{
    
    newStatusModel *newStaus = [[newStatusModel alloc]init];
    _stus = newStaus.status;
    __weak typeof(self) weakSelf = self;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    [_manager POST:detailURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        if (_stus == 0) {
            
            if (self.loadNew) {
                
                [self.personArray removeAllObjects];
            }
            NSArray *menuList = dict[@"menuList"];
            NSDictionary *dateDic = [menuList lastObject];
            _createDate = dateDic[@"createDate"];
            
            for (NSDictionary *appDict in menuList) {
 
                self.personMdoel = [[menuListModel alloc]init];
                [self.personMdoel yy_modelSetWithDictionary:appDict];
                [weakSelf.personArray addObject:_personMdoel];
                
                target_uid = self.personMdoel.from_uid;
                nickStr = self.personMdoel.nickName;
                remarkStr = self.personMdoel.remarkName;
                faceImg = self.personMdoel.faceImg;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.refreshTableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf.refreshTableView.mj_header endRefreshing];
        [weakSelf.refreshTableView.mj_footer endRefreshing];
        [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(void)layoutPersonUI{
    __weak typeof(self)weakSelf = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView).offset(25);
        make.centerX.equalTo(weakSelf.headView.mas_centerX);
        make.width.height.mas_equalTo(65);
    }];

    [self.headLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgView.mas_bottom);
        make.centerX.equalTo(weakSelf.headView.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headLab.mas_bottom).offset(20);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.headView).offset(15);
        make.bottom.equalTo(weakSelf.sepeView.mas_top).offset(-10);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.personArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section < self.personArray.count) {
        
        return [self.refreshTableView fd_heightForCellWithIdentifier:@"newViewCell" configuration:^(newViewCell *cell) {
            [self configureOriCell:cell atIndexPath:indexPath];
        }];
    }
    else{
        return 44.0f;
    }
}

- (void)configureOriCell:(newViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = NO;
    if (indexPath.section < _personArray.count) {
        cell.menuListModel = _personArray[indexPath.section];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    menuListModel *model = self.personArray[indexPath.section];
    
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
        video.is4GOrNot = _netWifiOr4G;
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
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    newViewCell *cell =[tableView dequeueReusableCellWithIdentifier:managerCellId];
    if (!cell) {
        cell =[[newViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:managerCellId];
    }
    menuListModel *model = self.personArray[indexPath.section];
    cell.indexPath = indexPath;
    cell.menuListModel = model;
    cell.imgArrow.hidden = YES;
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
                
                [self.playerView resetPlayer];
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                currentIndexPath = [NSIndexPath indexPathForRow:cell.indexPath.row inSection:0];
                NSLog(@"currentIndexPath.row = %ld",currentIndexPath.row);
                menuListModel *model = self.personArray[weakCell.indexPath.row];
                weakCell.menuListModel = model;
                
                if ([model.sort isEqualToString:@"2"]) {
                    
                    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                    playerModel.fatherViewTag    = weakCell.backImageView.tag;
                    playerModel.title            = model.title;
                    NSString *URLstring = [NSString stringWithFormat:@"%@",model.imgs];
                    NSURL * url = [NSURL URLWithString:URLstring];
                    
                    playerModel.videoURL         = url;
                    playerModel.scrollView       = weakSelf.refreshTableView;
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
                    self.netState = @"2";
                }
            }];
            
            [alertControl addAction:action];
            [alertControl addAction:action1];
            [self presentViewController:alertControl animated:YES completion:nil];
        }else if([_netWifiOr4G isEqualToString:@"wifi"]){
            
            currentIndexPath = [NSIndexPath indexPathForRow:cell.indexPath.row inSection:0];
            NSLog(@"currentIndexPath.row = %ld",currentIndexPath.row);
            menuListModel *model = self.personArray[weakCell.indexPath.row];
            weakCell.menuListModel = model;
            if ([model.sort isEqualToString:@"2"]) {
                
                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                playerModel.fatherViewTag    = weakCell.backImageView.tag;
                playerModel.title            = model.title;
                NSString *URLstring = [NSString stringWithFormat:@"%@",model.imgs];
                NSURL * url = [NSURL URLWithString:URLstring];
                
                playerModel.videoURL         = url;
                playerModel.scrollView       = weakSelf.refreshTableView;
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
            [self showAlertWithMessage:@"网路不佳，请稍后尝试"];
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

#pragma mark - 网络请求
- (void)requestDataLoadNew:(BOOL)loadNew{
    
    YHRefreshType refreshType;
    [self.refreshTableView loadBegin:refreshType];
    
    self.loadNew = loadNew;
    if (loadNew) {
        //请求参数
        
        NSDictionary *param = @{@"userId":userId,@"target_uid":self.target_uid,@"createDate":@""};
        [self loadDataWithParam:param];
        refreshType = YHRefreshType_LoadNew;
        [self.refreshTableView setNoMoreData:NO];
    }
    else{
        
        if (_createDate) {
            DDLog(@"%@",_createDate);
            NSDictionary *param = @{@"userId":userId,@"target_uid":self.target_uid,@"createDate":_createDate};
            [self loadDataWithParam:param];
            refreshType = YHRefreshType_LoadMore;
        }else{
            
            [self.refreshTableView setNoData:YES];
            [self.refreshTableView setNoMoreData:YES];
        }
    }
    
    [self.refreshTableView loadFinish:refreshType];
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
    
//    if (self.netStatus1 == YES) {
    
        menuListModel *model = self.personArray[cell.indexPath.section];
        DDLog(@"model.from_uid%@",model.from_uid);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:model.from_uid forKey:@"from_uid"];
        
        messageDetailController *chat =[[messageDetailController alloc]init];
        chat.target_uid = model.from_uid;
        chat.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:chat animated:NO];
        self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，tabBar会恢复正常显示
//    }else{
//
//        [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
//    }
}

#pragma mark -- 头像
- (void)onMoreInCell:(newViewCell *)cell{
    DDLog(@"查看详情");
    if (cell.indexPath.section < [self.personArray count]) {
        menuListModel *model = self.personArray[cell.indexPath.section];
        model.isOpening = !model.isOpening;
        [self.refreshTableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)onCommentInCell:(newViewCell *)cell{
    
    menuListModel *model = self.personArray[cell.indexPath.section];
    NSString *commentCount = [NSString stringWithFormat:@"%d",model.comment_count];
    
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
            menuListModel *model = self.personArray[cell.indexPath.section];
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
            menuListModel *model = self.personArray[cell.indexPath.section];
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
}

#pragma mark -- 收藏
-(void)loadData{
    
    DDLog(@"%d",collectStatus);
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"userId":userId,@"taskId":taskId,@"type":@"1",@"status":[[NSString alloc]initWithFormat:@"%d",collectNumber]};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:collectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
       int status = [dict[@"status"]intValue];
        
        if (status == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.refreshTableView reloadData];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
}

- (void)onLikeInCell:(newViewCell *)cell{
    
    menuListModel *model = self.personArray[cell.indexPath.section];
    taskId = model.taskId;
    collectStatus = model.collectStatus;
    
    if (cell.indexPath.section < [self.personArray count]) {
        menuListModel *model = self.personArray[cell.indexPath.section];
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
    
    [self loadData];
}

- (void)onShareInCell:(newViewCell *)cell{
    if (cell.indexPath.section < [self.personArray count]){
        [self _shareWithCell:cell];
        
    }
}

- (void)onDeleteInCell:(newViewCell *)cell{
    if (cell.indexPath.section < [self.personArray count]) {
        //     [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.statusModel.dynamicId];
    }
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
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
 
                [weakSelf refreshTableViewLoadNew:weakSelf.refreshTableView];
                [weakSelf.refreshTableView reloadData];
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

#pragma mark -- 图片
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    DDLog(@"%@",imgStr);
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:contentStr thumImage:imgStr];
    
    //设置网页地址
    NSString *baseStr1 = [NSString stringWithFormat:@"http://www.uujz.me:8082/neworld/user/143?taskId=%@",userId];
    NSString *baseStr2 = [NSString stringWithFormat:@"&taskId=%@",shareTaskId];
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

-(void)onPulldownInCell:(newViewCell *)cell{

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        
        return 170;
    }else{
    
        return 0.1f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1f;
}

-(void)presentController{

    [self.navigationController popViewControllerAnimated:NO];
}

@end
