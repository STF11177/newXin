//
//  middleTestController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "middleTestController.h"
#import "hotCell.h"
#import "hotArticleModel.h"
#import "hotAticleDetailController.h"
#import "ETMessageView.h"
#import "loginMessageController.h"
#import "backGroundView.h"

@interface middleTestController ()<UITableViewDelegate,UITableViewDataSource,backViewdelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *recommentTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) hotCell *recommCell;
@property (nonatomic,strong) NSMutableArray *cellHeightArray;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态
@property (nonatomic,assign) BOOL pullMore;//刷新
@property (nonatomic,assign) BOOL biaoJi;//标记
/** 上次选中的索引(或者控制器) */
@property (nonatomic,assign) NSInteger lastSelectedIndex;
@property (nonatomic,strong) backGroundView *backView;

@end

@implementation middleTestController
static NSString *userId;
static NSString *tokenStr;
static NSDate *lastDate;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
    
    YYReachability *reachablity = [YYReachability reachability];
    NSString *string = [NSString stringWithFormat:@"%lu",(unsigned long)reachablity.status];
    if ([string isEqualToString:@"2"]) {
        
        self.netStatus1 = YES;
    }else if ([string isEqualToString:@"1"]){
        
        self.netStatus1 = YES;
    }else{
        
        self.netStatus1 = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createHttp];
    [self createTableView];
    [self.recommentTableView registerClass:[hotCell class] forCellReuseIdentifier:NSStringFromClass([hotCell class])];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];
    
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"6",@"token":tokenStr};
    [self loadDataWithText:param];

    [self refresh];
    [self loadMore];
    //注册接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSeleted) name:@"hotRefresh" object:nil];
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"testRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

-(void)noNetStatus{
    
    if (self.dataArray.count == 0) {
        
//        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lian"]];
//        _imageView.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/5, 115, 73);
//        
//        _btnImage = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/5 + 10 +73, SCREEN_WIDTH, 44)];
//        [_btnImage.titleLabel setTextColor:[UIColor blackColor]];
//        [_btnImage setTitle:@"网络不佳，请点击屏幕重试" forState:UIControlStateNormal];
//        [_btnImage addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_btnImage setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _btnImage.titleLabel.textAlignment = NSTextAlignmentCenter;
//        
//        [self.recommentTableView addSubview:_imageView];
//        [self.recommentTableView addSubview:_btnImage];
    }
    self.netStatus1 = NO;
}

-(void)netStatus{
    
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    self.netStatus1 = YES;
    [self.backView removeFromSuperview];
    self.backView = nil;
    [self.recommentTableView.mj_header beginRefreshing];
}

-(void)netStatuswifi{
    
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    self.netStatus1 = YES;
    [self.backView removeFromSuperview];
    self.backView = nil;
    [self.recommentTableView.mj_header beginRefreshing];
}

-(void)netClickDelegate:(backGroundView *)view{

    [self.backView removeFromSuperview];
    self.backView = nil;
    [self.recommentTableView.mj_header beginRefreshing];
}

-(NSMutableArray *)cellHeightArray{
    
    if (!_cellHeightArray) {
        
        _cellHeightArray = [[NSMutableArray alloc]init];
    }
    return _cellHeightArray;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)createTableView{
    
    _dataArray = [[NSMutableArray alloc]init];
    
    _recommentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 40 , self.view.frame.size.width, self.view.frame.size.height - 40 - 64 - 10) style:UITableViewStylePlain];
    _recommentTableView.dataSource = self;
    _recommentTableView.delegate = self;
    _recommentTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_recommentTableView];
}

-(void)tabBarSeleted{
    
    // 如果本控制器的view显示在最前面，就下拉刷新
    if ([self isShowingOnKeyWindow]) { // 判断一个view是否显示在根窗口上，该方法在UIView的分类中实现
        
        //获取单击的NavigationController
        NSDate *date = [NSDate date];
//        if (date.timeIntervalSince1970 - lastDate.timeIntervalSince1970 < 0.5) {
            //完成一次双击后，重置第一次单击的时间，区分3次或多次的单击
            lastDate = [NSDate dateWithTimeIntervalSince1970:0];
            [self.recommentTableView setContentOffset:CGPointMake(0, -64)];
            [self.recommentTableView.mj_header beginRefreshing];
//        }
        lastDate = date;
    }
}

