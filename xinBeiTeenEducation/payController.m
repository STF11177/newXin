//
//  payController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payController.h"
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
#import "studentController.h"
#import "detailController.h"
#import "childDataController.h"
#import "orderController.h"
#import "headImageCell.h"
#import "payBookCell.h"
#import "payAddressController.h"
#import "checkAddressModel.h"
#import "addnewAdressController.h"
#import "addressController.h"
#import "mySonController.h"

@interface payController ()<UITableViewDelegate,UITableViewDataSource,payFootViewDelete>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) NSMutableArray *phoneArray;
@property (nonatomic,strong) NSMutableArray *checkAdressArray;
@property (nonatomic,strong) payFootView *footView;
@property (nonatomic,assign) float headHeight;
@property (nonatomic,strong) headImageCell *headCell;
@property (nonatomic,strong) NSMutableArray *addressArray;

@end

@implementation payController
static NSString *userId;
static NSString *nameStr;
static NSString *phoneStr;
static NSString *titleStr;
static NSString *levelStr;
static NSString *priceStr;
static NSString *personStr;
static NSString *orderId;
//static NSString *subriId;
static NSString *typeId;
static NSString *examTime;
static NSString *address;
static NSString *pictureImg;
static NSString *subjectId;

static NSString *sendBookName;//送的书名字
static NSString *sendBookImg;//送的书封面
static NSString *sendBookPrice;//送的书的价格
static NSString *expressPrice;//快递费
static float sumPriceStr;//总价
static NSString *firstNameStr;//第一次的姓名
static NSString *firstPhoneStr;//第一次的号码
static NSString *addressStrId;//地址ID
static NSString *payAddress;//收货地址
static NSString *checkAddress;//第一次的地址
static NSString *checkAddressId;//第一次的地址ID

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self createNav];
    [self createTableView];
   
    [self createHttpRequest];
    [self loadNameData];
    [self loadWillPayData];
    self.fd_interactivePopDisabled = YES;
    
    [self.tableView registerClass:[payUserCell class] forCellReuseIdentifier:@"payUserCell"];
    [self.tableView registerClass:[payDetailCell class] forCellReuseIdentifier:@"payDetailCell"];
    [self.tableView registerClass:[payToolCell class] forCellReuseIdentifier:@"payToolCell"];
    [self.tableView registerClass:[headImageCell class] forCellReuseIdentifier:@"headImageCell"];
    [self.tableView registerClass:[payBookCell class] forCellReuseIdentifier:@"payBookCell"];

    NSDictionary *param = @{@"userId":userId};
    [self loadChildDatawithParam:param];
    
    [self createFootView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [self loadCheckData];
}

