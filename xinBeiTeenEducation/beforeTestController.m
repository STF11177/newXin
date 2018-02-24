//
//  beforeTestController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "beforeTestController.h"
#import "ETMessageView.h"

@interface beforeTestController ()<UIWebViewDelegate>

@end

@implementation beforeTestController
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[ETMessageView sharedInstance]showMessage:@"加载中" onView:self.view];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"考前辅导";
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

-(void)createView{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];

    DDLog(@"%@",userId);
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:NO];
    
    NSURL* url = [NSURL URLWithString:self.beforeURL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    
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

#pragma mark -- 加loading
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[ETMessageView sharedInstance] hideMessage];
}

-(void)goBack{

    [self.navigationController popViewControllerAnimated:YES];

}


@end
