//
//  gradeController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "gradeController.h"
#import "gradeDetailController.h"
#import "childDataController.h"
#import "mySonSchoolModel.h"
#import "personDataOtherCell.h"

@interface gradeController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation gradeController
static NSString *contentStr;
static NSInteger count;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNav];
    [self createHttp];
    
    [self.tableView registerClass:[personDataOtherCell class] forCellReuseIdentifier:@"personDataOtherCell"];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSDictionary *param = @{@"babyId":self.babyId};
    [self loadChildDataWithParam:param];
    [self refresh];
    
    if ([self.signStr isEqualToString:@"1"]) {
        
        count = 1;
    }else if([self.signStr isEqualToString:@"2"]){
        
        count = 2;
    }else{
        
        count = 3;
    }
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"学校";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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

-(void)loadChildDataWithParam:(NSDictionary *)param{
    
    DDLog(@"%@",self.babyId);

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:seeChildMesURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            [self.dataArray removeAllObjects];
            
            NSArray *babyList = dict[@"babyList"];
            for (NSDictionary *appDict in babyList) {
                
                mySonSchoolModel *mdoel = [[mySonSchoolModel alloc]init];
                [mdoel yy_modelSetWithDictionary:appDict];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setValue:mdoel.schoolName forKey:mdoel.type];
                [self.dataArray addObject:dict];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    DDLog(@"%ld",count);
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    personDataOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personDataOtherCell"];
    if (!cell) {
        
        cell = [[personDataOtherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personDataOtherCell"];
    }
    
        if (indexPath.row == 0) {
            
            cell.titleLb.text = @"幼儿园";
        
            for (NSDictionary *dict in self.dataArray) {
                NSString *keyStr = [NSString stringWithFormat:@"%@",[dict allKeys][0]];
                if ([keyStr isEqualToString:@"0"]) {
                    
                    contentStr = [dict objectForKey:[dict allKeys][0]];
                    cell.headLb.text = contentStr;
                }
            }
        }else if(indexPath.row == 1){
            
           cell.titleLb.text = @"小学";
            
            for (NSDictionary *dict in self.dataArray) {
                NSString *keyStr = [NSString stringWithFormat:@"%@",[dict allKeys][0]];
                if ([keyStr isEqualToString:@"1"]) {
                    
                    contentStr = [dict objectForKey:[dict allKeys][0]];
                    cell.headLb.text = contentStr;
                }
            }
        }else {
            
            cell.titleLb.text = @"初中";
            for (NSDictionary *dict in self.dataArray) {
                NSString *keyStr = [NSString stringWithFormat:@"%@",[dict allKeys][0]];
                if ([keyStr isEqualToString:@"2"]) {
                    
                    contentStr = [dict objectForKey:[dict allKeys][0]];
                    cell.headLb.text = contentStr;                }
            }
        }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [tableView deselectRowAtIndexPath:indexPath animated:YES];

    gradeDetailController *detail = [[gradeDetailController alloc]init];
    detail.babyId = self.babyId;
    if (indexPath.row == 0) {
        
        detail.nameStr = @"幼儿园";
        detail.fromWhere = @"0";
    }else if(indexPath.row == 1){
    
        detail.nameStr = @"小学";
        detail.fromWhere = @"1";
    }else{
    
        detail.nameStr = @"初中";
        detail.fromWhere = @"2";
    }
   
    detail.detailStr = self.signStr;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -- 刷新
-(void)refresh{
    
        __weak __typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        NSDictionary *param = @{@"babyId":self.babyId};
        [self loadChildDataWithParam:param];
        [weakSelf.tableView.mj_header beginRefreshing];

    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

-(void)presentBack{
                
    childDataController *child = [[childDataController alloc]init];
    child.babyId = self.babyId;
    [self.navigationController pushViewController:child animated:YES];
}

@end
