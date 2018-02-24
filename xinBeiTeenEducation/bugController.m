//
//  bugController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "bugController.h"
#import "issueController.h"
#import "bugHeadCell.h"
#import "bugCell.h"
#import "bugListModel.h"
#import "settingController.h"
#import "bugCommentModel.h"
#import "ETMessageView.h"

static CGFloat textFieldH = 40;
@interface bugController ()<UITableViewDelegate,UITableViewDataSource,bugCellDelegate,UITextFieldDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
     CGFloat _totalKeybordHeight;
    
}
@property (nonatomic,strong) UITableView *tabelView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UILabel *issueLb;
@property (nonatomic,strong) bugCell *bugcell;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITextField *commTextField;
@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;

@end

@implementation bugController
static NSString *userId;
static NSString *bugStatus;
static NSString *bugIdStr;
static NSString *tokenStr;
static NSString *roleStr;//管理员

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNav];

    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    DDLog(@"%@",userId);
    
    self.netStatus1 = YES;
    [self createHttpRequest];

    [self loadManagerData];
    
    [self createView];
    [self.tabelView registerClass:[bugHeadCell class] forCellReuseIdentifier:@"bugHeadCell"];
    [self.tabelView registerClass:[bugCell class] forCellReuseIdentifier:@"bugCell"];
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)noNetStatus{

    self.netStatus1 = NO;
    [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
}

-(void)netStatus{

    self.netStatus1 = YES;
}

-(void)netStatuswifi{
    
    self.netStatus1 = YES;
}

-(void)dealloc{

    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_commTextField resignFirstResponder];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createNav{
    
    _dataArray = [[NSMutableArray alloc]init];
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = @"用户反馈";
    lable1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable1.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable1;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 , 10, 20, 19)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"appear"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick1) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)createView{

    _tabelView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.sectionHeaderHeight = 0.1f;
    _tabelView.sectionFooterHeight = 10.f;
    [self.view addSubview:_tabelView];
}