-(void)createNav{

    self.dataArray = [[NSMutableArray alloc]init];
    self.dataSource = [[NSMutableArray alloc]init];
    self.nameArray = [[NSMutableArray alloc]init];
    self.phoneArray = [[NSMutableArray alloc]init];
    self.checkAdressArray = [[NSMutableArray alloc]init];
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

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
            UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
            [cell addGestureRecognizer:tapGuesture];
        
            if (self.dataArray.count==0) {
                
                cell.nameLb.text = @"请选择考生信息";
            }else{
        
                if (self.dataArray.count == 1||[ETRegularUtil isEmptyString:nameStr]||[ETRegularUtil isEmptyString:phoneStr]) {

                    cell.nameLb.text = [NSString stringWithFormat:@"%@",firstNameStr];
                    cell.phoneLb.text = [NSString stringWithFormat:@"%@",firstPhoneStr];
                }else{
                    
                    cell.nameLb.text = [NSString stringWithFormat:@"%@",nameStr];
                    cell.phoneLb.text = [NSString stringWithFormat:@"%@",phoneStr];
                }
            }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section ==1){
       
        if (indexPath.row == 0) {
            
            self.headCell = [tableView dequeueReusableCellWithIdentifier:@"headImageCell"];
            if (!self.headCell) {
                
                self.headCell = [[headImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headImageCell"];
            }
                if ([ETRegularUtil isEmptyString:self.titleStr]) {
                    
                    self.headCell.headLb.text = titleStr;
                }else{
                    
                    self.headCell.headLb.text = self.titleStr;
                }
                
                if ([ETRegularUtil isEmptyString:self.pictureImg]) {
                    
                    [self.headCell.headImageView sd_setImageWithURL:[NSURL URLWithString:pictureImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
                }else{
                    
                    [self.headCell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.pictureImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
                }
                
                self.headCell.priceLb.text = [NSString stringWithFormat:@"¥%@",priceStr];
            
            self.headCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.headCell;
        }else{
            payDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payDetailCell"];
            if (!cell) {
                
                cell = [[payDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payDetailCell"];
            }
                if(indexPath.row == 1){
                    
                    DDLog(@"%@",levelStr);
                    cell.headLb.text = @"考试级别";
                    cell.contentLb.text = levelStr;
                    
                }else if(indexPath.row ==2){
                    
                    cell.headLb.text = @"考试时间";
                    DDLog(@"%@",examTime);
                    cell.contentLb.text = examTime;
                }else{
                    
                    cell.headLb.text = @"考试地点";
                    DDLog(@"%@",address);
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
            return cell;
        }else{
            payUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payUserCell"];
            if (!cell) {
                cell = [[payUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payUserCell"];
            }
            
            cell.titleLb.text = @"收货地址";
            
            DDLog(@"%@",payAddress);
            if (self.checkAdressArray.count ==0) {
                
                cell.phoneLb.text = @"请选择收货地址";
            }else{
            
                if (self.checkAdressArray.count == 1||[ETRegularUtil isEmptyString:payAddress]) {
                    
                    cell.phoneLb.text = [NSString stringWithFormat:@"%@",checkAddress];
                }else{
                    
                    cell.phoneLb.text = [NSString stringWithFormat:@"%@",payAddress];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(indexPath.section ==4){
        
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
    }else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        sumPriceStr = [sendBookPrice floatValue] + [priceStr floatValue] + [expressPrice floatValue];
        cell.textLabel.text = [NSString stringWithFormat:@"商品共 ¥%0.2f",sumPriceStr];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        return cell;
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
    
    NSString *str;
    if ([ETRegularUtil isEmptyString:titleStr]) {
        str = self.titleStr;
    }else{
        str = titleStr;
    }
    
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;

    if (size.height>21) {
        
        [self.headCell.headLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.headCell).offset(20);
            make.left.equalTo(self.headCell.headImageView.mas_right).offset(5);
            make.right.equalTo(self.headCell.arrowImage.mas_left).offset(-5);
        }];
    }
    self.headHeight = size.height +15 +15 +30;
    return self.headHeight;
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
    self.headHeight = size.height +15 +15 +30;
    return self.headHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 1&& indexPath.row == 0) {
        
        detailController *detail = [[detailController alloc]init];
        detail.activityTitle = self.activityTitle;
        detail.subjectId = subjectId;
        [self.navigationController pushViewController:detail animated:NO];
    }else if(indexPath.section == 2&&indexPath.row ==2){
    
        
//        if (self.checkAdressArray.count == 0) {
 
            addressController *payAdress = [[addressController alloc]init];
            payAdress.orderStr = self.orderId;
            payAdress.fromStr = @"1";
            [self.navigationController pushViewController:payAdress animated:NO];
//        }else{
//
//            payAddressController *payAdress = [[payAddressController alloc]init];
//            payAdress.orderStr = self.orderId;
//            [self.navigationController pushViewController:payAdress animated:NO];
//        }
  }
}

-(void)tapClick{
    
//    if (self.dataArray.count ==0) {
//
//        childDataController *child = [[childDataController alloc]init];
//        child.babyId = @"";
//        child.fromWhere = @"112";//标记
//        child.money = priceStr;
//        child.subjectId = self.type;
//        child.taskId = self.subjectStr;
//        child.orderId = self.orderId;
//        child.pictureImg = self.pictureImg;
//        child.titleStr = self.titleStr;
//        child.levelStr = self.typeName;
//        child.examTime = self.examDate;
//        child.adressStr = self.address;
//        [self.navigationController pushViewController:child animated:YES];
//    }else{
    
        mySonController *student = [[mySonController alloc]init];
        student.orderId = self.orderId;
        student.fromStr = @"112";
        [self.navigationController pushViewController:student animated:YES];
}

#pragma mark -- 待支付
-(void)loadWillPayData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    
    DDLog(@"%@",userId);
    DDLog(@"%@",self.orderId);
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"userId":userId,@"orderId":self.orderId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:detialToPayURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            NSDictionary *menuList = dict[@"menuList"];
            NSDictionary *results = dict[@"results"];
            NSDictionary *userAdress = dict[@"UserAddressList"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                titleStr = menuList[@"title"];
                levelStr = menuList[@"type_name"];
                priceStr = menuList[@"money"];
                personStr = menuList[@"apply_count"];
                orderId = menuList[@"orderId"];
                examTime = menuList[@"subject_date"];
                address = menuList[@"address"];
                pictureImg = menuList[@"comment_img"];
                subjectId = menuList[@"id"];
                nameStr = menuList[@"examinee_name"];
                phoneStr = menuList[@"phone"];
                typeId = menuList[@"typeId"];
                
                sendBookName = results[@"bookName"];//书名
                sendBookImg = results[@"iconImg"];//封面
                sendBookPrice = results[@"price"];//价格
                expressPrice = results[@"expressFee"];//快递
                
                addressStrId = userAdress[@"id"];
                payAddress = userAdress[@"address"];
                
                [self createFootView];
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 姓名，电话号码
-(void)loadNameData{
    
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *param = @{@"userId":userId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:addchildDataURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        NSArray *results = dict[@"results"];
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            for (NSDictionary *appDict in results) {
                
                mySonModel *model = [[mySonModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.nameArray addObject:model.name];
                [self.phoneArray addObject:model.userName];
                firstNameStr = model.name;
                
                NSString *phoneStr = [NSString stringWithFormat:@"%@",model.phone];
                if ([ETRegularUtil isEmptyString:phoneStr]) {
                    
                    firstPhoneStr = model.userName;
                }else{
                
                     firstPhoneStr = model.phone;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)loadChildDatawithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:addchildDataURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSArray *result = dict[@"results"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            for (NSDictionary *appDict in result) {
                
                mySonModel *model = [[mySonModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
                
                NSString *phoneStrig = [NSString stringWithFormat:@"%@",appDict[@"phone"]];
                if ([ETRegularUtil isEmptyString:phoneStrig]) {
                    
                    phoneStr = appDict[@"userName"];
                }else{
                
                    phoneStr = appDict[@"phone"];
                }
                    nameStr = appDict[@"name"];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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

#pragma mark -- 地址
-(void)loadCheckData{
    
    NSDictionary *param = @{@"userId":userId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:checkEduAdressURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            [self.checkAdressArray removeAllObjects];
            NSArray *menuList = dict[@"menuList"];
            for (NSDictionary *appDict in menuList) {
                
                checkAddressModel *model = [[checkAddressModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.checkAdressArray addObject:model];
                
                checkAddress = model.address;
                checkAddressId = model.id;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 支付
-(void)loadPayData{
    
    DDLog(@"%@",subjectId);
    DDLog(@"%@",typeId);
    DDLog(@"%@",self.orderId);
    DDLog(@"%@",self.money);
    DDLog(@"%@",addressStrId);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    
    [GetIP getCurrentDeviceModel];
    [GetIP getIPAddress];
    
    NSString *nameString;
    NSString *phoneString;
    if ([ETRegularUtil isEmptyString:nameStr]) {
        
        nameString = firstNameStr;
    }else{
        
        nameString = nameStr;
    }
    if ([ETRegularUtil isEmptyString:phoneStr]) {
        
        phoneString = firstPhoneStr;
    }else{
        
        phoneString = phoneStr;
    }

    DDLog(@"%@",nameString);
    DDLog(@"%@",phoneString);
    DDLog(@"%@",self.orderId);
    DDLog(@"%@",addressStrId);
    DDLog(@"%lf",sumPriceStr);
    DDLog(@"%@",subjectId);
    DDLog(@"%@",typeId);
    
    NSString *addressId;
    if ([ETRegularUtil isEmptyString:addressStrId]) {
        
        addressId = checkAddressId;
    }else{
    
        addressId = addressStrId;
    }
    NSString *priceStr = [NSString stringWithFormat:@"%lf",sumPriceStr];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"userId":userId,@"money":priceStr,@"subjectId":subjectId,@"typeId":typeId,@"babyName":nameString,@"phone":phoneString,@"spbill_create_ip":[GetIP getIPAddress],@"orderId":self.orderId,@"addressId":addressId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:payURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict)  ;
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = @"1480432402";
                request.prepayId= dict[@"prepayid"];
                request.package = @"Sign=WXPay";
                request.nonceStr = dict[@"noncestr"];
                request.timeStamp = [dict[@"timeStamp"]intValue];
                request.sign = dict[@"sign"];
                [WXApi sendReq:request];
                [weakSelf.tableView reloadData];
        }else{
            
            [self showAlertWithMessage:@"此项目已经售完，请选择其他的项目"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)payFootView{
    
    DDLog(@"%@",self.payNameStr);
    DDLog(@"%@",self.phoneNumber);
    
    NSString *nameString;
    NSString *phoneString;
    if ([ETRegularUtil isEmptyString:nameStr]) {
        
        nameString = firstNameStr;
    }else{
    
        nameString = nameStr;
    }
    if ([ETRegularUtil isEmptyString:phoneStr]) {
        
        phoneString = firstPhoneStr;
    }else{
    
        phoneString = phoneStr;
    }
    
    if ([ETRegularUtil isEmptyString:nameString]||[ETRegularUtil isEmptyString:phoneString]) {
        
        [self showAlertWithMessage:@"请选择考生的相关信息"];
    }else if(self.checkAdressArray.count ==0){
        
        [self showAlertWithMessage:@"请选择收货地址"];
    }else{
    
        [self loadPayData];
    }
}

-(void)presentLeftMenuViewController{
    
    if ([self.fromWhere isEqualToString:@"order"]) {
    
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[orderController class]]) {
                
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }else{
    
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[detailController class]]) {
                
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
}

@end
