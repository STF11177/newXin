//
//  hotAticleController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "hotAticleController.h"
#import "recommentController.h"
#import "chanelController.h"
#import "searchHotController.h"
#import "collectController.h"
#import "hotTypeModel.h"
#import "hotCollectController.h"
#import "hotTopTitleView.h"
#import "middleTestController.h"
#import "yongRiseSmallController.h"
#import "smallRiseEarlyController.h"
#import "teachChildController.h"
#import "livingController.h"
#import "studyMaterialController.h"
#import "informationController.h"
#import "ETMessageView.h"

@interface hotAticleController ()<UIScrollViewDelegate,SGTopTitleViewDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic, strong) hotTopTitleView *topTitleView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIButton *editCategoriesBtn;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) NSMutableArray *hotTypeArray;//存放滚动条类型的数组
@property (nonatomic, strong) NSMutableArray *hotIdArray;//类型相对应的数组
@property (nonatomic, strong) hotTypeModel *typeModel;
@property (nonatomic, strong) NSMutableArray *dataArray;//所有的数据
@property (nonatomic, strong) NSMutableArray *titleArray;//存放类型和类型对应ID字典的数组
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) UIView *sepeView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btnImage;
@property (nonatomic, assign) BOOL netStatus1;

@end

@implementation hotAticleController
static NSString *typeName;
static NSString *typeStr;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hotTypeArray = [[NSMutableArray alloc]init];
    _hotIdArray = [[NSMutableArray alloc]init];
    _hotArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.netStatus1 = YES;
    [self createNav];
    [self createHttp];
    [self loadData];
    [self setUpChildController];
    [self setUpTopTitlesViews];

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

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

-(void)createNav{
    
    _titleArray = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"热文";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 , 10, 20, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"font"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(hotRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadData{
    
    [_manager POST:hotTypeURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        NSArray *menuList = dict[@"menuList"];
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            for (NSDictionary *appDict in menuList) {
                _typeModel = [[hotTypeModel alloc]init];
                [_typeModel yy_modelSetWithDictionary:appDict];
                [_hotTypeArray addObject:_typeModel.typeName];
                [_hotIdArray addObject:_typeModel.id];
                NSMutableDictionary *dictType = [[NSMutableDictionary alloc]init];
                dictType = [NSMutableDictionary dictionaryWithObject:self.typeModel.id forKey:self.typeModel.typeName];
                [self.titleArray addObject:dictType];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                    for (int  i =0; i<[_hotIdArray count]-1; i++) {
                        for (int j = i+1; j<[_hotIdArray count]; j++) {
                            if ([_hotIdArray[i] intValue]>[_hotIdArray[j] intValue]) {
                                
                                //交换
                                [_hotIdArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                                [_hotTypeArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                                NSMutableDictionary *newDict = [[NSMutableDictionary alloc]init];
                                newDict = [NSMutableDictionary dictionaryWithObject:_hotIdArray[i] forKey:_hotTypeArray[i]];
                                [_hotArray addObject:newDict];
        
                            }
                        }
                    }

            });
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 添加子控制器
-(void)setUpChildController{
    
        recommentController *newest =[[recommentController alloc]init];
        [self addChildViewController:newest];
    
        yongRiseSmallController *young = [[yongRiseSmallController alloc]init];
        [self addChildViewController:young];
    
        smallRiseEarlyController *small = [[smallRiseEarlyController alloc]init];
        [self addChildViewController:small];
    
        middleTestController *middle = [[middleTestController alloc]init];
        [self addChildViewController:middle];
    
        informationController *info = [[informationController alloc]init];
        [self addChildViewController:info];
    
        teachChildController *teach = [[teachChildController alloc]init];
        [self addChildViewController:teach];
    
        livingController *living = [[livingController alloc]init];
        [self addChildViewController:living];
    
        studyMaterialController *study = [[studyMaterialController alloc]init];
        [self addChildViewController:study];
}

#pragma mark -- 设置顶部标签栏

-(void)setUpTopTitlesViews
{
    self.titles = @[@"全部",@"幼升小",@"小升初",@"中考",@"资讯",@"育儿",@"生活",@"学习资料"];
    
    self.topTitleView = [hotTopTitleView topTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    _topTitleView.scrollTitleArr = [NSArray arrayWithArray:_titles];
    self.topTitleView.backgroundColor = [UIColor colorWithHexString:@"#f6f5f3"];
    _topTitleView.delegate_SG = self;
    
    self.sepeView = [[UIView alloc]init];
//    self.sepeView.backgroundColor = [UIColor redColor];
    self.sepeView.frame = CGRectMake(0, 60 + 64, SCREEN_WIDTH, 20);
    [self.topTitleView addSubview:self.sepeView];
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
    
    recommentController *oneVC = [[recommentController alloc] init];
    [self.mainScrollView addSubview:oneVC.view];
    [self addChildViewController:oneVC];
    
    [self.view insertSubview:_mainScrollView belowSubview:_topTitleView];
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(hotTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    
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
    
    [self.topTitleView scrollTitleLabelSelecteded:selLabel];
    // 3.让选中的标题居中
    [self.topTitleView scrollTitleLabelSelectededCenter:selLabel];
}

-(void)hotRightBtnClick{

    if (self.netStatus1 == YES) {
        
        hotCollectController *collect = [[hotCollectController alloc]init];
        collect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collect animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
