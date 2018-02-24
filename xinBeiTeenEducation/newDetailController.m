//
//  newDetailController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "newDetailController.h"
#import "newController.h"
#import <UShareUI/UShareUI.h>
#import "messageDetailController.h"
#import "settingController.h"
#import "tabbarView.h"
#import "commentDetailController.h"
#import "ETMessageView.h"
#import "parenAllCommentController.h"
#import "SDPhotoBrowser.h"
#import "ZYBrowerView.h"

@interface newDetailController ()<UIWebViewDelegate,UITextFieldDelegate,tabbarViewDelegate,commentDetailDelegate,UIGestureRecognizerDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    WebViewJavascriptBridge *_bridge;
    
}

@property (nonatomic,strong) tabbarView *tabView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,strong) NSArray *pictureArray;
@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态

@end

@implementation newDetailController
static NSString *userId;
static NSString *collectStr;
static NSString *likeStr;
static NSString *fromWhere;
static NSString *pictureStr;
static int likeCount;
static int collectNumber;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    fromWhere = [NSString stringWithFormat:@"%@",self.fromStr];
    DDLog(@"%@",fromWhere);
    
//    if (![fromWhere isEqualToString:@"2"]) {
    
//        [self createView];
//        [self createFootView];
//    }

}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (![fromWhere isEqualToString:@"2"]) {
        
        [self createView];
    }
    
    [self createNav];
    [self isLikeOrCollect];
    [self createFootView];
    
    self.fd_interactivePopDisabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

- (void)dealloc{
    
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
}

//有网络
-(void)netStatus{
    
    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    
    [self createView];
    [self createFootView];
}

-(void)netStatuswifi{

    _imageView.hidden = YES;
    _btnImage.hidden = YES;
    
    [self createView];
    [self createFootView];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"正文";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 19, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"arrow-fx"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(goRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)selectStr:(NSString *)str{

    DDLog(@"%@",str);
    self.fromStr = str;
    [self createView];
    [self createFootView];
}

-(void)createView{

    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.scrollEnabled = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    
//  [[ETMessageView sharedInstance]showMessage:@"加载中" onView:self.view];
    
    if(iOS11){
        
        self.webView.scrollView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    //添加锚点
    NSString *bodyView;
    fromWhere = [NSString stringWithFormat:@"%@",self.fromStr];
    if ([fromWhere isEqualToString:@"2"]) {
        
        bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&maodian=%@",self.from_uid,self.taskId,@"0"];
        fromWhere = @"0";
    }else{
        
        bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&maodian=%@",self.from_uid,self.taskId,@"1"];
    }
    
    self.fromStr = @"0";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newDetailURL]];
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

-(void)createFootView{

    self.tabView = [[tabbarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 46, SCREEN_WIDTH, 46)];
    self.tabView.delegate = self;
    [self.view addSubview:self.tabView];
}

#pragma mark -- textfield代理
-(void)textFieldDelegate:(tabbarView *)field{

    commentDetailController *comment = [[commentDetailController alloc]init];
    comment.delegate = self;
    comment.commentTaskId = self.taskId;
    comment.userName = self.userName;
    comment.from_uid = self.from_uid;
    [self.navigationController pushViewController:comment animated:YES];
}

#pragma mark -- 点赞
-(void)liekTabbarDelegate:(tabbarView *)field{

    if (field.likeBtn.selected == YES) {
        
        [field.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        likeCount = likeCount - 1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeCount];
        [field.likeBtn setTitle:likeStr forState:UIControlStateNormal];
        collectNumber = 0;
    }else{
        
        [field.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
        collectNumber = 1;
        likeCount = likeCount + 1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeCount];
        [field.likeBtn setTitle:likeStr forState:UIControlStateNormal];
    }
    field.likeBtn.selected = !self.tabView.likeBtn.selected;
    field.likeBtn = self.tabView.likeBtn;
    [self loadDetailLikeData];
}

-(void)loadDetailLikeData{

    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    NSString *collectNum = [[NSString alloc]initWithFormat:@"%d",collectNumber];
    NSString *taskStr = [[NSString alloc]initWithFormat:@"%@",self.taskId];
    
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&type=%@&status=%@&typeStatus=%@",self.from_uid,taskStr,@"1",collectNum,@"1"];
    DDLog(@"bodyView:%@",bodyView);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newDetailLikeURL]];//111
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
    
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&status=%@",self.from_uid,taskStr,@"1"];
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
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&type=%@&status=%@&typeStatus=%@",self.from_uid,taskStr,@"1",collectNum,@"2"];
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
    
    self.tabView.likeBtn.userInteractionEnabled = NO;
    self.tabView.collectBtn.userInteractionEnabled = NO;
    self.tabView.shareBtn.userInteractionEnabled = NO;
    self.tabView.textFiled.userInteractionEnabled = NO;
}

