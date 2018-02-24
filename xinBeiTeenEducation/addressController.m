//
//  addressController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "addressController.h"
#import "addnewAdressController.h"
#import "managerDefaultCell.h"
#import "managerDetailCell.h"
#import "checkAddressModel.h"
#import "payController.h"
#import "eduPayController.h"

@interface addressController ()<UITableViewDelegate,UITableViewDataSource,managerDefaultCellDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *addBtn;
@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation addressController
static NSString *userId;
static NSString *nameStr;
static NSString *phoneStr;
static NSString *addressStr;
static NSString *statusStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createView];
    [self createFootView];
    
    [self createHttpRequest];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
//    [self loadCheckData];
    
    [self.tableView registerClass:[managerDefaultCell class] forCellReuseIdentifier:@"managerDefaultCell"];
    [self.tableView registerClass:[managerDetailCell class] forCellReuseIdentifier:@"managerDetailCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
    self.dataArray = [[NSMutableArray alloc]init];
    [self loadCheckData];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"地址";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    if (iOS11) {
        self.tableView.sectionFooterHeight = 15;
        self.tableView.sectionHeaderHeight = 0.1;
    }
    [self.view addSubview:self.tableView];
}

-(void)createFootView{
   
    self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addBtn.backgroundColor = [UIColor colorWithHexString:@"#3696d3"];
    [self.view addSubview:self.addBtn];
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
            
                nameStr = model.consignee;
                phoneStr = model.phone;
                addressStr = model.address;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)editAddress:(managerDefaultCell *)cell{

    checkAddressModel *model = self.dataArray[cell.indexPath.section];
    addnewAdressController *addNew = [[addnewAdressController alloc]init];
    DDLog(@"%@",model.phone);
    DDLog(@"%ld",cell.indexPath.section);
    
    addNew.addressId = model.id;
    addNew.nameStr = model.consignee;
    addNew.phoneStr = model.phone;
    addNew.statusStr = model.status;
    addNew.addressStr = model.address;
    [self.navigationController pushViewController:addNew animated:NO];
}

-(void)defaultAddress:(managerDefaultCell *)cell{
   
    checkAddressModel *model = self.dataArray[cell.indexPath.section];
    if ([model.status isEqualToString:@"0"]) {
        
        [cell.defaultBtn setImage:[UIImage imageNamed:@"moren2"] forState:UIControlStateNormal];
        model.status = @"1";
    }else{
    
        [cell.defaultBtn setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
        model.status = @"0";
    }
    
    NSDictionary *param = @{@"userId":userId,@"phone":model.phone,@"consignee":model.consignee,@"status":model.status,@"address":model.address,@"addressId":model.id};
    [self loadModifyDataWithParam:param];
}

-(void)loadModifyDataWithParam:(NSDictionary*)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:modifyEduAdressURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self loadCheckData];
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)deleteAddress:(managerDefaultCell *)cell{

    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"是否删除地址"message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        checkAddressModel *model = self.dataArray[cell.indexPath.section];
        NSString *addressIdStr = [NSString stringWithFormat:@"%@",model.id];
        DDLog(@"%@",addressIdStr);
        
        [self.dataArray removeObjectAtIndex:cell.indexPath.section];
        NSDictionary *dict = @{@"addressId":addressIdStr};
        [self loadDeleteDataWithParam:dict];

    }];
    
    [alertControl addAction:action];
    [alertControl addAction:action1];
    [self presentViewController:alertControl animated:YES completion:nil];

}

-(void)loadDeleteDataWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:deleteEduAdressURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.fromStr isEqualToString:@"1"]||[self.fromStr isEqualToString:@"edupay"]) {
        
        checkAddressModel *model = self.dataArray[indexPath.section];
        DDLog(@"%@",model.id);
        NSDictionary *param = @{@"userId":userId,@"orderId":self.orderStr,@"addressId":model.id};
        [self loadSaveAdressData:param];
    }
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

                if ([self.fromStr isEqualToString:@"edupay"]) {
                    
                    eduPayController *pay = [[eduPayController alloc]init];
                    pay.orderIdStr = self.orderStr;
                    [self.navigationController pushViewController:pay animated:NO];
                    
                }else{
                    
                    payController *pay = [[payController alloc]init];
                    pay.orderId = self.orderStr;
                    [self.navigationController pushViewController:pay animated:NO];
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)addBtnClick{
    
    addnewAdressController *addNew = [[addnewAdressController alloc]init];
    [self.navigationController pushViewController:addNew animated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        managerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"managerDetailCell"];
        if (!cell) {
            
            cell = [[managerDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"managerDetailCell"];
        }

        checkAddressModel *model = self.dataArray[indexPath.section];
        cell.model = model;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    
        managerDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"managerDefaultCell"];
        if (!cell) {
            
            cell = [[managerDefaultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"managerDefaultCell"];
        }
        
        checkAddressModel *model = self.dataArray[indexPath.section];
        cell.model = model;
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
    
        return 75;
    }else{
    
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        
        return 0.1f;
    }else{
    
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 15;
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:YES];
}

@end
