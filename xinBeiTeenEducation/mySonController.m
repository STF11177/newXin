//
//  mySonController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/15.
//  Copyright © 2017年 user. All rights reserved.
//

#import "mySonController.h"
#import "childDataController.h"
#import "mySonModel.h"
#import "mineViewController.h"
#import "payController.h"
#import "TableViewCell.h"

@interface mySonController ()<UITableViewDelegate,UITableViewDataSource,tableViewCellDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation mySonController
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createHttp];
    
    self.fd_interactivePopDisabled = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self createTableView];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.dataArray = [[NSMutableArray alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    
    
    NSDictionary *param = @{@"userId":userId};
    [self loadChildDatawithParam:param];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:self.tableView];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"我的孩子";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadChildDatawithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:addchildDataURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSArray *result = dict[@"results"];
    
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            for (NSDictionary *appDict in result) {
                
                mySonModel *model = [[mySonModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 删除
-(void)loadDeleteDataWithparam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:deletePersonURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        
    }];
}

-(void)presentBack{
    
    if ([self.fromStr isEqualToString:@"112"]) {
        
        payController *pay = [[payController alloc]init];
        pay.orderId = self.orderId;
        [self.navigationController pushViewController:pay animated:YES];
    }else{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    if (!cell) {
        cell =[[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    }
    
    mySonModel *model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.nameLable.text = model.name;
    
    if ([self.fromStr isEqualToString:@"112"]) {

        cell.arrowImageView.image = [UIImage imageNamed:@"edit"];
        
        [cell.arrowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }else{
        
        cell.arrowImageView.image = [UIImage imageNamed:@"jiantou"];
    }
    
    return cell;
}

-(void)onDefaultInCell:(TableViewCell *)cell{
    
    mySonModel *model = self.dataArray[cell.indexPath.row];
    childDataController * child = [[childDataController alloc]init];
    child.nameString = model.name;
    child.babyId = model.id;
    if ([self.fromStr isEqualToString:@"112"]) {
       
        child.fromWhere = @"112";
    }
    child.orderId = self.orderId;
    [self.navigationController pushViewController:child animated:YES];
}

#pragma mark -- 孩子信息
-(void)loadStudentMessageWithParam:(NSDictionary*)param{
    
    __weak typeof(self) weakSelf = self;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:payStudentMessageURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                payController *pay = [[payController alloc]init];
                pay.orderId = weakSelf.orderId;
                [weakSelf.navigationController pushViewController:pay animated:YES];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.fromStr isEqualToString:@"112"]) {
        
        mySonModel *model = self.dataArray[indexPath.row];
        
        DDLog(@"%@",self.orderId);
        DDLog(@"%@",userId);
        DDLog(@"%@",model.name);
        DDLog(@"%@",model.userName);
        NSDictionary *dict = @{@"userId":userId ,@"orderId":self.orderId ,@"babaName":model.name,@"phone":model.userName};
        [self loadStudentMessageWithParam:dict];
        
    }else{
        
        mySonModel *model = self.dataArray[indexPath.row];
        childDataController * child = [[childDataController alloc]init];
        child.nameString = model.name;
        child.babyId = model.id;
        [self.navigationController pushViewController:child animated:YES];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.view addSubview:footView];
    
    UIButton *footBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 20, SCREEN_WIDTH - 50, 40)];
    [footBtn setTitle:@"添加" forState:UIControlStateNormal];
    footBtn.layer.cornerRadius = 10;
    footBtn.backgroundColor  = [UIColor colorWithHexString:@"#3696d3"];
    [footBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(addChild) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:footBtn];
    return footView;
}

#pragma mark -- 编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *indexPaths = @[indexPath];
            
        mySonModel *model = self.dataArray[indexPath.row] ;
        NSString *babyStr = model.id;
        
        //请求参数
        NSDictionary *param = @{@"babyId":babyStr};
        [self loadDeleteDataWithparam:param];
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)addChild{

    childDataController *addChild = [[childDataController alloc]init];
    addChild.babyId = @"";
    addChild.fromWhere = self.fromStr;
    addChild.orderId = self.orderId;
    [self.navigationController pushViewController:addChild animated:YES];
}


#pragma mark -- 刷新
-(void)refresh{
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaults objectForKey:@"userName"];
        NSDictionary *param = @{@"userId":userId};
        [weakSelf loadChildDatawithParam:param];
        [self.tableView.mj_header beginRefreshing];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 100;
}

@end
