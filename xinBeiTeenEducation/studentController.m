//
//  studentController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "studentController.h"
#import "mySonModel.h"
#import "ETRegularUtil.h"
#import "payController.h"

@interface studentController ()<UITableViewDelegate,UITableViewDataSource>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSIndexPath *selectPath;//存放被点击哪一行的标志
@end

@implementation studentController
static NSString *phoneStr;
static NSString *nameStr;
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self createNav];
    [self createTableView];
    [self createHttpRequest];
    [self loadNameData];
}

#pragma mark --网络请求
-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createNav{
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.dataSource = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"考生信息";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createTableView{

    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
}

#pragma mark -- 姓名，电话号码
-(void)loadNameData{
    
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *param = @{@"userId":userId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:addchildDataURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        NSArray *results = dict[@"results"];
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            for (NSDictionary *appDict in results) {
                
                mySonModel *model = [[mySonModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model.name];
                [self.dataSource addObject:model];
            }
            DDLog(@"%@",self.dataArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.textLabel.text = self.dataArray[indexPath.row];
    
    DDLog(@"%@",self.selectId);
    NSString *indexPathStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSString *sexString = [NSString stringWithFormat:@"%@",self.selectId];
    if ([indexPathStr isEqualToString:sexString]) {
        
        _selectPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int newRow = (int)[indexPath row];
    int oldRow = (int)(_selectPath != nil) ? (int)[_selectPath row]:-1;
    
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_selectPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    mySonModel *model = self.dataSource[indexPath.row];
    phoneStr = model.userName;
    
    _selectPath = [indexPath copy];
    
    self.selectId = [NSString stringWithFormat:@"%ld",(long)[_selectPath row]];
    NSDictionary *dict = @{@"userId":userId ,@"orderId":self.orderId ,@"babaName":model.name,@"phone":model.userName};
    [self loadStudentMessageWithParam:dict];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    DDLog(@"%ld",self.dataArray.count);
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(void)presentVC{

    [self.navigationController popViewControllerAnimated:YES];
}

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
@end
