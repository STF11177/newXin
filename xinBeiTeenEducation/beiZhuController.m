//
//  beiZhuController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/17.
//  Copyright © 2017年 user. All rights reserved.
//

#import "beiZhuController.h"
#import "messageDetailController.h"
#import "SBJson.h"

@interface beiZhuController ()
{

 AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UITextField *headtextField;
@property (nonatomic, assign) int status;

@end

@implementation beiZhuController
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor =[UIColor colorWithHexString:@"#f2f2f2"];
    [self createNavBarItem];
    [self createView];
    [self layoutUI];
    [self createHttpRequest];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];

    
}

-(void)createNavBarItem{
        
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"备注信息";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goback2) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 19)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item1;
    
}

- (void)createView{

    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = @"备注名";
    self.nameLable.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:self.nameLable];

    self.headView = [[UIView alloc]init];
    self.headView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.headView];
    
    self.headtextField = [[UITextField alloc]init];
    _headtextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.headView addSubview:self.headtextField];
    
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}


- (void)layoutUI{

    __weak typeof(self)weakSelf = self;
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(70);
        make.left.equalTo(weakSelf.view).offset(10);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(50);
    }];
    
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLable.mas_bottom);
        make.left.equalTo(weakSelf.view).offset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.headtextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLable.mas_bottom);
        make.left.equalTo(weakSelf.view).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

-(void)goback2{

    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -- 完成
- (void)completeClick{
   
    DDLog(@"%@",userId);
    DDLog(@"%@",self.from_uid);
    NSDictionary *param = @{@"userId":userId,
                             @"target_uid":self.from_uid,
                             @"remarkName":self.headtextField.text,@"status":@"0"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [NSString stringWithUTF8String:[baseData bytes]];
    
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:beizhuURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        _status =[dict[@"status"]intValue];
        if (_status == 0) {
            
            messageDetailController *detail = [[messageDetailController alloc]init];
            detail.target_uid = self.from_uid;
            [self.navigationController pushViewController:detail animated:NO];
        }else{
        
            DDLog(@"解析错误");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