-(void)btnClick{
    
    [self createView];
    [self createFootView];
}

#pragma mark -- 交互 拦截
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

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
    
//  图片
    NSRange pictureRange = [str rangeOfString:@"rStatus=1"];
    if (pictureRange.location != NSNotFound) {
        
      NSArray *pictureArray = [str componentsSeparatedByString:@"imgList="];
      NSString *str = pictureArray[1];
      pictureStr = [self decodeFromPercentEscapeString:str];
        
      self.pictureArray = [pictureStr componentsSeparatedByString:@"|"];
      DDLog(@"%@",pictureStr);
        
      ZYBrowerView *browerView = [[ZYBrowerView alloc] initWithFrame:[UIScreen mainScreen].bounds imagesUrlAry:self.pictureArray currentIndex:0];
      [browerView show];
    
      return NO;
    }
    
//  回复评论
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
    
        commentDetailController *detail = [[commentDetailController alloc] init];
        detail.fromUser = fromUid;
        detail.commentStr = commStr;
        detail.remarkStr = remarkStr;
        detail.nickStr = [self decodeFromPercentEscapeString:nickStr];
        detail.taskStr = taskStr;
        detail.userName = self.userName;
        detail.from_uid = self.from_uid;
        detail.fromParent = @"1";
        detail.delegate = self;
        [self.navigationController pushViewController:detail animated:YES];
        return NO;
    }
    
    //查看所有回复
    NSRange allRange = [str rangeOfString:@"106.14.251.200/neworld/user/192?"];
    if (allRange.location != NSNotFound) {
        
        NSArray *statusArray = [str componentsSeparatedByString:@"106.14.251.200/neworld/user/192?"];
        NSString *commentStr = statusArray[1];
        
        NSArray *statusArry1 = [commentStr componentsSeparatedByString:@"&?"];
        NSString *commentStr1 = statusArry1[0];
        NSString *from_userStr = statusArry1[1];
        
        NSArray *statusArray2 = [commentStr1 componentsSeparatedByString:@"="];
        NSString *commentId = statusArray2[1];
        
        NSArray *statusArray3 = [from_userStr componentsSeparatedByString:@"="];
        NSString *from_UID = statusArray3[1];
        
        parenAllCommentController *parent = [[parenAllCommentController alloc]init];
        parent.comemntId = commentId;
        parent.from_uid = from_UID;
        [self.navigationController pushViewController:parent animated:YES];
        return NO;
    }
    
    //点赞 收藏
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

//URL解码
- (NSString *)decodeFromPercentEscapeString:(NSString *) input{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.x > 0) {
        scrollView.contentOffset = CGPointMake(0, point.y);//这里不要设置为CGPointMake(0, 0)，这样我们在文章下面左右滑动的时候，就跳到文章的起始位置，不科学
    }
}

-(void)goBack{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 分享
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
    }
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:self.contentStr thumImage:thumImage];
    
    //设置网页地址
    NSString *baseStr1 = [NSString stringWithFormat:@"http://www.uujz.me:8082/neworld/user/143?userId=%@",self.from_uid];
    NSString *baseStr2 = [NSString stringWithFormat:@"&taskId=%@",self.taskId];
    NSString *str = [baseStr1 stringByAppendingString:baseStr2];
    
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
           
                [self shareData];
            }else{
                
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark -- 分享的数
-(void)shareData{
    
    //1.动态内容 2.考证 3.热文
    NSDictionary *param = @{@"taskId":_taskId,@"type":@"1"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:shareTaskIdURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
