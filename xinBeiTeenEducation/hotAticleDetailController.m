//
//  hotAticleDetailController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "hotAticleDetailController.h"
#import "hotAticleController.h"
#import "messageDetailController.h"
#import <UShareUI/UShareUI.h>
#import "tabbarView.h"
#import "hotCommentController.h"
#import "ETMessageView.h"
#import "MBProgressHUD.h"
#import "backGroundView.h"

@interface hotAticleDetailController ()<UIWebViewDelegate,tabbarViewDelegate,commentDetailDelegate,UIGestureRecognizerDelegate,backViewdelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) tabbarView *tabView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态
@property (nonatomic,strong) backGroundView *backView;

@end

@implementation hotAticleDetailController
static NSString *userId;
static int collectNumber;
static int likeCount;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    YYReachability *reachablity = [YYReachability reachability];
    NSString *string = [NSString stringWithFormat:@"%lu",(unsigned long)reachablity.status];
    if ([string isEqualToString:@"2"]) {
        
        self.netStatus1 = YES;
    }else if ([string isEqualToString:@"1"]){
        
        self.netStatus1 = YES;
    }else{
        
        self.netStatus1 = NO;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createNav];
    
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    self.fd_interactivePopDisabled = NO;
    
    [self createView];//相当于刷新
    [self isLikeOrCollect];
    [self createFootView];
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

//无网络
-(void)noNetStatus{
    
    self.tabView.likeBtn.userInteractionEnabled = NO;
    self.tabView.collectBtn.userInteractionEnabled = NO;
    self.tabView.shareBtn.userInteractionEnabled = NO;
    self.tabView.textFiled.userInteractionEnabled = NO;
    self.netStatus1 = NO;
}

//有网络
-(void)netStatus{
    
    _imageView.hidden = YES;
    _btnImage.hidden = YES;

    self.netStatus1 = YES;
    [self.backView removeFromSuperview];
    [self createView];
    [self createFootView];
}

-(void)netStatuswifi{

    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    self.netStatus1 = YES;
    
    [self.backView removeFromSuperview];
    [self createView];
    [self createFootView];
}

-(void)netClickDelegate:(backGroundView *)view{

    [self.backView removeFromSuperview];
    [self createView];
    [self createFootView];
}

-(void)selectStr:(NSString *)str{
    
    self.fromHotAticle = str;
    DDLog(@"%@",self.fromHotAticle);
    [self createView];
    [self createFootView];
}

-(void)createView{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    DDLog(@"%@",self.taskId);
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    if(iOS11){
        
        self.webView.scrollView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    
    NSString *fromStr = [NSString stringWithFormat:@"%@",self.fromHotAticle];
    DDLog(@"%@",fromStr);
    
    //添加锚点
    NSString *bodyView;
    if ([fromStr isEqualToString:@"2"]) {
        
    bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&maodian=%@",userId,self.taskId,@"0"];
    }else{
    
    bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&maodian=%@",userId,self.taskId,@"1"];
    }
    
    self.fromHotAticle = @"0";
    DDLog(@"bodyView:%@",bodyView);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:hotArtcleURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyView dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest:request];
    
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    for (UIView *_aView in [_webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:YES];
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    
    return UIStatusBarStyleDefault;
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"正文";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor blackColor];
    self.navigationItem.titleView = lable;
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 19, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"arrow-fx1"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(goRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)createFootView{
    
    self.tabView = [[tabbarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    self.tabView.delegate = self;
    [self.view addSubview:self.tabView];
}

#pragma mark -- textfield代理
-(void)textFieldDelegate:(tabbarView *)field{
    
    hotCommentController *comment = [[hotCommentController alloc]init];
    comment.commentTaskId = self.taskId;
    comment.userName = self.userName;
    comment.from_uid = self.from_uid;
    comment.delegate = self;
    DDLog(@"%@",self.userName);
    DDLog(@"%@",comment.userName);
    
    [self presentViewController:comment animated:NO completion:^{
        
    }];
}

#pragma mark -- 点赞
-(void)liekTabbarDelegate:(tabbarView *)field{
    
    DDLog(@"%d",likeCount);
    if (field.likeBtn.selected == YES) {
        
        [field.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        likeCount = likeCount - 1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeCount];
        DDLog(@"%@",likeStr);
        [field.likeBtn setTitle:likeStr forState:UIControlStateNormal];
        collectNumber = 0;
    }else{
        
        [field.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
        collectNumber = 1;
        likeCount = likeCount + 1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeCount];
        DDLog(@"%@",likeStr);
        [field.likeBtn setTitle:likeStr forState:UIControlStateNormal];
    }
    field.likeBtn.selected = !self.tabView.likeBtn.selected;
    field.likeBtn = self.tabView.likeBtn;
    [self loadDetailLikeData];
}

-(void)loadDetailLikeData{
    
    DDLog(@"%@",self.taskId);
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    NSString *collectNum = [[NSString alloc]initWithFormat:@"%d",collectNumber];
    NSString *taskStr = [[NSString alloc]initWithFormat:@"%@",self.taskId];
    
    DDLog(@"%@",collectNum);
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&type=%@&status=%@&typeStatus=%@",self.from_uid,taskStr,@"3",collectNum,@"1"];
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
    
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&status=%@",self.from_uid,taskStr,@"3"];
    DDLog(@"bodyView:%@",bodyView);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:isLikeOrCollectURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyView dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest:request];
}

#pragma mark -- 收藏
-(void)collectTabbarDelegate:(tabbarView *)field{
    
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
    
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&type=%@&status=%@&typeStatus=%@",self.from_uid,taskStr,@"3",collectNum,@"2"];
    DDLog(@"bodyView:%@",bodyView);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newDetailLikeURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyView dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest:request];
}

#pragma mark -- 分享
-(void)shareTabbarDelegate:(tabbarView *)field{
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
    }];
}

