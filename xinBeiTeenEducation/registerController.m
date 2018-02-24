//
//  registerController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "registerController.h"
//#import "headCell.h"

@interface registerController ()<UITextFieldDelegate>

//@property (nonatomic,strong) UITextField *phoneTextField;
//@property (nonatomic,strong) UITextField *testTextField;//验证码
//@property (nonatomic,strong) UITextField *codeField;//密码
//@property (nonatomic,strong) UIButton *getBtn;//获取的按钮
//@property (nonatomic,strong) UIButton *registerBtn;//注册
//@property (nonatomic,strong) UIButton *accountBtn;//已有账号登录
//@property (nonatomic,strong) UILabel *telephoneLb;//客服热线
//@property (nonatomic,strong) UIImageView *headImagView;
//@property (nonatomic,strong) UIView *lineView;//线
//@property (nonatomic,strong) UIView *lineView1;//线
//@property (nonatomic,strong) UIView *lineView2;//线
//@property (nonatomic,strong) UIView *lineView3;//线
//@property (nonatomic,assign) int status;//下载有没有成功

@end

@implementation registerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self createNav];
//    
//    [self createView];
//    [self layoutUI];
}

//-(void)createNav{
//    
//    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
//    lable1.textAlignment = NSTextAlignmentCenter;
//    lable1.text = @"注册";
//    lable1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
//    self.navigationItem.titleView = lable1;
//    
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = item;
//}
//
//-(void)createView{
//
//    _headImagView = [[UIImageView alloc]init];
//    _headImagView.image = [UIImage imageNamed:@"logoing"];
//    _headImagView.layer.cornerRadius = 10;
//    _headImagView.layer.masksToBounds = YES;
//    [self.view addSubview:_headImagView];
//    
//    _phoneTextField = [[UITextField alloc]init];
//    _phoneTextField.placeholder = @"请输入手机号码";
//    [_phoneTextField setValue:[UIColor colorWithHexString:@"#cdcdcd"] forKeyPath:@"_placeholderLabel.textColor"];
//    _phoneTextField.delegate = self;
//    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 43, 17)];
//    iconView.image = [UIImage imageNamed:@"iphone"];
//    iconView.contentMode = UIViewContentModeLeft;
//    _phoneTextField.leftView =iconView;
//    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
//    [_phoneTextField setBackgroundColor:[UIColor whiteColor]];//透明效果
//    [self.view addSubview:_phoneTextField];
//    
//    _testTextField= [[UITextField alloc]init];
//    _testTextField.placeholder = @"请输入验证码";
//    [_testTextField setValue:[UIColor colorWithHexString:@"#cdcdcd"] forKeyPath:@"_placeholderLabel.textColor"];
//    _testTextField.delegate = self;
//    UIImageView *iconView1 = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 43, 17)];
//    iconView1.image = [UIImage imageNamed:@"password"];
//    iconView1.contentMode = UIViewContentModeLeft;
//    _testTextField.leftView =iconView1;
//    _testTextField.leftViewMode = UITextFieldViewModeAlways;
//    [_testTextField setBackgroundColor:[UIColor whiteColor]];//透明效果
//     [self.view addSubview:_testTextField];
//    
//    _codeField = [[UITextField alloc]init];
//    _codeField.placeholder = @"密码";
//    
//    [_codeField setValue:[UIColor colorWithHexString:@"#cdcdcd"] forKeyPath:@"_placeholderLabel.textColor"];
//    _codeField.delegate = self;
//    UIImageView *iconView2 = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 43, 17)];
//    iconView2.image = [UIImage imageNamed:@"password"];
//    iconView2.contentMode = UIViewContentModeLeft;
//    _codeField.leftView =iconView2;
//    _codeField.leftViewMode = UITextFieldViewModeAlways;
//    [_codeField setBackgroundColor:[UIColor whiteColor]];//透明效果
//    [self.view addSubview:_codeField];
//    
//    _getBtn = [[UIButton alloc]init];
//    [_getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [_getBtn.layer setMasksToBounds:YES];
//    [_getBtn.layer setCornerRadius:5];
//    [_getBtn.layer setBorderWidth:1];
//    _getBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    _getBtn.backgroundColor = [UIColor colorWithHexString:@"#3696d3"];
//    _getBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    [_getBtn addTarget:self action:@selector(getBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_testTextField addSubview:_getBtn];
//    
//    _accountBtn = [[UIButton alloc]init];
//    [_accountBtn setTitle:@"已有账号登录" forState:UIControlStateNormal];
//    [_accountBtn setTitleColor:[UIColor colorWithHexString:@"#3696d3"] forState:UIControlStateNormal];
//    [self.view addSubview:self.accountBtn];
//    
//    _registerBtn = [[UIButton alloc]init];
//    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
//    [_registerBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
//    [_registerBtn.layer setCornerRadius:5];
//    _registerBtn.backgroundColor = [UIColor colorWithHexString:@"#3696d3"];
//    [self.view addSubview:_registerBtn];
//    
//    self.lineView = [[UIView alloc]init];
//    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"];
//    [self.view addSubview:self.lineView];
//    
//    self.lineView1 = [[UIView alloc]init];
//    self.lineView1.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"];
//    [self.view addSubview:self.lineView1];
//    
//    self.lineView2 = [[UIView alloc]init];
//    self.lineView2.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"];
//    [self.view addSubview:self.lineView2];
//    
//    self.lineView3 = [[UIView alloc]init];
//    self.lineView3.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"];
//    [self.view addSubview:self.lineView3];
//    
//}
//
//    -(void)layoutUI{
//        
//        [self.headImagView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.centerX.equalTo(self.view);
//            make.top.equalTo(self.view.mas_top).offset(43 +64);
//            make.width.height.mas_equalTo(62);
//        }];
//        
//        [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.headImagView.mas_bottom).offset(27);
//            make.centerX.equalTo(self.view);
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(44);
//        }];
//        
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.phoneTextField.mas_top);
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(0.5);
//        }];
//        
//        [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.phoneTextField.mas_bottom);
//            make.left.equalTo(self.view.mas_left).offset(15);
//            make.width.mas_equalTo(SCREEN_WIDTH-15);
//            make.height.mas_equalTo(0.5);
//        }];
//        
//        [self.testTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.phoneTextField.mas_left);
//            make.top.equalTo(self.phoneTextField.mas_bottom);
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(44);
//        }];
//        
//        [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.testTextField.mas_bottom);
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(0.5);
//        }];
//        
//        [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.phoneTextField.mas_left);
//            make.top.equalTo(self.lineView2.mas_bottom);
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(44);
//            
//        }];
//        
//        [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.phoneTextField.mas_right).offset(-15);
//            make.top.equalTo(self.testTextField.mas_top).offset(7);
//            make.width.mas_equalTo(80);
//            make.height.mas_equalTo(30);
//        }];
//        
//        [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.codeField.mas_bottom);
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(0.5);
//            
//        }];
//        
//        [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView3.mas_bottom).offset(10);
//            make.right.equalTo(self.view).offset(-15);
//        }];
//        
//        [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.accountBtn.mas_bottom).offset(SCREEN_HEIGHT*0.08);
//            make.left.equalTo(self.view.mas_left).offset(15);
//            make.width.mas_equalTo(SCREEN_WIDTH - 30);
//            make.height.mas_equalTo(40);
//        }];
//    }
//
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    [_phoneTextField resignFirstResponder];
//    [_testTextField resignFirstResponder];
//    [_codeField resignFirstResponder];
//}
//
//-(void)loginClick{
//
//
//}
//
//-(void)getBtnClick{
//
//  
//}
//
//-(void)presentBack{
//
//    [self.navigationController popViewControllerAnimated:NO];
//}

@end
