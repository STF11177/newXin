//
//  addClassController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "addClassController.h"
#import "gradeDetailController.h"
#import "ETRegularUtil.h"

@interface addClassController ()
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITextField *field;

@end

@implementation addClassController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:_field];
    [self createNav];
    [self createHttp];
    [self createTextField];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"添加班级";
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

-(void)loadClassData{

    NSDictionary *param = @{@"type":self.typeStr,@"schoolName":self.schoolStr,@"className":_field.text};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:addClassURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            DDLog(@"%@",self.babyId);
            gradeDetailController *detail = [[gradeDetailController alloc]init];
            detail.addClass = _field.text;
            detail.fromAddClass = @"addClass";
            detail.fromWhere = self.typeStr;
            detail.babyId = self.babyId;
            detail.addressStr = self.addressStr;
            detail.schoolStr = self.schoolStr;
            detail.timeStr = self.timeStr;
            detail.nameStr = self.nameStr;
            DDLog(@"%@",self.classStr);
            
//              NSArray *classArray = [self.classStr componentsSeparatedByString:@"/"];
//              self.classStr = [classArray[0] stringByAppendingString:@"/"];
            NSString *str1 = [self.gradeStr stringByAppendingString:@"/"];
            NSString *str = [str1 stringByAppendingString:_field.text];
            detail.classStr = str;
            
            [self.navigationController pushViewController:detail animated:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:NO];
}

-(void)saveMessage{

    [self loadClassData];
}

@end







