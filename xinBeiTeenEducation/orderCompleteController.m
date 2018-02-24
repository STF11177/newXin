//
//  orderCompleteController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "orderCompleteController.h"
#import "orderCompleteCell.h"

@interface orderCompleteController ()<UITableViewDelegate,UITableViewDataSource>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation orderCompleteController
static NSString *subjectName;
static NSString *studentName;
static NSString *baoMingTime;
static NSString *testTime;
static NSString *payStr;
static NSString *testAddress;
static NSString *willTestAdress;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createHttpRequest];
    [self loadCompleteOrderData];
    [self createView];
    [self createNav];
}

-(void)createView{

    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

-(void)createNav{

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"订单详情";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;

}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark -- 已完成订单详情
- (void)loadCompleteOrderData{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];

    NSDictionary *param = @{@"userId":userId,@"orderId":self.orderId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:orderWillPayURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            NSDictionary *menuList = dict[@"menuList"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                subjectName = menuList[@"title"];
                studentName = menuList[@"examinee_name"];
                baoMingTime = menuList[@"examDate"];
                testTime = menuList[@"subject_date"];
                payStr = menuList[@"money"];
                testAddress = menuList[@"address"];
                willTestAdress = menuList[@"get_address"];
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 9;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    orderCompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCompleteCell"];
    if (!cell) {
        
        cell = [[orderCompleteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCompleteCell"];
    }

    cell.titleLable.font = [UIFont systemFontOfSize:16];
    if (indexPath.row == 1) {
        
        cell.titleLable.text = [NSString stringWithFormat:@"考证名称：%@",subjectName];
        cell.titleLable.textColor = [UIColor lightGrayColor];
        NSMutableAttributedString *centStr3 = [[NSMutableAttributedString alloc]initWithString:cell.titleLable.text];
        [centStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
        cell.titleLable.attributedText = centStr3;
        
    }else if(indexPath.row == 2){
    
        cell.titleLable.text = [NSString stringWithFormat:@"考生姓名：%@",studentName];
        cell.titleLable.textColor = [UIColor lightGrayColor];
        NSMutableAttributedString *centStr3 = [[NSMutableAttributedString alloc]initWithString:cell.titleLable.text];
        [centStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
        cell.titleLable.attributedText = centStr3;
        
    }else if(indexPath.row == 3){
        
        cell.titleLable.text = [NSString stringWithFormat:@"报名时间：%@",baoMingTime];
        cell.titleLable.textColor = [UIColor lightGrayColor];
        NSMutableAttributedString *centStr3 = [[NSMutableAttributedString alloc]initWithString:cell.titleLable.text];
        [centStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
        cell.titleLable.attributedText = centStr3;
        
    }else if(indexPath.row == 4){
        
        cell.titleLable.text = [NSString stringWithFormat:@"考试时间：%@",testTime];
        cell.titleLable.textColor = [UIColor lightGrayColor];
        NSMutableAttributedString *centStr3 = [[NSMutableAttributedString alloc]initWithString:cell.titleLable.text];
        [centStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
        cell.titleLable.attributedText = centStr3;
        
    }else if(indexPath.row == 5){
        
        cell.titleLable.text = [NSString stringWithFormat:@"报名费用：¥%@",payStr];
        cell.titleLable.textColor = [UIColor lightGrayColor];
        NSMutableAttributedString *centStr3 = [[NSMutableAttributedString alloc]initWithString:cell.titleLable.text];
        [centStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
        cell.titleLable.attributedText = centStr3;

        
    }else if(indexPath.row == 6){
        
        cell.titleLable.text = [NSString stringWithFormat:@"考场地址：%@",testAddress];
        cell.titleLable.textColor = [UIColor lightGrayColor];
        NSMutableAttributedString *centStr3 = [[NSMutableAttributedString alloc]initWithString:cell.titleLable.text];
        [centStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
        cell.titleLable.attributedText = centStr3;

        
    }else if(indexPath.row == 7){
        
        cell.titleLable.text = [NSString stringWithFormat:@"准考证领取地址：%@",willTestAdress];
        cell.titleLable.textColor = [UIColor lightGrayColor];
        NSMutableAttributedString *centStr3 = [[NSMutableAttributedString alloc]initWithString:cell.titleLable.text];
        [centStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 8)];
        cell.titleLable.attributedText = centStr3;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0||indexPath.row == 8) {
        
        return 10;
    }else{
    
         return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1f;
}

-(void)presentLeftMenuViewController{

    [self.navigationController popViewControllerAnimated:NO];

}

@end
