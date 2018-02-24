//
//  noAttentionController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/30.
//  Copyright © 2017年 user. All rights reserved.
//

#import "AttentionDetailController.h"
#import "newViewCell.h"
#import "UITableView+FDTemplateLayoutCellDebug.h"
#import "YHUtils.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "messageDetailController.h"
#import "newDetailController.h"
#import "commentController.h"
#import "YHActionSheet.h"
#import <UShareUI/UShareUI.h>
#import "ETMessageView.h"
#import "XMNetWorkHelpManager.h"
#import "YYReachability.h"
#import "newVideoController.h"

@interface AttentionDetailController ()<newCellDelegate,UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    NSIndexPath *currentIndexPath;
    
}

@property (nonatomic,assign) int  staus;
@property (nonatomic,assign) BOOL isRefreshing;
@property (nonatomic,assign) BOOL isLoadMore;
@property (nonatomic,strong) menuListModel *noAttenModel;
@property (nonatomic,strong) UILabel *navTitle;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) YHActionSheet *asheet;
@property (nonatomic,strong) CommonSheet *sheet;
@property (nonatomic,assign) BOOL pullMore; //加载更多
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,assign) BOOL biaoJi;
@property (nonatomic,strong) newViewCell *newcell;
@property (nonatomic,strong) NSString *netWifiOr4G;
@property (nonatomic,strong) NSString *netState;//是否是4g
@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态

@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation AttentionDetailController
static NSString *taskId;
static NSString *target_uid;
static NSString *userId;
static NSString *contentStr;
static NSString *pictureStr;
static NSString *shareTaskId;
static NSString *imgStr;
static NSString *titleStr;
static NSString *from_uid;
static NSString *status;//是否取消屏蔽
static NSString *managerStr;//管理员的userId;
static NSString *roleStr;
static NSString *videoStr;//视频
static NSString *videoImg;//视频封面
static NSString *maskStatus;//屏蔽所有人
static NSString *showString;//是否显示屏蔽信息
static int collectNumber;
static int collectStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createHttpRequest];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    DDLog(@"%@",userId);
    DDLog(@"%@",self.typeId);
    NSDictionary *param = @{@"userId":userId,@"typeId":self.typeId,@"createDate":@""};
    [self loadAttendData:param];
    [self crateView];
    [self creatNavigationItem];
    
    if (iOS11) {
        
        self.noAttenTableView.estimatedRowHeight = 0;
        self.noAttenTableView.estimatedSectionHeaderHeight = 0;
        self.noAttenTableView.estimatedSectionFooterHeight = 0;
    }
    
    self.biaoJi = YES;
    self.netStatus1 = YES;
    [self refresh];
    [self loadMore];
    [self.noAttenTableView registerClass:[newViewCell class] forCellReuseIdentifier:@"newViewCell"];
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
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

-(void)noNetStatus{
    
    if (self.noAttenArray.count == 0) {
        
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lian"]];
        _imageView.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/5, 115, 73);
        
        _btnImage = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/5 + 10 +73, SCREEN_WIDTH, 44)];
        [_btnImage.titleLabel setTextColor:[UIColor blackColor]];
        [_btnImage setTitle:@"网络不佳，请点击屏幕重试" forState:UIControlStateNormal];
        [_btnImage addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnImage setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnImage.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.noAttenTableView addSubview:_imageView];
        [self.noAttenTableView addSubview:_btnImage];
    }
    _netWifiOr4G = @"noNet";//没网
    _netStatus1 = NO;
}

-(void)netStatus{
    
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    _netStatus1 = YES;
    _netWifiOr4G = @"4G";//4G
    [self.noAttenTableView.mj_header beginRefreshing];
    
    if ([self.netState isEqualToString:@"1"]) {
        
        [self.playerView pause];
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"你正在使用流量进行播放视频，是否继续播放？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.playerView play];
        }];
        
        [alertControl addAction:action];
        [alertControl addAction:action1];
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }
}

-(void)netStatuswifi{

    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    _btnImage.hidden = YES;
    _netWifiOr4G = @"wifi";//wifi
    [self.noAttenTableView.mj_header beginRefreshing];
}

-(void) creatNavigationItem{
    
    self.navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    self.navTitle.textAlignment = NSTextAlignmentCenter;
   
    self.navTitle.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    self.navTitle.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.navTitle;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)crateView{
    
    self.noAttenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStylePlain];
    self.noAttenTableView.delegate   = self;
    self.noAttenTableView.dataSource = self;
    self.noAttenTableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.noAttenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:self.noAttenTableView];
    
}

