//
//  addnewAdressController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "addnewAdressController.h"
#import "textFieldCell.h"
#import "textViewCell.h"
#import "defaultCell.h"
#import "eduTextFieldCell.h"
#import "payController.h"

@interface addnewAdressController ()<UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate,defaultCellDelegate,textViewDelegate,eduTextFieldCellDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation addnewAdressController
static NSString *userId;
static NSString *textViewStr;
static NSString *nameStr;
static NSString *phoneStr;
static NSString *statusStr;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self.tableView registerClass:[eduTextFieldCell class] forCellReuseIdentifier:@"eduTextFieldCell"];
    [self.tableView registerClass:[textViewCell class] forCellReuseIdentifier:@"textViewCell"];
    [self.tableView registerClass:[defaultCell class] forCellReuseIdentifier:@"defaultCell"];

    [self createHttp];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    self.dataArray = [[NSMutableArray alloc]init];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"添加新地址";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;

    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 , 10, 40, 40)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(UITableView *)tableView{

    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (iOS11) {
            self.tableView.sectionFooterHeight = 10;
            self.tableView.sectionHeaderHeight = 0.1;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        
        return 2;
    }else{
    
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            textViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textViewCell"];
            if (!cell) {
                
                cell = [[textViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textViewCell"];
            }
            cell.textView.text = self.addressStr;
            cell.delegate = self;
            [cell.textView becomeFirstResponder];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
        
            eduTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eduTextFieldCell"];
            if (!cell) {
                
                cell = [[eduTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eduTextFieldCell"];
            }
            
            cell.delegate = self;
            cell.nameField.text = self.nameStr;
            cell.phoneField.text = self.phoneStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        
        defaultCell *cell= [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
        if (!cell) {
            
            cell = [[defaultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
        }
        cell.delegate = self;
        
        DDLog(@"%@",statusStr);
        if ([self.statusStr isEqualToString:@"0"]) {
            
            [cell.switchBtn setOn:YES];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)selectTextView:(textViewCell *)textCell{
 
    textViewStr = textCell.textView.text;
    self.addressStr = textCell.textView.text;
    DDLog(@"%@",textViewStr);
}

-(void)nameTextField:(eduTextFieldCell *)cell{

    nameStr = cell.nameField.text;
    self.nameStr = cell.nameField.text;
    DDLog(@"%@",nameStr);
}

-(void)phoneTextField:(eduTextFieldCell *)cell{

    phoneStr = cell.phoneField.text;
    self.phoneStr = cell.phoneField.text;
    DDLog(@"%@",phoneStr);
}

-(void)loadAddAdressData{
    
    DDLog(@"xxxxx%@",nameStr);
    DDLog(@"yyyyy%@",phoneStr);
    DDLog(@"zzzzz%@",textViewStr);
    DDLog(@"uuuuu%@",statusStr);
    
    if ([ETRegularUtil isEmptyString:statusStr]) {
        
        statusStr = @"1";
    }
    
    NSDictionary *param = @{@"userId":userId,@"phone":phoneStr,@"consignee":nameStr,@"status":statusStr,@"address":textViewStr};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:eduAddAdressURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.signStr isEqualToString:@"1"]) {
                
                payController *pay = [[payController alloc]init];
                pay.orderId = self.orderStr;
                pay.firsrAddressStr = textViewStr;
                [self.navigationController pushViewController:pay animated:NO];
            }else{
            
                [self.navigationController popViewControllerAnimated:NO];
            }
      });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showHint:@"网络不佳，请稍后再试"];
    }];
}

-(void)loadModifyData{
    
    NSDictionary *param = @{@"userId":userId,@"phone":self.phoneStr,@"consignee":self.nameStr,@"status":self.statusStr,@"address":self.addressStr,@"addressId":self.addressId};
    
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
                
                [self.tableView reloadData];
                [self.navigationController popViewControllerAnimated:NO];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showHint:@"网络不佳，请稍后再试"];
    }];
}

-(void)onSwitchInCell:(defaultCell *)cell{

    BOOL isBttonOn = [cell.switchBtn isOn];
    if (isBttonOn) {
        
        statusStr = @"0";
        self.statusStr = @"0";
    }else{
    
       statusStr = @"1";
        self.statusStr = @"1";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        if (indexPath.row ==0) {
            
            return 88;
        }else{
        
          
            return 100;
        }
    }else{
    
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.1f;
    }else{
    
        return 10.f;
    }
}

-(void)presentBack{
    
    if ([self.signStr isEqualToString:@"1"]) {
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[payController class]]) {
            
                [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            }
        }
    }else{
    
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)saveMessage{
    
    DDLog(@"%@",self.phoneStr);
    if (self.addressId) {
        
        if ([ETRegularUtil isEmptyString:self.nameStr]) {
            
            [self showHint:@"收货人不能为空"];
        }else if([ETRegularUtil isEmptyString:self.phoneStr]){
            
            [self showHint:@"联系电话不能为空"];
        }else if (self.phoneStr.length !=11){
            
            [self showHint:@"联系电话应为11位数"];
        }else if([ETRegularUtil isEmptyString:self.addressStr]){
            
            [self showHint:@"收货地址不能为空"];
        }else{
            
            [self loadModifyData];
        }
    }else{
    
    if ([ETRegularUtil isEmptyString:nameStr]) {
        
        [self showHint:@"收货人不能为空"];
    }else if([ETRegularUtil isEmptyString:phoneStr]){
    
        [self showHint:@"联系电话不能为空"];
    }else if (phoneStr.length !=11){
    
        [self showHint:@"联系电话应为11位数"];
    }else if([ETRegularUtil isEmptyString:textViewStr]){
        
        [self showHint:@"收货地址不能为空"];
    }else{
    
            [self loadAddAdressData];
    }
  }
}

@end
