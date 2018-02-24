////
////  getAddressController.m
////  xinBeiTeenEducation
////
////  Created by user on 2017/6/29.
////  Copyright © 2017年 user. All rights reserved.
////
//
//#import "getAddressController.h"
////#import "schoolModel.h"
//#import "schollCell.h"
//#import "detailController.h"
//
//#define LoadGetAdressURL @"http://192.168.1.123:8080/neworld/user/156"
//@interface getAddressController ()<UITableViewDelegate,UITableViewDataSource>
//{
//    AFHTTPRequestOperationManager *_manager;
//}
//@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) NSMutableArray *dataArray;
//@property (nonatomic,strong) NSIndexPath *selectPath;//存放被点击哪一行的标志
//
//@end
//
//@implementation getAddressController
//static NSString *schoolStr;
//static NSString *activityTitle;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//   
//    [self createNav];
//    [self createHttpRequest];
//    [self loadSchoolData];
//    [self createView];
//    [self.tableView registerClass:[schollCell class] forCellReuseIdentifier:@"schollCell"];
//}
//
//-(void)createNav{
//    
//    self.dataArray = [[NSMutableArray alloc]init];
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.text = @"领取地点";
//    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
//    lable.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lable;
//    
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = item;
//}
//
//-(void)createView{
//    
//    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
//}
//
//#pragma mark --网络请求
//-(void)createHttpRequest{
//    
//    _manager = [AFHTTPRequestOperationManager manager];
//    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//}
//
//-(void)loadSchoolData{
//
//    DDLog(@"%@",self.subjectId);
//    __weak typeof(self) weakSelf = self;
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [userDefaults objectForKey:@"userName"];
//    NSString *subjectStr = [NSString stringWithFormat:@"%@",self.subjectId];
//    NSDictionary *param = @{@"subjectId":subjectStr,@"userId":userId};
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
//    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
//    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
//    
//    DDLog(@"%@",jsonString);
//    [_manager POST:subjectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        DDLog(@"下载成功");
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        DDLog(@"dict:%@",dict);
//        
//        NSDictionary *menuListDict = dict[@"menuList"];
//        NSArray *addressList = dict[@"addressList"];
//        int status = [dict[@"status"]intValue];
//        if (status == 0) {
//            
////            for (NSDictionary *appDict in addressList) {
////                schoolModel *model = [[schoolModel alloc]init];
////                [model setValuesForKeysWithDictionary:appDict];
////                [self.dataArray addObject:model];
////                
////                DDLog(@"%@",self.dataArray);
////            }
//            activityTitle = menuListDict[@"activityTitle"];
//            DDLog(@"%@",self.dataArray);
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [weakSelf.tableView reloadData];
//            });
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    DDLog(@"%ld",self.dataArray.count);
//    return self.dataArray.count;
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 1;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    schollCell *cell =[tableView dequeueReusableCellWithIdentifier:@"schollCell"];
//    if (!cell) {
//        cell =[[schollCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"schollCell"];
//    }
//    
//    schoolModel *model = self.dataArray[indexPath.row];
//    cell.model = model;
//    DDLog(@"%@",model);
//    if (_selectPath == indexPath) {
//        
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//    
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    
//    
//    DDLog(@"%@",self.selectId);
//    NSString *indexPathStr = [NSString stringWithFormat:@"%ld",indexPath.row];
//    NSString *sexString = [NSString stringWithFormat:@"%@",self.selectId];
//    if ([indexPathStr isEqualToString:sexString]) {
//        
//        _selectPath = indexPath;
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        
//    }else{
//        
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    int newRow = (int)[indexPath row];
//    int oldRow = (int)(_selectPath != nil) ? (int)[_selectPath row]:-1;
//    
//    if (newRow != oldRow) {
//        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
//        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
//        
//        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_selectPath];
//        oldCell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    
//    _selectPath = [indexPath copy];
//    DDLog(@"%@",_selectPath);
//    
//    self.selectId = [NSString stringWithFormat:@"%ld",(long)[_selectPath row]];
//    [self loadAddressData];
//}
//
//#pragma mark -- 获取地址
//-(void)loadAddressData{
//
//    DDLog(@"%@",self.subjectId);
//    DDLog(@"%@",[NSString stringWithFormat:@"%ld",[_selectPath row]+1]);
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [userDefaults objectForKey:@"userName"];
//    NSDictionary *param = @{@"activityId":self.subjectId,@"userId":userId,@"addressId":[NSString stringWithFormat:@"%ld",[_selectPath row]+1]};
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
//    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
//    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
//    DDLog(@"%@",jsonString);
//    
//    [_manager POST:LoadGetAdressURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        DDLog(@"下载成功");
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        DDLog(@"dict:%@",dict);
//        
//        int status = [dict[@"status"]intValue];
//        if (status == 0) {
//            
//            detailController *detail = [[detailController alloc]init];
//            detail.activityTitle = activityTitle;
//            detail.subjectId = self.subjectId;
//            detail.fromWhere = @"110";//可以随便定义的
//            detail.selectId = self.selectId;
//            [self.navigationController pushViewController:detail animated:YES];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 70;
//}
//
//-(void)presentVC{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}
//
//@end
