//
//  interDiscussController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import "interlocutionController.h"
#import "interlocutionCell.h"
#import "interlocutionModel.h"
#import "interDiscussController.h"
#import "loginMessageController.h"
#import "ETMessageView.h"

#define userDefault [NSUserDefaults standardUserDefaults]

@interface interlocutionController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *pullArray;
@property(nonatomic,strong) NSString *createDate;
@property(nonatomic,strong) NSString *createDate1;
@property(nonatomic,strong) NSString *endDate;
@property(nonatomic,strong) NSString *dateCountStr;//日期
@property(nonatomic,strong) NSString *lastEndDate;//最后一条的时间
@property(nonatomic,strong) NSMutableArray *dateArray;
@property(nonatomic,assign) BOOL pullNew;
@property(nonatomic,assign) BOOL loadNew;
@property(nonatomic,assign) BOOL firstSign;
@property(nonatomic,assign) BOOL signStr;
@property(nonatomic,assign) int pullCount;
@property(nonatomic,strong) NSString *dataCount;
@property(nonatomic,strong) NSString *interSignStr;
@property(nonatomic,strong) NSString *biaojiStr;
@property(nonatomic,assign) BOOL firstPullStr;
@property(nonatomic,strong) interlocutionCell *interCell;
@property(nonatomic,strong) NSString *repeateLastDate;
@property(nonatomic,strong) NSMutableArray *interArray;//刚进入界面保存的数组
@property(nonatomic,assign) BOOL isCompleted;//已经加载完成
@property(nonatomic,assign) BOOL isDetele;//删除
@property(nonatomic,assign) BOOL isContentNew;//是否是最新的数据
@property(nonatomic,strong) NSString *xinStatus;


@end

@implementation interlocutionController
static NSString *userId;
static NSString *tokenStr;
static NSString *pullStr;
static NSString *createStr;
static NSString *endStr;
static NSString *firstCreateStr;
static NSString *firstEndStr;
static NSString *taskId;
static NSString *currentDateStr;//当前时间
static NSString *answerStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createHttp];
    
    userId = [userDefault objectForKey:@"userName"];
    tokenStr = [userDefault objectForKey:@"tokenName"];

    [self refresh];
    [self loadMore];

    
    DDLog(@"%@",[self currentDateAddOneSecond]);
    
    
    self.firstSign = YES;
    self.isCompleted = NO;
    NSString *startDate = [userDefault objectForKey:@"createDate"];
    createStr =[userDefault objectForKey:@"createDate"];
    DDLog(@"%@",startDate);
    if ([ETRegularUtil isEmptyString:startDate]) {

        startDate = @"";
    }

    self.dataCount = [userDefault objectForKey:@"count"];
    for (int i =0; i<[self.dataCount intValue];i++) {
        
        NSString *intStr = [NSString stringWithFormat:@"%d",i];
        NSString *str = [userDefault objectForKey:intStr];
        if ([ETRegularUtil isEmptyString:str]) {
         
            str = @"";
        }
        [self.dateArray addObject:str];
        [self.interArray addObject:str];
    }
    
    self.signStr = YES;
    self.pullNew = YES;
    self.firstPullStr = YES;
    self.isDetele = YES;//已经加载完了，第一次刷新
    self.isContentNew = NO;
    DDLog(@"%@",self.dateArray);
    self.lastEndDate = [userDefault objectForKey:@"lastObject"];
    
    self.repeateLastDate = [userDefault objectForKey:@"lastObject"];
    DDLog(@"%@",self.lastEndDate);
    
      NSString *endDate ;
    if ([ETRegularUtil isEmptyString:self.dataCount]||[self.dataCount isEqualToString:@"0"]) {
    
      endDate = @"";
        answerStatus = @"1";
      currentDateStr = [self currentTimeAddOneSecond];
      [userDefault setObject:currentDateStr forKey:@"first"];
      [self.dateArray addObject:currentDateStr];
    }else{
        answerStatus = @"3";
      self.signStr = NO;
      self.pullCount = 0;
      endDate = [userDefault objectForKey:[NSString stringWithFormat:@"%d",self.pullCount]];
      self.pullCount = self.pullCount +1;
    }
    
    if ([ETRegularUtil isEmptyString:endDate]) {
        
        endDate = @"";
    }
    
    DDLog(@"%@",endDate);
    DDLog(@"%@",startDate);
    
    NSDictionary *param = @{@"userId":userId,@"token":tokenStr,@"createDate":startDate,@"endDate":endDate,@"answerStatus":answerStatus};
    [self createInterlocutionWithParam:param];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[interlocutionCell class] forCellReuseIdentifier:@"interlocutionCell"];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
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