#pragma mark - Lazy Load
- (NSMutableArray *)noAttenArray{
    if (!_noAttenArray) {
        
        _noAttenArray = [NSMutableArray array];
    }
    return _noAttenArray;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadAttendData:(NSDictionary *)param{

    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:AttenURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        _staus = [dict[@"status"]intValue];
        if (_staus == 0) {
            
            NSArray *menuList = dict[@"menuList"];
            NSDictionary *dateDic = [menuList lastObject];
            _createDate = dateDic[@"createDate"];
            DDLog(@"%@",_createDate);
            
            if (_pullMore == YES) {
                
                [self.noAttenArray removeAllObjects];
            }
            
            for (NSDictionary *appDict in menuList) {
                
                self.noAttenModel = [[menuListModel alloc]init];
                [_noAttenModel yy_modelSetWithDictionary:appDict];
                [weakSelf.noAttenArray addObject:_noAttenModel];
            }
            
            self.navTitle.text = _noAttenModel.typeName;
            DDLog(@"%@",self.navTitle.text);

            dispatch_async(dispatch_get_main_queue(), ^{
                
                _imageView.hidden = YES;
                _btnImage.hidden = YES;
                weakSelf.noAttenTableView.mj_footer.hidden = NO;
                
                [weakSelf.noAttenTableView.mj_header endRefreshing];
                [weakSelf.noAttenTableView reloadData];
            });
            
            if (!_createDate) {
                
                [weakSelf.noAttenTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                
                [weakSelf.noAttenTableView.mj_footer endRefreshing];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf.noAttenTableView.mj_header endRefreshing];
        [weakSelf.noAttenTableView.mj_footer endRefreshing];
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
        
        if (self.noAttenArray.count == 0) {
            
            weakSelf.noAttenTableView.mj_footer.hidden = YES;
            
            if (self.biaoJi == YES) {
                
                [self createImage];
                self.biaoJi = NO;
            }
        }else{
            
            weakSelf.noAttenTableView.mj_footer.hidden = NO;
        }
    }];
}

-(void)createImage{
    
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lian"]];
    _imageView.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/5, 115, 73);
    
    _btnImage = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/5 + 10 +73, SCREEN_WIDTH, 44)];
    [_btnImage.titleLabel setTextColor:[UIColor blackColor]];
    [_btnImage setTitle:@"网络不佳，请点击屏幕重试" forState:UIControlStateNormal];
    [_btnImage addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnImage setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _btnImage.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.noAttenTableView addSubview:_imageView];
    [self.noAttenTableView addSubview:_btnImage];
}

