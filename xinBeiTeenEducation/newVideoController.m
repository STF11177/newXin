//
//  newVideoController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/17.
//  Copyright © 2017年 user. All rights reserved.
//

#import "newVideoController.h"
#import "ZFPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "tabbarView.h"
#import "commentDetailController.h"
#import <UShareUI/UShareUI.h>
#import "ETMessageView.h"
#import "messageDetailController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface newVideoController ()<ZFPlayerDelegate,UIWebViewDelegate,tabbarViewDelegate,commentDetailDelegate>

/** 播放器View的父视图*/
@property (strong, nonatomic)  UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) tabbarView *tabView;

@end

@implementation newVideoController
static NSString *userId;
static NSString *collectStr;
static NSString *likeStr;
static NSString *fromWhere;
static int likeCount;
static int collectNumber;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
    
//    [self createView];
//    [self createWebView];
//    [self isLikeOrCollect];
//    [self createFootView];
    
//    [[ETMessageView sharedInstance]showMessage:@"加载中" onView:self.view];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        self.playerView.playerPushedOrPresented = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    
    [self createView];
    [self createWebView];
    [self createNav];
    [self isLikeOrCollect];
    [self createFootView];
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
    
     [[ETMessageView sharedInstance]showMessage:@"加载中" onView:self.view];
}

-(void)noNetStatus{

}

-(void)netStatus{
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"你正在使用流量进行播放视频，是否继续播放？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.playerView pause];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.playerView play];
    }];
    
    [alertControl addAction:action];
    [alertControl addAction:action1];
    [self presentViewController:alertControl animated:YES completion:nil];
}

-(void)netStatuswifi{
    
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"正文";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createView{
    
    self.playerFatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 210)];
    [self.view addSubview:self.playerFatherView];
    
    [self.playerView pause];
    if ([self.is4GOrNot isEqualToString:@"4G"]) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"你正在使用流量进行播放视频，是否继续播放？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.playerView autoPlayTheVideo];
        }];
        
        [alertControl addAction:action];
        [alertControl addAction:action1];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
    
        //  自动播放，默认不自动播放
        [self.playerView autoPlayTheVideo];
    }
}

-(void)createFootView{
    
    self.tabView = [[tabbarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 46, SCREEN_WIDTH, 46)];
    self.tabView.delegate = self;
    [self.view addSubview:self.tabView];
}

-(void)selectStr:(NSString *)str{
    
//    self.fromStr = str;
//    DDLog(@"%@",self.fromStr);

    [self createWebView];
    [self createFootView];
}

#pragma mark -- textfield代理
-(void)textFieldDelegate:(tabbarView *)field{
    
    commentDetailController *comment = [[commentDetailController alloc]init];
    comment.delegate = self;
    comment.commentTaskId = self.taskId;
    comment.userName = self.userName;
    
    comment.from_uid = self.from_uid;
    DDLog(@"%@",self.userName);
    DDLog(@"%@",comment.userName);
    
    [self presentViewController:comment animated:NO completion:^{
        
    }];
}

-(void)createWebView{

    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 200,SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.scrollEnabled = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    //添加锚点
    NSString *bodyView;
    fromWhere = [NSString stringWithFormat:@"%@",self.fromStr];
    DDLog(@"%@",fromWhere);
    if ([fromWhere isEqualToString:@"2"]) {
        
        bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&maodian=%@",self.from_uid,self.taskId,@"0"];
        fromWhere =@"0";
    }else{
        
        bodyView = [NSString stringWithFormat:@"userId=%@&taskId=%@&maodian=%@",self.from_uid,self.taskId,@"1"];
    }
    DDLog(@"bodyView:%@",bodyView);
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

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = 0;
    }];
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = fullscreen;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = !fullscreen;
    }];
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init]
        ;
//      _playerModel.title            = self.titleStr;
        
        DDLog(@"%@",self.URLString);
        NSString *URLstring = [NSString stringWithFormat:@"%@",self.URLString];
        NSURL * url = [NSURL URLWithString:URLstring];
        _playerModel.videoURL         = url;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = NO;
    
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
    }
    return _playerView;
}

-(void)goBack{

    [self.navigationController popViewControllerAnimated:YES];
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
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight)];
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
    
    [self.playerView pause];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareVedioToPlatformType:platformType];
    }];
}

#pragma mark -- 加loading
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[ETMessageView sharedInstance] hideMessage];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //wofaojiu
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [[ETMessageView sharedInstance] hideMessage];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lian"]];
    imageView.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/5 + 200 ,115, 73);
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/5 + 10 +73 +200
                                                              
, SCREEN_WIDTH, 44)];
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
    
    [self createWebView];
    [self createFootView];
}

#pragma mark -- 交互
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
        [self presentViewController:detail animated:NO completion:^{
            
        }];
        return NO;
    }
    
    NSRange range1 = [str rangeOfString:@"106.14.251.200/neworld/user/154?"];
    DDLog(@"%@",str);
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
- (NSString *)decodeFromPercentEscapeString:(NSString *) input

{
    
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

#pragma mark -- 分享视频
- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:self.titleStr  descr:self.contentStr thumImage:[UIImage imageNamed:self.videoImg]];
    //设置视频网页播放地址
    shareObject.videoUrl = self.faceImage;
    //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

@end