/**
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

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadDataWithText:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    
    [_manager POST:hotRecommentURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"%@",dict);
        
        [self.backView removeFromSuperview];
        self.backView = nil;
        NSArray *menuList = dict[@"menuList"];
        int status = [dict[@"status"]intValue];
        int tokenStuts = [dict[@"tokenStatus"]intValue];
        if (status == 0) {
            
            NSDictionary *dateDic = [menuList lastObject];
            _createDate = dateDic[@"createDate"];
            
            if (_pullMore == YES) {
                
                [self.dataArray removeAllObjects];
            }
            
            for (NSDictionary *appDict in menuList) {
                hotArticleModel *model = [[hotArticleModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (tokenStuts == 2) {
                    
                    self.hidesBottomBarWhenPushed=YES;
                    loginMessageController *login = [[loginMessageController alloc]init];
                    login.loginStatus = @"1";
                    [self presentViewController:login animated:NO completion:^{
                        
                    }];
                    
                    self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，t
                }
                
                _imageView.hidden = YES;
                _btnImage.hidden = YES;
                self.biaoJi = NO;
                weakSelf.recommentTableView.mj_footer.hidden = NO;
                [weakSelf.recommentTableView reloadData];
            });
            
            [weakSelf.recommentTableView.mj_header endRefreshing];
            if (!_createDate) {
                [weakSelf.recommentTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                
                [weakSelf.recommentTableView.mj_footer endRefreshing];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
        [weakSelf.recommentTableView.mj_header endRefreshing];
        [weakSelf.recommentTableView.mj_footer endRefreshing];
        
        if (self.dataArray.count == 0) {
            
            weakSelf.recommentTableView.mj_footer.hidden = YES;
            
            self.backView = [[backGroundView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.backView.delegate = self;
            [self.view addSubview:self.backView];
            
            self.biaoJi = YES;
        }else{
            
            weakSelf.recommentTableView.mj_footer.hidden = NO;
        }
    }];
}

-(void)createImage{
    
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lian"]];
    _imageView.frame = CGRectMake(SCREEN_WIDTH/3,  SCREEN_HEIGHT/5, 115, 73);
    
    _btnImage = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/5 + 10 +73, SCREEN_WIDTH, 44)];
    [_btnImage.titleLabel setTextColor:[UIColor blackColor]];
    [_btnImage setTitle:@"网络不佳，请点击屏幕重试" forState:UIControlStateNormal];
    [_btnImage addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnImage setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _btnImage.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.recommentTableView addSubview:_imageView];
    [self.recommentTableView addSubview:_btnImage];
}

-(void)btnClick{
    
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"6",@"token":tokenStr};
    [self loadDataWithText:param];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    hotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    if (!cell) {
        
        cell =[[hotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
    }
    
    hotArticleModel *model = self.dataArray[indexPath.row];
    cell.indexpath = indexPath;
    cell.hotModel = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.netStatus1 ==YES ) {
        
        hotAticleDetailController *hotDetail = [[hotAticleDetailController alloc]init];
        hotArticleModel *model = self.dataArray[indexPath.row];
        hotDetail.taskId = model.id;
        hotDetail.from_uid = userId;
        hotDetail.titleStr = model.title;
        hotDetail.contentStr = model.attachedContent;
        hotDetail.faceImage = model.imgs;
        hotDetail.fromHotAticle = @"1";
        hotDetail.userName = model.nickName;
        hotDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hotDetail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    hotArticleModel *model = self.dataArray[indexPath.row];
    hotCell *cell = [[hotCell alloc]init];
    cell.hotModel = model;
    cell.indexpath = indexPath;
    return  cell.cellHeight;
}

#pragma mark -- 刷新
-(void)refresh{
    
    __weak __typeof(self) weakSelf = self;
    self.recommentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"6",@"token":tokenStr};
        [weakSelf loadDataWithText:param];
        
        if (self.biaoJi == YES) {
            
            [self.backView removeFromSuperview];
            self.backView = nil;
        }
        
        self.pullMore = YES;
        [self.recommentTableView.mj_header beginRefreshing];
    }];
}

-(void)loadMore{

    __weak __typeof(self) weakSelf = self;
    self.recommentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",self.createDate];
        NSDictionary *param = @{@"userId":userId,@"createDate":dateStr,@"type":@"6",@"token":tokenStr};
        [weakSelf loadDataWithText:param];
        
        self.pullMore = NO;
        [self.recommentTableView.mj_footer beginRefreshing];
    }];
}

@end
