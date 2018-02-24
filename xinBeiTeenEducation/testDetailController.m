//
//  testDetailController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/30.
//  Copyright © 2017年 user. All rights reserved.
//

#import "testDetailController.h"
#import "detailtabView.h"
#import "testCommentController.h"
#import "ETMessageView.h"
#import "tabbarView.h"
#import <UShareUI/UShareUI.h>

@interface testDetailController ()<UIWebViewDelegate,tabbarViewDelegate>
@property (nonatomic,strong) tabbarView *tabView;

@end

@implementation testDetailController
static NSString *userId;
static int collectNumber;
static int likeNumber;
static int likeCount;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createNav];
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self createView];//相当于刷新
    [self isLikeOrCollect];
    [self createFootView];
    [[ETMessageView sharedInstance]showMessage:@"加载中" onView:self.view];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"评论";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createFootView{
    
    self.tabView = [[tabbarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    self.tabView.delegate = self;
    [self.view addSubview:self.tabView];
}

-(void)textFieldDelegate:(detailtabView *)field{

    testCommentController *comment = [[testCommentController alloc]init];
    comment.commentTaskId = self.taskId;
    [self presentViewController:comment animated:NO completion:^{
        
    }];
}

-(void)createView{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    DDLog(@"%@",self.taskId);
    DDLog(@"%@",userId);
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    if(iOS11){
        
        self.webView.scrollView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    
    NSString *bodyView;
    bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@",userId,self.taskId];
    
    DDLog(@"bodyView:%@",bodyView);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:testDetailURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyView dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest:request];
    
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    for (UIView *_aView in [_webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    [self.view addSubview:_webView];
}

#pragma mark -- 点赞
-(void)liekTabbarDelegate:(detailtabView *)field{
    
    if (field.likeBtn.selected == YES) {
        
        [field.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        likeCount = likeCount -1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeCount];
        DDLog(@"%@",likeStr);
        [field.likeBtn setTitle:likeStr forState:UIControlStateNormal];
        likeNumber = 0;
    }else{
        
        [field.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
        likeCount = likeCount + 1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeCount];
        DDLog(@"%@",likeStr);
        [field.likeBtn setTitle:likeStr forState:UIControlStateNormal];
        likeNumber = 1;
    }
    
    field.likeBtn.selected = !self.tabView.likeBtn.selected;
    field.likeBtn = self.tabView.likeBtn;
    [self loadDetailLikeData];
}

-(void)loadDetailLikeData{
    
    DDLog(@"%@",self.taskId);
    DDLog(@"%d",collectNumber);
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    NSString *collectNum = [[NSString alloc]initWithFormat:@"%d",likeNumber];
    NSString *taskStr = [[NSString alloc]initWithFormat:@"%@",self.taskId];
    
    DDLog(@"%@",collectNum);
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&type=%@&status=%@&typeStatus=%@",userId,taskStr,@"2",collectNum,@"1"];
    DDLog(@"bodyView:%@",bodyView);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newDetailLikeURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyView dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest:request];
}

#pragma mark -- 是否点赞或收藏
-(void)isLikeOrCollect{
    
    DDLog(@"%@",self.taskId);
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    NSString *taskStr = [[NSString alloc]initWithFormat:@"%@",self.taskId];
    
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&status=%@",userId,taskStr,@"2"];
    DDLog(@"bodyView:%@",bodyView);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:isLikeOrCollectURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyView dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest:request];
}

#pragma mark -- 收藏
-(void)collectTabbarDelegate:(detailtabView *)field{
    
    if (field.collectBtn.selected == YES) {
        
        [field.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
        collectNumber = 0;
    }else{
        
        [field.collectBtn setImage:[UIImage imageNamed:@"nices2"] forState:UIControlStateNormal];
        collectNumber = 1;
    }
    
    field.collectBtn.selected = !self.tabView.collectBtn.selected;
    field.collectBtn = self.tabView.collectBtn;
    [self loadDetailCollectData];
}

-(void)loadDetailCollectData{
    
    DDLog(@"%@",self.taskId);
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    NSString *collectNum = [[NSString alloc]initWithFormat:@"%d",collectNumber];
    NSString *taskStr = [[NSString alloc]initWithFormat:@"%@",self.taskId];
    DDLog(@"%@",collectNum);
    
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&type=%@&status=%@&typeStatus=%@",userId,taskStr,@"2",collectNum,@"2"];
    DDLog(@"bodyView:%@",bodyView);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newDetailLikeURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyView dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest:request];
}

#pragma mark -- 加loading
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[ETMessageView sharedInstance] hideMessage];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [[ETMessageView sharedInstance] hideMessage];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lian"]];
    imageView.frame = CGRectMake(SCREEN_WIDTH/3, 64 + SCREEN_HEIGHT/5, 115, 73);
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 64 + SCREEN_HEIGHT/5 + 10 +73, SCREEN_WIDTH, 44)];
    [btn.titleLabel setTextColor:[UIColor blackColor]];
    [btn setTitle:@"网络不佳，请点击屏幕重试" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:imageView];
    [self.view addSubview:btn];
    
    self.tabView.shareBtn.userInteractionEnabled = NO;
    self.tabView.collectBtn.userInteractionEnabled = NO;
    self.tabView.likeBtn.userInteractionEnabled = NO;
}

