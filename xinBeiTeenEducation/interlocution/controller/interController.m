//
//  interController.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/2/13.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interController.h"
#import "interlocutionCell.h"
#import "interDiscussController.h"

#define userDefault [NSUserDefaults standardUserDefaults]

@interface interController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property(nonatomic,strong) interlocutionCell *interCell;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *pullArray;
@property(nonatomic,strong) NSMutableArray *endDateArray;//存放最后一条时间的数据
@property(nonatomic,strong) NSMutableArray *interArray;//存放缓存的数组
@property(nonatomic,strong) NSString *createDate;
@property(nonatomic,strong) NSString *endDate;
@property(nonatomic,strong) NSString *endDateCount;//最后一条的个数
@property(nonatomic,strong) NSString *lastDate;//最后一条的时间
@property(nonatomic,strong) NSString *createStr;//最新的时间
@property(nonatomic,strong) NSString *biaoji;//
@property(nonatomic,assign) BOOL pullNew;
@property(nonatomic,assign) BOOL firstStr;
@property(nonatomic,assign) int pullCount;//记录之前缓存有没有读取完

@end

@implementation interController
static NSString *userId;
static NSString *tokenStr;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    userId = [userDefault objectForKey:@"userName"];
    tokenStr = [userDefault objectForKey:@"tokenName"];
    
    [self createNav];
    [self createHttp];
    [self.view addSubview:self.tableView];
    
    self.firstStr = YES;
    self.pullNew = YES;
    
    [self dealEndDateDateData];
    
    NSString *endDateStr = [userDefault objectForKey:@"0"];
    self.createStr = [userDefault objectForKey:@"createDate"];
    self.lastDate = [userDefault objectForKey:@"lastObject"];
    DDLog(@"%@",self.lastDate);
    if ([ETRegularUtil isEmptyString:self.createStr]) {
        
        self.createStr = @"";
    }else{
        
        self.pullCount = 1;
    }
    
    [self refresh];
    [self loadMore];
    NSDictionary *param = @{@"userId":userId,@"token":tokenStr,@"createDate":self.createStr,@"endDate":endDateStr,@"answerStatus":@"1"};
    [self createInterlocutionWithParam:param];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    DDLog(@"%@",self.endDateArray);
}

//对最后一条时间的处理
-(void)dealEndDateDateData{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        //通知主线程刷新
        
        self.endDateCount = [userDefault objectForKey:@"count"];
        for (int i =0; i<[self.endDateCount intValue];i++) {
            
            NSString *intStr = [NSString stringWithFormat:@"%d",i];
            NSString *str = [userDefault objectForKey:intStr];
            if ([ETRegularUtil isEmptyString:str]) {
                
                str = @"";
            }
            [self.endDateArray addObject:str];
            [self.interArray addObject:str];
        }

        if (self.endDateArray.count == 0) {

            [self.endDateArray addObject:@""];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
        });
    });
    
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createNav{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"问答";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)presentVC{
    
    [userDefault removeObjectForKey:@"lastObject"];
    [userDefault removeObjectForKey:@"count"];
    [userDefault removeObjectForKey:@"createDate"];
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if (iOS11) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)pullArray{
    
    if (!_pullArray) {
        
        _pullArray = [[NSMutableArray alloc]init];
    }
    return _pullArray;
}

-(NSMutableArray *)endDateArray{
    
    if (!_endDateArray) {
        
        _endDateArray = [[NSMutableArray alloc]init];
    }
    return _endDateArray;
}

-(NSMutableArray *)interArray{
    
    if (!_interArray) {
        
        _interArray = [[NSMutableArray alloc]init];
    }
    return _interArray;
}

