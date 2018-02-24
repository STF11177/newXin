//
//  atttionViewController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "atttionViewController.h"
#import "attionCell.h"
#import "noAttentionCell.h"
#import "AttentionDetailController.h"
#import "MJRefresh.h"
#import "ETMessageView.h"

@interface atttionViewController ()<noAttionCellDelete,attionCellDelegate>
{

    AFHTTPRequestOperationManager *_manager;
    
}

@property (nonatomic,assign) int status;
@property (nonatomic,strong) NSMutableDictionary *comParams;
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态

@end

@implementation atttionViewController

static NSString *managerCellId = @"attionCell";
static NSString *spotId;
static NSString *typeId;
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self creatNavigationItem];
    [self createHttpRequest];
    [self refresh];
    
    self.attenedArray = [[NSMutableArray alloc]init];
    self.noAttenedArray = [[NSMutableArray alloc]init];
    
    _netStatus1 = YES;
    [self.attionTableView registerClass:[attionCell class] forCellReuseIdentifier:@"attionCell"];
    [self.attionTableView registerClass:[noAttentionCell class] forCellReuseIdentifier:@"noAttentionCell"];

    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

-(void)noNetStatus{
    
    _netStatus1 = NO;
}

-(void)netStatus{
    
    _netStatus1 = YES;
      [self loadDta];
}

-(void)netStatuswifi{

    _netStatus1 = YES;
      [self loadDta];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
}

-(void) creatNavigationItem{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#1b82d2"]];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"关注";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}


-(UITableView *)attionTableView{

    if (!_attionTableView) {
        
        _attionTableView =[[UITableView alloc]initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _attionTableView.delegate = self;
        _attionTableView.dataSource = self;
        _attionTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        
        if (iOS11) {
            
            _attionTableView.estimatedRowHeight = 0;
            _attionTableView.estimatedSectionHeaderHeight = 0;
            _attionTableView.estimatedSectionFooterHeight = 0;
        }
        
        [self.view addSubview:_attionTableView];
        
        self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    }
    return _attionTableView;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadDta{

    __weak typeof(self) weakSelf = self;
    
    DDLog(@"userId:%@",userId);
    //请求参数
    NSDictionary *param = @{@"userId":userId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:attenedURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        _status = [dict[@"status"]intValue];
        if (_status == 0) {
            
            [weakSelf.attenedArray removeAllObjects];
            [weakSelf.noAttenedArray removeAllObjects];
            
            //已关注
            NSArray *menuList = dict[@"menuList"];
            for (NSDictionary *appDict in menuList) {
                
                _attenModel = [[namicInfoBeanModel alloc]init];
                [weakSelf.attenModel yy_modelSetWithDictionary:appDict];
                
                [weakSelf.attenedArray addObject:weakSelf.attenModel];
                DDLog(@"attenedArray:%@",weakSelf.attenedArray);
            }
            
            //未关注
            NSArray *CircleList = dict[@"notCircleList"];
            for (NSDictionary *menDict in CircleList) {
                
                _noAttionModel = [[noAttionModel alloc]init];
                [weakSelf.noAttionModel yy_modelSetWithDictionary:menDict];
                [weakSelf.noAttenedArray addObject:weakSelf.noAttionModel];
        
                DDLog(@"noAttenedArray:%ld",weakSelf.noAttenedArray.count);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.attionTableView reloadData];
        });
        
         [weakSelf.attionTableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf.attionTableView.mj_header endRefreshing];
        [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
       
        return self.attenedArray.count;
    }else{
    
        return self.noAttenedArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==0) {
        
        attionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attionCell"];
        if (!cell) {
            cell = [[attionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"attionCell"];
        }
        
        namicInfoBeanModel *model = self.attenedArray[indexPath.row];
        DDLog(@"%@",model);
        DDLog(@"%@",self.attenedArray);
        cell.namicModel = model;
        cell.indexPath= indexPath;
        cell.delegate = self;
        return cell;
    }else{
    
        noAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noAttentionCell"];
        if (!cell) {
            
            cell = [[noAttentionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noAttentionCell"];
        }
    
        noAttionModel *model = self.noAttenedArray[indexPath.row];
        DDLog(@"%@",model);
        cell.noAtendModel = model;
        cell.delegate = self;
        cell.indexPath= indexPath;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, 30)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#d0cfd3"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#87878d"];
    view.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
    
        label.text = @"我的关注";
        
    }else if (section == 1){
    
        label.text = @"推荐关注";
    }
    [view addSubview:label];
    [view addSubview:view1];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_netStatus1 == YES) {
        
        AttentionDetailController *attenVC = [[AttentionDetailController alloc]init];
        [self.navigationController pushViewController:attenVC animated:YES];
        
        if (indexPath.section == 0) {
            
            namicInfoBeanModel *namoModel = self.attenedArray[indexPath.row] ;
            attenVC.typeId = namoModel.typeId;
            DDLog(@"typeId:%@",attenVC.typeId);
        }else{
            
            noAttionModel *noAttenModel = self.noAttenedArray[indexPath.row];
            attenVC.typeId = noAttenModel.typeId;
            DDLog(@"typeId:%@",attenVC.typeId);
        }
    }else{
    
     [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

#pragma mark -- 添加未关注
-(void)addAttentionInCell:(noAttentionCell *)cell{

     if (_netStatus1 == YES) {
    noAttionModel *model = self.noAttenedArray[cell.indexPath.row];
    typeId = model.typeId;
    NSDictionary *param = @{@"userId":userId, @"typeId":typeId};
    [self loadWithParams:param URL:addURL];
    [self.attionTableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
     }else{
         
         [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
     }
}

#pragma mark -- 刷新
-(void)refresh{
    
   __weak __typeof(self) weakSelf = self;
    self.attionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadDta];
        
    }];
    [self.attionTableView.mj_header beginRefreshing];
}

-(void)onDeleteOrderInCell:(attionCell *)cell{
    
    if (self.netStatus1 == YES) {
        
        NSArray *indexPaths = @[cell.indexPath];
        namicInfoBeanModel *namoModel = self.attenedArray[cell.indexPath.row] ;
        spotId = namoModel.spotId;
        DDLog(@"%@",spotId);
        [self.attenedArray removeObjectAtIndex:cell.indexPath.row];
        [self.attionTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        //请求参数
        NSDictionary *param = @{@"userId":userId, @"spotId":spotId};
        [self loadWithParams:param URL:deleteAttnedURL];
    }else{
    
       [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

#pragma mark -- 删除
-(void)loadWithParams:(NSDictionary *)param URL:(NSString*)url{

    //请求参数
   __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:url parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        _status = [dict[@"status"]intValue];
        
        if (_status == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf refresh];
                [weakSelf.attionTableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:YES];
}

@end
