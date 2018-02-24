//
//  orderWillPayController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import "orderWillPayController.h"
#import "payUserCell.h"
#import "payDetailCell.h"
#import "cashCell.h"
#import "payPriceCell.h"
#import "payToolCell.h"
#import "payFootView.h"
#import "CommonAlert.h"
#import "GetIP.h"
#import "WXApi.h"
#import "mySonModel.h"
#import "testTypeAlert.h"
#import "ETRegularUtil.h"
#import "headImageCell.h"
#import "payBookCell.h"

@interface orderWillPayController ()<UITableViewDelegate,UITableViewDataSource,payFootViewDelete>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) payFootView *footView;
@property (nonatomic,strong) headImageCell *headCell;

@end

@implementation orderWillPayController
static NSString *nameStr;
static NSString *phoneStr;
static NSString *titleStr;//题目
static NSString *levelStr;//考证类型
static NSString *priceStr;//价格
static NSString *personStr;//已有多少人报名
static NSString *orderId;
static NSString *typeId;
static NSString *examTime;
static NSString *address;

static NSString *sendBookName;//送的书名字
static NSString *sendBookImg;//送的书封面
static NSString *sendBookPrice;//送的书的价格
static NSString *expressPrice;//快递费
static float sumPriceStr;//总价
static NSString *addressStrId;
static NSString *payAddress;//快递费

static NSTimeInterval overTime;//课程结束时间

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createHttpRequest];
    [self loadWillPayData];
    [self createTableView];
    [self createFootView];
    
    [self.tableView registerClass:[payUserCell class] forCellReuseIdentifier:@"payUserCell"];
    [self.tableView registerClass:[payDetailCell class] forCellReuseIdentifier:@"payDetailCell"];
    [self.tableView registerClass:[cashCell class] forCellReuseIdentifier:@"cashCell"];
    [self.tableView registerClass:[payPriceCell class] forCellReuseIdentifier:@"payPriceCell"];
    [self.tableView registerClass:[payToolCell class] forCellReuseIdentifier:@"payToolCell"];
    [self.tableView registerClass:[payBookCell class] forCellReuseIdentifier:@"payBookCell"];
}