-(void)btnClick{
    
    [self createView];
    [self createFootView];
}

#pragma mark -- 交互
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //    [[ETMessageView sharedInstance]showMessage:@"加载中" onView:self.view];
    //    直接截取后面的id
    NSString *str = request.URL.resourceSpecifier;
    NSLog(@"request.URL.resourceSpecifier = %@",request.URL.resourceSpecifier);
    
    NSRange commentRanage = [str rangeOfString:@"comment_id="];
    if (commentRanage.location != NSNotFound) {
        NSArray *commentArray = [str componentsSeparatedByString:@"&"];
        NSString *from_userId = commentArray[0];
        NSString *comment_Id = commentArray[1];
        NSString *remarkName = commentArray[2];
        NSString *nickName = commentArray[3];
        NSString *taskId = commentArray[4];
        
        NSArray *fromUserIdArray = [from_userId componentsSeparatedByString:@"="];
        NSString *fromUid = fromUserIdArray[1];
        
        NSArray *commArray = [comment_Id componentsSeparatedByString:@"="];
        NSString *commStr = commArray[1];
        
        NSArray *remarkArray = [remarkName componentsSeparatedByString:@"="];
        NSString *remarkStr = remarkArray[1];
        
        NSArray *nickArray = [nickName componentsSeparatedByString:@"="];
        NSString *nickStr = nickArray[1];
        
        NSArray *taskArray = [taskId componentsSeparatedByString:@"="];
        NSString *taskStr = taskArray[1];
        
        DDLog(@"%@",fromUid);
        DDLog(@"%@",commStr);
        DDLog(@"%@",remarkStr);
        DDLog(@"%@",nickStr);
        DDLog(@"%@",taskStr);
        
        testCommentController *detail = [[testCommentController alloc] init];
        detail.fromUser = fromUid;
        detail.commentStr = commStr;
        detail.remarkStr = remarkStr;
        detail.nickStr = nickStr;
        detail.taskStr = taskStr;
        detail.userName = self.userName;
        detail.from_uid = userId;
        
        [self presentViewController:detail animated:NO completion:^{
            
        }];
        
        return NO;
    }
    
    NSRange range1 = [str rangeOfString:@"106.14.251.200/neworld/user/154?"];
    if (range1.location != NSNotFound) {
        NSArray *statusArray = [str componentsSeparatedByString:@"106.14.251.200/neworld/user/154?"];
        NSString *status1 = statusArray[1];
        
        NSArray *statusArry1 = [status1 componentsSeparatedByString:@"&"];
        NSString *collectStr = statusArry1[0];
        NSString *likeStr = statusArry1[1];
        NSString *likeCount1 = statusArry1[2];
        
        NSArray *statusArry2 = [collectStr componentsSeparatedByString:@"="];
        collectStr = statusArry2[1];
        
        NSArray *statusArry3 = [likeStr componentsSeparatedByString:@"="];
        likeStr = statusArry3[1];
        
        NSArray *statusArry4 = [likeCount1 componentsSeparatedByString:@"="];
        likeCount1 = statusArry4[1];
        
        if ([likeStr isEqualToString:@"0"]) {
            
            [self.tabView.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
            self.tabView.likeBtn.selected = YES;
        }else{
            
            [self.tabView.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
            self.tabView.likeBtn.selected = NO;
        }
        
        //点赞数
        [self.tabView.likeBtn setTitle:likeCount1 forState:UIControlStateNormal];
        likeCount = [likeCount1 intValue];
        
        if ([collectStr isEqualToString:@"0"]) {
            
            [self.tabView.collectBtn setImage:[UIImage imageNamed:@"nices2"] forState:UIControlStateNormal];
            self.tabView.collectBtn.selected = YES;
        }else{
            
            [self.tabView.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
            self.tabView.collectBtn.selected = NO;
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark -- 分享
-(void)shareTabbarDelegate:(tabbarView *)field{
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pictureImg]];
    UIImage *thumImage = [UIImage imageWithData:data];
    
    if (!thumImage) {
        
        thumImage = [UIImage imageNamed:@"lianjie"];
    }
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:self.titleStr thumImage:thumImage];
    
    //设置网页地址
    NSString *baseStr1 = [NSString stringWithFormat:@"http://www.uujz.me:8082/neworld/user/162?userId=%@",userId];
    NSString *baseStr2 = [NSString stringWithFormat:@"&taskId=%@",self.taskId];
    NSString *str = [baseStr1 stringByAppendingString:baseStr2];
    DDLog(@"%@",str);
    
    shareObject.webpageUrl = str;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}



-(void)goBack{

    [self.navigationController popViewControllerAnimated:NO];
}

@end
