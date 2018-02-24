//
//  queryResultController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "queryResultController.h"
#import "ETMessageView.h"

@interface queryResultController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation queryResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLb.text = @"成绩查询";
    [self createView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[ETMessageView sharedInstance]showMessage:@"加载中" onView:self.view];
}

-(void)createView{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.scrollEnabled = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0]setBounces:YES];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    if(iOS11){
        
        self.webView.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    NSURL* url = [NSURL URLWithString:@"http://www.uujz.me:8082/neworld/admin/jsp/chengji/query.jsp"];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    for (UIView *_aView in [_webView subviews]){
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

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

#pragma mark -- 加loading
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[ETMessageView sharedInstance] hideMessage];
}


@end
