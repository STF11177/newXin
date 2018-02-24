//
//  eduOrderController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduOrderController.h"
#import "eduOrderCell.h"
#import "orderModel.h"
#import "eduPayController.h"
#import "ETMessageView.h"
#import "eduOrderFinishController.h"

@interface eduOrderController ()<UITableViewDelegate,UITableViewDataSource,eduOrderdelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL netStatus1;

@end

@implementation eduOrderController
static NSString *userId;
static NSString *orderId;
static NSString *bookId;
static NSString *orderId;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self createHttp];
    [self createNav];
    [self createTableView];
    
    [self loadEduOrderData];
    [self.tableView registerClass:[eduOrderCell class] forCellReuseIdentifier:@"eduOrderCell"];
    
    self.netStatus1 = YES;
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

-(void)createNav{

    self.dataArray = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"图书订单";
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

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    if (iOS11) {
        
        self.tableView.sectionHeaderHeight = 0.1f;
        self.tableView.sectionFooterHeight = 15.f;
    }
    [self.view addSubview:self.tableView];
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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

-(void)dealloc{
    
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

-(void)loadEduOrderData{

    //请求参数
    NSDictionary *param = @{@"userId":userId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:eduOrderURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);

        NSArray *menlistArray = dict[@"menuList"];
        for (NSDictionary *appDict in menlistArray) {
            
            orderModel *model = [[orderModel alloc]init];
            [model yy_modelSetWithDictionary:appDict];
            [self.dataArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.dataArray.count == 0) {
                
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.centerY -64, ScreenWidth, 40)];
                lable.text = @"暂无订单";
                lable.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:lable];
            }
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark -- 删除
-(void)deleteInCell:(eduOrderCell *)cell{
    
    if (self.netStatus1 == YES) {
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"是否删除此订单"message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            orderModel *mdoel = self.dataArray[cell.indexPath.section];
            NSDictionary *param = @{@"orderId":mdoel.orderId};
            [self deleteOrderDataWithParam:param];
            
            // 从removeArray中移除student
            [self.dataArray removeObjectAtIndex:cell.indexPath.section];
        }];
        
        [alertControl addAction:action];
        [alertControl addAction:action1];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
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
                orderModel *mdoel = [[orderModel alloc]init];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    eduOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eduOrderCell"];
    if (!cell) {
     
        cell = [[eduOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eduOrderCell"];
    }
    orderModel *model = self.dataArray[indexPath.section];
    cell.model = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.netStatus1 == YES) {
        orderModel *model = self.dataArray[indexPath.section];
        NSString *payStr = [NSString stringWithFormat:@"%@",model.payStatus];
        if ([payStr isEqualToString:@"0"]) {
            
            eduPayController *eduPay = [[eduPayController alloc]init];
            eduPay.bookStr = model.bookId;
            eduPay.orderIdStr = model.orderId;
            eduPay.fromStr = @"order";
            [self.navigationController pushViewController:eduPay animated:YES];
        }
        else{

            eduOrderFinishController *finish = [[eduOrderFinishController alloc]init];
            finish.bookStr = model.bookId;
            finish.orderIdStr = model.orderId;
            [self.navigationController pushViewController:finish animated:YES];
        }
    }
    else{
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 140;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        
        return 0.1f;
    }else{
    
        return 15.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1f;
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:YES];
}

@end