-(void)createNav{
    
    self.dataArray = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"付款";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    if (iOS11) {
        
        self.tableView.sectionFooterHeight = 20.f;
    }
    [self.view addSubview:self.tableView];
}
-(void)createFootView{
    
    self.footView = [[payFootView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    self.footView.delegate = self;
    sumPriceStr = [sendBookPrice floatValue] + [priceStr floatValue] + [expressPrice floatValue];
    NSString *priceStr = [NSString stringWithFormat:@"%0.2lf",sumPriceStr];
    self.footView.priceLb.text = [NSString stringWithFormat:@"需支付：¥%@",priceStr];
    NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.footView.priceLb.text];
    [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(4, self.footView.priceLb.text.length - 4)];
    [centStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(4, self.footView.priceLb.text.length - 4)];
    self.footView.priceLb.attributedText = centStr;
    [self.view addSubview:self.footView];
}


-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 || section == 3) {
        
        return 1;
    }else if(section ==1){
        
        return 4;
    }else if (section ==2){
        
        return 3;
    }else{
        
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    [self.view addSubview:view];
    
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        payUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payUserCell"];
        if (!cell) {
            cell = [[payUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payUserCell"];
        }

        cell.nameLb.text = [NSString stringWithFormat:@"%@",nameStr];
        cell.phoneLb.text = [NSString stringWithFormat:@"%@",phoneStr];
        cell.arrowImage.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section ==4){
        
        payToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payToolCell"];
        if (!cell) {
            
            cell = [[payToolCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payToolCell"];
        }
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"支付方式";
            cell.toolImageView.hidden = YES;
        }else{
            
            cell.titleLb.text = @"微信支付";
            cell.contentLb.text = @"推荐安装微信5.0及以上版本";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            self.headCell = [tableView dequeueReusableCellWithIdentifier:@"headImageCell"];
            if (!self.headCell) {
                
                self.headCell = [[headImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headImageCell"];
            }
            
            self.headCell.headLb.text = titleStr;
            [self.headCell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.pictureImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
            self.headCell.arrowImage.hidden = YES;
            self.headCell.priceLb.text = [NSString stringWithFormat:@"¥%@",priceStr];
           
            self.headCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.headCell;
        }else{
            payDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payDetailCell"];
            if (!cell) {
                
                cell = [[payDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payDetailCell"];
            }
            if(indexPath.row == 1){
                
                cell.headLb.text = @"考试级别";
                cell.contentLb.text = levelStr;
            }else if(indexPath.row ==2){
                
                cell.headLb.text = @"考试时间";
                cell.contentLb.text = examTime;
            }else{
                
                cell.headLb.text = @"考试地点";
                cell.contentLb.text = address;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(indexPath.section ==2){
        
        if (indexPath.row == 0) {
            
            payBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payBookCell"];
            if (!cell) {
                
                cell = [[payBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payBookCell"];
            }
            
            cell.headLb.text = sendBookName;
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:sendBookImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
            cell.priceLb.text = [NSString stringWithFormat:@"¥%@",sendBookPrice];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if(indexPath.row ==1){
            
            payDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payDetailCell"];
            if (!cell) {
                
                cell = [[payDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payDetailCell"];
            }
            cell.headLb.text = @"配送方式";
            cell.contentLb.text = [NSString stringWithFormat:@"快递费用%@元",expressPrice];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            payUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payUserCell"];
            if (!cell) {
                cell = [[payUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payUserCell"];
            }
            
            cell.titleLb.text = @"收货地址";
            cell.phoneLb.text = payAddress;
            cell.arrowImage.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        sumPriceStr = [sendBookPrice floatValue] + [priceStr floatValue] + [expressPrice floatValue];
        cell.textLabel.text = [NSString stringWithFormat:@"商品共 ¥%0.2lf",sumPriceStr];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        return cell;
    }
}

-(void)payFootView{
    
    if ([ETRegularUtil isEmptyString:nameStr]) {
        [self showAlertWithMessage:@"请选择考生的相关信息"];
        if (overTime >0){
            
            [self showAlert:@"此报名已结束" withBtnTitles:@[@"知道了"]];
        }
    }else if([ETRegularUtil isEmptyString:addressStrId]){
        
        [self showAlertWithMessage:@"地址无效，请填写收货地址，并重新下订单"];
    }else{
    
         [self loadPayData];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0.1f;
    }else{
        
        return 20;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            
            return 44;
        }else{
            
            return 70;
        }
    }else if(indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            return [self cellHeight];
        }else{
            
            return 44;
        }
    }else if(indexPath.section ==2){
        
        if (indexPath.row ==0) {
            
            return [self cellHeight1];
        }else{
            
            return 44;
        }
    }else{
        
        return 44;
    }
}

-(CGFloat)cellHeight{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    /** 行高 */
    paraStyle.lineSpacing = 0;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paraStyle};
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 50 -15 - 5 - 5 - 15 - 8, CGFLOAT_MAX);
    
    CGSize size = [titleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    if (size.height>21) {
        
        [self.headCell.headLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.headCell).offset(20);
            make.left.equalTo(self.headCell.headImageView.mas_right).offset(5);
            make.right.equalTo(self.headCell.arrowImage.mas_left).offset(-5);
        }];
    }
    float headHeight = size.height +15 +15 +30;
    return headHeight;
}

-(CGFloat)cellHeight1{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    /** 行高 */
    paraStyle.lineSpacing = 0;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paraStyle};
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 50 -15 - 5 - 5 - 15 - 8, CGFLOAT_MAX);
    
    CGSize size = [sendBookName boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    if (size.height>21) {
        
        [self.headCell.headLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.headCell).offset(20);
            make.left.equalTo(self.headCell.headImageView.mas_right).offset(5);
            make.right.equalTo(self.headCell.arrowImage.mas_left).offset(-5);
        }];
    }
    float headHeight = size.height +15 +15 +30;
    return headHeight;
}

#pragma mark -- 待支付
-(void)loadWillPayData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    
    NSDictionary *param = @{@"userId":userId,@"orderId":self.orderId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:orderWillPayURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            NSDictionary *menuList = dict[@"menuList"];
            NSDictionary *results = dict[@"results"];
            NSDictionary *userAdress = dict[@"UserAddressList"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                nameStr = menuList[@"examinee_name"];
                phoneStr = menuList[@"phone"];
                titleStr = menuList[@"title"];
                levelStr = menuList[@"type_name"];
                priceStr = menuList[@"money"];
                personStr = menuList[@"apply_count"];
                orderId = menuList[@"orderId"];
                typeId = menuList[@"typeId"];
                examTime = menuList[@"subject_date"];
                address = menuList[@"address"];
                
                sendBookName = results[@"bookName"];
                sendBookImg = results[@"iconImg"];
                sendBookPrice = results[@"price"];
                expressPrice = results[@"expressFee"];
                
                addressStrId = userAdress[@"id"];
                payAddress = userAdress[@"address"];
                
                DDLog(@"%@",addressStrId);
                // ------实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYY-MM-dd"];//这里的格式必须和DateString格式一致
                // ------将需要转换的时间转换成 NSDate 对象
                NSDate * nowDate = [NSDate date];
                //    NSDate *beginDate = [dateFormatter dateFromString:menuList[@"biginDate"]];
                NSDate *endDate = [dateFormatter dateFromString:menuList[@"endDate"]];
                
                // ------取当前时间和转换时间两个日期对象的时间间隔
                //    NSTimeInterval time = [nowDate timeIntervalSinceDate:beginDate];
                overTime = [nowDate timeIntervalSinceDate:endDate];
                DDLog(@"%f",overTime);
                
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = @"1480432402";
                request.prepayId= dict[@"prepayid"];
                request.package = @"Sign=WXPay";
                request.nonceStr = dict[@"noncestr"];
                request.timeStamp = [dict[@"timeStamp"]intValue];
                request.sign = dict[@"sign"];
                
                 [WXApi sendReq:request];
                
                 [self createFootView];
                 [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 支付
-(void)loadPayData{
    
    DDLog(@"%@",nameStr);
    DDLog(@"%@",phoneStr);
    DDLog(@"%@",typeId);
    DDLog(@"%@",addressStrId);
    DDLog(@"%@",orderId);
    
    DDLog(@"%@",priceStr);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    
    [GetIP getCurrentDeviceModel];
    [GetIP getIPAddress];
    
    DDLog(@"%@",[GetIP getCurrentDeviceModel]);
    DDLog(@"%@",[GetIP getIPAddress]);
    __weak typeof(self) weakSelf = self;

    NSString *priceStr = [NSString stringWithFormat:@"%lf",sumPriceStr];
    NSDictionary *param = @{@"userId":userId,@"money":priceStr,@"subjectId":@"",@"typeId":typeId,@"babyName":nameStr,@"phone":phoneStr,@"spbill_create_ip":[GetIP getIPAddress],@"orderId":orderId,@"addressId":addressStrId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:payURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            //
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = @"1480432402";
                request.prepayId= dict[@"prepayid"];
                request.package = @"Sign=WXPay";
                request.nonceStr = dict[@"noncestr"];
                request.timeStamp = [dict[@"timeStamp"]intValue];
                request.sign = dict[@"sign"];
                
                [WXApi sendReq:request];
                [weakSelf.tableView reloadData];
            });
        }else{
        
            [self showAlertWithMessage:@"此项目已经售完，请选择其他的项目"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



-(void)presentLeftMenuViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
