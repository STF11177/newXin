//
//  addfriendController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 user. All rights reserved.

#import "addfriendController.h"
#import "chatViewController.h"
#import "addfriendViewCell.h"
#import "testfiController.h"
#import "chatViewController.h"
#import "InvitationManager.h"
#import "chatViewModel.h"

static addfriendController *controller = nil;

@interface addfriendController ()<addfriendViewCellDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isPress;

@end

@implementation addfriendController
static NSString *managerCellId = @"addfriendViewCell";
static NSString *userId;

+(instancetype)shareController{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self createNavBarItem];
    [self createTableView];
    [self createHttpRequest];
    
    [self.addfriendTableView registerClass:[addfriendViewCell class] forCellReuseIdentifier:managerCellId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSDictionary *params = @{@"userId":userId};
    [self loadDataNewFriendwithParam:params];
    _isPress = NO;
    [self loadDataSourceFromLocalDB];
}

-(void)createNavBarItem{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"新朋友";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    [self.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 10, 19);
    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackChatView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
}

//- (NSString *)loginUsername
//{
////    return [[EMClient sharedClient] currentUsername];
//}

-(void)createTableView{
    
    self.addfriendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.addfriendTableView.delegate = self;
    self.addfriendTableView.dataSource = self;
    self.addfriendTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.addfriendTableView];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

//    DDLog(@"%ld",[self.dataSource count]);
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

#pragma mark -- 新的好友
-(void)loadDataNewFriendwithParam:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    
    [_manager POST:allFriendURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
         int status = [dict[@"status"]intValue];
        
        if (status == 0) {
            
            NSArray *menuList = dict[@"menuList"];
            
            DDLog(@"%@",menuList);
            for (NSDictionary *appDict in menuList) {
                
                chatViewModel *chatModel = [[chatViewModel alloc]init];
                NSString *blackStatus = [NSString stringWithFormat:@"%@",appDict[@"status"]];
                DDLog(@"%@",blackStatus);
                if ([blackStatus isEqualToString:@"1"]) {
                    
                    [chatModel yy_modelSetWithDictionary:appDict];
                    [weakSelf.dataArray addObject:chatModel];
                }
                
                if (weakSelf.dataArray.count == 0) {
                    
                    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 44)];
                    lable.textAlignment = NSTextAlignmentCenter;
                    lable.text = @"暂无好友申请";
                    lable.textColor = [UIColor grayColor];
                    [self.view addSubview:lable];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.addfriendTableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    addfriendViewCell *cell =[tableView dequeueReusableCellWithIdentifier:managerCellId];
    if (!cell) {
        cell =[[addfriendViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:managerCellId];
    }
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatViewModel *chatModel = self.dataArray[indexPath.row];
    DDLog(@"%@",chatModel);
    cell.chatModel = chatModel;
    cell.indexPath = indexPath;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    chatViewModel *chatModel = self.dataArray[indexPath.row];
//    testfiController *testifyVC = [[testfiController alloc]init];
//    testifyVC.from_target = chatModel.id;
//    [self.navigationController pushViewController:testifyVC animated:NO];
}

-(void)goBackChatView{

    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)applyCellAddFriendCell:(addfriendViewCell *)cell{

    _isPress = YES;
    _isPress = !_isPress;
    [cell.jieShouBtn setTitle:@"已同意" forState:UIControlStateNormal];
    [cell.jieShouBtn setBackgroundColor:[UIColor whiteColor]];
    [cell.jieShouBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    chatViewModel *model = self.dataArray[cell.indexPath.row];
    DDLog(@"%@",model.id);
    NSString *from_uid = [NSString stringWithFormat:@"%@",model.id];
    
    NSDictionary *param = @{@"userId":userId,@"target_uid":from_uid,@"status":@"0"};
    [self loadBlackListWithParam:param];
    
    NSDictionary *param1 = @{@"userId":from_uid,@"target_uid":userId,@"status":@"0"};
    [self loadBlackListWithParam:param1];
    
}

#pragma mark - public
- (void)addNewApply:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    [self.addfriendTableView reloadData];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity *newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            
//            NSString *loginName = [[EMClient sharedClient] currentUsername];
//            newEntity.receiverUsername = loginName;
            
//            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
//            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
            [_dataSource insertObject:newEntity atIndex:0];
            [self.addfriendTableView reloadData];
        }
    }
}

//- (void)removeApply:(NSString *)aTarget
//{
//    if ([aTarget length] == 0) {
//        return ;
//    }
//    
//    for (ApplyEntity *entity in self.dataSource) {
//        if ([entity.applicantUsername isEqualToString:aTarget] ) {
////            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
//            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
//            [self.dataSource removeObject:entity];
//            [self.addfriendTableView reloadData];
//            break;
//        }
//    }
//}


#pragma mark -- 同意
-(void)loadBlackListWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    
    [_manager POST:blackListURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        
        if (status == 0) {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - getter
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

//- (void)loadDataSourceFromLocalDB
//{
//    [_dataSource removeAllObjects];
//    NSString *loginName = [self loginUsername];
//    if(loginName && [loginName length] > 0)
//    {
//        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
//        [self.dataSource addObjectsFromArray:applyArray];
//        
//        DDLog(@"%@",self.dataSource);
//        [self.addfriendTableView reloadData];
//    }
//}

#pragma mark - EMContactManagerDelegate
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    NSString *msgstr = [NSString stringWithFormat:@"%@同意了加好友申请", aUsername];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
