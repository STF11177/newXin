//
//  educationController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import "educationController.h"
#import "bookCell.h"
#import "eduDetailController.h"
#import "eduBookModel.h"
#import "loginMessageController.h"
#import "ETMessageView.h"
#import "eduOrderController.h"
#import "backGroundView.h"

@interface educationController ()<UICollectionViewDelegate,UICollectionViewDataSource,backViewdelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) eduBookModel *bookModel;
@property (nonatomic,strong) NSString *createDate; //请求的时间
@property (nonatomic,assign) BOOL pullNew;
@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态
@property (nonatomic,strong) backGroundView *backView;

@end

@implementation educationController
static NSString *userId;
static NSString *tokenStr;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self createNav];
    [self createHttp];
    [self refresh];
    [self loadMore];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];
    
    self.netStatus1 = YES;
    NSDictionary *param = @{@"userId":userId,@"token":tokenStr,@"type":@"0",@"CreateDate":@""};
    [self loadDataWithParamWith:param];

    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[bookCell class] forCellWithReuseIdentifier:@"bookCell"];

    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
    
    if (self.dataArray.count!=0) {
        
        [self.backView removeFromSuperview];
    }
}

-(void)netStatus{

    [self.backView removeFromSuperview];
    self.netStatus1 = YES;
    [self.collectionView.mj_header beginRefreshing];
}

-(void)netStatuswifi{

    [self.backView removeFromSuperview];
    self.netStatus1 = YES;
    [self.collectionView.mj_header beginRefreshing];
}

-(void)noNetStatus{

    self.netStatus1 = NO;
    [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
}

-(void)netClickDelegate:(backGroundView *)view{

    [self.backView removeFromSuperview];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"图书";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
//    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 , 10, 20, 20)];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"kz_ouder"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(testRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = item1;
}

-(UICollectionView*)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = (SCREEN_WIDTH - 88*3)/3;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadDataWithParamWith:(NSDictionary*)param{
    
    //请求参数
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:eduAllBookURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        if (_pullNew == YES) {
            
             [self.dataArray removeAllObjects];
        }

        NSArray *array = dict[@"menuList"];
        
        NSDictionary *dateDic = [array lastObject];
        _createDate = dateDic[@"createDate"];
        
        for (NSDictionary *appDict in array) {
            
            eduBookModel *model = [[eduBookModel alloc]init];
            [model yy_modelSetWithDictionary:appDict];
            [self.dataArray addObject:model];
        }
        
            [UIView animateWithDuration:0.25 animations:^{
                //刷新
               [self.collectionView reloadData];
            }];
        
        [self.backView removeFromSuperview];
        self.collectionView.mj_footer.hidden = NO;
        [self.collectionView.mj_header endRefreshing];
        if (!_createDate) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.collectionView.mj_footer endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (self.dataArray.count==0) {
            
        self.collectionView.mj_footer.hidden = YES;
    
            self.backView = [[backGroundView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
            self.backView.delegate = self;
            [self.view addSubview:self.backView];
        }else{
        
//      self.collectionView.mj_footer.hidden = NO;
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
        }
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    bookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCell" forIndexPath:indexPath];
    eduBookModel * model = self.dataArray[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //在这里进行点击cell后的操作
    
    if (self.netStatus1 == YES) {
        
        eduBookModel *model = self.dataArray[indexPath.row];
        eduDetailController *detail = [[eduDetailController alloc]init];
        detail.bookStr = model.bookId;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    bookCell *cell = [[bookCell alloc]init];
    cell.indexpath = indexPath;
    return CGSizeMake(88, cell.cellHeight);
}

#pragma mark -- 下拉加载
-(void)refresh{
    
    [UIView performWithoutAnimation:^{
    
       
        __weak __typeof(self) weakSelf = self;
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            NSDictionary *param = @{@"userId":userId,@"token":tokenStr,@"type":@"0",@"CreateDate":@""};
            [weakSelf loadDataWithParamWith:param];
            weakSelf.pullNew = YES;
            
            [weakSelf.collectionView.mj_header beginRefreshing];
        }];
    }];
}

-(void)loadMore{
    
    __weak __typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSString *dateStr = [NSString stringWithFormat:@"%@",weakSelf.createDate];
        NSDictionary *param = @{@"type":@"0",@"CreateDate":dateStr,@"userId":userId,@"token":tokenStr};
        
        weakSelf.pullNew = NO;
        [weakSelf loadDataWithParamWith:param];
        [weakSelf.collectionView.mj_footer beginRefreshing];
    }];
}

//-(void)testRightBtnClick{
//
//    if (self.netStatus1 == YES) {
//
//        eduOrderController *order = [[eduOrderController alloc]init];
//        order.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:order animated:NO];
//        self.hidesBottomBarWhenPushed=NO;
//    }else{
//
//        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
//    }
//}

@end
