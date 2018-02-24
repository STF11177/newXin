////  chatViewController.m
////  xinBeiTeenEducation
////
////  Created by user on 2017/3/1.
////  Copyright © 2017年 user. All rights reserved.
//
//#import "chatViewController.h"
//#import "fiendCell.h"
//#import "addfriendController.h"
//#import "chatController.h"
//#import "messageSettingController.h"
//#import "newfriendCell.h"
//#import "parentsCircleController.h"
//#import "chatViewModel.h"
//#import "TableViewCell.h"
//#import "ConversationListController.h"
//#import "YHActionSheet.h"
//#import "BaseTableViewCell.h"
//#import "SRRefreshView.h"
//#import "UserProfileManager.h"
//#import "ETMessageView.h"
//
//@interface chatViewController ()<UIActionSheetDelegate,SRRefreshDelegate>
//{
//        
//        AFHTTPRequestOperationManager *_manager;
//        NSIndexPath *_currentLongPressIndex;
//    
//}
//@property (nonatomic,assign) int status;
//@property (nonatomic,strong) UIView *networkStateView;
//@property (nonatomic,strong) NSMutableArray *dataSource;
//@property (nonatomic,strong) SRRefreshView *slimeView;
//@property (nonatomic,strong) NSMutableArray *blackListArray;
//@property (nonatomic,strong) NSMutableArray *pictureArray;
//
//@end
//
//@implementation chatViewController
//static  NSString  *managerCellId = @"fiendCell";
//static  NSString  *userId;
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        
//        _dataSource = [NSMutableArray array];
//        _dataArray = [[NSMutableArray alloc]init];
//        _blackListArray = [[NSMutableArray alloc]init];
//        _pictureArray = [[NSMutableArray alloc]init];
//    }
//    return self;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self createNavBarItem];
//    [self createTableView];
//    [self createHttpRequest];
//    [self loadDataAllFriend];
//    [self loadNewFirend];
//    
////    EMError *error = nil;
////    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
////    if (!error) {
////        NSLog(@"获取成功 -- %@",userlist);
////    }
//    
//    [self.firendTableView registerClass:[fiendCell class] forCellReuseIdentifier:managerCellId];
//    [self.firendTableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"cell"];
//}
//
//-(void)createNavBarItem{
//
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.text = @"好友";
//    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
//    lable.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lable;
//    [self.navigationItem setHidesBackButton:YES];
//    
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = item;
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    userId = [userDefaults objectForKey:@"userName"];
//    DDLog(@"%@",userId);
//}
//
//-(void)createTableView{
//
//    self.firendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
//    self.firendTableView.delegate = self;
//    self.firendTableView.dataSource = self;
//    self.firendTableView.tableHeaderView = [[UIView alloc]init];
//    self.firendTableView.tableFooterView = [[UIView alloc]init];
//    [self.view addSubview:self.firendTableView];
//
//    _slimeView = [[SRRefreshView alloc] init];
//    _slimeView.delegate = self;
//    _slimeView.upInset = 0;
//    _slimeView.slimeMissWhenGoingBack = YES;
//    _slimeView.slime.bodyColor = [UIColor grayColor];
//    _slimeView.slime.skinColor = [UIColor grayColor];
//    _slimeView.slime.lineWith = 1;
//    _slimeView.slime.shadowBlur = 4;
//    _slimeView.slime.shadowColor = [UIColor grayColor];
//    _slimeView.hidden = YES;
//    [self.view addSubview:_slimeView];
//    [self.slimeView setLoadingWithExpansion];
//}
//
//-(void)createHttpRequest{
//    
//    _manager = [AFHTTPRequestOperationManager manager];
//    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//}
//
//#pragma mark -- 所有好友
//-(void)loadDataAllFriend{
//
//    __weak typeof(self) weakSelf = self;
//    DDLog(@"%@",userId);
//    NSDictionary *params = @{@"userId":userId};
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
//    
//    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
//    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
//    DDLog(@"%@",jsonString);
//    
//    [_manager POST:allFriendURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        DDLog(@"下载成功");
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        DDLog(@"dict:%@",dict);
//        _status = [dict[@"status"]intValue];
//        
//        if (_status == 0) {
//            
//            NSArray *menuList = dict[@"menuList"];
//            for (NSDictionary *appDict in menuList) {
//                
//                chatViewModel *chatModel = [[chatViewModel alloc]init];
//                [chatModel setValuesForKeysWithDictionary:appDict];
//                
//                DDLog(@"%@",chatModel.status);
//                NSString *blackStatus = [NSString stringWithFormat:@"%@",chatModel.status];
//                
//                if ([blackStatus isEqualToString:@"0"]) {
//                    
//                    [weakSelf.dataArray addObject:chatModel];
//                    DDLog(@"%@",weakSelf.dataArray);
//                }else if([blackStatus isEqualToString:@"2"]){
//                
//                    [weakSelf.blackListArray addObject:chatModel];
//                    DDLog(@"%@",self.blackListArray);
//                }
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.firendTableView reloadData];
//        });
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 4;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//   if(section == 2) {
//       
//       DDLog(@"%ld",self.dataArray.count);
//        return self.dataArray.count;
//   }else if (section ==1){
//   
//       return 1;
//   }else if (section == 3){
//   
//       return self.blackListArray.count;
//   }else{
//   
//   return 0;
//   }
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 70;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//        if (indexPath.section == 2 ) {
//            
//            fiendCell *cell =[tableView dequeueReusableCellWithIdentifier:managerCellId];
//            if (!cell) {
//                cell =[[fiendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:managerCellId];
//            }
//            
//            chatViewModel *chatModel = self.dataArray[indexPath.row];
//            DDLog(@"%@",chatModel);
//            cell.chatViewModel = chatModel;
//            cell.indexPath = indexPath;
//          return cell;
//        }
//        
//        if (indexPath.section == 3) {
//            
//            fiendCell *cell =[tableView dequeueReusableCellWithIdentifier:managerCellId];
//            if (!cell) {
//                cell =[[fiendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:managerCellId];
//            }
//            
//            chatViewModel *chatModel = self.blackListArray[indexPath.row];
//            DDLog(@"%@",chatModel);
//            cell.chatViewModel = chatModel;
//            cell.indexPath = indexPath;
//         return cell;
//
//        }else{
//        
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" ];
//            if (!cell) {
//             
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//            }
//            return cell;
//        }
//}
//
//#pragma mark - scrollView delegate
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [_slimeView scrollViewDidScroll];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [_slimeView scrollViewDidEndDraging];
//}
//
//#pragma mark - slimeRefresh delegate
////刷新列表
//- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
//{
//    [self reloadDataSource];
//    [_slimeView endRefresh];
//}
//
//- (void)reloadDataSource
//{
//    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
//    __weak typeof(self) weakself = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [weakself.dataSource removeAllObjects];
//        EMError *error = nil;
//        NSArray *blocked = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
//        DDLog(@"%@",blocked);
//        [weakself.dataSource addObjectsFromArray:blocked];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideHud];
//            [weakself.firendTableView reloadData];
//        });
//    });
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//    
//    view.backgroundColor =[UIColor whiteColor];
//    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 30)];
//    headLabel.font = [UIFont systemFontOfSize:15];
//    headLabel.textColor = [UIColor lightGrayColor];
//    
//    if (section == 0) {
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//        [tap addTarget:self action:@selector(tapGesture)];
//        tap.numberOfTapsRequired =1;
//        [view setUserInteractionEnabled:YES];
//        
//        UILabel *newfriendLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 30)];
//        
//        for (int i = 0; i < _pictureArray.count; i++) {
//            
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (50 +5) * i + 20 , newfriendLable.frame.size.height + 5 + 5, 50, 50)];
//            imageView.image = [UIImage imageNamed:@"ride_snap_default"];
//            
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pictureArray[i]]];
//            imageView.image = [UIImage imageWithData:data];
//            [view addSubview:imageView];
//        }
//        
//        newfriendLable.font = [UIFont systemFontOfSize:15];
//        newfriendLable.textColor = [UIColor lightGrayColor];
//        newfriendLable.text = @"新的朋友";
//        
//        [view addSubview:newfriendLable];
//        [view addGestureRecognizer:tap];
//        
//    }else if (section == 1) {
//        
//        headLabel.text = @"我的消息";
//        view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
//    }
//    
//   else if (section == 2) {
//       
//       headLabel.text = @"我的好友";
//       view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
//    }else if (section == 3){
//    
//        headLabel.text = @"黑名单";
//        headLabel.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
//        view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
//    }
//    
//    [view addSubview:headLabel];
//    return view;
//}
//
//#pragma mark -- 点击进入聊天界面
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (indexPath.section == 1) {
//        
//       ConversationListController *conVerList  =[[ConversationListController alloc]init];
//        conVerList.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:conVerList animated:NO];
//        [self presentedViewController];
//        
//        self.hidesBottomBarWhenPushed = YES;
//        
//    }else if (indexPath.section == 2) {
//    
//        chatViewModel *model = self.dataArray[indexPath.row];
//         chatController *chatContrller = [[chatController alloc] initWithConversationChatter:model.nickName conversationType:EMConversationTypeChat];
//        
//        if (!model.remarkName) {
//            
//            chatContrller.hidesBottomBarWhenPushed = YES;
//            chatContrller.titleName = model.nickName;
//                   }else{
//        
//            chatContrller.hidesBottomBarWhenPushed = YES;
//            chatContrller.titleName = model.remarkName;
//        }
//        chatContrller.faceImage = model.faceImg;
//        chatContrller.from_uid = model.id;
//        [self.navigationController pushViewController:chatContrller animated:NO];
//        self.hidesBottomBarWhenPushed = YES;
//
//        
//    }else if(indexPath.section == 3){
//    
//        chatViewModel *chatModel = self.blackListArray[indexPath.row];
//        messageSettingController *mess = [[messageSettingController alloc]init];
//        mess.taget_uid = chatModel.id;
//        [self.navigationController pushViewController:mess animated:NO];
//    }
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    if (section == 0) {
//        
//        return 100;
//    }else{
//        
//        return 30;
//    }
//}
//
//#pragma mark -- 编辑
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        NSArray *indexPaths = @[indexPath];
//        if (indexPath.section == 2) {
//            
//            [self.dataArray removeObjectAtIndex:indexPath.row];
//            [self.firendTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        }else if (indexPath.section == 3){
//        
//            chatViewModel *chatModel = self.blackListArray[indexPath.row];
//            [self.blackListArray removeObjectAtIndex:indexPath.row];
//            [self.firendTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//            NSDictionary *param = @{@"userId":userId,@"target_uid":chatModel.id,@"status":@"0"};
//            [self loadBlackListWithParam:param];
//
//            //移除黑名单
//            NSString *str = [NSString stringWithFormat:@"%@",chatModel.id];
//            EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:str];
//            if (!error) {
//                [[ETMessageView sharedInstance]showMessage:@"已经移除黑名单!"  onView:self.view withDuration:0.5];
//                DDLog(@"移除黑名单成功");
//            }
//
//        }
//    }
//}
//
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.section == 3) {
//        
//        return YES;
//    }else{
//        
//        return NO;
//    }
//}
//
//#pragma mark -- 新的朋友
//-(void)loadNewFirend{
//    
//    NSDictionary *params = @{@"userId":userId};
//    __weak typeof(self) weakSelf = self;
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
//    
//    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
//    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
//    DDLog(@"%@",jsonString);
//    
//    [_manager POST:allFriendURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        DDLog(@"下载成功");
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        DDLog(@"dict:%@",dict);
//        int status = [dict[@"status"]intValue];
//        
//        if (status == 0) {
//            
//            NSArray *menuList = dict[@"menuList"];
//            for (NSDictionary *appDict in menuList) {
//                
//                chatViewModel *chatModel = [[chatViewModel alloc]init];
//                [chatModel setValuesForKeysWithDictionary:appDict];
//                NSString *blackStatus = [NSString stringWithFormat:@"%@",appDict[@"status"]];
//                DDLog(@"%@",blackStatus);
//                if ([blackStatus isEqualToString:@"0"]) {
//                    
//                    [weakSelf.pictureArray addObject:chatModel.faceImg];
//                    DDLog(@"%@",weakSelf.pictureArray);
//                }
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [weakSelf.firendTableView reloadData];
//        });
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
//
//#pragma mark -- 黑名单
//-(void)loadBlackListWithParam:(NSDictionary *)param{
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
//    
//    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
//    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
//    DDLog(@"%@",jsonString);
//    
//    [_manager POST:blackListURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        DDLog(@"下载成功");
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        DDLog(@"dict:%@",dict);
//        _status = [dict[@"status"]intValue];
//        
//        if (_status == 0) {
//            
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
//
//-(void)goBack{
//
//    [self.navigationController popToRootViewControllerAnimated:NO];
//}
//
//-(void)tapGesture{
//    
//    addfriendController *addfriend =[[addfriendController alloc]init];
//    addfriend.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:addfriend animated:NO];
//    self.hidesBottomBarWhenPushed = YES;
//
//}
//
//
//@end
