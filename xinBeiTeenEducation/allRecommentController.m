//
//  allRecommentController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "allRecommentController.h"
#import "ADCell.h"
#import "textualResearchCell.h"
#import "textDetailController.h"
#import "allRecommentModel.h"
#import "detailController.h"
#import "ETMessageView.h"
#import "loginMessageController.h"
#import "backGroundView.h"

@interface allRecommentController ()<UITableViewDelegate,UITableViewDataSource,textualCellDelegate,backViewdelegate>{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,assign) BOOL pullNew;
@property (nonatomic,assign) BOOL biaoJi;
@property (nonatomic,assign) BOOL netStatus1;
@property (nonatomic,strong) backGroundView *backView;

/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation allRecommentController
static NSString *userId;
static NSString *tokenStr;
static NSDate *lastDate;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    [self createTableView];
    [self createHttpRequest];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];
    
    NSDictionary *param = @{@"type":@"0",@"CreateDate":@"",@"userId":userId,@"token":tokenStr};
    [self loadAllDataWithParam:param];

    [self refresh];
    [self loadMore];
    [self.tableView registerClass:[textualResearchCell class] forCellReuseIdentifier:@"textualResearchCell"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    //注册接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSeleted) name:@"testRefresh" object:nil];
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

- (void)dealloc{
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"testRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

-(void)noNetStatus{

    if (self.dataArray.count == 0) {

    }
    self.netStatus1 = NO;
}

-(void)netStatus{

    self.netStatus1 = YES;
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    [self.backView removeFromSuperview];
    self.backView = nil;
    [self.tableView.mj_header beginRefreshing];
}

-(void)netStatuswifi{

    self.netStatus1 = YES;
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    [self.backView removeFromSuperview];
    self.backView = nil;
    [self.tableView.mj_header beginRefreshing];
}

-(void)netClickDelegate:(backGroundView *)view{

    [self.backView removeFromSuperview];
    self.backView = nil;
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)tabBarSeleted{
    
    // 如果本控制器的view显示在最前面，就下拉刷新
    if ([self isShowingOnKeyWindow]) { // 判断一个view是否显示在根窗口上，该方法在UIView的分类中实现
    
        //获取单击的NavigationController
        NSDate *date = [NSDate date];
//        if (date.timeIntervalSince1970 - lastDate.timeIntervalSince1970 < 0.5) {
            //完成一次双击后，重置第一次单击的时间，区分3次或多次的单击
            lastDate = [NSDate dateWithTimeIntervalSince1970:0];
            [self.tableView setContentOffset:CGPointMake(0, -64)];
            [self.tableView.mj_header beginRefreshing];
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

-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0, 64 +40, SCREEN_WIDTH, SCREEN_HEIGHT - 64-40) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 6;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    if (iOS11) {
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:self.tableView];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma make -- 全部
-(void)loadAllDataWithParam:(NSDictionary *)param{
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:testTypeURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        [self.backView removeFromSuperview];
        self.backView = nil;
        NSArray *menuList = dict[@"menuList"];
        int tokenStuts = [dict[@"tokenStatus"]intValue];
        int status = [dict[@"status"]intValue];
        
        if (status == 0) {
            
            NSDictionary *dateDic = [menuList lastObject];
            _createDate = dateDic[@"updateDate"];
            
            if (_pullNew == YES) {
                
                [self.dataArray removeAllObjects];
            }
            for ( NSDictionary *appDict in menuList) {
                
                allRecommentModel *model = [[allRecommentModel alloc]init];
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
                weakSelf.tableView.mj_footer.hidden = NO;
                [weakSelf.tableView reloadData];
            });
            
            self.biaoJi = NO;
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
        
//        self.netStatus1 = NO;
        if (self.dataArray.count == 0) {
            
            weakSelf.tableView.mj_footer.hidden = YES;
            self.backView = [[backGroundView alloc]initWithFrame:self.view.frame];
            self.backView.delegate = self;
            [self.view addSubview:self.backView];
            
            self.biaoJi = YES;
        }else{
            
            weakSelf.tableView.mj_footer.hidden = NO;
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
    [self.tableView addSubview:_imageView];
    [self.tableView addSubview:_btnImage];
}

-(void)btnClick{

    NSDictionary *param = @{@"type":@"0",@"CreateDate":@"",@"userId":userId,@"token":tokenStr};
    [self loadAllDataWithParam:param];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    textualResearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textualResearchCell"];
    if (!cell) {
        cell = [[textualResearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textualResearchCell"];
    }
        cell.delegate = self;
        cell.indexPath = indexPath;
        allRecommentModel *model = self.dataArray[indexPath.section];
        cell.allModel = model;
    
    return cell;
}

-(void)pressBtn:(textualResearchCell *)cell{

    if (self.netStatus1 == YES) {
        
        allRecommentModel *model = self.dataArray[cell.indexPath.section];
        detailController *detail = [[detailController alloc]init];
        detail.subjectId = model.id;
        detail.activityTitle = model.activityTitle;
        detail.fromWhere = @"111";
        detail.pictureImg = model.comment_img;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.netStatus1 == YES) {
        
        allRecommentModel *model = self.dataArray[indexPath.section];
        detailController *detail = [[detailController alloc]init];
        detail.subjectId = model.id;
        detail.activityTitle = model.activityTitle;
        detail.fromWhere = @"111";
        detail.pictureImg = model.comment_img;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

#pragma mark -- 刷新
-(void)refresh{
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *param = @{@"type":@"0",@"CreateDate":@"",@"userId":userId,@"token":tokenStr};
        [weakSelf loadAllDataWithParam:param];
        
        if (self.biaoJi == YES) {
            
            [self.backView removeFromSuperview];
            self.backView = nil;
        }
        weakSelf.pullNew = YES;
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

-(void)loadMore{

    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSString *dateStr = [NSString stringWithFormat:@"%@",weakSelf.createDate];
        NSDictionary *param = @{@"type":@"0",@"CreateDate":dateStr,@"userId":userId,@"token":tokenStr};
        weakSelf.pullNew = NO;
        [weakSelf loadAllDataWithParam:param];
        [weakSelf.tableView.mj_footer beginRefreshing];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        textualResearchCell *cell = [[textualResearchCell alloc]init];
        allRecommentModel *model = self.dataArray[indexPath.section];
        cell.allModel = model;
        cell.indexpath = indexPath;
        return  cell.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.f;
}

@end
