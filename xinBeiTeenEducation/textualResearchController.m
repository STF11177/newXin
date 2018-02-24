//
//  textualResearchController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "textualResearchController.h"
#import "allRecommentController.h"
#import "mathViewController.h"
#import "englishViewController.h"
#import "chineseController.h"
#import "orderController.h"
#import "testTopTitleView.h"
#import "talentController.h"
#import "ETMessageView.h"

@interface textualResearchController ()<UIScrollViewDelegate,SGTopTitleViewDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic, strong) testTopTitleView *topTitleView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSString *signStr;
@property (nonatomic,assign) BOOL netStatus1;

@end

@implementation textualResearchController
static NSString *typeName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createNav];
    [self setUpTopTitlesViews];
    
    self.netStatus1 = YES;
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
}

-(void)noNetStatus{

    self.netStatus1 = NO;
}

-(void)netStatus{

    self.netStatus1 = YES;
}

-(void)netStatuswifi{

    self.netStatus1 = YES;
}

-(void)createNav{
    
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"考证";
        lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
        lable.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = lable;
    
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 , 10, 20, 20)];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"kz_ouder"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(testRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = item1;
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(testTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index{
    
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded){
    
     [self.mainScrollView addSubview:vc.view];
    }else{
        if (index!=0) {
            
            [self.mainScrollView addSubview:vc.view];
    }
}
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
    
    // 2.把对应的标题选中
    UILabel *selLabel = self.topTitleView.allTitleLabel[index];
    
    // 3.滚动时，改变标题选中
    [self.topTitleView staticTitleLabelSelecteded:selLabel];
    
}

#pragma mark -- 添加子控制器
-(void)setUpChildController{
    
    allRecommentController *newest =[[allRecommentController alloc]init];
    [self addChildViewController:newest];
    
    englishViewController *info = [[englishViewController alloc]init];
    [self addChildViewController:info];

    chineseController *china = [[chineseController alloc]init];
    [self addChildViewController:china];
    
    mathViewController *focus =[[mathViewController alloc]init];
    [self addChildViewController:focus];

    talentController *talent = [[talentController alloc]init];
    [self addChildViewController:talent];
}

#pragma mark -- 设置顶部标签栏

-(void)setUpTopTitlesViews
{
    // 1.添加所有子控制器
    [self setUpChildController];
    
    self.titles = @[@"全部",@"英语",@"语文",@"数学",@"才艺"];
    
    self.topTitleView = [testTopTitleView topTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    
    _topTitleView.scrollTitleArr = [NSArray arrayWithArray:_titles];
    _topTitleView.delegate_SG = self;
    self.topTitleView.backgroundColor = [UIColor colorWithHexString:@"#f6f5f3"];
    [self.view addSubview:_topTitleView];
    
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _titles.count, 0);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    allRecommentController *oneVC = [[allRecommentController alloc] init];
    [self.mainScrollView addSubview:oneVC.view];
    [self addChildViewController:oneVC];
    [self.view insertSubview:_mainScrollView belowSubview:_topTitleView];

}

-(void)testRightBtnClick{
    
    if (self.netStatus1 == YES) {
        
        orderController *allOrder = [[orderController alloc]init];
        allOrder.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:allOrder animated:NO];
        self.hidesBottomBarWhenPushed = NO;
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

@end
