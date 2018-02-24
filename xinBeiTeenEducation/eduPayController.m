//
//  eduPayController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduPayController.h"
#import "payHeadCell.h"
#import "addressController.h"
#import "payImgCell.h"
#import "payNumberCell.h"
#import "sendStyleCell.h"
#import "textFieldCell.h"
#import "paySumCell.h"
#import "eduPayFootView.h"
#import "addnewAdressController.h"
#import "payAddressController.h"
#import "checkAddressModel.h"
#import "WXApi.h"
#import "GetIP.h"
#import "eduDetailController.h"
#import "eduOrderController.h"


@interface eduPayController ()<UITableViewDelegate,UITableViewDataSource,payNumberCellDelegate,eduPayFootViewDelete,textFieldCellDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) payImgCell *imgCell;
@property (nonatomic,strong) paySumCell *sumCell;
@property (nonatomic,strong) eduPayFootView *footView;
@property (nonatomic,strong) textFieldCell *textField;
@property (nonatomic,strong) NSMutableArray *checkAdressArray;

@end

@implementation eduPayController
static int number;
static NSString *userId;
static NSString *booktitle;
static NSString *bookName;
static NSString *bookImg;
static NSString *bookPrice;
static NSString *addressStr;//地址
static NSString *personStr;//收货人
static NSString *phoneStr;//电话

static NSString *firstAddStr;
static NSString *firstPersonStr;
static NSString *firstPhoneStr;
static NSString *expressFee;
static NSString *addressId;//第一次
static NSString *checkAddressId;
static NSString *sumPrice;
static NSString *payStr;//支付状态
static NSString *bookId;
static NSString *textfieldStr;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createHttp];
    [self createNav];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self loadCheckData];

    [self createView];
    [self createFootView];
    
    number = 1;
    [self.tableView registerClass:[payHeadCell class] forCellReuseIdentifier:@"payHeadCell"];
    [self.tableView registerClass:[payImgCell class] forCellReuseIdentifier:@"payImgCell"];
    [self.tableView registerClass:[payNumberCell class] forCellReuseIdentifier:@"payNumberCell"];
    [self.tableView registerClass:[sendStyleCell class] forCellReuseIdentifier:@"sendStyleCell"];
    [self.tableView registerClass:[textFieldCell class] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView registerClass:[paySumCell class] forCellReuseIdentifier:@"paySumCell"];
    
     [self loadWillPayData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self loadCheckData];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

-(void)createNav{
    
    self.checkAdressArray = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"付款";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor blackColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    
    return UIStatusBarStyleDefault;
}

