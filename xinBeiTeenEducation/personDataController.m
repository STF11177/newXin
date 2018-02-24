//
//  personDataController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/13.
//  Copyright © 2017年 user. All rights reserved.

#import "personDataController.h"
#import "personDataCell.h"
#import "nickController.h"
#import "phoneController.h"
#import "sexController.h"
#import "personSignatureController.h"
#import "faceImgController.h"
#import "mineViewController.h"
#import "loginMessageController.h"
#import "personDataOtherCell.h"

@interface personDataController ()<UITableViewDelegate,UITableViewDataSource>
{

    AFHTTPRequestOperationManager *_manager;

}
@end

@implementation personDataController
static NSString *nickStr;
static NSString *phoneStr;
static NSString *sexStr;
static NSString *signatureStr;
static NSString *faceImg;
static NSString *userId;
static NSString *UUId;
static NSString *tokenStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createTableView];
    [self createHttp];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];
    
    NSDictionary *param = @{@"userId":userId,@"token":tokenStr};
    DDLog(@"userId:%@",userId);
    [self loadDatawithParam:param];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"个人资料";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadDatawithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:mineURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        int tokenStuts = [dict[@"tokenStatus"]intValue];
        if (status == 0) {
            
            
            NSDictionary *menuList = dict[@"menuList"];
            
            if (![menuList[@"nickName"] isKindOfClass:[NSNull class]]) {
                
                 nickStr = menuList[@"nickName"];
            }
            
            if (![menuList[@"userName"] isKindOfClass:[NSNull class]]) {
                
               phoneStr = [NSString stringWithFormat:@"%@",menuList[@"userName"]];
            }
            if (![menuList[@"faceImg"] isKindOfClass:[NSNull class]]) {
                
               faceImg = menuList[@"faceImg"];
            }
            if (![menuList[@"sdasd"] isKindOfClass:[NSNull class]]) {
                
                signatureStr = menuList[@"sdasd"];
            }
            if (![menuList[@"sex"] isKindOfClass:[NSNull class]]) {
                
                sexStr = menuList[@"sex"];
            }
            if (![menuList[@"userAccount"] isKindOfClass:[NSNull class]]) {
                
                UUId = menuList[@"userAccount"];
                DDLog(@"%@",UUId);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if (tokenStuts == 2) {
                    
                    self.hidesBottomBarWhenPushed=YES;
                    loginMessageController *login = [[loginMessageController alloc]init];
                    login.loginStatus = @"1";
                    [self presentViewController:login animated:NO completion:^{
                        
                    }];
                }
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        personDataCell *cell =[tableView dequeueReusableCellWithIdentifier:@"headCell"];
        if (!cell) {
            cell =[[personDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCell"];
        }
            if (![faceImg isKindOfClass:[NSNull class]]) {
                
                [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:faceImg] placeholderImage:[UIImage imageNamed:@"moren_imgs"]];
            }
            cell.titleLb.text = @"头像";
            
               return cell;
    }else{
        personDataOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personDataOtherCell"];
        if (!cell) {
            
            cell = [[personDataOtherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personDataOtherCell"];
        }
    
        if(indexPath.row == 4){
            
            cell.titleLb.text = @"昵称";
            if (![nickStr isKindOfClass:[NSNull class]]) {
                
                cell.headLb.text = nickStr;
            }
            
        }else if(indexPath.row == 2){
            
            cell.titleLb.text =@"电话";
            if (![phoneStr isKindOfClass:[NSNull class]]&&![ETRegularUtil isEmptyString:phoneStr]) {
                
                cell.headLb.text = [NSString stringWithFormat:@"%@",phoneStr];
            }else{
                
                cell.headLb.text = [NSString stringWithFormat:@"%@",@""];
            }
        }else if(indexPath.row == 3){
            
            cell.titleLb.text = @"性别";
            if (![sexStr isKindOfClass:[NSNull class]]&&![ETRegularUtil isEmptyString:phoneStr]) {
                
                NSString *sex = [NSString stringWithFormat:@"%@",sexStr];
                if ([sex isEqualToString:@"0"]) {
                    
                    cell.headLb.text = @"男";
                }else{
                    
                    cell.headLb.text = @"女";
                }
            }else{
                
                cell.headLb.text = [NSString stringWithFormat:@"%@",@""];
            }
        }else if(indexPath.row == 1){
            
            cell.titleLb.text = @"ID";
            if ([ETRegularUtil isEmptyString:UUId]) {
                
                cell.headLb.text = [NSString stringWithFormat:@"%@",@""];
            }else{
                
                cell.headLb.text = [NSString stringWithFormat:@"%@",UUId];
            }
            cell.arrowImg.hidden = YES;
        }else {
            
            cell.titleLb.text = @"个性签名";
            if (![phoneStr isKindOfClass:[NSNull class]]) {
                
                cell.headLb.text = signatureStr;
            }
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        faceImgController *faceVC =[[faceImgController alloc]init];
        faceVC.imageStr = faceImg;
        faceVC.fromWhere = @"1001";
        [self.navigationController pushViewController:faceVC animated:YES];
    }
   else if (indexPath.row == 4) {
       
        nickController *nick = [[nickController alloc]init];
        nick.nickStr = nickStr;
        [self.navigationController pushViewController:nick animated:YES];
    }else if(indexPath.row == 2){
    
        phoneController *phoneVC = [[phoneController alloc]init];
        phoneVC.phoneStr = phoneStr;
        [self.navigationController pushViewController:phoneVC animated:YES];
    }else if (indexPath.row == 3){
    
        sexController *sexVC = [[sexController alloc]init];
        sexVC.sexStr = sexStr;
        [self.navigationController pushViewController:sexVC animated:YES];
    }else if(indexPath.row == 5){
    
        personSignatureController *signature = [[personSignatureController alloc]init];
        signature.signatureStr = signatureStr;
        [self.navigationController pushViewController:signature animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        return 88;
    }else{
    
        
        return 44;
    }
}

#pragma mark -- 判断是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL||[string isEqualToString:@""]||!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)presentBack{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