-(void)createInterlocutionWithParam:(NSDictionary*)param{
    
    __weak typeof(self) weakSelf = self;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:interlocutionURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        NSArray *menulistArray = dict[@"menuList"];
        
        NSDictionary *dateDic1 = [menulistArray lastObject];
        self.endDate = dateDic1[@"createDate"];
        
        
        DDLog(@"%@",self.endDateArray);
        //createDate永远是最新的
        if (self.firstStr == YES) {
            
            NSDictionary *dateDic = [menulistArray firstObject];
            self.createDate = dateDic[@"createDate"];
        
            DDLog(@"%@",self.interArray);
            DDLog(@"%@",self.createDate);
            
            int result = [self compareDate:self.createStr withDate:self.createDate];
            if (result == 1) {
                
                self.createStr = self.createDate;
            }
            if ([ETRegularUtil isEmptyString:self.createStr]) {
                
                self.createStr = self.createDate;
            }
            
            [userDefault setObject:self.createStr forKey:@"createDate"];
            self.firstStr = NO;
        }
        
        //添加数据
        if (self.pullNew == YES) {
            
            int result1 = [self compareDate:self.endDate withDate:self.lastDate];
            if (result1 == 1) {
                
                self.biaoji = self.lastDate;
            }else{
                
                self.biaoji = self.endDate;
            }
            
            
            //删除请求后为空的endDate
            if ([ETRegularUtil isEmptyString:self.endDate]) {
                
                [self.endDateArray removeObjectAtIndex:0];
                [userDefault removeObjectForKey:@"0"];
                
                NSString *dataCount = [NSString stringWithFormat:@"%lu",(unsigned long)self.endDateArray.count];
                [userDefault setObject:dataCount forKey:@"count"];
                
                for (int i =0 ; i<self.endDateArray.count; i++) {
                    
                    NSString *intStr = [NSString stringWithFormat:@"%d",i];
                    [userDefault setObject:self.endDateArray[i] forKey:intStr];
                }
            }
            
            [self.pullArray removeAllObjects];
            for (NSDictionary *appDict in menulistArray) {
                
                interlocutionModel *model = [[interlocutionModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                
                [self.pullArray addObject:model];
            }
            // 要插入的数组
            [self.dataArray insertObjects:self.pullArray atIndex:0];
        } else {
            
            for (NSDictionary *appDict in menulistArray) {
                
                interlocutionModel *model = [[interlocutionModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        if ([ETRegularUtil isEmptyString:self.endDate]) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            DDLog(@"%@",self.endDate);
            [userDefault setObject:self.endDate forKey:@"lastObject"];
            [self.tableView.mj_footer endRefreshing];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.interCell = [tableView dequeueReusableCellWithIdentifier:@"interlocutionCell"];
    
    if (!self.interCell) {
        
        self.interCell = [[interlocutionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"interlocutionCell"];
    }
    interlocutionModel *model = self.dataArray[indexPath.row];
    self.interCell.model = model;
    return self.interCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    interlocutionModel *model = self.dataArray[indexPath.row];
    interDiscussController *discuss = [[interDiscussController alloc]init];
    discuss.hidesBottomBarWhenPushed = YES;
    discuss.taskStr = model.id;
    [self.navigationController pushViewController:discuss animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    interlocutionModel *model = self.dataArray[indexPath.row];
    return [self.interCell cellHeightWithModel:model];
}

#pragma mark -- 刷新
-(void)refresh{
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        NSString *endDateStr;
        if (self.pullCount <self.endDateArray.count) {
            
            DDLog(@"%@",self.lastDate);
            endDateStr = self.biaoji;
        }else{
            
            endDateStr = self.endDate;
        }
        
        if (![ETRegularUtil isEmptyString:endDateStr]) {
            
            //存放endDate
            [self.endDateArray insertObject:self.endDate atIndex:0];
            NSString *dataCount = [NSString stringWithFormat:@"%lu",(unsigned long)self.endDateArray.count];
            [userDefault setObject:dataCount forKey:@"count"];
            
            for (int i =0 ; i<self.endDateArray.count; i++) {
                
                NSString *intStr = [NSString stringWithFormat:@"%d",i];
                [userDefault setObject:self.endDateArray[i] forKey:intStr];
            }
            
            NSDictionary *param = @{@"userId":userId,@"token":tokenStr,@"createDate":self.createStr,@"endDate":endDateStr,@"answerStatus":@"3"};
            
            [weakSelf createInterlocutionWithParam:param];
            
            self.pullNew = YES;
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

#pragma mark -- 加载
-(void)loadMore{
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *endDateStr;
        DDLog(@"%@",self.interArray);
        DDLog(@"%d",self.pullCount);
        if (self.pullCount <self.interArray.count) {
            
            endDateStr = self.interArray[self.pullCount];
            self.pullCount = self.pullCount +1;
        }else{
            
            endDateStr = self.endDate;
            //存放endDate
            [self.endDateArray addObject:self.endDate];
            NSString *dataCount = [NSString stringWithFormat:@"%lu",(unsigned long)self.endDateArray.count];
            [userDefault setObject:dataCount forKey:@"count"];
            
            for (int i =0 ; i<self.endDateArray.count; i++) {
                
                NSString *intStr = [NSString stringWithFormat:@"%d",i];
                [userDefault setObject:self.endDateArray[i] forKey:intStr];
            }
        }
    
       self.pullNew = NO;
            NSDictionary *param = @{@"userId":userId,@"token":tokenStr,@"createDate":self.createStr,@"endDate":endDateStr,@"answerStatus":@"3"};
            [weakSelf createInterlocutionWithParam:param];
            [weakSelf.tableView.mj_footer beginRefreshing];
    }];
}

//2个时间字符串的比较
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc]init];
    NSDate *dt2 = [[NSDate alloc]init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci = 1;
            break;
            //date02比date01小
        case NSOrderedDescending: ci = -1;
            break;
            //date02=date01
        case NSOrderedSame: ci=0;
            break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
    return ci;
}

@end
