//
//  nickController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "nickController.h"
#import "personDataController.h"
#import "KSAlertView.h"
#import "ETMessageView.h"

//字符串是否为空
#define KSTRING_IS_EMPTY(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 || [str isEqualToString:@""]? YES : NO )
@interface nickController ()<UITextFieldDelegate,CommonAlertDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITextField *field;

@end

@implementation nickController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    [self createView];
    [self createHttp];
    [self createTextField];
}

-(void)createView{

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"昵称";
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

-(void)createTextField{

    _field = [[UITextField alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 44)];
    _field.backgroundColor = [UIColor whiteColor];
    _field.placeholder = self.nickStr;
    _field.delegate = self;
    
    _field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)] ;
    _field.leftView.userInteractionEnabled = NO;
    _field.leftViewMode = UITextFieldViewModeAlways;
    
    // Text 垂直居中
    _field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _field.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_field];
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)saveMessage{

    [self.field resignFirstResponder];
     NSString *textField=[_field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    DDLog(@"%ld",_field.text.length);
    if (KSTRING_IS_EMPTY(textField) == YES) {
        
        [self showAlertWithMessage:@"昵称不能为空"];
    } else{
    
        [self loadData];
        //时间延迟
       
    }
}

#pragma mark -- 限制字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.field == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 15) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:15];
            [self showAlertWithMessage:@"字数限制在15字以内"];
         
            return NO;
        }
    }
    return YES;
}

-(void)loadData{
    
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaults objectForKey:@"userName"];
        NSDictionary *param = @{@"userId":userId,@"nickName":_field.text,@"phone":@"",@"sdasd":@"",@"sex":@""};
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

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 判断是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