#pragma mark -- 加loading
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[ETMessageView sharedInstance] hideMessage];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

    [[ETMessageView sharedInstance]showMessage:@"加载中" onView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [[ETMessageView sharedInstance] hideMessage];
    
    self.backView = [[backGroundView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.backView.delegate = self;
    [self.view addSubview:self.backView];
    
    self.tabView.likeBtn.userInteractionEnabled = NO;
    self.tabView.shareBtn.userInteractionEnabled = NO;
    self.tabView.collectBtn.userInteractionEnabled = NO;
    self.tabView.textFiled.userInteractionEnabled = NO;
}

-(void)btnClick{

    [self createView];
    [self createFootView];
}

#pragma mark -- 交互
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //[[ETMessageView sharedInstance]showMessage:@"加载中" onView:self.view];
    //直接截取后面的id
    NSString *str = request.URL.resourceSpecifier;
    NSLog(@"request.URL.resourceSpecifier = %@",request.URL.resourceSpecifier);
    
    NSRange range = [str rangeOfString:@"from_userId="];
    if (range.location != NSNotFound) {
        
        NSArray *canshuArray = [str componentsSeparatedByString:@"from_userId="];
        NSString *from_userId = canshuArray[1];
        NSLog(@"userId = %@", from_userId);
        
        messageDetailController *courseVC = [[messageDetailController alloc] init];
        courseVC.target_uid = from_userId;
        [self.navigationController pushViewController:courseVC animated:YES];
        return NO;
    }
    
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
        
        hotCommentController *detail = [[hotCommentController alloc] init];
        detail.fromUser = fromUid;
        detail.commentStr = commStr;
        detail.remarkStr = remarkStr;
        detail.nickStr = nickStr;
        detail.taskStr = taskStr;
        detail.userName = self.userName;
        detail.from_uid = self.from_uid;
        detail.delegate = self;
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
        DDLog(@"%d",likeCount);
        
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

-(void)goBack{
    
      [self.navigationController popViewControllerAnimated:YES];
}

-(void)goRightBtn{
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];

    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {

        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSArray *picViews =[self.faceImage componentsSeparatedByString:@"|"];
    NSString *imgStr = [picViews firstObject];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]];
    UIImage *thumImage = [UIImage imageWithData:data];
    
    if (!thumImage) {
        
        thumImage = [UIImage imageNamed:@"lianjie"];
    }//kun,si kun
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:self.contentStr thumImage:thumImage];
    
    //设置网页地址
    NSString *baseStr1 = [NSString stringWithFormat:@"http://www.uujz.me:8082/neworld/user/149?userId=%@",self.from_uid];
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.x > 0) {
        scrollView.contentOffset = CGPointMake(0, point.y);//这里不要设置为CGPointMake(0, 0)，这样我们在文章下面左右滑动的时候，就跳到文章的起始位置，不科学
    }
}

@end
