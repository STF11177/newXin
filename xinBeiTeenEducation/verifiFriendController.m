//
//  verifiFriendController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "verifiFriendController.h"
#import "addfriendController.h"
#import "messageDetailController.h"

@interface verifiFriendController ()
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITextField *field;
@property (nonatomic,strong) UILabel *verfiLb;

@end

@implementation verifiFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createView];
    [self createHttp];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
}

-(void)createNav{

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"朋友验证";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:18];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 19)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton addTarget:self action:@selector(goback2) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 19)];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)createView{

    self.verfiLb = [[UILabel alloc]initWithFrame:CGRectMake( 5, 64, SCREEN_WIDTH,44)];
    self.verfiLb.text = @"你需要发送验证申请，等对方通过";
    self.verfiLb.textColor = [UIColor grayColor];
    self.verfiLb.font = [UIFont systemFontOfSize:16];
    self.verfiLb.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:self.verfiLb];
    
    self.field = [[UITextField alloc]initWithFrame:CGRectMake(0, 64 + 44, SCREEN_WIDTH, 44)];
    self.field.backgroundColor = [UIColor whiteColor];
    _field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 44, 5, 0)] ;
    _field.leftView.userInteractionEnabled = NO;
    _field.leftViewMode = UITextFieldViewModeAlways;
    self.field.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.field];
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark -- 加好友
-(void)loadFriendData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    
    //请求参数
    NSDictionary *param = @{@"userId":userId,@"target_uid":self.from_uid,@"remarks":self.field.text};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:addFriendURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            DDLog(@"%@",@"成功");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            messageDetailController *detail = [[messageDetailController alloc]init];
            detail.target_uid = self.from_uid;
            [self.navigationController pushViewController:detail animated:NO];
         
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)goback2{

    [self.navigationController popViewControllerAnimated:NO];
}

-(void)completeClick{

    [self loadFriendData];

}

@end