-(NSMutableArray *)dateArray{
    
    if (!_dateArray) {
        
        _dateArray = [[NSMutableArray alloc]init];
    }
    return _dateArray;
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
        
        
        int tokenStuts = [dict[@"tokenStatus"]intValue];
        self.xinStatus = dict[@"xinStatus"];
        NSArray *menulistArray = dict[@"menuList"];
       
        if (self.firstSign == YES) {
            //刚进入界面的时间
            NSDictionary *dateDic = [menulistArray firstObject];
            _createDate = dateDic[@"createDate"];
            
            DDLog(@"%@",createStr);
            DDLog(@"%@",_createDate);
            
            int result = [self compareDate:createStr withDate:_createDate];
            if (result == -1) {
                
                _createDate = createStr;
            }
            
            NSDictionary *dateDic1 = [menulistArray lastObject];
            _endDate = dateDic1[@"createDate"];
        }
        self.firstSign = NO;
        
        //最后一次刷新，第一条的时间
        NSDictionary *dateDic = [menulistArray firstObject];
        _createDate1 = dateDic[@"createDate"];
        
        int result1 = [self compareDate:_createDate1 withDate:_createDate];
        if (result1 == -1) {
            
            self.isContentNew = YES;
            _createDate = _createDate1;
        }else{
            
            self.isContentNew = NO;
        }
            
        NSDictionary *dateDic1 = [menulistArray lastObject];
        
        if (![ETRegularUtil isEmptyString:[NSString stringWithFormat:@"%@",dateDic1[@"createDate"]]]) {
            
            if (_isContentNew == NO) {
                
                self.endDate = dateDic1[@"createDate"];
            }
        }else{
            
            if (self.pullNew == YES && self.isDetele == YES && self.isCompleted == NO) {

                self.isCompleted = YES;
                [self.dateArray removeObjectAtIndex:0];
                [userDefault removeObjectForKey:@"0"];

                DDLog(@"%@",self.dateArray);
                NSString *dataCount = [NSString stringWithFormat:@"%lu",(unsigned long)self.dateArray.count];
                [userDefault setObject:dataCount forKey:@"count"];

                for (int i =0 ; i<self.dateArray.count; i++) {

                    NSString *intStr = [NSString stringWithFormat:@"%d",i];
                    [userDefault setObject:self.dateArray[i] forKey:intStr];
                }
                self.isDetele = NO;
            }
             DDLog(@"%@",self.dateArray);
        }
        
        //2比1大
        if (self.pullNew == YES) {
            
            int result = [self compareDate:self.lastEndDate withDate:_endDate];
            if (result == 1) {
                if (_isContentNew == NO) {
                    self.biaojiStr = self.lastEndDate;
                }
            }else{
                
                if (_isContentNew == NO) {
                    
                    self.biaojiStr = self.endDate;
                }
            }
        }
        
        DDLog(@"%@",self.createDate);
        
        if (_isContentNew == NO) {
            
            if (![ETRegularUtil isEmptyString:self.createDate]) {
                
                [userDefault setObject:self.createDate forKey:@"createDate"];
            }
            
            [userDefault setObject:self.endDate forKey:@"lastObject"];
        }
     
        if (self.pullNew == YES) {
            
            [self.pullArray removeAllObjects];
            for (NSDictionary *appDict in menulistArray) {

                interlocutionModel *model = [[interlocutionModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                
//                if ([[NSString stringWithFormat:@"%@",self.xinStatus] isEqualToString:@"1"]) {
                
                    [self.pullArray addObject:model];
//                }
            }

            // 要插入的数组
            [self.dataArray insertObjects:self.pullArray atIndex:0];

        } else {
        
            for (NSDictionary *appDict in menulistArray) {
                
                interlocutionModel *model = [[interlocutionModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                
//                if ([[NSString stringWithFormat:@"%@",self.xinStatus] isEqualToString:@"1"]) {
                
                   [self.dataArray addObject:model];
//                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (tokenStuts == 2) {
//
//                loginMessageController *login = [[loginMessageController alloc]init];
//                login.loginStatus = @"1";
//                login.hidesBottomBarWhenPushed = YES;
//                [weakSelf presentViewController:login animated:NO completion:^{
//
//                }];
//                weakSelf.hidesBottomBarWhenPushed = NO;//最后一句话，可以保证在back回到A时
//            }

            [self.tableView reloadData];
        });
        
        
        if ([ETRegularUtil isEmptyString: dateDic1[@"createDate"]] && self.pullCount == self.interArray.count ) {
            
            
            self.isCompleted = YES;
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView.mj_header endRefreshing];
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
        
        NSString *endDater;
        
        DDLog(@"%d",self.pullCount);
        DDLog(@"%d",[self.dataCount intValue]);
        
        DDLog(@"%@",self.biaojiStr);
           
            if (self.signStr == NO || self.pullCount< self.interArray.count) {
                
                endDater = self.biaojiStr;
                _interSignStr = @"1";
            }else{
                
                _interSignStr = @"2";
                endDater = self.endDate;
                DDLog(@"%@",self.endDate);
                
                }
        
        if (![ETRegularUtil isEmptyString:endDater] && self.isCompleted == NO && _isContentNew == NO) {
            
            [self.dateArray insertObject:endDater atIndex:0];
            
            NSString *dataCount = [NSString stringWithFormat:@"%lu",(unsigned long)self.dateArray.count];
            [userDefault setObject:dataCount forKey:@"count"];
            
            for (int i =0 ; i<self.dateArray.count; i++) {
                
                NSString *intStr = [NSString stringWithFormat:@"%d",i];
                [userDefault setObject:self.dateArray[i] forKey:intStr];
            }
        }
        
            self.firstPullStr = NO;
            NSDictionary *param = @{@"userId":userId,@"token":tokenStr,@"createDate":self.createDate,@"endDate":endDater,@"answerStatus":@"3"};
            
            [weakSelf createInterlocutionWithParam:param];
            
            self.pullNew = YES;
            self.loadNew = NO;
            [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

-(void)loadMore{
    
    DDLog(@"%@",self.dateArray);
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pullNew = NO;
        if (self.pullCount< self.interArray.count) {
            
            if (_isContentNew == NO) {
                
                endStr = self.interArray[self.pullCount];
                self.pullCount = self.pullCount +1;
            }else{
                
//                endStr = self.endDate;
            }
            
            DDLog(@"yyyyyy%d",self.pullCount);
            
            DDLog(@"%@",endStr);
            self.signStr = NO;
        }else{
        
            if ([ETRegularUtil isEmptyString:self.interSignStr]) {
                
                _interSignStr = @"";
            }
            
            if ([_interSignStr isEqualToString:@"1"]) {
                
                endStr = self.biaojiStr;
                DDLog(@"%@",self.biaojiStr);
                _interSignStr = @"2";
            }else{
                
                endStr = self.endDate;
            }
            
            if (![ETRegularUtil isEmptyString:endStr] && _isCompleted == NO && _isContentNew == NO) {
                
                [self.dateArray addObject:endStr];
                
                NSString *dataCount = [NSString stringWithFormat:@"%lu",(unsigned long)self.dateArray.count];
                [userDefault setObject:dataCount forKey:@"count"];
                
                for (int i =0 ; i<self.dateArray.count; i++) {
                    
                    NSString *intStr = [NSString stringWithFormat:@"%d",i];
                    [userDefault setObject:self.dateArray[i] forKey:intStr];
                }
            }
    
            self.signStr = YES;
        }

        if ([endStr isEqualToString:[userDefault objectForKey:@"first"]]) {
            
            answerStatus = @"2";
        }else{
            
            answerStatus = @"3";
        }
        
        if ([ETRegularUtil isEmptyString:endStr]) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            NSDictionary *param = @{@"userId":userId,@"token":tokenStr,@"createDate":self.createDate,@"endDate":endStr,@"answerStatus":answerStatus};
            [weakSelf createInterlocutionWithParam:param];
            [weakSelf.tableView.mj_footer beginRefreshing];
        }
    
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

//当前字时间+1秒
-(NSString *)currentDateAddOneSecond{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];

    NSArray *array = [currentTimeString componentsSeparatedByString:@":"];
    NSString *secondStr = array[2];
    int secondInt = [secondStr intValue] +1;

    NSString *string = [array[0] stringByAppendingString:[NSString stringWithFormat:@":%@",array[1]]];
    NSString *String1 = [string stringByAppendingString:[NSString stringWithFormat:@":%d",secondInt]];

    return String1;
}


- (NSString *)currentTimeAddOneSecond{
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter1 stringFromDate:datenow];
    
    DDLog(@"xxxxxxxx%@",currentTimeString);
    long long time=  [[NSDate date] timeIntervalSince1970]*1000 + 1000;
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSString*timeString=[formatter1 stringFromDate:d];
    
    DDLog(@"yyyyyyyyyy%@",timeString);
    return timeString;
}

@end
