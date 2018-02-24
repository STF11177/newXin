//
//  interDiscussController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import "interDiscussController.h"
#import "interDiscussCell.h"
#import "interDiscussHeadCell.h"
#import "interlocutionModel.h"
#import "interDiscussDetailController.h"
#import "interDiscussView.h"
#import "interReplyController.h"
#import "interDisscussModel.h"
#import "interDisscussHeadModel.h"

@interface interDiscussController ()<UITableViewDelegate,UITableViewDataSource,discussViewDelegate,interDiscussCellDelegate,discussHeadCellDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *headArray;
@property (nonatomic,strong) NSMutableArray *minDateArray;
@property (nonatomic,strong) NSMutableArray *commentIdArray;
@property (nonatomic,strong) interDiscussView *disscussView;
@property (nonatomic,strong) interDiscussCell *discussCell;
@property (nonatomic,strong) interDiscussHeadCell *disscussHeadCell;
@property (nonatomic,assign) BOOL open;//展开
@property (nonatomic,assign) BOOL pullNew;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,assign) BOOL firstSignStr;

@end

@implementation interDiscussController
static NSString *userId;
static NSString *from_uid;
static NSString *tokenStr;
static NSString *titleStr;
static NSString *contentStr;
static NSString *imgStr;
static NSString *collectStatus;
static NSString *likeCommentStatus;
static NSString *commentId;
static int collectNum;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNav];
    [self createHttp];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.disscussView];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    tokenStr = [userDefaults objectForKey:@"tokenName"];
    
    NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"taskId":self.taskStr};
    [self createWithParam:param];
    
    self.open = NO;
    self.firstSignStr = YES;
    
    [self loadMore];
    [self loadNew];
    [self.tableView registerClass:[interDiscussCell class] forCellReuseIdentifier:@"interDiscussCell"];
    [self.tableView registerClass:[interDiscussHeadCell class] forCellReuseIdentifier:@"interDiscussHeadCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

-(void)createNav{

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"UU问答";
    lable.font = [UIFont systemFontOfSize:20];
    lable.textColor = [UIColor blackColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)presentVC{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (iOS11) {
            
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

-(interDiscussView *)disscussView{
    
    if (!_disscussView) {
        
        _disscussView = [[interDiscussView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
        _disscussView.delegate = self;
        _disscussView.backgroundColor = [UIColor whiteColor];
    }
    return _disscussView;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
    
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)headArray{
    
    if (!_headArray) {
        
        _headArray = [[NSMutableArray alloc]init];
    }
    return _headArray;
}

-(NSMutableArray *)minDateArray{
    
    if (!_minDateArray) {
        
        _minDateArray = [[NSMutableArray alloc]init];
    }
    return _minDateArray;
}

-(NSMutableArray *)commentIdArray{
    
    if (!_commentIdArray) {
        
        _commentIdArray = [[NSMutableArray alloc]init];
    }
    return _commentIdArray;
}

#pragma mark --电池的颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    
    return UIStatusBarStyleDefault;
}

-(void)createWithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:interDiscussURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"%@",dict);
        
        NSDictionary *result = dict[@"result"];
        collectStatus = result[@"collectStatus"];
        collectNum = [result[@"collect_count"] intValue];
        from_uid = result[@"from_uid"];        
        
        titleStr = result[@"title"];
        contentStr = result[@"content"];
        imgStr = result[@"imgs"];
        
        [self.headArray removeAllObjects];
        interDisscussHeadModel *model = [[interDisscussHeadModel alloc]init];
        model.title = titleStr;
        model.imgs = imgStr;
        model.content = contentStr;
        [self.headArray addObject:model];
        
        NSString *footCollectStus = [NSString stringWithFormat:@"%@",collectStatus];
        if ([footCollectStus isEqualToString:@"0"]) {
            
            [self.disscussView.collectBtn setImage:[UIImage imageNamed:@"nices2"] forState:UIControlStateNormal];
            self.disscussView.collectBtn.selected = YES;
        }else{
            
            [self.disscussView.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
            self.disscussView.collectBtn.selected = NO;
        }
        
        [self.disscussView.collectBtn setTitle:[NSString stringWithFormat:@"%d个收藏",collectNum] forState:UIControlStateNormal];
        
        NSArray *menuListArray = dict[@"menuList"];
        NSArray *stickArray = dict[@"stickNamicfoList"];
        
        if (self.pullNew == YES) {
            
            [self.dataArray removeAllObjects];
        }
        
    
        if (stickArray.count !=0 && self.firstSignStr == YES) {
            for (NSDictionary *appDict in stickArray) {
                
                interDisscussModel *model = [[interDisscussModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
                [self.minDateArray addObject:model.createDate];
                [self.commentIdArray addObject:model.commentId];
            }
        }
        
        for (NSDictionary *appDict in menuListArray) {

            interDisscussModel *model = [[interDisscussModel alloc]init];
            [model yy_modelSetWithDictionary:appDict];
            [self.dataArray addObject:model];
            [self.minDateArray addObject:model.createDate];
            [self.commentIdArray addObject:model.commentId];
        }
        
        if (self.minDateArray.count >0) {
            for (int i = 0; i < self.minDateArray.count; ++i) {
                
                //遍历数组的每一个`索引`（不包括最后一个,因为比较的是j+1）
                for (int j = 0; j < self.minDateArray.count -1 - i; ++j) {
                    
                    if ([self compareDate:self.minDateArray[j] withDate:self.minDateArray[j+1]] == -1) {
                        
                        [self.minDateArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    }
                }
            }
        }
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
    
            [weakSelf.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 收藏
-(void)collectInView:(interDiscussView *)view{
    
    if (view.collectBtn.selected == YES) {
        
        [view.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
        collectNum = collectNum -1;
        NSString *likeStr = [NSString stringWithFormat:@"%d个收藏",collectNum];
        [view.collectBtn setTitle:likeStr forState:UIControlStateNormal];
        collectStatus = @"0";
        view.collectBtn.selected = NO;
    }else{
        
        [view.collectBtn setImage:[UIImage imageNamed:@"nices2"] forState:UIControlStateNormal];
        collectNum = collectNum +1;
        NSString *likeStr = [NSString stringWithFormat:@"%d个收藏",collectNum];
        [view.collectBtn setTitle:likeStr forState:UIControlStateNormal];
        collectStatus = @"1";
        view.collectBtn.selected = YES;
    }
    
    NSDictionary *param = @{@"userId":userId,@"taskId":self.taskStr,@"type":@"5",@"status":collectStatus};
    [self createCollectWithParam:param];
}

-(void)createCollectWithParam:(NSDictionary *)param{
    
    //status 1是收藏， 0是取消
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:collectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 点赞
-(void)likeInCell:(interDiscussCell *)cell{
    
    DDLog(@"%ld",cell.indexPath.section);
    interDisscussModel *model = self.dataArray[cell.indexPath.section-1];
    BOOL isLike = !model.isLike;
    model.isLike = isLike;
    
    NSString *likeStatus;
    if (cell.likeBtn.selected == YES) {
        
        [cell.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        likeStatus = @"1";
        cell.likeBtn.selected = NO;
        
    }else{
        
        [cell.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateSelected];
        likeStatus = @"0";
        cell.likeBtn.selected = YES;
    }
    
    NSDictionary *param = @{@"userId":userId,@"commentId":model.commentId,@"type":@"5",@"status":likeStatus};
    [self createLikeWithParam:param];
}

-(void)createLikeWithParam:(NSDictionary *)param{
    
//  __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:commentLikeURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count +1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        self.disscussHeadCell = [tableView dequeueReusableCellWithIdentifier:@"interDiscussHeadCell"];
        if (!self.disscussHeadCell) {
         
            self.disscussHeadCell = [[interDiscussHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"interDiscussHeadCell"];
        }
        
        if (self.headArray.count !=0) {
            
            
            interDisscussHeadModel *model = self.headArray[0];
         
            [self.disscussHeadCell setModel:model isOpen:self.open];
            self.disscussHeadCell.delegate = self;
        }

        self.disscussHeadCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.disscussHeadCell;
    }else{
        self.discussCell = [tableView dequeueReusableCellWithIdentifier:@"interDiscussCell"];
        if (!self.discussCell) {
            
            self.discussCell = [[interDiscussCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"interDiscussCell"];
        }
        interDisscussModel *mdoel = self.dataArray[indexPath.section -1];
        self.discussCell.model = mdoel;
        self.discussCell.indexPath = indexPath;
        self.discussCell.delegate = self;
        
        NSString *likeStatus = [NSString stringWithFormat:@"%@",mdoel.likeCommentStatus];
        
        if ([likeStatus isEqualToString:@"0"]) {

            _discussCell.likeBtn.selected = YES;
            if (mdoel.isLike) {

                 _discussCell.likeBtn.selected = NO;
            }
        }
        return self.discussCell;
    }
}

-(void)exprandInCell:(interDiscussHeadCell *)cell{
    
    self.open = YES;
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
    }else{
        
        interDisscussModel *mdoel = self.dataArray[indexPath.section -1];
        interDiscussDetailController *detail = [[interDiscussDetailController alloc]init];
        detail.commentStr = mdoel.commentId;
        detail.from_uid = from_uid;
        detail.titleStr = titleStr;
        detail.taskStr = self.taskStr;
        DDLog(@"%@",[self.minDateArray firstObject]);
        detail.minDateStr = [self.minDateArray firstObject];
        detail.createArray = self.commentIdArray;
        [self.navigationController pushViewController:detail animated:NO];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {

        if (self.open == YES) {

            return [self.disscussHeadCell cellHeightWith:imgStr isOpen:YES];
        }else{

            return [self.disscussHeadCell cellHeightWith:imgStr isOpen:NO];
        }
    }else{
        
        interDisscussModel *mdoel = self.dataArray[indexPath.section -1];
        return  [self.discussCell cellHeightWithModel:mdoel];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

        return 5.0f;
}

-(void)discussInCell:(interDiscussView *)View{
    
    interReplyController *reply = [[interReplyController alloc]init];
    reply.titleStr = titleStr;
    reply.from_uid = from_uid;
    reply.taskStr = self.taskStr;
    [self.navigationController pushViewController:reply animated:NO];
}

-(void)loadMore{
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
   
            self.createDate = [self.minDateArray firstObject];
        if ([ETRegularUtil isEmptyString:self.createDate]) {
            
            self.createDate = @"";
        }
            NSDictionary *param = @{@"userId":userId,@"createDate":self.createDate,@"taskId":self.taskStr};
            [self createWithParam:param];
            
            weakSelf.pullNew = NO;
            self.firstSignStr = NO;//第一次进入
            [weakSelf.tableView.mj_footer beginRefreshing];
    }];
}

-(void)loadNew{
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSDictionary *param = @{@"userId":userId,@"createDate":@"",@"taskId":self.taskStr};
        [weakSelf createWithParam:param];
        weakSelf.pullNew = YES;
        self.firstSignStr = YES;
        
        [weakSelf.tableView.mj_header beginRefreshing];
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
    switch (result){
            
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

