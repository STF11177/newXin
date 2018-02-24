//
//  newMessageController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/7.
//  Copyright © 2017年 user. All rights reserved.
//

#import "newMessageController.h"
#import "messageCell.h"
#import "messageModel.h"

@interface newMessageController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *messageArray;

@end

@implementation newMessageController
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLb.text = @"消息";
    [self createHttpRequest];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    DDLog(@"%@",userId);

    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[messageCell class] forCellReuseIdentifier:@"cell"];
    
      [self loadMessageData];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(UITableView*)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(NSMutableArray *)messageArray{
    
    if (!_messageArray) {
        
        _messageArray = [[NSMutableArray alloc]init];
    }
    return _messageArray;
}

#pragma mark -- 消息的标记
-(void)loadMessageData{
    
    //请求参数
    NSDictionary *param = @{@"userId":userId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:messageURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        int status = [dict[@"status"]intValue];
        NSArray *menuList = dict[@"menuList"];
        
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (NSDictionary *appDict in menuList) {
                    
                    messageModel *model = [[messageModel alloc]init];
                    [model yy_modelSetWithDictionary:appDict];
                    [self.messageArray addObject:model];
                }
                
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    messageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[messageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    DDLog(@"%@",self.messageArray);
    messageModel *model = self.messageArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

@end
