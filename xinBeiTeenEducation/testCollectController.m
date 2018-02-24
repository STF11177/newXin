//
//  testCollectController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/18.
//  Copyright © 2017年 user. All rights reserved.
//

#import "testCollectController.h"
#import "ADCell.h"
#import "textualResearchCell.h"
#import "textDetailController.h"
#import "allRecommentModel.h"
#import "detailController.h"
#import "ETMessageView.h"
#import "backGroundView.h"

@interface testCollectController ()<UITableViewDelegate,UITableViewDataSource,textualCellDelegate,backViewdelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) UILabel *testLb;
@property (nonatomic,assign) BOOL isPress;
@property (nonatomic,assign) BOOL pullNew;
@property (nonatomic,assign) BOOL biaoJi;
@property (nonatomic,assign) BOOL netStatus1;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,strong) backGroundView *backView;

@end

@implementation testCollectController
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createTableView];
    [self createHttpRequest];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    _isPress = NO;
    self.biaoJi = YES;
    self.netStatus1 = YES;
    [self.tableView registerClass:[ADCell class] forCellReuseIdentifier:@"ADCell"];
    [self.tableView registerClass:[textualResearchCell class] forCellReuseIdentifier:@"textualResearchCell"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"2"};
    [self loadTestDataWithParam:param];
    
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
    [self.tableView.mj_header beginRefreshing];
}

-(void)netStatuswifi{

    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    self.netStatus1 = YES;
    [self.backView removeFromSuperview];
    [self.tableView.mj_header beginRefreshing];
}

-(void)netClickDelegate:(backGroundView *)view{

    [self.tableView.mj_header beginRefreshing];
    [self.backView removeFromSuperview];
}

-(void)btnClick{
    
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"2"};
    [self loadTestDataWithParam:param];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"考证收藏";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_WIDTH*0.1, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goToCollect) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)goToCollect{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 6;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
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
-(void)loadTestDataWithParam:(NSDictionary *)param{

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
        
        NSArray *menuList = dict[@"menuList"];
        int status = [dict[@"status"]intValue];
        
        if (status == 0) {
            
            NSDictionary *dateDic = [menuList lastObject];
            _createDate = dateDic[@"newDate"];
            
            DDLog(@"%@",_createDate);
            if (self.pullNew == YES) {
                
                [self.dataArray removeAllObjects];
            }
            
            for ( NSDictionary *appDict in menuList) {
                
                allRecommentModel *model = [[allRecommentModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.dataArray.count == 0) {
                    
                    weakSelf.tableView.mj_footer.hidden = NO;
                    self.testLb = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH,40)];
                    self.testLb.text = @"暂无收藏";
                    self.testLb.textAlignment = NSTextAlignmentCenter;
                    [self.view addSubview:self.testLb];
                }
                
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
//            if (self.biaoJi == YES) {
            
//                [self createImage];
//                self.biaoJi = NO;
//            }
            
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.netStatus1 == YES) {
        
        allRecommentModel *model = self.dataArray[indexPath.section];
        detailController *testDetail = [[detailController alloc]init];
        testDetail.subjectId = model.id;
        testDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:testDetail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

-(void)pressBtn:(textualResearchCell*)cell{
    
    _isPress = YES;
    cell.signButton.backgroundColor = [UIColor lightGrayColor];
    
    allRecommentModel *model = self.dataArray[cell.indexPath.section];
    DDLog(@"%@",model.id);
    textDetailController *testDetail = [[textDetailController alloc]init];
    testDetail.subjectId = model.id;
    testDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:testDetail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -- 刷新
-(void)refresh{
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"type":@"2"};
        [weakSelf loadTestDataWithParam:param];
        weakSelf.pullNew = YES;
        [weakSelf.tableView.mj_header beginRefreshing];
        
    }];
}

-(void)loadMore{
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSString *dateStr = [NSString stringWithFormat:@"%@",weakSelf.createDate];
        NSDictionary *param = @{@"userId":userId,@"createDate":dateStr,@"type":@"2"};
        weakSelf.pullNew = NO;
        [weakSelf loadTestDataWithParam:param];
        [weakSelf.tableView.mj_footer beginRefreshing];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20;
}

@end
