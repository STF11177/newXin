//
//  eduOrderFinishController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/16.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduOrderFinishController.h"
#import "payHeadCell.h"
#import "eduOrderCell.h"
#import "orderModel.h"

@interface eduOrderFinishController ()<UITableViewDelegate,UITableViewDataSource>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation eduOrderFinishController
static NSString *userId;
static NSString *receiver;
static NSString *phoneNumber;
static NSString *address;
static NSString *orderTime;
static NSString *orderImageView;
static NSString *orderTitle;
static NSString *orderCount;
static NSString *orderSum;
static NSString *orderOriginPrice;
static NSString *ordderSale;
static NSString *expressFee;
static NSString *payStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLb.text = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self createHttp];
    [self loadWillPayData];

    [self createView];
    [self.tableView registerClass:[payHeadCell class] forCellReuseIdentifier:@"payHeadCell"];
    [self.tableView registerClass:[eduOrderCell class] forCellReuseIdentifier:@"eduOrderCell"];
}

-(void)createView{
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (iOS11) {
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:_tableView];
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
            
                receiver = [NSString stringWithFormat:@"收货人：%@",userAdress[@"consignee"]];
                phoneNumber = [NSString stringWithFormat:@"%@",userAdress[@"phone"]];
                address = [NSString stringWithFormat:@"%@",userAdress[@"address"]];
                
                orderTime = menuList[@"date"];
                orderImageView = menuList[@"contentImg"];
                orderTitle = menuList[@"bookName"];
                orderCount = [NSString stringWithFormat:@"%@",menuList[@"orderCount"]];
                ordderSale = [NSString stringWithFormat:@"%@",menuList[@"price"]];
                expressFee = menuList[@"expressFee"];
                payStatus = menuList[@"payStatus"];
                
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
    
        payHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payHeadCell"];
        if (!cell) {
            
            cell = [[payHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payHeadCell"];
        }
        
        cell.nameLb.text = receiver;
        cell.phoneLb.text = phoneNumber;
        cell.addressLb.text = address;
        cell.arrowImg.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        eduOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eduOrderCell"];
        if (!cell) {
            
            cell = [[eduOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eduOrderCell"];
        }
        
        cell.titleLb.text = orderTitle;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:orderImageView] placeholderImage:[UIImage imageNamed:@"fenmian"]];
        cell.countLb.text = [NSString stringWithFormat:@"x%@",orderCount];
        cell.timeLb.text = orderTime;
        
        float sumPrice = [ordderSale floatValue] + [expressFee floatValue];
        cell.saleLb.text = [NSString stringWithFormat:@"¥%.0f",sumPrice];
        
        cell.sumLb.text = [NSString stringWithFormat:@"共%@件商品 合计：¥%.2f(含运费¥%.2f)",orderCount,sumPrice,[expressFee floatValue]];
        NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:cell.sumLb.text];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff2b24"] range:NSMakeRange(8 + orderCount.length, ordderSale.length+4)];
        cell.sumLb.attributedText = centStr;
        
        
        NSString *payStr = [NSString stringWithFormat:@"%@",payStatus];
        if([payStr isEqualToString:@"1"]){
        
            cell.statusLb.text = @"已支付";
        }else{
            
            cell.statusLb.text = @"已发货";
        }
        cell.deleteBtn.hidden = YES;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 80;
    }else{
        
        return 140;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

@end
