//
//  blackListController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "blackListController.h"
#import "fiendCell.h"
#import "chatViewModel.h"
#import "blackModel.h"

@interface blackListController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *blackListArray;

@end

@implementation blackListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavBarItem];
    [self createTableView];

    [self createHttpRequest];
    [self loadDataAllFriend];
    
    [self.tableView registerClass:[fiendCell class] forCellReuseIdentifier:@"fiendCell"];
}

-(void)createNavBarItem{
    
    self.blackListArray = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"黑名单";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 20, 24);
    [btn setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBack1) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark -- 加入黑名单
-(void)loadDataAllFriend{
    
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    
    NSDictionary *params = @{@"userId":userId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    
    [_manager POST:BlackListURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
        NSArray *menuList = dict[@"menuList"];
        for (NSDictionary *appDict in menuList) {
            
        blackModel *model = [[blackModel alloc]init];
            
        [model yy_modelSetWithDictionary:appDict];
        [weakSelf.blackListArray addObject:model];
        DDLog(@"%@",self.blackListArray);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.blackListArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    fiendCell *cell =[tableView dequeueReusableCellWithIdentifier:@"fiendCell"];
    if (!cell) {
        cell =[[fiendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fiendCell"];
    }
    
    blackModel *model = self.blackListArray[indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    cell.nameLable.text = model.nickName;
 
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark -- 编辑
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *indexPaths = @[indexPath];
        
            blackModel *chatModel = self.blackListArray[indexPath.row];

        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaults objectForKey:@"userName"];
        
            NSString *targetStr = [NSString stringWithFormat:@"%@",chatModel.taruId];
            NSString *userStr = [NSString stringWithFormat:@"%@",userId];
            NSDictionary *param = @{@"userId":userStr,@"target_uid":targetStr,@"status":@"0"};
            [self loadBlackListWithParam:param];
        
        [self.blackListArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -- 黑名单
-(void)loadBlackListWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    
    [_manager POST:parentBlackCircleURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        
        if (status == 0) {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

-(void)goBack1{

   [self.navigationController popViewControllerAnimated:YES];
}

@end
