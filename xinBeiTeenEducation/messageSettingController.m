//
//  messageSettingController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/15.
//  Copyright © 2017年 user. All rights reserved.
//

#import "messageSettingController.h"
#import "ImgUpLoadModel.h"
#import "ETMessageView.h"
#import "UserInfoModel.h"
#import "chatViewModel.h"

@interface messageSettingController ()<CommonSheetDelegate>
{

    AFHTTPRequestOperationManager *_manager;

}

@property (nonatomic, strong) UISwitch *blackMenu;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *deleBtn;
//@property (nonatomic, strong) UserInfoModel *userInfoModel;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSMutableArray *blackListArray;

@end

@implementation messageSettingController
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    [self createHttpRequest];
    [self createNav];
    [self creaetView];
    [self getBlackList];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
}

-(void)createNav{

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"资料设置";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    [self.navigationItem setHidesBackButton:YES];
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame =CGRectMake(0, 0, 10, 19);
    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)goBack{

    [self.navigationController popViewControllerAnimated:NO];
}

-(void)creaetView{
    
    self.titleView =[[UIView alloc]init];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    self.titleLable = [[UILabel alloc]init];
    self.titleLable.text = @"加入黑名单";
    
    self.blackMenu = [[UISwitch alloc]init];
    self.blackMenu.onTintColor = [UIColor colorWithRed:0.164 green:0.657 blue:0.915 alpha:1.000];
    [self.blackMenu addTarget:self action:@selector(blackClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleBtn = [[UIButton alloc]init];
    self.deleBtn.backgroundColor = [UIColor lightGrayColor];
    [self.deleBtn setTitle:@"删除好友" forState:UIControlStateNormal];
    [self.deleBtn addTarget:self action:@selector(deleClick) forControlEvents:UIControlEventTouchUpInside];
    self.deleBtn.clipsToBounds = YES;
    self.deleBtn.layer.cornerRadius = 5;
    
    [self.view addSubview:self.deleBtn];
    [self.titleView addSubview:self.blackMenu];
    [self.titleView addSubview:self.titleLable];
    
    [self layoutUI];
}

- (void)layoutUI{
    __weak typeof(self)weakSelf = self;
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(80);
        make.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(50);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleView.mas_top);
        make.left.equalTo(weakSelf.titleView).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];
    
    [self.blackMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLable.mas_top).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    [self.deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleView.mas_bottom).offset(100);
        make.left.equalTo(weakSelf.view).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth - 20);
    }];
}

-(void)deleClick{

    CommonSheet *sheet = [[CommonSheet alloc]initWithDelegate:self];
    sheet.itemColor = COLOR_7a8fc1;
    sheet.sheetTag = 1003;
    [sheet setupWithTitles:@[@"删除好友，对方将被移出你的好友列表",@"确定"]];
    [sheet showInView:self.view];
}

- (void)getBlackList{
    
//    DDLog(@"self.taget_uid%@",self.taget_uid);
//    EMError *error = nil;
//    NSArray *blacklist = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
//    DDLog(@"blacklist:%@",blacklist);
//    if (!error) {
//        [blacklist enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            NSString *blackName = obj;
//            
//            NSString *str = [NSString stringWithFormat:@"%@",self.taget_uid];
//            if ([blackName isEqualToString:str]) {
//                
//                self.blackMenu.on = YES;
//                self.deleBtn.hidden = YES;
//            }else{
//            
//                self.blackMenu.on = NO;
//                self.deleBtn.hidden = NO;
//            }
//        }];
//    }
}

#pragma mark -- 黑名单
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
        _status = [dict[@"status"]intValue];
        
        if (_status == 0) {
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)blackClick:(UISwitch *)sender{
    
    if (sender.on) {
        
        DDLog(@"%@",userId);
        DDLog(@"%@",self.taget_uid);
        NSDictionary *params = @{@"userId":userId,@"target_uid":self.taget_uid,@"status":@"2"};
        [self loadBlackListWithParam:params];
//        NSString *str = [NSString stringWithFormat:@"%@",self.taget_uid];
//        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:str relationshipBoth:YES];
//        if (!error) {
//            NSLog(@"添加黑名单成功");
//        }
//        NSArray *blacklist = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
//        DDLog(@"%@",self.taget_uid);
//        DDLog(@"%@",blacklist);
//        if (!error) {
//            _blackMenu.on = YES;
//            DDLog(@"%@",blacklist);
//            [[ETMessageView sharedInstance]showMessage:@"黑名单添加成功!" onView:self.view withDuration:1.0];
//        }
    }else {
        
        NSDictionary *param = @{@"userId":userId,@"target_uid":self.taget_uid,@"status":@"0"};
        [self loadBlackListWithParam:param];
        
        //移除黑名单
//        NSString *str = [NSString stringWithFormat:@"%@",self.taget_uid];
//        EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:str];
//        if (!error) {
//            [[ETMessageView sharedInstance]showMessage:@"已经移除黑名单!"  onView:self.view withDuration:0.5];
//            DDLog(@"移除黑名单成功");
//        }
    }
}

#pragma mark -------commonDelegate--------
-(void)commonSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag{

    switch ([index integerValue]) {
        case 0:
            if([tag integerValue]==1003){
                //删除好友
                NSDictionary *param = @{@"userId":userId,
                                        @"target_uid":self.taget_uid,@"status":@"0"};
                [self loadDeteDatawithparam:param];
                
                NSDictionary *param1 = @{@"userId":self.taget_uid,
                                         @"target_uid":userId,@"status":@"0"};
                [self loadDeteDatawithparam:param1];
                
//                // 删除好友
//                [[EMClient sharedClient].contactManager deleteContact:[NSString stringWithFormat:@"%@",self.taget_uid]
//                                                 isDeleteConversation: YES
//                                                           completion:^(NSString *aUsername, EMError *aError) {
//                                                               if (!aError) {
//                                                                   NSLog(@"删除成功");
//                                                               }
//                                                           }];
            }
            break;
            
        default:
            break;
    }
}

-(void)loadDeteDatawithparam:(NSDictionary *)param{

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:deleFriendURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        _status = [dict[@"status"]intValue];
        if (_status == 0) {
            
            DDLog(@"%@",@"成功");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:NO];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
