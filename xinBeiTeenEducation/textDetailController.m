//
//  textDetailController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "textDetailController.h"
#import "payController.h"
#import "DetailCell.h"
#import "enrollCell.h"
#import "enrollCell.h"
#import "testTimeCell.h"
#import "detailHeadView.h"
#import "textDetailListModel.h"
#import "mySonModel.h"

@interface textDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *detailtableView;
@property (nonatomic,strong) detailHeadView *headView;
@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UILabel *personLb;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIButton *enrollBtn;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIView *sepeView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *categoryId;
@property (nonatomic,strong) NSMutableArray *categoryName;
@property (nonatomic,strong) NSMutableArray *subjectCountAry;//课程数量
@property (nonatomic,strong) NSMutableArray *testTimeArray;//考试时间

@property (nonatomic,strong) UIButton *categoryBtn;
@property (nonatomic,strong) UILabel *categoryLb;
@property (nonatomic,strong) NSArray *listArray;

@property (nonatomic,assign) BOOL islike;
@property (nonatomic,assign) BOOL btnSelect;//记录button的选中状态

@property (nonatomic,strong) testTimeCell *timeCell;

@end

@implementation textDetailController
static NSString *referral;
static NSString *endTime;//截止时间
static NSString *testTime;//考试时间
static NSString *testPayment;//报名费用
static NSString *testPayment1;
static NSString *testAddress;//考场地址
static NSString *testReceiveAdrs;//考场地址
static NSString *testGetPerson;//报名人数
static NSString *price;
static NSString *taskId;
static NSString *subject_count;
static NSString *subject_id;
static NSString *typeName;
static NSString *userId;
static NSString *typeStr;//要选择的科目
static NSString *titleStr;
static NSString *iconImage;
static int collectNumber;
static int collectStatus;
static NSTimeInterval overTime;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createHttpRequest];
    [self loadSubject];
    [self createTableview];
    
    [self.detailtableView registerClass:[DetailCell class] forCellReuseIdentifier:@"DetailCell"];
    [self.detailtableView registerClass:[enrollCell class] forCellReuseIdentifier:@"enrollCell"];
    [self.detailtableView registerClass:[testTimeCell class] forCellReuseIdentifier:@"testTimeCell"];
}

-(void)createNav{
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.categoryId = [[NSMutableArray alloc]init];
    self.categoryName = [[NSMutableArray alloc]init];
    self.subjectCountAry = [[NSMutableArray alloc]init];
    self.testTimeArray = [[NSMutableArray alloc]init];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"课程详情";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
}