-(void)createView{

    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (iOS11) {
        
        self.tableView.sectionHeaderHeight = 0.1f;
        self.tableView.sectionFooterHeight = 10.f;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
    [self.view addSubview:self.tableView];
}

-(void)closeKeyBoard{
    
    [self.tableView endEditing:YES];
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
                firstAddStr = model.address;
                firstPersonStr = model.consignee;
                firstPhoneStr = model.phone;
                addressId = model.id;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.checkAdressArray.count == 0) {
                    
                    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还没有设置收货地址，请点击这里设置" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        addnewAdressController *payAdress = [[addnewAdressController alloc]init];
                        payAdress.signStr = @"eduPay";
                        [self.navigationController pushViewController:payAdress animated:YES];
                    }];
                    
                    [alertControl addAction:action];
                    [alertControl addAction:action1];
                    [self presentViewController:alertControl animated:YES completion:nil];
                }
                
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 待支付
-(void)loadWillPayData{
 
    __weak typeof(self) weakSelf = self;

    NSDictionary *param = @{@"userId":userId,@"orderId":self.orderIdStr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:eduWillPayURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            NSDictionary *menuList = dict[@"menuList"];
            NSDictionary *userAdress = dict[@"UserAddressList"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                personStr = userAdress[@"consignee"];
                phoneStr = userAdress[@"phone"];
                addressStr = userAdress[@"address"];
                checkAddressId = userAdress[@"id"];
                
                bookName = menuList[@"bookName"];
                bookImg = menuList[@"iconImg"];
                
                float price = [menuList[@"price"]floatValue];
                bookPrice = [NSString stringWithFormat:@"%.2f",price];
                booktitle = menuList[@"title"];
                bookId = menuList[@"bookId"];
                
                float expressPrice = [menuList[@"expressFee"]floatValue];
                expressFee = [NSString stringWithFormat:@"%.2f",expressPrice];
                
                payStr = [NSString stringWithFormat:@"%@",menuList[@"payStatus"]];
                DDLog(@"%@",payStr);
                
                [self createFootView];
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)idCardInCell:(textFieldCell *)cell{
    
    textfieldStr = cell.contentField.text;
}

-(void)payFootView{
    
    NSString *nameString;
    NSString *phoneString;
    if ([ETRegularUtil isEmptyString:personStr]) {
        
        nameString = firstPersonStr;
    }else{
        
        nameString = personStr;
    }
    if ([ETRegularUtil isEmptyString:phoneStr]) {
        
        phoneString = firstPhoneStr;
    }else{
        
        phoneString = phoneStr;
    }
    
    NSString *addressId1;
    if ([ETRegularUtil isEmptyString:checkAddressId]) {
        
        addressId1 = addressId;
    }else{
        
        addressId1 = checkAddressId;
    }

    DDLog(@"%@",textfieldStr);
    DDLog(@"%@",addressId1);
    
    NSString *fieldStr = [NSString stringWithFormat:@"%@",textfieldStr];
    
    NSDictionary *param = @{@"userId":userId,@"money":sumPrice,@"subjectId":@"0",@"typeId":@"0",@"babyName":nameString,@"phone":phoneString,@"spbill_create_ip":[GetIP getIPAddress],@"orderId":self.orderIdStr,@"addressId":addressId1,@"userMeassage":fieldStr,@"count":[NSString stringWithFormat:@"%d",number],@"bookId":bookId};
    [self loadPayDataWithParam:param];
}

//付款
-(void)loadPayDataWithParam:(NSDictionary*)param{

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:eduBookPayURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = @"1480432402";
                request.prepayId= dict[@"prepayid"];
                request.package = @"Sign=WXPay";
                request.nonceStr = dict[@"noncestr"];
                request.timeStamp = [dict[@"timeStamp"]intValue];
                request.sign = dict[@"sign"];
                [WXApi sendReq:request];
                [self.tableView reloadData];
            });
        }else{
            
            [self showAlertWithMessage:@"此图书已售完，请选择其他的图书"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 1) {
        
        return 5;
    }else{
    
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==0) {
        payHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payHeadCell"];
        if (!cell) {
            
            cell = [[payHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payHeadCell"];
        }
        
        if ([ETRegularUtil isEmptyString:personStr]) {
            
            cell.nameLb.text = firstPersonStr;
            cell.addressLb.text = firstAddStr;
            cell.phoneLb.text = firstPhoneStr;
        }else{
        
            if (self.checkAdressArray.count==1) {
                
                cell.nameLb.text = firstPersonStr;
                cell.addressLb.text = firstAddStr;
                cell.phoneLb.text = firstPhoneStr;
            }else{
                
                cell.nameLb.text = personStr;
                cell.addressLb.text = addressStr;
                cell.phoneLb.text = phoneStr;
            }
        }
               return cell;
    }else if(indexPath.section ==1){
        
        if (indexPath.row == 0) {
           
            self.imgCell = [tableView dequeueReusableCellWithIdentifier:@"payImgCell"];
            if (!self.imgCell) {
                
                self.imgCell = [[payImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payImgCell"];
            }
            
            self.imgCell.bookLb.text = bookName;
            
            [self.imgCell.bookImg sd_setImageWithURL:[NSURL URLWithString:bookImg] placeholderImage:[UIImage imageNamed:@"lianjie"]];
            sumPrice = bookPrice;
            self.imgCell.priceLb.text = [NSString stringWithFormat:@"¥%@",bookPrice];
            self.imgCell.priceLb.textColor = [UIColor redColor];
            self.imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.imgCell;
        }else if(indexPath.row == 1){
        
            payNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payNumberCell"];
            if (!cell) {
                
                cell = [[payNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payNumberCell"];
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 2){
        
            sendStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sendStyleCell"];
            if (!cell) {
                
                cell = [[sendStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sendStyleCell"];
            }
            cell.arrowIMg.hidden = YES;
            cell.contentLb.text = [NSString stringWithFormat:@"快递费用%@元",expressFee];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 3){
        
            textFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
            if (!cell) {
                
                cell = [[textFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textFieldCell"];
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
        
            self.sumCell = [tableView dequeueReusableCellWithIdentifier:@"paySumCell"];
            if (!self.sumCell) {
                
                self.sumCell = [[paySumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paySumCell"];
            }
            self.sumCell.selectionStyle = UITableViewCellSelectionStyleNone;
            float sumPrice1 = [bookPrice intValue] + [expressFee floatValue];
            sumPrice = [NSString stringWithFormat:@"%.2f",sumPrice1];
            self.sumCell.priceLb.text = [NSString stringWithFormat:@"¥%.2f",sumPrice1];
            return self.sumCell;
        }
    }else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)createFootView{

    self.footView = [[eduPayFootView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    self.footView.delegate = self;

    float sumprice = [bookPrice floatValue] + [expressFee floatValue];
    NSString *string = [NSString stringWithFormat:@"合计：¥%.2f",sumprice];
     self.footView.priceLb.text = string;
    [self.view addSubview:self.footView];
}

-(void)addProductNumWith:(payNumberCell *)cell{
    
    cell.numberLb.text = [NSString stringWithFormat:@"%d",++number];
    if (number !=0) {
        
        [cell.deleteBtn setImage:[UIImage imageNamed:@"jian2"] forState:UIControlStateNormal];
    }
    
    self.imgCell.priceLb.text = [NSString stringWithFormat:@"¥%d",[bookPrice intValue]*number];
    
    float sumPrice1 = [bookPrice intValue]*number + [expressFee floatValue];
    sumPrice = [NSString stringWithFormat:@"%.2f",sumPrice1];
    self.imgCell.numberLb.text = [NSString stringWithFormat:@"¥%d",number];
    self.sumCell.productLb.text = [NSString stringWithFormat:@"共%d件商品",number];
    self.sumCell.priceLb.text = [NSString stringWithFormat:@"¥%.2f",sumPrice1];

    self.footView.priceLb.text = [NSString stringWithFormat:@"合计：¥%.2f",sumPrice1];
}

-(void)deleteProductNumWith:(payNumberCell *)cell{
    
    if (number <2) {
        
        number =1;
        [cell.deleteBtn setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    }else{
        
        cell.numberLb.text = [NSString stringWithFormat:@"%d",--number];
    }
    
    float sumPrice1 = [bookPrice intValue]*number + [expressFee floatValue];
    sumPrice = [NSString stringWithFormat:@"%.2f",sumPrice1];
    self.imgCell.priceLb.text = [NSString stringWithFormat:@"¥%d",[bookPrice intValue]*number];
    self.imgCell.numberLb.text = [NSString stringWithFormat:@"¥%d",number];
    self.sumCell.productLb.text = [NSString stringWithFormat:@"共%d件商品",number];
    self.sumCell.priceLb.text = [NSString stringWithFormat:@"¥%.2f",sumPrice1];
    self.footView.priceLb.text = [NSString stringWithFormat:@"合计：¥%.2f",sumPrice1];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        if (self.checkAdressArray.count == 0) {
            
            addnewAdressController *payAdress = [[addnewAdressController alloc]init];
            [self.navigationController pushViewController:payAdress animated:NO];
        }else{
            
            addressController *payAdress = [[addressController alloc]init];
            payAdress.fromStr = @"edupay";
            payAdress.orderStr = self.orderIdStr;
            [self.navigationController pushViewController:payAdress animated:NO];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==1) {
        if (indexPath.row == 0) {
            
            return 80;
        }else{
        
            return 44;
        }
    }else{
    
    return 73;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}

-(void)presentBack{
    
    if ([self.fromStr isEqualToString:@"order"]) {
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[eduOrderController class]]) {
                
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }else{
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[eduDetailController class]]) {
                
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
}

@end
