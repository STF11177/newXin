//
//  settingController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "settingController.h"
#import "loginMessageController.h"
#import "collectCell.h"
#import "blackListController.h"
#import <CoreImage/CoreImage.h>
#import "addressController.h"
#import "accountSafeCell.h"
#import "TableViewCell.h"
#import "accountController.h"
#import "bugController.h"
#import "newMessageController.h"

@interface settingController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *wechatImageView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) NSMutableArray *messgaeArray;

@end

@implementation settingController
static NSString *userId;
static NSString *statusStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self createHttpRequest];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    DDLog(@"%@",userId);
    
    self.titleLb.text = @"设置";
    [self.leftBtn addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerClass:[accountSafeCell class] forCellReuseIdentifier:@"accountSafeCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadMessageData];
}

-(void)createTableView {

    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//  self.tableView.tableFooterView = [[UIView alloc]init];
    if (iOS11) {

        self.tableView.sectionFooterHeight = 0.1f;
        self.tableView.sectionHeaderHeight = 0.1f;
        self.tableView.estimatedRowHeight = 0.1f;
    }
    [self.view addSubview:self.tableView];
}

-(NSMutableArray *)messgaeArray{
    
    if (!_messgaeArray) {
        
        _messgaeArray = [[NSMutableArray alloc]init];
    }
    return _messgaeArray;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    if (section ==1) {
    
        return 3;
//    }else{
    
//        return 1;
//    }
}

#pragma mark -- 消息的标记
-(void)loadMessageData{
    
    DDLog(@"userId:%@",userId);
    //请求参数
    NSDictionary *param = @{@"userId":userId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:messageSignURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        int status = [dict[@"status"]intValue];

        
        if (status == 0) {
           
            statusStr = dict[@"newMeStatus"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        accountSafeCell *cell =[tableView dequeueReusableCellWithIdentifier:@"accountSafeCell"];
        if (!cell) {
            cell =[[accountSafeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountSafeCell"];
        }

        if (indexPath.row == 0) {
    
            cell.nameLb.text = @"黑名单";
        }else if(indexPath.row == 1){
        
            cell.nameLb.text = @"收货地址";
        }else{
            
            cell.nameLb.text = @"消息中心";
        
            NSString *str = [NSString stringWithFormat:@"%@",statusStr];
            if ([str isEqualToString:@"1"]) {
                
                cell.redImg.backgroundColor = [UIColor redColor];
            }else{
                
                cell.redImg.hidden = YES;
            }
        }
    
        cell.nameLb.font = [UIFont systemFontOfSize:17];
        return cell;
}

-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    //圆的边框宽度为2，颜色为红色
    CGContextSetLineWidth(context,2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    //在圆区域内画出image原图
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

        self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake( 40,20, SCREEN_WIDTH - 80, 40)];
        [self.backBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        self.backBtn.layer.cornerRadius = 10;
        self.backBtn.userInteractionEnabled = YES;
        [self.backBtn setBackgroundColor:[UIColor colorWithHexString:@"#3696d3"]];
        [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.footView addSubview:self.backBtn];
        return self.footView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

//    if (section == 0) {
    
//        return 10;
//    }else{
//    
        return 44;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    if (section ==0) {
    
        return 10;
//    }else{
//    
//        return 0.1f;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    if (indexPath.section ==1) {
        if (indexPath.row ==0) {
            
            blackListController *black = [[blackListController alloc]init];
            [self.navigationController pushViewController:black animated:YES];
        }else if(indexPath.row == 1){
        
            addressController *addnew = [[addressController alloc]init];
            [self.navigationController pushViewController:addnew animated:YES];
        }else{
            
            newMessageController *new = [[newMessageController alloc]init];
            [self.navigationController pushViewController:new animated:YES];
        }
//    }else{
    
//        accountController *account = [[accountController alloc]init];
//        [self.navigationController pushViewController:account animated:NO];
//    }
}

-(void)backBtnClick{

    [self loadLogOut];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadLogOut{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *param = @{@"userId":userId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:logOutURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
        DDLog(@"下载成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            loginMessageController *login = [[loginMessageController alloc]init];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:@"userName"];
            [self.navigationController presentViewController:login animated:NO completion:^{
                
            }];

    });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)presentBack{

    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
