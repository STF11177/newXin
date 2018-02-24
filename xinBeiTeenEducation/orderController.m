//
//  orderController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/13.
//  Copyright © 2017年 user. All rights reserved.
//

#import "orderController.h"
#import "orderCell.h"
#import "orderWillPayController.h"
#import "allorderModel.h"
#import "orderCompleteController.h"
#import "payController.h"
#import "detailController.h"
#import "beforeTestController.h"
#import "ETRegularUtil.h"
#import "orderWillPayController.h"
#import "ETMessageView.h"

@interface orderController ()<UITableViewDelegate,UITableViewDataSource,orderCellDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *orderLb;
@property (nonatomic,assign) BOOL netStatus1;

@end

@implementation orderController
static NSString *testLoad;
static NSString *checkScore;
static NSString *beforeURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createTableView];
    [self createHttpRequest];
    self.netStatus1 = YES;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *dict = @{@"userId":userId};
    [self loadOrderDataWithParam:dict];
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

-(void)noNetStatus{

    self.netStatus1 = NO;
}

-(void)netStatus{

    self.netStatus1 = YES;
}

-(void)netStatuswifi{

    self.netStatus1 = YES;
}

-(void)createNav{

    self.dataArray = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"我的考证";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createTableView{

    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (iOS11) {
        
        self.tableView.sectionHeaderHeight = 0.1f;
        self.tableView.sectionFooterHeight = 15.f;
    }
    [self.view addSubview:self.tableView];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadOrderDataWithParam:(NSDictionary*)param{

    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:loadCardURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        NSArray *menuList = dict[@"menuList"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            for (NSDictionary *appDict in menuList) {
                allorderModel *mdoel = [[allorderModel alloc]init];
                [mdoel yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:mdoel];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.dataArray.count == 0) {
                    
                    self.orderLb = [[UILabel alloc]init];
                    self.orderLb.frame = CGRectMake( 0,SCREEN_HEIGHT/3 - 20 , SCREEN_WIDTH, 30);
                    self.orderLb.textAlignment = NSTextAlignmentCenter;
                    self.orderLb.text = @"暂无订单";
                    [self.view addSubview:self.orderLb];
                }
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 190;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 15.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    orderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if (!cell) {
        cell = [[orderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
    }
    
    allorderModel *model = self.dataArray[indexPath.section];
    cell.model = model;
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.netStatus1 == YES) {
        
        allorderModel *model = self.dataArray[indexPath.section];
        NSString *payStr = [NSString stringWithFormat:@"%@",model.payStatus];
        if ([payStr isEqualToString:@"0"]) {
            
            orderWillPayController *order = [[orderWillPayController alloc]init];
            order.money = model.orderMoney;
            order.orderId = model.orderId;
            order.pictureImg = model.comment_img;
            [self.navigationController pushViewController:order animated:YES];
        }else{
            
            detailController *order = [[detailController alloc]init];
            order.subjectId = model.id;
            order.activityTitle = model.activityTitle;
            [self.navigationController pushViewController:order animated:YES];
        }
    }else{
    
    [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

#pragma mark -- footView
-(void)onBeforeTestInCell:(orderCell *)cell{
    
    allorderModel *model = self.dataArray[cell.indexPath.section];
    NSString *testStr = [NSString stringWithFormat:@"%@",model.ccaaUrl];
    beforeTestController *before = [[beforeTestController alloc]init];
    before.beforeURL = testStr;
    [self.navigationController pushViewController:before animated:YES];
}

-(void)onTestDownLoadingInCell:(orderCell *)cell{

    allorderModel *model = self.dataArray[cell.indexPath.section];
    NSString *testStr = [NSString stringWithFormat:@"%@",model.admissionUrl];

    if ([ETRegularUtil isEmptyString:testStr]) {
        
    }else{
    
        [self showAlertWithMessage:testStr];
    }
}

-(void)onCheckScoreInCell:(orderCell *)cell{

    allorderModel *model = self.dataArray[cell.indexPath.section];
    NSString *testStr = [NSString stringWithFormat:@"%@",model.queryResultUrl];
    
    if ([ETRegularUtil isEmptyString:testStr]) {
        
    }else{
        
        [self showAlertWithMessage:testStr];
    }
}

#pragma mark -- 删除
-(void)onDeleteOrderInCell:(orderCell *)cell{
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"是否删除此订单"message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        allorderModel *mdoel = self.dataArray[cell.indexPath.section];
        NSDictionary *param = @{@"orderId":mdoel.orderId};
        [self deleteOrderDataWithParam:param];
        
        // 从removeArray中移除student
        [self.dataArray removeObjectAtIndex:cell.indexPath.section];
    }];
    
    [alertControl addAction:action];
    [alertControl addAction:action1];
    [self presentViewController:alertControl animated:YES completion:nil];
}

-(void)deleteOrderDataWithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:deleteOrderURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        NSArray *menuList = dict[@"menuList"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            for (NSDictionary *appDict in menuList) {
                allorderModel *mdoel = [[allorderModel alloc]init];
                [mdoel yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:mdoel];
            }
            DDLog(@"%@",self.dataArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)presentBack{

[self.navigationController popViewControllerAnimated:YES];
}

@end
