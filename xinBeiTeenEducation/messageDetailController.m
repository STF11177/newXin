//
//  messageDetailController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import "messageDetailController.h"
#import "personController.h"
#import "TableViewCell.h"
#import "messageSettingController.h"
#import "beiZhuController.h"
#import "messDetailModel.h"
#import "parentsCircleController.h"
#import "personController.h"
#import "addfriendController.h"
#import "chatController.h"
#import "ETMessageView.h"
#import "ETRegularUtil.h"
#import "verifiFriendController.h"

@interface messageDetailController ()<CommonAlertDelegate,UITextFieldDelegate>
{

    AFHTTPRequestOperationManager *_manager;
    
}

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *sexView;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UIButton *beizhuBtn;//修改备注
@property (nonatomic,strong) UILabel *nickLable;//昵称的内容
@property (nonatomic,strong) UILabel *nameLable;//昵称
@property (nonatomic,strong) UIView *vepeView;

//申请好友理由
@property (nonatomic,strong) NSString  *reasonStr;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UIButton *footBtn;
@property (nonatomic,strong) UITableViewCell *tableCell;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;


@property (nonatomic,assign) int tagg;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,assign) int os;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int count;
@property (nonatomic,strong) UIImageView *faceView;
@property (nonatomic,assign) BOOL netStatus1;

@end

@implementation messageDetailController

static NSString  *managerCellId = @"TableViewCell";

static NSString *articleStr;
static NSString *personStr;
static NSString *addressStr;
static NSString *userStr;
static NSString *target_uid;
static NSString *userID;
static NSString *targetStr;

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    self.fd_interactivePopDisabled = YES;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.dataSource = [[NSMutableArray alloc]init];
    
    [self createTableView];
    [self createNavBarItem];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userID = [userDefaults objectForKey:@"userName"];

    self.netStatus1 = YES;
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //有网络
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWorkError" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createHttpRequest];
    [self loadDetaleData];
    [self createView];
    
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationNetWorkError" object:nil];
}

-(void)noNetStatus{
    
    self.netStatus1 = NO;
}

-(void)netStatus{
    
    self.netStatus1 = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (instancetype)initWithUsername:(NSString *)username
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _username = username;
    }
    return self;
}

-(void)createNavBarItem{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"详细资料";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 20, 24);
    [btn setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBack1) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
    
    
//    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 5)];
//    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"arrow-fx"] forState:UIControlStateNormal];
//    [self.rightBtn addTarget:self action:@selector(goRight) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
//    self.navigationItem.rightBarButtonItem = right;

}

-(void)createTableView{
    
    self.messageDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.messageDetailTableView.delegate = self;
    self.messageDetailTableView.dataSource = self;
    
    self.messageDetailTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:self.messageDetailTableView];

}