-(void)createTableview{
    
    self.detailtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.detailtableView.delegate = self;
    self.detailtableView.dataSource = self;
    self.detailtableView.separatorStyle = UITableViewCellAccessoryNone;
    self.headView = [detailHeadView headView];
    self.detailtableView.tableHeaderView = self.headView;
    
    [self.view addSubview:self.detailtableView];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadSubject{
    
    DDLog(@"%@",self.subjectId);
    __weak typeof(self) weakSelf = self;
    NSString *subjectId = [NSString stringWithFormat:@"%@",self.subjectId];
    NSDictionary *param = @{@"subjectId":subjectId,@"userId":userId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:subjectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSDictionary *menuList = dict[@"menuList"];
        int status = [dict[@"status"]intValue];
        
        if (status == 0) {
            
            //头视图
            [self.headView.headImgView sd_setImageWithURL:[NSURL URLWithString:menuList[@"icon"]] placeholderImage:[UIImage imageNamed:@"nsme_ke"]];
            
            iconImage = menuList[@"icon"];
            self.headView.titleLb.text = menuList[@"title"];
            titleStr = menuList[@"title"];
            
            NSString *timeStr = [menuList[@"biginDate"] stringByAppendingString:@"-"];
            NSString *timeStr1 = [timeStr stringByAppendingString:menuList[@"endDate"]];
            self.headView.timeLb.text = timeStr1;
            
            if (!menuList[@"apply_count"]) {
                self.headView.personHeadLb.text = @"已有0人报名";
                testGetPerson = @"已有0人报名";
            }else{
                self.headView.personHeadLb.text = [NSString stringWithFormat:@"已有%@人报名",menuList[@"apply_count"]];
                testGetPerson = [NSString stringWithFormat:@"已有%@人报名",menuList[@"apply_count"]];
            }
            
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
            
            if(overTime > 0){
                
                self.headView.enrollImg.image = [UIImage imageNamed:@"kz_over"];
            }else{
                
                self.headView.enrollImg.image = [UIImage imageNamed:@"kz_hot"];
            }
            
            taskId = menuList[@"id"];
            
            //类别
            self.listArray = dict[@"list"];
            for (NSDictionary *appDict in self.listArray) {
                textDetailListModel *listModel = [[textDetailListModel alloc]init];
                [listModel yy_modelSetWithDictionary:appDict];
                [self.categoryName addObject:listModel.type_name];
                [self.categoryId addObject:listModel.id];
                [self.subjectCountAry addObject:listModel.subject_count];
                [self.testTimeArray addObject:listModel.subject_date];
            }
            
            //介绍
            referral = menuList[@"referral"];
            
            //考试安排
            endTime = [NSString stringWithFormat:@"报名截止时间：%@",menuList[@"endDate"]];
            NSString *payStr = [NSString stringWithFormat:@"报名费用：%@元/课",menuList[@"money"]];
            testPayment = payStr;
//          testAddress = [NSString stringWithFormat:@"考场地址：%@",menuList[@"address"]];
            testReceiveAdrs = [NSString stringWithFormat:@"准考证领取地址：%@",menuList[@"get_address"]];
            
            //收藏
            collectStatus = [dict[@"collectStatus"]intValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.detailtableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        self.categoryLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 30)];
        self.categoryLb.text = @"类别";
        [cell addSubview:self.categoryLb];
        
        self.sepeView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
        self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [cell addSubview:self.sepeView];
        
        CGFloat olderWith = 0;//保存前一个button的宽及前一个button距离屏幕边缘的距离
        CGFloat height = 71;//用来控制button的距离父视图的高
        for (int i = 0; i< self.categoryName.count; i++) {
        
            self.categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.categoryBtn.backgroundColor = [UIColor brownColor];
            [self.categoryBtn addTarget:self action:@selector(categoryClick1:) forControlEvents:UIControlEventTouchUpInside];
            self.categoryBtn.tag = 101 + i;
        
            self.categoryBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.categoryBtn setTitle:self.categoryName[i] forState:UIControlStateNormal];
            [self.categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.categoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            self.categoryBtn.layer.cornerRadius = 5;
            
            //计算文字的大小
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            CGFloat length = [self.categoryName[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, cell.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size.width;
            self.categoryBtn.frame = CGRectMake(10 + olderWith, height, length + 30, 30);
            
            //当button的位置超出屏幕边缘时换行，SCREEN_WIDTH只是button所在父视图的宽度
            if ( 10 + olderWith +length +30 >SCREEN_WIDTH) {
                olderWith = 0;//换行时将olderWith置为0
                height = height +self.categoryBtn.frame.size.height +10;
                self.categoryBtn.frame = CGRectMake( 10 +olderWith, height, length +20, 30);//重设button的frame
            }
            
            olderWith = self.categoryBtn.frame.size.width + self.categoryBtn.frame.origin.x;
            [cell addSubview:self.categoryBtn];
        }                                                                                                                                                                                

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 1){
        
        enrollCell *cell = [tableView dequeueReusableCellWithIdentifier:@"enrollCell"];
        if (!cell) {
            cell = [[enrollCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"enrollCell"];
        }
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentLb.text = referral;
        
        return cell;
    }else{
        
        self.timeCell = [tableView dequeueReusableCellWithIdentifier:@"testTimeCell"];
        if (!self.timeCell) {
            self.timeCell = [[testTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testTimeCell"];
        }
        
        self.timeCell.userInteractionEnabled = NO;
        self.timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.timeCell.endTimeLb.text = endTime;
        self.timeCell.endTimeLb.font = [UIFont systemFontOfSize:16];
        self.timeCell.endTimeLb.textColor = [UIColor lightGrayColor];
//        NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.timeCell.endTimeLb.text];
//        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 7)];
//        self.timeCell.endTimeLb.attributedText = centStr;
        
        self.timeCell.priceLb.text = testPayment;
        self.timeCell.priceLb.font = [UIFont systemFontOfSize:16];
        self.timeCell.priceLb.textColor = [UIColor lightGrayColor];
//        NSMutableAttributedString *centStr3 = [[NSMutableAttributedString alloc]initWithString:self.timeCell.priceLb.text];
//        [centStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
//        self.timeCell.priceLb.attributedText = centStr3;
        
//        NSMutableAttributedString *centStr1 = [[NSMutableAttributedString alloc]initWithString:self.timeCell.testTimeLb.text];
//        [centStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
//        self.timeCell.testTimeLb.attributedText = centStr1;
        
//        NSMutableAttributedString *centStr4 = [[NSMutableAttributedString alloc]initWithString:self.timeCell.adressLb.text];
//        [centStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
//        self.timeCell.adressLb.attributedText = centStr4;
        
        self.timeCell.admissionCardLb.text = testReceiveAdrs;
        self.timeCell.admissionCardLb.font = [UIFont systemFontOfSize:16];
        self.timeCell.admissionCardLb.textColor = [UIColor lightGrayColor];
//        NSMutableAttributedString *centStr5 = [[NSMutableAttributedString alloc]initWithString:self.timeCell.admissionCardLb.text];
//        [centStr5 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 8)];
//        self.timeCell.admissionCardLb.attributedText = centStr5;
        
        return self.timeCell;
    }
}

-(void)categoryClick1:(UIButton *)btn{
    
    if (btn != self.categoryBtn) {
        
        self.categoryBtn.selected = NO;
        self.categoryBtn.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        self.categoryBtn = btn;
    }
    self.categoryBtn.selected = YES;
    self.categoryBtn.backgroundColor = [UIColor orangeColor];
    
    for (int i = 0 ; i< self.listArray.count; i++) {
        
        typeName = self.categoryName[i];
        DDLog(@"%@",self.categoryBtn.titleLabel.text);
        DDLog(@"%@",typeName);
        if ([self.categoryBtn.titleLabel.text isEqualToString:typeName]) {
            price = [self.listArray[i] objectForKey:@"subject_money"];
            subject_count = [self.listArray[i] objectForKey:@"subject_count"];
            testPayment1 = [NSString stringWithFormat:@"¥%@",price];
            
            self.priceLb.text = testPayment1;
            self.timeCell.priceLb.text = [NSString stringWithFormat:@"报名费用：%@",testPayment1];
        
            testTime = [self.listArray[i] objectForKey:@"subject_date"];
            self.timeCell.testTimeLb.text = [NSString stringWithFormat:@"考试时间：%@",testTime];

            self.timeCell.adressLb.text = [NSString stringWithFormat:@"考场地址：%@",[self.listArray[i] objectForKey:@"subject_address"]];
            
            subject_id = self.categoryId[i];
        }
    }
    
    DDLog(@"%@",subject_id);
    NSString *countStr = [NSString stringWithFormat:@"%@",subject_count];
    DDLog(@"%@",countStr);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    self.footView = [[UIView alloc]init];
    self.footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footView];
    
    self.priceLb = [[UILabel alloc]init];
    self.priceLb.textColor = [UIColor orangeColor];
    self.priceLb.text = [NSString stringWithFormat:@"¥0"];
    [self.footView addSubview:self.priceLb];
    
    self.personLb = [[UILabel alloc]init];
    self.personLb.font = [UIFont systemFontOfSize:14];
    self.personLb.text =[NSString stringWithFormat:@"%@",testGetPerson];
    self.personLb.textColor = [UIColor lightGrayColor];
    [self.footView addSubview:self.personLb];
    
    self.collectBtn = [[UIButton alloc]init];
    [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    DDLog(@"%d",collectStatus);
    if (collectStatus == 0) {
            
        [self.collectBtn setImage:[UIImage imageNamed:@"kaoz_nices2"] forState:UIControlStateNormal];
        self.collectBtn.selected = YES;
    }else{
    
        [self.collectBtn setImage:[UIImage imageNamed:@"kaoz_nices"] forState:UIControlStateNormal];
        self.collectBtn.selected = NO;
    }
    
    [self.collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:self.collectBtn];
    
    self.enrollBtn = [[UIButton alloc]init];
    [self.enrollBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [self.enrollBtn addTarget:self action:@selector(enrollClick) forControlEvents:UIControlEventTouchUpInside];
    self.enrollBtn.backgroundColor = [UIColor orangeColor];
    [self.footView addSubview:self.enrollBtn];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.footView addSubview:self.sepeView];
    
    [self layoutUI];
    return self.footView;
}

-(void)layoutUI{
    
    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.footView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.footView).offset(5);
        make.left.equalTo(self.footView).offset(10);
        make.right.equalTo(self.collectBtn.mas_left).offset(-10);
        make.bottom.equalTo(self.personLb.mas_top).offset(-5);
    }];
    
    [self.personLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.priceLb.mas_bottom).offset(5);
        make.left.equalTo(self.priceLb.mas_left);
        make.right.equalTo(self.collectBtn.mas_left).offset(-10);
        make.bottom.equalTo(self.footView).offset(-5);
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLb.mas_right).offset(10);
        make.right.equalTo(self.enrollBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.footView);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(100);
    }];
    
    [self.enrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.footView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(SCREEN_WIDTH*0.3);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 190;
    }else if(indexPath.row ==1){
        
        return 150;
    }else{
        
        return 200;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
}

-(void)presentLeftMenuViewController{
    
    subject_id = @"";
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -- 收藏相关的点击方法
-(void)collectClick:(UIButton*)btn{
    
    
    if (btn.selected == YES) {
        
        [btn setImage:[UIImage imageNamed:@"kaoz_nices"] forState:UIControlStateNormal];
        collectNumber = 0;
    }else{
        
        [btn setImage:[UIImage imageNamed:@"kaoz_nices2"] forState:UIControlStateNormal];
        collectNumber = 1;
    }
    
    btn.selected = !self.collectBtn.selected;
    btn = self.collectBtn;
    
    [self loadCollectData];
}

#pragma mark -- 下载收藏
-(void)loadCollectData{
    
    DDLog(@"%d",collectStatus);

    NSDictionary *param = @{@"userId":userId,@"taskId":taskId,@"type":@"2",@"status":[[NSString alloc]initWithFormat:@"%d",collectNumber]};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:collectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
      }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)enrollClick{
    
    DDLog(@"%@",typeName);
    DDLog(@"%@",subject_count);
    NSString *countStr = [NSString stringWithFormat:@"%@",subject_count];
    NSString *sunjectId = [NSString stringWithFormat:@"%@",subject_id];
    DDLog(@"%@",sunjectId);
    if (overTime >0){
        
        [self showAlert:@"此报名已结束" withBtnTitles:@[@"知道了"]];
    }else if ([ETRegularUtil isEmptyString:sunjectId]) {
        
        CommonAlert *alert = [[CommonAlert alloc]initWithMessage:@"请选择要报名的类型" withBtnTitles:@[@"我知道了"]];
        alert.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
    }else if ([countStr isEqualToString:@"0"]){
        
        CommonAlert *alert = [[CommonAlert alloc]initWithMessage:@"此项目已经售完,请选择其它项目" withBtnTitles:@[@"我知道了"]];
        alert.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
    }else{
        
        [self loadOrder];
    }
}

#pragma mark -- 下订单
-(void)loadOrder{
    
    DDLog(@"%@",userId);
    DDLog(@"%@",subject_id);
    DDLog(@"%@",taskId);
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"userId":userId,@"subjectId":taskId,@"typeId":subject_id};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:testOrderURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSDictionary *list = dict[@"list"];
        NSDictionary *menuList = dict[@"menuList"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.detailtableView reloadData];
                payController *pay = [[payController alloc]init];
                
                DDLog(@"%@",list[@"type_name"]);
                pay.money = [NSString stringWithFormat:@"%@",testPayment1];
                pay.titleStr = titleStr;
                pay.subjectStr = taskId;
                pay.personStr = testGetPerson;
                pay.typeName = list[@"type_name"];
                pay.type = subject_id;
                pay.iconImg = iconImage;
                pay.orderId = dict[@"orderId"];
                pay.examDate = menuList[@"examDate"];
                pay.address = menuList[@"address"];
                subject_id = @"";
                
                [self.navigationController pushViewController:pay animated:NO];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
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

@end
