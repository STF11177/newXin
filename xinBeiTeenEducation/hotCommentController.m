//
//  hotCommentController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "hotCommentController.h"
#import "ETMessageView.h"
#import "CommonSheet.h"
#import "newController.h"
#import "newDetailController.h"
#import "ETRegularUtil.h"

@interface hotCommentController ()<YYTextViewDelegate,CommonAlertDelegate,UIWebViewDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) YYTextView *textView;
@property (nonatomic,strong) UITextView *commentView;
@property (nonatomic,strong) UILabel *pladerLb;

@property (nonatomic,strong) UIView *naView;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation hotCommentController
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    [self createTextView];
    [self createHttpRequest];
    
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

-(void)createView{
    
    self.naView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.naView.backgroundColor = [UIColor colorWithHexString:@"#1b82d2"];
    [self.view addSubview:self.naView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 20, 100, 40)];
    lable.text = @"发评论";
     lable.font = [UIFont systemFontOfSize:18];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [self.naView addSubview:lable];
    
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, 50, 50)];
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.leftBtn addTarget:self action:@selector(cancelLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.naView addSubview:self.leftBtn];
    
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15- 50, 20, 50, 50)];
    [self.rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.rightBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.naView addSubview:self.rightBtn];
}

-(void)createTextView{
    
    DDLog(@"%@",self.commentTaskId);
    self.textView = [[YYTextView alloc]initWithFrame:CGRectMake(15, 64, SCREEN_WIDTH-15, SCREEN_HEIGHT)];
    self.textView.alwaysBounceVertical = YES;//垂直向上有弹簧效果
    self.textView.delegate = self;
    
    if ([ETRegularUtil isEmptyString:self.commentStr]) {
        
        self.textView.placeholderText = @"写评论";
    }else{
        if ([ETRegularUtil isEmptyString:self.remarkStr]) {
            
            self.textView.placeholderText = [NSString stringWithFormat:@"@%@",self.nickStr];
            self.textView.placeholderTextColor = [UIColor grayColor];
        }else{
            
            self.textView.placeholderText = [NSString stringWithFormat:@"@%@",self.remarkStr];
            self.textView.placeholderTextColor = [UIColor grayColor];
        }
    }
    
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.textColor = [UIColor colorWithHexString:@"#000000"];
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.placeholderFont = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.textView];
}

-(void)cancelLeftBtn{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

-(void)sendMessage{
    
    if([ETRegularUtil isEmptyString:_textView.text]){
        
        [self showAlertWithMessage:@"请输入评论内容"];
        return;
    }else{
        if ([ETRegularUtil isEmptyString:self.commentStr]) {
            
            [self loadMyCommentHotparam];
        }else{
            
            [self loadHotDataWithParam];
        }
    }
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark -- 回复评论
-(void)loadHotDataWithParam{
    
    __weak typeof(self) weakSelf = self;
    NSString *from_uid = [NSString stringWithFormat:@"%@",self.fromUser];
    NSString *commentStr = [NSString stringWithFormat:@"%@",self.commentStr];
    NSString *commentTask = [NSString stringWithFormat:@"%@",self.taskStr];
    DDLog(@"%@",commentTask);
    DDLog(@"%@",commentStr);
    DDLog(@"%@",from_uid);
    
    NSDictionary *param = @{@"userId":userId,@"taskId":commentTask,@"content":self.textView.text,@"from_userId":from_uid,@"comment_id":commentStr,@"maodian":@"1"};

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:hotCommentURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf dismissViewControllerAnimated:NO completion:^{
                    
                    if (self.delegate) {
                        
                        [self.delegate selectStr:@"2"];
                    }
                }];                [weakSelf showHint:@"发表评论成功"];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showHint:@"发表评论失败"];
    }];
}

#pragma mark -- 自己评论

-(void)loadMyCommentHotparam{
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"userId":userId,@"taskId":self.commentTaskId,@"content":self.textView.text,@"from_userId":@"",@"comment_id":@"",@"maodian":@"1"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:hotCommentURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:NO completion:^{
                    
                    if (self.delegate) {
                        
                        [self.delegate selectStr:@"2"];
                    }
                }];
                [weakSelf showHint:@"发表评论成功"];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showHint:@"发表评论失败"];
    }];
}

@end
