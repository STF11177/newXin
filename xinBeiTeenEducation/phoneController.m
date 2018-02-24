//
//  phoneController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "phoneController.h"
#import "personDataController.h"
#import "nickController.h"
#import "ETMessageView.h"
#import "CommonAlert.h"
#import "CommonSheet.h"

@interface phoneController ()<UITextFieldDelegate,CommonAlertDelegate,CommonSheetDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITextField *field;
@property (nonatomic, copy)NSString *tagg;

@end

@implementation phoneController
static int status;
static NSString *codeStr;
static NSString *fieldStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self createView];
    [self createTextField];
    [self createHttp];
}

-(void)createView{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"手机号码";
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

-(void)createTextField{
    
    _field = [[UITextField alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 44)];
    _field.backgroundColor = [UIColor whiteColor];
    _field.placeholder = self.phoneStr;
    _field.delegate = self;
    
    _field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)] ;
    _field.leftView.userInteractionEnabled = NO;
    _field.leftViewMode = UITextFieldViewModeAlways;
    
    // Text 垂直居中
    _field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _field.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_field];
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveMessage{

    [_field resignFirstResponder];
    [self loadPhoneData];
    
}

#pragma mark --修改手机号码
-(void)loadPhoneData{
    
    NSDictionary *param = @{@"mobile":self.field.text};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:chagePhoneURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        codeStr = dict[@"authCode"];
            if ([self valiMobile:_field.text]) {
                status = [dict[@"status"]intValue];
                if (status == 1) {
                    
                    [self showAlertWithMessage:@"此手机号已被注册"];
                    
                }else{
                        CommonAlert *alert1 = [[CommonAlert alloc]initWithBtnTitles:@[@"好的"]];
                        alert1.delegate = self;
                        self.tagg = @"2";
                        fieldStr = alert1.textField.text;
                        DDLog(@"%@",fieldStr);
                        
                        [[UIApplication sharedApplication].keyWindow addSubview:alert1];
                    }
            }else{
    
                [self showAlertWithMessage:@"请输入有效的手机号码"];
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)oneButtonitemCertain:(CommonAlert *)alert{
    DDLog(@"%@",codeStr);
    if ([self.tagg isEqualToString:@"2"]) {
        
        if ([alert.textField.text isEqualToString:codeStr]) {
            
            [self loadData];
            
        }else{
            
            CommonAlert *alert = [[CommonAlert alloc]initWithMessage:@"验证码错误，请重新输入" withBtnTitles:@[@"我知道了"]];
            alert.delegate = self;
            self.tagg = @"3";
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
        }
    }
}

-(void)loadData{
    
    DDLog(@"%@",_field.text);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *param = @{@"userId":userId,@"nickName":@"",@"phone":_field.text,@"sdasd":@"",@"sex":@""};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:nickURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            DDLog(@"成功");
            
            personDataController *person = [[personDataController alloc]init];
            [self.navigationController pushViewController:person animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

#pragma mark -- 点击空白处收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_field resignFirstResponder];
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
