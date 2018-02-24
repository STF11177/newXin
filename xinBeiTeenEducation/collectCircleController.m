//
//  CircleCollectController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/12.
//  Copyright © 2017年 user. All rights reserved.
//

#import "collectCircleController.h"
#import "newViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "newDetailController.h"
#import "messageDetailController.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "commentController.h"
#import <UShareUI/UShareUI.h>
#import "ETMessageView.h"
#import "newVideoController.h"
#import "backGroundView.h"

@interface collectCircleController ()<UITableViewDelegate,UITableViewDataSource,newCellDelegate,ZFPlayerDelegate,backViewdelegate>
{
    AFHTTPRequestOperationManager *_manager;
    NSIndexPath *currentIndexPath;
}
@property (nonatomic,strong) NSString *createDate; //请求的时间
@property (nonatomic,assign) BOOL pullMore; //加载更多
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,assign) BOOL biaoJi;
@property (nonatomic,assign) BOOL netStatus1;
@property (nonatomic,strong) newViewCell *newcell;
@property (nonatomic,strong) NSString *netWifiOr4G;
@property (nonatomic,strong) NSString *netState;//是否是4g

@property (nonatomic, strong) backGroundView      *backView;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation collectCircleController
static NSString *taskId;
static NSString *target_uid;
static NSString *userId;
static NSString *contentStr;
static NSString *pictureStr;
static NSString *shareTaskId;
static NSString *imgStr;
static NSString *titleStr;
static NSString *status;
static NSString *nickStr;
static int collectNumber;
static int collectStatus;
static NSString *shareStatus;
static NSString *videoStr;//视频
static NSString *videoImg;//视频封面

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createHttpRequest];
    
//    self.fd_interactivePopDisabled = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    DDLog(@"%@",userId);
    
    self.biaoJi = YES;
    self.netStatus1 = YES;
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"1"};
    [self loadDatawithParam:param];
    
    [self refresh];
    [self loadMore];
    [self.tableView registerClass:[newViewCell class] forCellReuseIdentifier:@"newViewCell"];
    
    if (iOS11) {
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

     [self.playerView resetPlayer];
}

-(void)noNetStatus{
    
    _netWifiOr4G = @"noNet";
    self.netStatus1 = NO;
    [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
}

-(void)netStatus{
    
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    self.netStatus1 = YES;
    [self.backView removeFromSuperview];
    [self.tableView.mj_header beginRefreshing];
    _netWifiOr4G = @"4G";
}

-(void)netStatuswifi{

    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    self.netStatus1 = YES;
    [self.backView removeFromSuperview];
    [self.tableView.mj_header beginRefreshing];
    
    _netWifiOr4G = @"wifi";//4G
}

-(void)netClickDelegate:(backGroundView *)view{

    [self.backView removeFromSuperview];
    [self.tableView.mj_header beginRefreshing];
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

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)btnClick{
    
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"1"};
    [self loadDatawithParam:param];
}

-(void)createNav{
    
    self.dataArray = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"圈子收藏";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_WIDTH*0.1, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goToCollect) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(UITableView *)tableView{

    if (!_tableView) {
        
        self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc]init];
        self.tableView.separatorStyle = UITableViewCellAccessoryNone;
        self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
        self.dataArray = [[NSMutableArray alloc]init];
        [self.view addSubview:self.tableView];
    }
    
    return _tableView;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark -- 下载
-(void)loadDatawithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:circleCollectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int staus = [dict[@"status"]intValue];
        if (staus == 0) {
            
            if (_pullMore == YES) {
            
                [self.dataArray removeAllObjects];
            }
            
            NSArray *menuList = dict[@"menuList"];
            NSDictionary *dateDic = [menuList lastObject];
            _createDate = dateDic[@"createDate"];
    
            for (NSDictionary *appDict in menuList) {
                
                menuListModel *model =[[menuListModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [weakSelf.dataArray addObject:model];
                nickStr = model.nickName;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _imageView.hidden = YES;
                _btnImage.hidden = YES;
                weakSelf.tableView.mj_footer.hidden = NO;
                [weakSelf.tableView reloadData];
            });
            
            [self.backView removeFromSuperview];
            
            [weakSelf.tableView.mj_header endRefreshing];
            if (!_createDate) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
        
        if (self.dataArray.count == 0) {
            
            weakSelf.tableView.mj_footer.hidden = YES;
            
            self.backView = [[backGroundView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.backView.delegate = self;
            [self.view addSubview:self.backView];
            
        }else{
            
            weakSelf.tableView.mj_footer.hidden = NO;
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.dataArray.count) {
        
        return [self.tableView fd_heightForCellWithIdentifier:@"newViewCell" configuration:^(newViewCell *cell) {
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
    if (indexPath.row < _dataArray.count) {
        cell.menuListModel = _dataArray[indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    menuListModel *model = self.dataArray[indexPath.row];
    
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    newViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"newViewCell"];
    if (!cell) {
        cell =[[newViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newViewCell"];
    }
    
    menuListModel *model = self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.menuListModel = model;
    cell.delegate = self;
    
    cell.imgArrow.hidden = YES;
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
                    self.netState = @"2";
                }
            }];
            
            [alertControl addAction:action];
            [alertControl addAction:action1];
            [self presentViewController:alertControl animated:YES completion:nil];
        }else if([_netWifiOr4G isEqualToString:@"wifi"]){
            
            currentIndexPath = [NSIndexPath indexPathForRow:cell.indexPath.row inSection:0];
            NSLog(@"currentIndexPath.row = %ld",currentIndexPath.row);
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
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
        // 移除屏幕移除player
        // _playerView.stopPlayWhileCellNotVisable = YES;
        
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
        
    }
    return _controlView;
}


#pragma mark -- 收藏
-(void)loadData{
    
    DDLog(@"%@",taskId);
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
                
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

- (void)onLikeInCell:(newViewCell *)cell{
    
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
    
    [self loadData];
}

#pragma mark - newViewCellDelegate
- (void)onAvatarInCell:(newViewCell *)cell{
    
    if (_netStatus1 == YES) {
        
        menuListModel *model = self.dataArray[cell.indexPath.row];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:model.from_uid forKey:@"from_uid"];
        
        messageDetailController *chat =[[messageDetailController alloc]init];
        chat.target_uid = model.from_uid;
        chat.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:chat animated:NO];
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
    
    DDLog(@"%@",titleStr);
    DLog(@"%@",contentStr);
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


#pragma mark -- 分享的数
-(void)shareData{
    
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
                
                menuListModel *model = self.dataArray[self.newcell.indexPath.row];
                self.newcell.menuListModel = model;
                model.transmit_count += 1;
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 刷新
-(void)refresh{
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"1"};
        [weakSelf loadDatawithParam:param];
        _pullMore = YES;
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

-(void)loadMore{

    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",_createDate];
        NSDictionary *param = @{@"userId":userId,@"createDate":dateStr,@"type":@"1"};
        [weakSelf loadDatawithParam:param];
        _pullMore = NO;
        [self.tableView.mj_footer beginRefreshing];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(void)goToCollect{
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
