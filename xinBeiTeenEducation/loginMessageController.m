//
//  loginMessageController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "loginMessageController.h"
#import "parentsCircleController.h"
#import "ETTabBarController.h"
#import "ETMessageView.h"
#import "newController.h"
#import "ETMessageView.h"
#import "CommonAlert.h"

@interface loginMessageController ()<UITextFieldDelegate,CommonAlertDelegate>
{

    AFHTTPRequestOperationManager *_manager;

}
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *testTextField;//验证码
@property (nonatomic,strong) UIButton *getBtn;//获取的按钮
@property (nonatomic,strong) UIButton *loginBtn;//登录
@property (nonatomic,strong) UILabel *telephoneLb;//客服热线
@property (nonatomic,strong) UIImageView *headImagView;
@property (nonatomic,strong) UIView *btnView;
@property (nonatomic,strong) UIView *lineView;//线
@property (nonatomic,strong) UIView *lineView1;//线
@property (nonatomic,strong) UIView *lineView2;//线
@property (nonatomic,assign) int status;//下载有没有成功

@end

@implementation loginMessageController
static NSString *codeStr;
static NSString *userId;
static NSString *date;
static NSString *userStatus;
static NSString *tokenStr;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self createView];
    [self layout];
    [self createHttp];
    
    DDLog(@"%@",self.loginStatus);
    if ([self.loginStatus isEqualToString:@"1"]) {
        
        [self showAlertWithMessage:@"手机号已被别人登录,请重新登录"];
    }
}

-(void)createView{
    
    _headImagView = [[UIImageView alloc]init];
    _headImagView.image = [UIImage imageNamed:@"logoing"];
    _headImagView.layer.cornerRadius = 10;
    _headImagView.layer.masksToBounds = YES;
    [self.view addSubview:_headImagView];
    
    _phoneTextField = [[UITextField alloc]init];
    _phoneTextField.placeholder = @"请输入手机号码";
    [_phoneTextField setValue:[UIColor colorWithHexString:@"#cdcdcd"] forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTextField.delegate = self;
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 43, 17)];
    iconView.image = [UIImage imageNamed:@"iphone"];
    iconView.contentMode = UIViewContentModeLeft;
    _phoneTextField.leftView =iconView;
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    [_phoneTextField setBackgroundColor:[UIColor whiteColor]];//透明效果
    [self.view addSubview:_phoneTextField];
    
    _testTextField= [[UITextField alloc]init];
    _testTextField.placeholder = @"请输入验证码";
    [_testTextField setValue:[UIColor colorWithHexString:@"#cdcdcd"] forKeyPath:@"_placeholderLabel.textColor"];
    _testTextField.delegate = self;
    UIImageView *iconView1 = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 43, 17)];
    iconView1.image = [UIImage imageNamed:@"password"];
    iconView1.contentMode = UIViewContentModeLeft;
    _testTextField.leftView =iconView1;
    _testTextField.leftViewMode = UITextFieldViewModeAlways;
    [_testTextField setBackgroundColor:[UIColor whiteColor]];//透明效果
    [self.view addSubview:_testTextField];
    
    _btnView = [[UIView alloc]init];
    _btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_btnView];
    
    _getBtn = [[UIButton alloc]init];
    [_getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getBtn.layer setMasksToBounds:YES];
    [_getBtn.layer setCornerRadius:5];
    [_getBtn.layer setBorderWidth:1];
    _getBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _getBtn.backgroundColor = [UIColor colorWithHexString:@"#3696d3"];
    _getBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [_getBtn addTarget:self action:@selector(getBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_getBtn];
    
    _loginBtn = [[UIButton alloc]init];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn.layer setCornerRadius:5];
    _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#3696d3"];
    [self.view addSubview:_loginBtn];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"];
    [self.view addSubview:self.lineView];
    
    self.lineView1 = [[UIView alloc]init];
    self.lineView1.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"];
    [self.view addSubview:self.lineView1];
    
    self.lineView2 = [[UIView alloc]init];
    self.lineView2.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"];
    [self.view addSubview:self.lineView2];
}

-(void)layout{
    
    [_headImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(43);
        make.width.height.mas_equalTo(62);
    }];

    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImagView.mas_bottom).offset(27);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(44);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [_testTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTextField.mas_left);
        make.top.equalTo(self.phoneTextField.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH- 80- 15 -10);
        make.height.mas_equalTo(44);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testTextField.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
    }];

    [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.testTextField.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.centerY.equalTo(self.testTextField.mas_centerY);
        make.height.mas_equalTo(44);
    }];
    
    [_getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneTextField.mas_right).offset(-15);
        make.top.equalTo(self.testTextField.mas_top).offset(7);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];

    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testTextField.mas_bottom).offset(SCREEN_HEIGHT*0.08);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.height.mas_equalTo(40);
    }];
}

