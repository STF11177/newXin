//
//  hotCollectController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "hotCollectController.h"
#import "hotCell.h"
#import "hotArticleModel.h"
#import "hotAticleDetailController.h"
#import "ETMessageView.h"
#import "backGroundView.h"

@interface hotCollectController ()<UITableViewDelegate,UITableViewDataSource,backViewdelegate>
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
@property (nonatomic,assign) BOOL pullMore; //加载更多
@property (nonatomic,assign) BOOL biaoJi;
@property (nonatomic,assign) BOOL netStatus1;
@property (nonatomic,strong) backGroundView *backView;

@end

@implementation hotCollectController
static NSString *userId;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createHttp];
    [self createHttpRequest];
    
    [self createTableView];
    [self.recommentTableView registerClass:[hotCell class] forCellReuseIdentifier:NSStringFromClass([hotCell class])];
    
    if (iOS11) {
        
        _recommentTableView.estimatedRowHeight = 0;
        _recommentTableView.estimatedSectionHeaderHeight = 0;
        _recommentTableView.estimatedSectionFooterHeight = 0;
    }
    
    self.biaoJi = YES;
    self.netStatus1 = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"3"};
    [self loadDataWithText:param];
    [self refresh];
    [self loadMore];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

-(void)noNetStatus{
    
    self.netStatus1 = NO;
    [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
}

-(void)netStatus{
    
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    self.netStatus1 = YES;
    [self.backView removeFromSuperview];
    [self.recommentTableView.mj_header beginRefreshing];
}

-(void)netStatuswifi{

    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    self.netStatus1 = YES;
    [self.backView removeFromSuperview];
    [self.recommentTableView.mj_header beginRefreshing];
}

-(void)netClickDelegate:(backGroundView *)view{

    [self.backView removeFromSuperview];
    [self.recommentTableView.mj_header beginRefreshing];
}

-(void)btnClick{
    
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"3"};
    [self loadDataWithText:param];
}

-(void)createHttpRequest{
        
  _manager = [AFHTTPRequestOperationManager manager];
  _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createNav{
    
    _dataArray = [[NSMutableArray alloc]init];
    _cellHeightArray = [[NSMutableArray alloc]init];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"热文收藏";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goToCollect) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)goToCollect{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView{
    
    _recommentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _recommentTableView.dataSource = self;
    _recommentTableView.delegate = self;
    _recommentTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_recommentTableView];
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
    
    [_manager POST:circleCollectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"%@",dict);
        NSArray *menuList = dict[@"menuList"];
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            if (_pullMore == YES) {
                
                [self.dataArray removeAllObjects];
            }
            
            NSDictionary *dateDic = [menuList lastObject];
            _createDate = dateDic[@"createDate"];
            DDLog(@"%@",_createDate);
            
            for (NSDictionary *appDict in menuList) {
                hotArticleModel *model = [[hotArticleModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
            DDLog(@"%@",self.dataArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 weakSelf.recommentTableView.mj_footer.hidden = NO;
                [weakSelf.recommentTableView reloadData];
            });
            
            [self.backView removeFromSuperview];
            
            [weakSelf.recommentTableView.mj_header endRefreshing];
            if (!_createDate) {
                [weakSelf.recommentTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                
                [weakSelf.recommentTableView.mj_footer endRefreshing];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf.recommentTableView.mj_header endRefreshing];
        [weakSelf.recommentTableView.mj_footer endRefreshing];
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
        
        if (self.dataArray.count == 0) {
            
            weakSelf.recommentTableView.mj_footer.hidden = YES;
            
            self.backView = [[backGroundView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.backView.delegate = self;
            [self.view addSubview:self.backView];
            
//            if (self.biaoJi == YES) {
//                
//                [self createImage];
//                self.biaoJi = NO;
//            }
        }else{
            
            weakSelf.recommentTableView.mj_footer.hidden = NO;
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
    
    [self.recommentTableView addSubview:_imageView];
    [self.recommentTableView addSubview:_btnImage];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    hotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    if (!cell) {
        
        cell =[[hotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
    }
    hotArticleModel *model = self.dataArray[indexPath.row];
    DDLog(@"%@",model);
    cell.indexpath = indexPath;
    cell.hotModel = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.netStatus1 == YES) {
        
        hotAticleDetailController *hotDetail = [[hotAticleDetailController alloc]init];
        hotArticleModel *model = self.dataArray[indexPath.row];
        hotDetail.taskId = model.id;
        hotDetail.from_uid = userId;
        hotDetail.titleStr = model.title;
        hotDetail.contentStr = model.content;
        hotDetail.faceImage = model.imgs;
        hotDetail.userName = model.nickName;
        [self.navigationController pushViewController:hotDetail animated:YES];
    }else{
    
          [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
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
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"3"};
        [weakSelf loadDataWithText:param];
        _pullMore = YES;
        [self.recommentTableView.mj_header beginRefreshing];
    }];
}

-(void)loadMore{

    __weak __typeof(self) weakSelf = self;
    self.recommentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",_createDate];
        NSDictionary *param = @{@"userId":userId,@"createDate":dateStr,@"type":@"3"};
        [weakSelf loadDataWithText:param];
        _pullMore = NO;
        [self.recommentTableView.mj_footer beginRefreshing];
    }];
}

@end