-(void)btnClick{
    
    NSDictionary *param = @{@"userId":userId,@"typeId":self.typeId,@"createDate":@""};
    [self loadAttendData:param];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.noAttenArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    newViewCell *cell = [[newViewCell alloc]init];
    cell.indexPath = indexPath;
    menuListModel *model = self.noAttenArray[cell.indexPath.row];
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
            [self.navigationController pushViewController:video animated:YES];
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
               
            }else{
                
                newDetail.userName = model.remarkName;
            }
            [self.navigationController pushViewController:newDetail animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }else{
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.noAttenArray.count) {
        
        return [self.noAttenTableView fd_heightForCellWithIdentifier:@"newViewCell" configuration:^(newViewCell *cell) {
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
    if (indexPath.row < _noAttenArray.count) {
        cell.menuListModel = _noAttenArray[indexPath.row];
    }
}

- (void)onCommentInCell:(newViewCell *)cell{
    
//    menuListModel *model = self.noAttenArray[cell.indexPath.row];
//    commentController *comment = [[commentController alloc]init];
//    comment.commentTaskId = model.taskId;
//    [self.navigationController pushViewController:comment animated:NO];
    
    menuListModel *model = self.noAttenArray[cell.indexPath.row];
    NSString *commentCount = [NSString stringWithFormat:@"%d",model.comment_count];
    
    if (self.netStatus1 == YES) {
        
        if ([commentCount isEqualToString:@"0"]) {
            
            commentController *comment = [[commentController alloc]init];
            comment.hidesBottomBarWhenPushed = YES;
            comment.commentTaskId = model.taskId;
            [self.navigationController pushViewController:comment animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else{
            
            NSString *sortStr = [NSString stringWithFormat:@"%@",model.sort];
            if ([sortStr isEqualToString:@"2"]){
                
                newVideoController *newDetail = [[newVideoController alloc]init];
                newDetail.hidesBottomBarWhenPushed = YES;
                menuListModel *model = self.noAttenArray[cell.indexPath.row];
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
                   
                }else{
                    
                    newDetail.userName = model.remarkName;
                  
                }
                
                [self.navigationController pushViewController:newDetail animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                
            }else{
                newDetailController *newDetail = [[newDetailController alloc]init];
                newDetail.hidesBottomBarWhenPushed = YES;
                menuListModel *model = self.noAttenArray[cell.indexPath.row];
                newDetail.taskId = model.taskId;
                newDetail.from_uid = userId;
                newDetail.titleStr = model.title;
                newDetail.contentStr = model.content;
                newDetail.faceImage = model.imgs;
                newDetail.fromStr = @"2";
                NSString *remarkStr = [NSString stringWithFormat:@"%@",model.remarkName];
                if ([ETRegularUtil isEmptyString:remarkStr]) {
                    
                    newDetail.userName = model.nickName;
                 
                }else{
                    
                    newDetail.userName = model.remarkName;
        
                }
                
                [self.navigationController pushViewController:newDetail animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
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
    
    menuListModel *model = self.noAttenArray[indexPath.row];
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
        
        if ([_netWifiOr4G isEqualToString:@"4G"]) {
            
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"你正在使用流量进行播放视频，是否继续播放？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                currentIndexPath = [NSIndexPath indexPathForRow:cell.indexPath.row inSection:0];
                NSLog(@"currentIndexPath.row = %ld",currentIndexPath.row);
                menuListModel *model = self.noAttenArray[weakCell.indexPath.row];
                weakCell.menuListModel = model;
                
                if ([model.sort isEqualToString:@"2"]) {
                    
                    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                    playerModel.fatherViewTag    = weakCell.backImageView.tag;
                    playerModel.title            = model.title;
                    NSString *URLstring = [NSString stringWithFormat:@"%@",model.imgs];
                    NSURL * url = [NSURL URLWithString:URLstring];
                    
                    playerModel.videoURL         = url;
                    playerModel.scrollView       = weakSelf.noAttenTableView;
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
            menuListModel *model = self.noAttenArray[weakCell.indexPath.row];
            weakCell.menuListModel = model;
            if ([model.sort isEqualToString:@"2"]) {
                
                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                playerModel.fatherViewTag    = weakCell.backImageView.tag;
                playerModel.title            = model.title;
                NSString *URLstring = [NSString stringWithFormat:@"%@",model.imgs];
                NSURL * url = [NSURL URLWithString:URLstring];
                
                playerModel.videoURL         = url;
                playerModel.scrollView       = weakSelf.noAttenTableView;
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
    
    __weak typeof(self) weakSelf = self;
 
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
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.noAttenTableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
  }];
}

- (void)onShareInCell:(newViewCell *)cell{
    if (cell.indexPath.row < [self.noAttenArray count]){
        [self _shareWithCell:cell];
    }
}

- (void)onLikeInCell:(newViewCell *)cell{
    
    menuListModel *model = self.noAttenArray[cell.indexPath.row];
    taskId = model.taskId;
    collectStatus = model.collectStatus;
    
    if (cell.indexPath.row < [self.noAttenArray count]) {
        menuListModel *model = self.noAttenArray[cell.indexPath.row];
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
    
    menuListModel *model = self.noAttenArray[cell.indexPath.row];
    messageDetailController *chat =[[messageDetailController alloc]init];
    chat.target_uid = model.from_uid;
    chat.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:chat animated:YES];
    self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，tabBar会恢复正常显示
}

- (void)onMoreInCell:(newViewCell *)cell{
    
    if (cell.indexPath.row < [self.noAttenArray count]) {
        menuListModel *model = self.noAttenArray[cell.indexPath.row];
        model.isOpening = !model.isOpening;
        [self.noAttenTableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    DDLog(@"%@",titleStr);
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
                
                menuListModel *model = self.noAttenArray[self.newcell.indexPath.row];
                self.newcell.menuListModel = model;
                model.transmit_count += 1;
                [weakSelf.noAttenTableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
    NSString *baseStr1 = [NSString stringWithFormat:@"http://www.uujz.me:8082/neworld/user/143?userId=%@",userId];
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
    
    self.newcell = cell;
    __weak typeof(self)weakSelf = self;
    menuListModel *model = weakSelf.noAttenArray[cell.indexPath.row];
    taskId = model.taskId;
    from_uid = model.from_uid;
    status = model.status;
    maskStatus = model.maskStatus;
    
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
                    
                    if ([showString isEqualToString:@"1"]) {
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"删除",@"取消屏蔽本条信息",@"屏蔽所有信息",@"隐藏屏蔽的信息"]];
                    }else{
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"删除",@"取消屏蔽本条信息",@"屏蔽所有信息",@"显示屏蔽的信息"]];
                    }
                }else{
                    
                    if ([showString isEqualToString:@"1"]) {
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"删除",@"取消屏蔽本条信息",@"取消屏蔽所有信息",@"隐藏屏蔽的信息"]];
                    }else{
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"删除",@"取消屏蔽本条信息",@"取消屏蔽所有信息",@"显示屏蔽的信息"]];
                    }
                }
            }else{
                
                NSString *string1 = [NSString stringWithFormat:@"%@",maskStatus];
                if ([string1 isEqualToString:@"0"]) {
                    
                    if ([showString isEqualToString:@"1"]) {
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"删除",@"屏蔽本条信息",@"屏蔽所有信息",@"隐藏屏蔽的信息"]];
                    }else{
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"删除",@"屏蔽本条信息",@"屏蔽所有信息",@"显示屏蔽的信息"]];
                    }
                }else{
                    
                    if ([showString isEqualToString:@"1"]) {
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"删除",@"屏蔽本条信息",@"取消屏蔽所有信息",@"隐藏屏蔽的信息"]];
                    }else{
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"删除",@"屏蔽本条信息",@"取消屏蔽所有信息",@"显示屏蔽的信息"]];
                    }
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
                    if ([showString isEqualToString:@"1"]) {
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"加入黑名单",@"取消屏蔽本条信息",@"屏蔽所有信息",@"隐藏屏蔽的信息"]];
                        
                    }else{
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"加入黑名单",@"取消屏蔽本条信息",@"屏蔽所有信息",@"显示屏蔽的信息"]];
                    }
                }else{
                    
                    if ([showString isEqualToString:@"1"]) {
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"加入黑名单",@"取消屏蔽本条信息",@"取消屏蔽所有信息",@"隐藏屏蔽的信息"]];
                        
                    }else{
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"加入黑名单",@"取消屏蔽本条信息",@"取消屏蔽所有信息",@"显示屏蔽的信息"]];
                    }
                }
            }else{
                
                NSString *string1 = [NSString stringWithFormat:@"%@",maskStatus];
                if ([string1 isEqualToString:@"0"]) {
                    
                    if ([showString isEqualToString:@"1"]) {
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"加入黑名单",@"屏蔽本条信息",@"屏蔽所有信息",@"隐藏屏蔽的信息"]];
                        
                    }else{
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"加入黑名单",@"屏蔽本条信息",@"屏蔽所有信息",@"显示屏蔽的信息"]];
                    }
                }else{
                    
                    if ([showString isEqualToString:@"1"]) {
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"加入黑名单",@"屏蔽本条信息",@"取消屏蔽所有信息",@"隐藏屏蔽的信息"]];
                        
                    }else{
                        
                        _sheet = [[CommonSheet alloc]initWithDelegate:self];
                        [_sheet setupWithTitles:@[@"",@"加入黑名单",@"屏蔽本条信息",@"取消屏蔽所有信息",@"显示屏蔽的信息"]];
                    }
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
                    
                    NSDictionary *param = @{@"userId":userId,@"taskId":taskId};
                    [self loadDeteDatawithparam:param];
                }
                    break;
                case 1:{
                    
                    [self loadPingBiData];
                }
                    break;
                case 2:{
                    
                    [self loadPingBiAllMessage];
                }
                    break;
                case 3:{
                    
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
                    
                    [self loadBlackListData];
                }
                    break;
                case 1:{
                    
                    [self loadPingBiData];
                }
                    break;
                case 2:{
                    
                    [self loadPingBiAllMessage];
                }
                    break;
                case 3:{
                    
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
                
                [self.noAttenTableView.mj_header beginRefreshing];
                [weakSelf.noAttenTableView reloadData];
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
                
                [self.noAttenTableView.mj_header beginRefreshing];
                [weakSelf.noAttenTableView reloadData];
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
                
                [weakSelf.noAttenTableView.mj_header beginRefreshing];
                [weakSelf.noAttenTableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//管理员
-(void)loadManagerData{
    
    //请求参数
    
    NSString *userStr = [NSString stringWithFormat:@"%@",userId];
    //    NSString *token = [NSString stringWithFormat:@"%@",tokenStr];
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
                
                [self.noAttenTableView.mj_header beginRefreshing];
                [weakSelf.noAttenTableView                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                reloadData];
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
                
                [weakSelf.noAttenArray removeObjectAtIndex:self.newcell.indexPath.row];
                [weakSelf.noAttenTableView deselectRowAtIndexPath:self.newcell.indexPath animated:YES];
                [weakSelf.noAttenTableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 刷新
-(void)refresh{
    
    __weak __typeof(self) weakSelf = self;
    self.noAttenTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSDictionary *param = @{@"userId":userId,@"typeId":self.typeId,@"createDate":@""};
        [weakSelf loadAttendData:param];
        _pullMore = YES;
        [weakSelf.noAttenTableView.mj_header beginRefreshing];
    }];
}

-(void)loadMore{

    __weak __typeof(self) weakSelf = self;
    self.noAttenTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",_createDate];
        NSDictionary *param = @{@"userId":userId,@"typeId":self.typeId,@"createDate":dateStr};
        [weakSelf loadAttendData:param];
        _pullMore = NO;
        [self.noAttenTableView.mj_footer beginRefreshing];
    }];
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:YES];
}

@end
