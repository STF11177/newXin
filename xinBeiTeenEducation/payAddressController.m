//
//  payAddressController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/9/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payAddressController.h"
#import "checkAddressModel.h"
#import "addnewAdressController.h"
#import "managerDetailCell.h"
#import "payController.h"
#import "eduPayController.h"

@interface payAddressController ()<UITableViewDelegate,UITableViewDataSource>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation payAddressController
static NSString *userId;
static NSString *address;
static NSString *addressId;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNav];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    [self createHttpRequest];
    [self loadCheckData];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[managerDetailCell class] forCellReuseIdentifier:@"cell"];
}

- (void)createNav{
        
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"地址";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(UITableView *)tableView{

    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

-(void)loadCheckData{
    
    NSDictionary *param = @{@"userId":userId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:checkEduAdressURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            [self.dataArray removeAllObjects];
            NSArray *menuList = dict[@"menuList"];
            for (NSDictionary *appDict in menuList) {
                
                checkAddressModel *model = [[checkAddressModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.dataArray.count==0) {
                    
                    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"您还没有设置收货地址，请点击这里设置"message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                        addnewAdressController *adress = [[addnewAdressController alloc]init];
                        adress.signStr = @"1";
                        
                        [self.navigationController pushViewController:adress animated:YES];
                    }];
                    
                    [alertControl addAction:action];
                    [alertControl addAction:action1];
                    [self presentViewController:alertControl animated:YES completion:nil];
                }
                
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)loadSaveAdressData:(NSDictionary*)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:paySaveAdressURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            [self.dataArray removeAllObjects];
            NSArray *menuList = dict[@"menuList"];
            for (NSDictionary *appDict in menuList) {
                
                checkAddressModel *model = [[checkAddressModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.fromStr isEqualToString:@"eduPay"]) {
                    
                    eduPayController *pay = [[eduPayController alloc]init];
                    pay.orderIdStr = self.orderStr;
                    [self.navigationController pushViewController:pay animated:NO];
                }else{
                
                    payController *payVC = [[payController alloc]init];
                    payVC.orderId = self.orderStr;
//                    payVC.payNameStr = self.nameStr;
//                    payVC.phoneNumber = self.phoneStr;
                    [self.navigationController pushViewController:payVC animated:NO];
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    managerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"managerDetailCell"];
    if (!cell) {
        
        cell = [[managerDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"managerDetailCell"];
    }
    
    checkAddressModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [tableView deselectRowAtIndexPath:indexPath animated:NO];

    checkAddressModel *model = self.dataArray[indexPath.row];
    address = model.address;

    DDLog(@"%@",model.id);
    NSDictionary *param = @{@"userId":userId,@"orderId":self.orderStr,@"addressId":model.id};
    [self loadSaveAdressData:param];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 75;
}

-(void)saveMessage{

}

-(void)presentVC{

    [self.navigationController popViewControllerAnimated:NO];
}

@end