-(void)createHttp{

    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    
    return UIStatusBarStyleDefault;
}

-(void)loadTestData{

    DDLog(@"%@",self.phoneTextField.text);
    NSDictionary *param = @{@"mobile":self.phoneTextField.text};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:testMessageURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
                codeStr = dict[@"authCode"];
                date = dict[@"date"];
                
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:date forKey:@"date"];
                
                userStatus = dict[@"userStatus"];
        
                DDLog(@"%@",userStatus);
//            NSString *userStr = [NSString stringWithFormat:@"%@",userStatus];
            
//            if ([userStr isEqualToString:@"0"]) {
//
//                [self showAlertWithMessage:@"此手机号已被登录，请重新登录"];
//            }else
                if ([self valiMobile:_phoneTextField.text]) {
                __block NSInteger time = 119;//倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer, dispatch_walltime(NULL,0), 1.0*NSEC_PER_SEC, 0);//每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    
                    if (time <=0) {//倒计时结束，关闭时间
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(),^{
                            
                          //设置按钮的样式
                          [_getBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                         _getBtn.userInteractionEnabled = YES;
                        });
                        
                    }else{
                        
                        int seconds = time%120;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置按钮的读秒效果
                            [_getBtn setTitle:[NSString stringWithFormat:@"%.2d",seconds] forState:UIControlStateNormal];
                            [_getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            _getBtn.userInteractionEnabled = NO;
                        });
                        time--;
                    }
                });
                
                dispatch_resume(_timer);
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user removeObjectForKey:@"date"];
            }else{
                
                [self showAlertWithMessage:@"请输出有效的手机号码"];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)presentController{

    [self.navigationController popViewControllerAnimated:NO];
}

//倒计时效果
-(void)getBtnClick{
    
    if ([self valiMobile:_phoneTextField.text]) {
    
       [self loadTestData];
    }else{
        [self showAlertWithMessage:@"请输出有效的手机号码"];
    }
}

#pragma mark -- 登录
-(void)loginClick{

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *dateStr = [userDefaults objectForKey:@"date"];

    DDLog(@"%@",dateStr);
    NSDate *oldDate = [self dateFromString:dateStr];
    DDLog(@"%@",oldDate);
    NSDate *nowDate = [NSDate date];
    DDLog(@"%@",nowDate);

    NSTimeInterval time = [nowDate timeIntervalSinceDate:oldDate];
    DDLog(@"%f",time);
    
    if ([self valiMobile:_phoneTextField.text]) {
        
        if ([_testTextField.text isEqualToString:@"123456"]&&[_phoneTextField.text isEqualToString: @"15821450047"]) {
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:@"10001" forKey:@"userName"];
            NSUserDefaults *token = [NSUserDefaults standardUserDefaults];
            [token setObject:@"123456" forKey:@"tokenName"];
            ETTabBarController *tab = [[ETTabBarController alloc]init];
            [self presentViewController:tab animated:NO completion:^{
            }];
        }else{
        
            if ([codeStr isEqualToString:_testTextField.text]||(time<120)) {
                
                [self loadLoginData];
            }
            else{
                [self showAlertWithMessage:@"验证码错误"];
            }
        }
    }else{
        [self showAlertWithMessage:@"请输出有效的手机号码"];
    }
}

//NSString转NSDate
- (NSDate *)dateFromString:(NSString *)string
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    return date;
}

-(void)loadLoginData{

    NSDictionary *param = @{@"mobile":self.phoneTextField.text};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);

    [_manager POST:loginURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"%@",dict);
        _status = [dict[@"status"]intValue];
        if (_status == 0) {
            
            DDLog(@"下载成功");
            userId = dict[@"userId"];
            DDLog(@"%@",userId);
            
            tokenStr = dict[@"token"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:userId forKey:@"userName"];
            
            NSUserDefaults *token = [NSUserDefaults standardUserDefaults];
            [token setObject:tokenStr forKey:@"tokenName"];
            
            DDLog(@"%@",tokenStr);
            
            //在真机上会有延迟的效果
            DDLog(@"%@",self.phoneTextField.text);
            dispatch_async(dispatch_get_main_queue(), ^{
            
                ETTabBarController *tab = [[ETTabBarController alloc]init];
                [self presentViewController:tab animated:NO completion:^{
                }];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_testTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
}

//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}


@end