-(void)createView{

    self.dataArray = [[NSMutableArray alloc]init];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark --详细资料
-(void)loadDetaleData{
    
    self.detailModel = [[messDetailModel alloc]init];
    __weak typeof(self) weakSelf = self;
    
    DDLog(@"%@",self.target_uid);
    //请求参数
    NSDictionary *param = @{@"userId":userID,@"target_uid":self.target_uid,@"status":@"0"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:isFriendURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        _status = [dict[@"status"]intValue];
        _os = [dict[@"os"]intValue];
        _count = [dict[@"count"]intValue];
        DDLog(@"%d",_count);
        DDLog(@"%d",_os);
        
        if (_status == 0) {
            NSDictionary *menuList = dict[@"menuList"];
            
            [weakSelf.detailModel yy_modelSetWithDictionary:menuList];
            [weakSelf.dataArray addObject:weakSelf.detailModel];
            
            DDLog(@"%@",weakSelf.dataArray);
            
//          addressStr = _detailModel.address;
            personStr = _detailModel.sdasd;
            
            target_uid = _detailModel.id;
            if (_detailModel.remarkName == nil) {
                userStr = _detailModel.nickName;
            }else{
            
                userStr = _detailModel.remarkName;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.messageDetailTableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.netStatus1 = NO;
    }];
    
    DDLog(@"%@",_dataArray);
}

- (void)goRight{

    messageSettingController *message =[[messageSettingController alloc]init];
    message.userName = userStr;
    message.taget_uid = target_uid;
    [self.navigationController pushViewController:message animated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:managerCellId];
    
        if (!cell) {
            cell =[[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:managerCellId];
        }
    NSString *atcleCount = [NSString stringWithFormat:@"%d",_count];

    if (indexPath.row == 0) {
        
        NSString *sexStr = [NSString stringWithFormat:@"%@",_detailModel.sex];
        if ([sexStr isEqualToString: @"1"]) {
            
            addressStr = @"女";
        }else {
            
            addressStr = @"男";
        }
        
        [cell setCellInfowithTitle:@"性别" withSubTitle:addressStr withArrow:NO];
    }else if (indexPath.row == 1){
    
        [cell setCellInfowithTitle:@"发表文章" withSubTitle:atcleCount withArrow:YES];
    }else if(indexPath.row == 2){
    
        [cell setCellInfowithTitle:@"个性签名" withSubTitle:personStr withArrow:NO];
    }
        return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.headView = headView;
    self.headView.backgroundColor = [UIColor whiteColor];
    
    self.vepeView = [[UIView alloc]init];
    self.vepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.headView addSubview:self.vepeView];
    
    self.imgView = [[UIImageView alloc]init];
    self.imgView.layer.cornerRadius = 22.5;
    self.imgView.layer.masksToBounds = YES;
    [self.headView addSubview:self.imgView];
    
    self.titleLable = [[UILabel alloc]init];
    self.titleLable.font = [UIFont systemFontOfSize:17];
    [self.headView addSubview:self.titleLable];
    
    self.sexView = [[UIImageView alloc]init];
    self.sexView.image =[UIImage imageNamed:@"ride_snap_default"];
    [self.headView addSubview:self.sexView];
    
    self.nickLable = [[UILabel alloc]init];
    self.nickLable.textColor = [UIColor lightGrayColor];
    self.nickLable.font = [UIFont systemFontOfSize:12];
    
    self.beizhuBtn = [[UIButton alloc]init];
    self.nameLable = [[UILabel alloc]init];
    
    self.nameLable.text = [NSString stringWithFormat:@"ID:%@",_detailModel.id];
    self.nameLable.textColor = [UIColor lightGrayColor];
    self.nameLable.font = [UIFont systemFontOfSize:12];
    
    [self.headView addSubview:self.nickLable];
    [self.headView addSubview:self.beizhuBtn];
    [self.headView addSubview:self.nameLable];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_detailModel.faceImg]placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    
    if ([ETRegularUtil isEmptyString:target_uid]) {
        
        self.nickLable.text = [NSString stringWithFormat:@"%@",target_uid];
    }else{
    
        self.nickLable.text = [NSString stringWithFormat:@"%@",@""];
    }
    
    NSString *sexStr = [NSString stringWithFormat:@"%@",_detailModel.sex];
    if ([sexStr isEqualToString: @"1"]) {
        
        self.sexView.image = [UIImage imageNamed:@"girl"];
    }else {
        
        self.sexView.image = [UIImage imageNamed:@"boy"];
    }
    
    targetStr = [NSString stringWithFormat:@"%@",self.target_uid];
    NSString *userStr = [NSString stringWithFormat:@"%@",userID];
    
    DDLog(@"%@",targetStr);
    DDLog(@"%@",userStr);
    if (_os == 1) {
    
        if ([userStr isEqualToString:targetStr]) {
            
//          self.nickLable.text = _detailModel.nickName;
            self.beizhuBtn.hidden = YES;
//          [self.footBtn setTitle:@"发消息" forState:UIControlStateNormal];
            self.footBtn.hidden = YES;
            if ([ETRegularUtil isEmptyString:_detailModel.remarkName]) {
                
                self.titleLable.text = _detailModel.nickName;
            }else{
                
                self.titleLable.text = _detailModel.remarkName;
            }
        }else{
        
            self.titleLable.text = _detailModel.nickName;
//            self.nickLable.hidden = YES;//昵称
//            self.nameLable.hidden = YES;
            self.footBtn.hidden = YES;
//          [self.footBtn setTitle:@"添加好友" forState:UIControlStateNormal];
            self.beizhuBtn.hidden = YES;
            self.rightBtn.hidden = YES;
        }
        
    }else{
        
//        self.nickLable.text = _detailModel.nickName;
//      [self.footBtn setTitle:@"发消息" forState:UIControlStateNormal];
        self.footBtn.hidden = YES;
        if ([ETRegularUtil isEmptyString:_detailModel.remarkName]) {
            
            self.titleLable.text = _detailModel.nickName;
        }else{
            
            self.titleLable.text = _detailModel.remarkName;
        }
    }
    
    NSString *user = [NSString stringWithFormat:@"%@",userID];
    NSString *uidStr = [NSString stringWithFormat:@"%@",self.target_uid];
    if ([user isEqualToString:uidStr]) {
        
//        self.nickLable.text = _detailModel.nickName;
//        if (!self.detailModel.remarkName) {
        
//            self.titleLable.text = _detailModel.nickName;
//        }else{
        
//            self.titleLable.text = _detailModel.remarkName;
//        }
        
        self.footBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.beizhuBtn.hidden = YES;
    }
    
    [self layoutUI1];
    return self.headView;
}

-(void)xiuGaiClick{

    
    beiZhuController *beiZhuVC =[[beiZhuController alloc]init];
    beiZhuVC.from_uid = target_uid;
    [self.navigationController pushViewController:beiZhuVC animated:NO];
}

- (void)layoutUI1{
    __weak typeof(self)weakSelf = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView).offset(10);
        make.left.equalTo(weakSelf.headView).offset(10);
        make.width.height.mas_equalTo(45);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView).offset(10);
        make.left.equalTo(weakSelf.imgView.mas_right).offset(10);
        make.right.equalTo(weakSelf.sexView.mas_left).offset(-10);
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLable.mas_top);
        make.left.equalTo(weakSelf.titleLable.mas_right).offset(10);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.beizhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLable.mas_top);
        make.right.equalTo(weakSelf.headView).offset(-15);
        make.width.mas_greaterThanOrEqualTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sexView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.imgView.mas_right).offset(10);
         make.width.mas_equalTo(80);
    }];
    
    [self.nickLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLable.mas_top);
        make.right.equalTo(weakSelf.headView).offset(-10);
        make.left.equalTo(weakSelf.nameLable.mas_right).offset(-5);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self.vepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.bottom.equalTo(weakSelf.headView);
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 60)];
    [footView setBackgroundColor:[UIColor colorWithHexString:@"#f2f2f2"]];
    
    self.footBtn =[[UIButton alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
    self.footBtn.layer.cornerRadius = 15;
    if (_os == 1) {
     
        NSString *userStr = [NSString stringWithFormat:@"%@",userID];
        if ([userStr isEqualToString:targetStr]){
        
            self.footBtn.hidden = YES;
//        [self.footBtn setTitle:@"发消息" forState:UIControlStateNormal];
//        [self.footBtn addTarget:self action:@selector(sendChat) forControlEvents:UIControlEventTouchUpInside];
          }else{
        
            self.footBtn.hidden = YES;
//        [self.footBtn setTitle:@"添加好友" forState:UIControlStateNormal];
//        [self.footBtn addTarget:self action:@selector(addfirend) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        self.footBtn.hidden = YES;
//        [self.footBtn setTitle:@"发消息" forState:UIControlStateNormal];
//        [self.footBtn addTarget:self action:@selector(sendChat) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSString *user = [NSString stringWithFormat:@"%@",userID];
    NSString *uidStr = [NSString stringWithFormat:@"%@",self.target_uid];
    if ([user isEqualToString:uidStr]) {
        
        self.footBtn.hidden = YES;
    }
    
    self.footBtn.backgroundColor = [UIColor colorWithRed:0.164 green:0.657 blue:0.915 alpha:1.000];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [footView addSubview:self.footBtn];
    
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        
        if (self.netStatus1 == YES) {
           
            personController *personVC = [[personController alloc]init];
            personVC.artCount = [NSString stringWithFormat:@"%d",_count];
            personVC.target_uid = self.target_uid;
            personVC.titleStr = self.titleLable.text;
            [self.navigationController pushViewController:personVC animated:NO];
        }else{
        
            [self showHint:@"网络不佳，请稍后尝试"];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 80.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 50;
}

-(void)goBack1{
    
   [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendChat{

//    chatController *chat = [[chatController alloc]init];
//    chat.titleName = self.titleLable.text;
//    [self.navigationController pushViewController:chat animated:NO];
}

-(void)addfirend{

    verifiFriendController *vertify = [[verifiFriendController alloc]init];
    vertify.from_uid = self.target_uid;
    [self.navigationController pushViewController:vertify animated:NO];
    
//    CommonAlert *alert = [[CommonAlert alloc] initWithBtnTitles:@[@"取消",@"确认"]];
//    alert.textField.layer.borderWidth = 0;
//    alert.textField.delegate = self;
//    alert.line.hidden = NO;
//    alert.delegate = self;
//    [alert.textField becomeFirstResponder];
//    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
}

#pragma mark -- 加好友
-(void)loadFriendData{

    __weak typeof(self) weakSelf = self;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.target_uid forKey:@"from_uid"];
    
    //请求参数
    NSDictionary *param = @{@"userId":userID,@"target_uid":self.target_uid};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:addFriendURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        _status = [dict[@"status"]intValue];
        if (_status == 0) {
            
            DDLog(@"%@",@"成功");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DDLog(@"%@",self.target_uid);
            addfriendController *add = [[addfriendController alloc]init];
            add.target_uid = self.target_uid;
            [self.navigationController pushViewController:add animated:NO];
            [weakSelf.messageDetailTableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 添加好友
- (void)itemCertain:(CommonAlert *)alert{
    
    self.reasonStr = alert.textField.text;
    DDLog(@"%@",self.reasonStr);
    [self loadFriendData];
    
//    DDLog(@"%@",self.target_uid);
//    NSString *targetStr = [NSString stringWithFormat:@"%@",self.target_uid];
//    [[EMClient sharedClient].contactManager addContact:targetStr
//                                               message:@"我想加您为好友"
//                                            completion:^(NSString *aUsername, EMError *aError) {
//                                                if (!aError) {
//                                                    NSLog(@"邀请发送成功");
//                                                }
//                                            }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    if (textField.text.length >= 15 && ![string isEqualToString:@""]){
        return NO;
    }
    return YES;
}

@end