#pragma mark -- 管理员
-(void)loadManagerData{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];
    
    //请求参数
    NSDictionary *param = @{@"userId":userId,@"token":tokenStr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:mineURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        int status = [dict[@"status"]intValue];
        NSDictionary *menuDict = dict[@"menuList"];
        
        if (status == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                roleStr = menuDict[@"role"];
                NSString *str = [NSString stringWithFormat:@"%@",roleStr];
                
                DDLog(@"%@",str);
                if ([str isEqualToString:@"1"]) {
                    
                   [self loadUserMessageData];
                }else{
                    
                   [self loadAllMessageData];
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 查看当前的用户反馈
-(void)loadUserMessageData{

    DDLog(@"%@",userId);
    NSString *userStr = [NSString stringWithFormat:@"%@",userId];
    NSDictionary *param = @{@"userId":userStr};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:bugListURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);

        NSArray *result = dict[@"results"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            [self.dataArray removeAllObjects];
            for ( NSDictionary *appDict in result) {
                
                bugListModel *model = [[bugListModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                
                NSString *str = model.parent_cid;
                NSString *parentStr = [NSString stringWithFormat:@"%@",str];
                for (NSDictionary *mDict in model.imgs) {
                    
                    bugCommentModel *mdoel = [[bugCommentModel alloc]init];
                    [mdoel yy_modelSetWithDictionary:mDict];
                }
                if ([parentStr isEqualToString:@"0"]) {
                    
                    [self.dataArray addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.bugcell.tableView reloadData];
                [self.tabelView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 查看所有反馈
-(void)loadAllMessageData{
    
    DDLog(@"%@",userId);
    NSString *userStr = [NSString stringWithFormat:@"%@",userId];
    NSDictionary *param = @{@"userId":userStr};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:bugAllListURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSArray *result = dict[@"results"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            [self.dataArray removeAllObjects];
            for ( NSDictionary *appDict in result) {
                
                bugListModel *model = [[bugListModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                
                NSString *str = model.parent_cid;
                NSString *parentStr = [NSString stringWithFormat:@"%@",str];
                for (NSDictionary *mDict in model.imgs) {
                    
                    bugCommentModel *mdoel = [[bugCommentModel alloc]init];
                    [mdoel yy_modelSetWithDictionary:mDict];
                }
                if ([parentStr isEqualToString:@"0"]) {
                    
                    [self.dataArray addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.bugcell.tableView reloadData];
                [self.tabelView reloadData];
            });
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)onDeleteInCell:(bugCell *)cell{

    bugListModel *model = self.dataArray[cell.indexpath.section];
    bugIdStr = [NSString stringWithFormat:@"%@",model.bugId];
    NSString *userStr = [NSString stringWithFormat:@"%@",userId];
    
    if (self.netStatus1 == YES) {
    
        NSString *str = [NSString stringWithFormat:@"%@",roleStr];
        if ([str isEqualToString:@"2"]) {
            
            [self.commTextField resignFirstResponder];
            [self setUpTextField];
        }else{
            
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"是否删除此订单"message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                [self.dataArray removeObjectAtIndex:cell.indexpath.section];
                [self.tabelView deselectRowAtIndexPath:cell.indexpath animated:NO];
                NSDictionary *param = @{@"userId":userStr,@"bugId":bugIdStr};
                [self loadDeleteDataWithParam:param];
            }];
            
            [alertControl addAction:action];
            [alertControl addAction:action1];
            [self presentViewController:alertControl animated:YES completion:nil];
            
        }
        
    }else{
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

#pragma mark -- 删除
- (void)loadDeleteDataWithParam:(NSDictionary*)param{

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:bugDeleteURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tabelView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        self.bugcell = [tableView dequeueReusableCellWithIdentifier:@"bugCell"];
        if (!self.bugcell) {
            
            self.bugcell = [[bugCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bugCell"];
        }

        bugListModel *model = self.dataArray[indexPath.section];
        self.bugcell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bugcell.delegate = self;
        self.bugcell.indexpath = indexPath;
    
      NSString *str = [NSString stringWithFormat:@"%@",roleStr];
      if ([str isEqualToString:@"2"]) {
        
        [self.bugcell.deleteBtn setTitle:@"评论" forState:UIControlStateNormal];
      }
    
        [self.bugcell configCellWithModel:model indexPath:indexPath];
        return self.bugcell;
}

//-(void)issueBtnInCell:(bugHeadCell *)cell{
//
//    issueController *issue = [[issueController alloc]init];
//    [self.navigationController pushViewController:issue animated:YES];
//}

//-(void)onCommentInCell:(bugCell *)cell indexPath:(NSIndexPath *)indexPath{
//
//    [self.commTextField resignFirstResponder];
//    [self setUpTextField];
//}

//-(void)selectBugId:(NSString *)bugId selectBugStatus:(NSString *)status{
//
//    [self.commTextField resignFirstResponder];
//    bugStatus = status;
//    bugIdStr = bugId;
//    [self setUpTextField];
//}

- (void)setUpTextField{
    
    self.commTextField = [[UITextField alloc]init];
    self.commTextField.returnKeyType = UIReturnKeyDone;
    
    self.commTextField.delegate = self;
    self.commTextField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    self.commTextField.layer.borderWidth = 1;
    self.commTextField.backgroundColor = [UIColor whiteColor];
    self.commTextField.frame = CGRectMake(0, SCREEN_HEIGHT, self.view.width, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:self.commTextField];
    
    [self.commTextField becomeFirstResponder];
    
    self.commTextField.placeholder = @"管理员回复";
    [self.tabelView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
      
        [self.commTextField resignFirstResponder];
        NSString *textStr = [NSString stringWithFormat:@"%@",textField.text];
        NSDictionary *params = @{@"userId":userId,@"content":textStr,@"bugId":bugIdStr};
        [self loadTextViewDataWithParam:params];
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.commTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.commTextField resignFirstResponder];
}

//- (void)dealloc
//{
//    // 移除通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//

#pragma mark -- 键盘
- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.commTextField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tabelView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tabelView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tabelView setContentOffset:offset animated:YES];
}


-(void)loadTextViewDataWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    
    [_manager POST:bugtextURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            DDLog(@"成功");
            
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self loadAllMessageData];
            
           });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    self.bugcell = [[bugCell alloc]init];
    bugListModel *model = self.dataArray[indexPath.section];
    CGFloat cellHeight = [self.bugcell cellHeight:model indexPath:indexPath];
    return cellHeight;
}

-(void)presentToBack{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)rightBtnClick1{

    if (self.netStatus1 == YES) {
        
        issueController *issue = [[issueController alloc]init];
        [self.navigationController pushViewController:issue animated:NO];
    }else{
    
    [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

-(void)refresh{

    __weak __typeof(self) weakSelf = self;
    self.tabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadUserMessageData];
        [weakSelf.tabelView.mj_header beginRefreshing];
    }];
}

@end
