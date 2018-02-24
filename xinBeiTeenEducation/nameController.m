//
//  nameController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/15.
//  Copyright © 2017年 user. All rights reserved.
//

#import "nameController.h"
#import "childDataController.h"

@interface nameController ()<UITextFieldDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITextField *field;

@end

@implementation nameController

static NSString *babyId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self createNav];
    [self createTextField];
    [self createHttp];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"姓名";
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
    _field.placeholder = self.nameStr;
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

-(void)loadData{
    
    DLog(@"%@",self.babyId);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   NSString *userId = [userDefaults objectForKey:@"userName"];
    NSString *str = [NSString stringWithFormat:@"%@",self.babyId];
        NSDictionary *param = @{@"userId":userId,@"name":_field.text,@"sex":@"",@"birthday":@"",@"babyId":str};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
        NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
        NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
        DDLog(@"jsonString:%@",jsonString);
        [_manager POST:childDataURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DDLog(@"下载成功");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            DDLog(@"dict:%@",dict);
            
            babyId = dict[@"babyId"];
          int status = [dict[@"status"]intValue];
            if (status == 0) {
                
                DDLog(@"成功");
                childDataController *childData = [[childDataController alloc]init];
                childData.babyId = babyId;
                childData.nameString = _field.text;
                childData.fromWhere = self.fromWhere;
                
                childData.money = self.money;
                childData.subjectId = self.subjectId;
                childData.taskId = self.taskId;
                childData.orderId = self.orderId;
                childData.pictureImg = self.pictureImg;
                
                [self.navigationController pushViewController:childData animated:YES];
          }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)presentBack{

    if ([ETRegularUtil isEmptyString:_field.text]) {
        
        [self.navigationController popViewControllerAnimated:NO];
    }else{
    
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息未保存，确认返回" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:NO];
        }];
        
        [alertControl addAction:action];
        [alertControl addAction:action1];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

-(void)saveMessage{
    
    [self.field resignFirstResponder];
    if([ETRegularUtil isEmptyString:_field.text]){
        
        [self showAlertWithMessage:@"请您填写姓名"];
        return;
    }else{
    
    [self loadData];
 }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
