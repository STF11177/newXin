//
//  commentController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "commentController.h"
#import "ETMessageView.h"
#import "CommonSheet.h"
#import "newController.h"
#import "newDetailController.h"

@interface commentController ()<YYTextViewDelegate,CommonAlertDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) YYTextView *textView;
@property (nonatomic,strong) UITextView *commentView;
@property (nonatomic,strong) UILabel *pladerLb;

@end

@implementation commentController
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    [self createTextView];
    [self createHttpRequest];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

-(void)createView{

    UILabel *lable = [[UILabel alloc] init];
    
    lable.text = @"发评论";
    lable.font = [UIFont systemFontOfSize:18];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.width = 100;
    lable.height = 80;
    lable.numberOfLines = 0;
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40 - 10, 40, 50, 50)];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)createTextView{

    self.textView = [[YYTextView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, SCREEN_HEIGHT)];
    self.textView.alwaysBounceVertical = YES;//垂直向上有弹簧效果
    self.textView.delegate = self;
    self.textView.placeholderText = @"写评论";
    
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.textColor = [UIColor colorWithHexString:@"#000000"];
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.placeholderFont = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.textView];
}

-(void)cancelLeftBtn{

       [self.navigationController popViewControllerAnimated:NO];
}

-(void)sendMessage{

    if([ETRegularUtil isEmptyString:_textView.text]){
        
        CommonAlert *alert = [[CommonAlert alloc]initWithMessage:@"请输入评论内容" withBtnTitles:@[@"我知道了"]];
        alert.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        
        return;
    }
    
    [self loadData];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark -- 家长圈评论
-(void)loadData{
    
    NSDictionary *param = @{@"userId":userId,@"taskId":_commentTaskId,@"content":self.textView.text};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:commentURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
            [self.navigationController popViewControllerAnimated:NO];
            [self showHint:@"发表评论成功"];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showHint:@"发表评论失败"];
    }];
}

@end
