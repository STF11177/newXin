//
//  parentsCircleController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "parentsCircleController.h"
#import "chatViewController.h"
#import "newController.h"
#import "atttionViewController.h"
#import "SGTopTitleView.h"
#import "sendController.h"
#import "menuListModel.h"
#import "CommonAlert.h"
#import "ETMessageView.h"
#import "allRecommentController.h"
#import "mathViewController.h"
#import "englishViewController.h"
#import "blackListController.h"

@interface parentsCircleController ()<UIScrollViewDelegate,SGTopTitleViewDelegate,CommonAlertDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic, strong) SGTopTitleView *topTitleView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *createDate;

@end

@implementation parentsCircleController
static NSString *nickStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    // 添加子控制器
    [self creatNavigationItem];
    [self setUpTopTitlesViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void) creatNavigationItem{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"家长圈";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"add_pass"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 , 10, 20, 19)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"appear"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick1) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

#pragma mark -- 判断是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL ||[string isEqualToString:@""]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)rightBtnClick1{
    
        self.hidesBottomBarWhenPushed=YES;
        sendController *sendVC =[[sendController alloc]init];
        [self.navigationController pushViewController:sendVC animated:NO];
        self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，tabBar会恢复正常显示
}

#pragma mark -- 添加子控制器
-(void)setUpChildController{

    newController *newest =[[newController alloc]init];
    [self addChildViewController:newest];
    
    atttionViewController *focus =[[atttionViewController alloc]init];
    [self addChildViewController:focus];
}

#pragma mark -- 设置顶部标签栏

-(void)setUpTopTitlesViews
{
    self.titles = @[@"最新", @"关注"];
    
    self.topTitleView = [SGTopTitleView topTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    _topTitleView.scrollTitleArr = [NSArray arrayWithArray:_titles];
    
    _topTitleView.delegate_SG = self;
    [self.view addSubview:_topTitleView];
    
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _titles.count, 0);
    _mainScrollView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    newController *oneVC = [[newController alloc] init];
    [self.mainScrollView addSubview:oneVC.view];
    [self addChildViewController:oneVC];
    
    [self.view insertSubview:_mainScrollView belowSubview:_topTitleView];
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    
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
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
    
    // 2.把对应的标题选中
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@(index) userInfo:nil];
    
    // 2.把对应的标题选中
    UILabel *selLabel = self.topTitleView.allTitleLabel[index];
    
    
    [self.topTitleView scrollTitleLabelSelecteded:selLabel];
    // 3.让选中的标题居中
    [self.topTitleView scrollTitleLabelSelectededCenter:selLabel];
}

-(void)presentLeftMenuViewController:(UIViewController*)viewController{
    
//    blackListController *chat =[[blackListController alloc]init];
//    chat.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:chat animated:NO];
//    self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，tabBar会恢复正常显示
}

@end
