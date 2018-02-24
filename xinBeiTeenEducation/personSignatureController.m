//
//  personSignatureController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "personSignatureController.h"
#import "ETMessageView.h"
#import "personDataController.h"

@interface personSignatureController ()<YYTextViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) YYTextView *textView;

@end

@implementation personSignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self createNav];
    [self createHttp];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //导航会使得UItextView的光标下移
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

  [self.textView becomeFirstResponder];
}

-(void)createNav{

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"个性签名";
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

-(void)createView{

    _textView = [[YYTextView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 60)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.placeholderText = self.signatureStr;
    _textView.placeholderFont = [UIFont systemFontOfSize:16];
    _textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_textView];
}

- (void)textViewDidChange:(YYTextView *)textView{

    if (textView == _textView) {
        if (_textView.text.length >50) {
            _textView.text = [_textView.text substringToIndex:50];
            
            [self showAlertWithMessage:@"字数限制在50字以内"];
        }
    }
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveMessage{

    [self loadQianData];

}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadQianData{
    
    DDLog(@"%@",_textView.text);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *param = @{@"userId":userId,@"nickName":@"",@"phone":@"",@"sdasd":_textView.text,@"sex":@""};
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

@end
