//
//  detailController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "detailController.h"
#import "testdetailCell.h"
#import "instroduceCell.h"
#import "testPriceCell.h"
#import "textDetailListModel.h"
#import "testAddressCell.h"
#import "examTimeCell.h"
#import "timeAndAdresCell.h"
#import "getAddressController.h"
#import "ETRegularUtil.h"
#import "allRecommentModel.h"
#import "CommonSheet.h"
#import "payController.h"
#import "testDetailController.h"
#import "detailFootCellView.h"
#import "beiZhuCell.h"
#import <UShareUI/UShareUI.h>
#import "beforeTestController.h"
#import "ETMessageView.h"
#import "queryResultController.h"

@interface detailController ()<UITableViewDelegate,UITableViewDataSource,detailFootViewDelete,CommonSheetDelegate,testdetailCellDelegate,beiZhuCellDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *categoryId;
@property (nonatomic,strong) NSMutableArray *subjectCountAry;
@property (nonatomic,strong) NSMutableArray *categoryArray;
@property (nonatomic,strong) NSMutableArray *priceArray;
@property (nonatomic,strong) NSMutableArray *firstArray;

@property (nonatomic,strong) testdetailCell *detailCell;
@property (nonatomic,strong) instroduceCell *instrodCell;
@property (nonatomic,strong) examTimeCell *examCell;
@property (nonatomic,strong) detailFootCellView *footView;
@property (nonatomic,strong) NSArray *listArray;

@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *contentLb;
@property (nonatomic,strong) UIView *lineView;


@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,strong) UIView *detailView;
@property (nonatomic,assign) BOOL netStatus1;//从没有网到有网的状态

@end

@implementation detailController
static NSString *userId;
static NSString *titleStr;
static NSString *testTime;
static NSString *personStr;
static NSString *instroduceStr;//课程介绍
static NSString *testAddress;
static NSString *willTestCard;//准考证领取时间
static NSString *getAdress;//准考证领取地点
static NSString *priceStr;
static NSString *examTime;//考试时间
static NSString *taskId;
static NSString *get_adtrss;//如果getAdress为空，则此领取地点
static NSString *getAdressStr; //领取地点，获取值得变量
static NSString *typeName;//考证的等级
static NSString *subject_count;//所报考的科目数
static NSString *createDate;
static NSString *subId;//标记某一条的
static NSString *beforeURL;//考前辅导
static NSTimeInterval overTime;
static int collectNumber;
static int collectStatus;
static int likeStatus;
static int likeCount;
static int commentCount;
static int collectCount;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    YYReachability *reachablity = [YYReachability reachability];
    NSString *string = [NSString stringWithFormat:@"%lu",(unsigned long)reachablity.status];
    if ([string isEqualToString:@"2"]) {
        
        self.netStatus1 = YES;
    }else if ([string isEqualToString:@"1"]){
        
        self.netStatus1 = YES;
    }else{
        
        self.netStatus1 = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createHttpRequest];
    [self loadDetailData];
    
    [self createNav];
    [self createTableView];
    
    [self createFootView];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    self.fd_interactivePopDisabled = YES;
    
    [self.tableView registerClass:[testdetailCell class] forCellReuseIdentifier:@"testdetailCell"];
    [self.tableView registerClass:[instroduceCell class] forCellReuseIdentifier:@"instroduceCell"];
    [self.tableView registerClass:[testPriceCell class] forCellReuseIdentifier:@"testPriceCell"];
    [self.tableView registerClass:[testAddressCell class] forCellReuseIdentifier:@"testAddressCell"];
    [self.tableView registerClass:[examTimeCell class] forCellReuseIdentifier:@"examTimeCell"];
    [self.tableView registerClass:[timeAndAdresCell class] forCellReuseIdentifier:@"timeAndAdresCell"];
    [self.tableView registerClass:[beiZhuCell class] forCellReuseIdentifier:@"beiZhuCell"];
    
    //没有网的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetStatus) name:@"notificationNetWorkbreup" object:nil];
    
    //数据网络 3G/4G
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatus) name:@"notificationNetWork" object:nil];
    
    //WiFi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatuswifi) name:@"notificationNetWorkWifi" object:nil];

}

#pragma mark --网络请求
-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)noNetStatus{

   _netStatus1 = NO;
    self.footView.likeBtn.enabled = NO;
    self.footView.collectBtn.enabled = NO;
    self.footView.commentBtn.enabled = NO;
}

-(void)netStatus{
    
        self.footView.likeBtn.enabled = YES;
        self.footView.collectBtn.enabled = YES;
        self.footView.commentBtn.enabled = YES;
        [self loadDetailData];
        _netStatus1 = YES;
}

-(void)netStatuswifi{
        
        self.footView.likeBtn.enabled = YES;
        self.footView.collectBtn.enabled = YES;
        self.footView.commentBtn.enabled = YES;
        [self loadDetailData];
        _netStatus1 = YES;
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkbreup" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWork" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationNetWorkWifi" object:nil];
}

-(void)btnClick{

 [self loadDetailData];
}

-(void)createNav{
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.categoryId = [[NSMutableArray alloc]init];
    self.categoryArray = [[NSMutableArray alloc]init];
    self.subjectCountAry = [[NSMutableArray alloc]init];
    self.priceArray = [[NSMutableArray alloc]init];
    self.firstArray = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = self.activityTitle;
    lable.font = [UIFont systemFontOfSize:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (iOS11) {
        
        self.tableView.sectionHeaderHeight = 0.1f;
        self.tableView.sectionFooterHeight = 20.f;
    }
    [self.view addSubview:self.tableView];
}

-(void)createFootView{
    
    self.footView = [[detailFootCellView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    self.footView.delegate = self;
    
    [self.view addSubview:self.footView];
}

#pragma mark -- 考证详情
-(void)loadDetailData{
    
    DDLog(@"%@",self.subjectId);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    __weak typeof(self) weakSelf = self;
    NSString *subjectStr = [NSString stringWithFormat:@"%@",self.subjectId];
    NSDictionary *param = @{@"subjectId":subjectStr,@"userId":userId,@"CreateDate":@""};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:subjectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSDictionary *menuListDict = dict[@"menuList"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            //收藏
            collectStatus = [dict[@"collectStatus"]intValue];
            //点赞
            likeCount = [menuListDict[@"like"]intValue];
            commentCount = [menuListDict[@"comment_count"]intValue];
            collectCount = [menuListDict[@"collect_count"]intValue];
            DDLog(@"%d",likeCount);
            beforeURL = menuListDict[@"ccaaUrl"];
            
            titleStr = menuListDict[@"title"];
            subId = menuListDict[@"id"];
            DDLog(@"%@",titleStr);
            
            personStr = [NSString stringWithFormat:@"已有%@人报名",menuListDict[@"apply_count"]];
            testTime = [NSString stringWithFormat:@"%@",menuListDict[@"examDate"]];
            examTime = menuListDict[@"examDate"];
            willTestCard = menuListDict[@"exam_schedule"];
            get_adtrss = menuListDict[@"get_address"];
            instroduceStr = menuListDict[@"referral"];
            testAddress = menuListDict[@"address"];
            self.listArray = dict[@"list"];
            for (NSDictionary *appdict in self.listArray) {
                
                textDetailListModel *model = [[textDetailListModel alloc]init];
                [model yy_modelSetWithDictionary:appdict];
                [self.dataArray addObject:model];
                [self.categoryArray addObject:model.type_name];
                [self.categoryId addObject:model.id];
                [self.subjectCountAry addObject:model.subject_count];
                [self.priceArray addObject:model.subject_money];
                priceStr = model.subject_money;
            }
            
            // ------实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];//这里的格式必须和DateString格式一致
            
            // ------将需要转换的时间转换成 NSDate 对象
            NSDate * nowDate = [NSDate date];
            //    NSDate *beginDate = [dateFormatter dateFromString:menuList[@"biginDate"]];
            NSDate *endDate = [dateFormatter dateFromString:menuListDict[@"endDate"]];
            
            // ------取当前时间和转换时间两个日期对象的时间间隔
            //    NSTimeInterval time = [nowDate timeIntervalSinceDate:beginDate];
            overTime = [nowDate timeIntervalSinceDate:endDate];
            
            NSDictionary *userAddDict = dict[@"userAdd"];
            NSString *str = userAddDict[@"name"];
            NSString *str1 = [str stringByAppendingString:@" "];
            NSString *str2 = [str1 stringByAppendingString:userAddDict[@"school"]];
            getAdress = str2;
            NSString *str3 = [str2 stringByAppendingString:@"\n"];
            getAdressStr = [str3 stringByAppendingString:userAddDict[@"address_name"]];
            
            DDLog(@"%@",getAdress);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                allRecommentModel *model = [[allRecommentModel alloc]init];
                [model yy_modelSetWithDictionary:menuListDict];
                [self.firstArray addObject:model];
                
                NSString *commentStr = [NSString stringWithFormat:@"%d",commentCount];
                [self.footView.commentBtn setTitle:commentStr forState:UIControlStateNormal];
                likeStatus = [dict[@"likeStatus"]intValue];
                
                NSString *collectStr = [NSString stringWithFormat:@"%d",collectCount];
                [self.footView.collectBtn setTitle:collectStr forState:UIControlStateNormal];
                
                if (collectStatus == 0) {
                    
                    [self.footView.collectBtn setImage:[UIImage imageNamed:@"nices2"] forState:UIControlStateNormal];
                    self.footView.collectBtn.selected = YES;
                }else{
                    
                    [self.footView.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
                    self.footView.collectBtn.selected = NO;
                }
                
                NSString *likeStr = [NSString stringWithFormat:@"%d",likeCount];
                [self.footView.likeBtn setTitle:likeStr forState:UIControlStateNormal];
                if (likeStatus == 0 ) {
                    
                    [self.footView.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
                    self.footView.likeBtn.selected = YES;
                }else{
                    
                    [self.footView.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
                    self.footView.likeBtn.selected = NO;
                }
                if (overTime >0){
                    
                    _footView.payBtn.backgroundColor = [UIColor colorWithHexString:@"#b1b4b3"];
                    [_footView.payBtn setTitle:@"报名结束" forState:UIControlStateNormal];
                }else{
                    
                    [_footView.payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
                    _footView.payBtn.backgroundColor = [UIColor colorWithHexString:@"#f37f13"];
                }
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _netStatus1 = [NSString stringWithFormat:@"%@",@"1"];
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0||section == 1) {
        return 1;
    }else if(section == 2){
        
        return self.dataArray.count + 1;
    }else if(section == 5){
     
        return 1;
    }else{
        
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        testdetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testdetailCell"];
        if (!cell) {
            cell = [[testdetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testdetailCell"];
        }
        
        cell.delegate = self;
        if (self.firstArray.count > 0) {
            
            allRecommentModel *mdoel = self.firstArray[0];
            cell.model = mdoel;
        }else{
        
            cell.titleLale.text = self.activityTitle;
        }
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        
        instroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instroduceCell"];
        if (!cell) {
            cell = [[instroduceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"instroduceCell"];
        }
        
        if (self.firstArray.count > 0) {
            
            allRecommentModel *mdoel = self.firstArray[0];
            cell.model = mdoel;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
            testAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testAddressCell"];
            if (!cell) {
                cell = [[testAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testAddressCell"];
            }
            cell.titleLb.text = @"考试费用";
            cell.arrowImage.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            
            testPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testPriceCell"];
            if (!cell) {
                cell = [[testPriceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testPriceCell"];
            }
            
            cell.headView.hidden =YES;
            cell.titleLb.hidden = YES;
            textDetailListModel *mdoel = self.dataArray[indexPath.row -1];
            cell.detailModel = mdoel;
            cell.indexpath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if(indexPath.section == 3||indexPath.section == 4){
        
        if (indexPath.row == 0) {
            testAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testAddressCell"];
            if (!cell) {
                cell = [[testAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testAddressCell"];
            }
            if (indexPath.section == 3) {
               
                cell.titleLb.text = @"考试时间";
            }else{
            
                cell.titleLb.text = @"考试地点";
            }
            
            cell.arrowImage.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            
            examTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"examTimeCell"];
            if (!cell) {
                cell = [[examTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"examTimeCell"];
            }
            
                if (self.firstArray.count > 0) {
                    
                     if (indexPath.section == 3) {
                    allRecommentModel *mdoel = self.firstArray[0];
                    cell.model = mdoel;
                     }else{
                         
                         NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                         paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
                         paraStyle.alignment = NSTextAlignmentLeft;
                         paraStyle.lineSpacing = 4; //设置行间距
                         //设置字间距 NSKernAttributeName:@1.5f
                         NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paraStyle};
                         NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:testAddress attributes:dic];
                         cell.headLb.attributedText = attributeStr;
                     }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(indexPath.section == 5){
        
        testAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testAddressCell"];
        if (!cell) {
            cell = [[testAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testAddressCell"];
        }
       
        cell.titleLb.text = @"成绩查询";
        cell.arrowImage.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    
        if (indexPath.row == 0) {
            testAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testAddressCell"];
            if (!cell) {
                cell = [[testAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testAddressCell"];
            }
//            if (indexPath.section == 6) {
//
//                cell.titleLb.text = @"考前辅导";
//            }else{
            
                cell.titleLb.text = @"备注说明";
                cell.arrowImage.hidden = YES;
//            }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            beiZhuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beiZhuCell"];
            if (!cell) {
                cell = [[beiZhuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"beiZhuCell"];
            }
//            if (indexPath.section == 6) {
//
//                cell.headLb.text = @"招生机构：新贝青少儿教育中心";
//                cell.headLb1.text = @"咨询电话：400-8812-318";
//                cell.headLb2.text = @"学校为沪上专业青少儿考证培训基地，拥有15个教学网点，师资力量雄厚，学员考证合格率屡创新高！";
//            }else{
            
                cell.headLb.text = @"1、报名成功后，可通过本APP“我的考证”下载打印";
                cell.headLb1.text = @"2、考试结束后，可通过本APP”我的考证“查询，成绩合格的考生，选择领取地点，证书自取。";
                cell.headLb2.text = @"3、最新的报考信息，我们将通过手机短信通知";
//            }
//            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    if (indexPath.section == 6 && indexPath.row == 0) {
//
//        beforeTestController *testVC = [[beforeTestController alloc]init];
//        testVC.beforeURL = beforeURL;
//        [self.navigationController pushViewController:testVC animated:NO];
//    }else
        if(indexPath.section == 5){
        
        queryResultController *query = [[queryResultController alloc]init];
        query.signStr = @"test";
        [self.navigationController pushViewController:query animated:YES];
    }
}

-(void)payFootView{
    
    if (self.netStatus1 == NO) {
        
    [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }else{
    
        DDLog(@"%@",typeName);
        NSString *sunjectId = [NSString stringWithFormat:@"%@",taskId];
        DDLog(@"%@",sunjectId);
        
        if (overTime >0){
            
            [self showAlertWithMessage:@"此报名已结束"];
        }else{
            
            DDLog(@"%@",self.subjectCountAry);
            CommonSheet *sheet = [[CommonSheet alloc]initWithDelegate:self];
            sheet.subjectId = self.subjectId;
            sheet.dataArray = self.categoryArray;
            sheet.categoryId = self.categoryId;
            sheet.subject_money = self.priceArray;
            sheet.subjectCount = self.subjectCountAry;
            [sheet setupSubView];
            [sheet showTestInView:self.view];
        }
    }
}

#pragma mark -- 电话
-(void)onPhoneInCell:(beiZhuCell *)cell{

    DDLog(@"%ld",cell.indexPath.section);
    if (cell.indexPath.section == 5) {
        
        UIWebView * callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:400-8812-318"]]];
        [self.view addSubview:callWebview];
    }
}

#pragma mark -- 评论
-(void)commentFootView:(detailFootCellView *)footView{
    
    testDetailController *detail = [[testDetailController alloc]init];
    detail.taskId = self.subjectId;
    detail.pictureImg = self.pictureImg;
    detail.titleStr = titleStr;
    detail.contentStr = instroduceStr;
    [self.navigationController pushViewController:detail animated:NO];
}

-(void)selectSubjectCount:(NSString *)subjectCount{
    
    subject_count = subjectCount;
}

-(void)selectChaining:(NSString *)tag{
    
    DDLog(@"%@",tag);
    taskId = tag;

    DDLog(@"%@",subject_count);
    NSString *sunjectId = [NSString stringWithFormat:@"%@",taskId];
    
    if ([ETRegularUtil isEmptyString:sunjectId]) {
        
        [self showAlertWithMessage:@"请选择要报名的类型"];
    }else if([subject_count isEqualToString:@"0"]){
        
        [self showAlertWithMessage:@"此项目已经售完,请选择其它项目"];
    }else{
    
        [self loadOrder];
    }
}

#pragma mark -- 下订单
-(void)loadOrder{
    
    DDLog(@"%@",userId);
    DDLog(@"%@",taskId);
    
    NSDictionary *param = @{@"userId":userId,@"subjectId":self.subjectId,@"typeId":taskId};
    
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
                
                payController *pay = [[payController alloc]init];
                
                DDLog(@"%@",testAddress);
            
                pay.titleStr = titleStr;
                pay.subjectStr = taskId;
                pay.typeName = list[@"type_name"];
                pay.type = self.subjectId;
                pay.orderId = dict[@"orderId"];
                pay.getAddress = getAdressStr;//领取地点
                pay.getTime = willTestCard;
                pay.money = list[@"subject_money"];
                pay.examDate = list[@"subject_date"];
                pay.address = list[@"subject_address"];
                
                pay.pictureImg = menuList[@"comment_img"];
                pay.activityTitle = self.activityTitle;
                pay.subId = subId;
   
                [self.navigationController pushViewController:pay animated:YES];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        DDLog(@"%f",[self cellHeight]);
        return [self cellHeight];
    }else if (indexPath.section == 1){
        
        return [self cellHeight1];
    }else if (indexPath.section == 3 ||indexPath.section == 4){
        
        if (indexPath.row == 0) {
            
            return 44;
        }else{
            
            if (indexPath.section == 3) {
                
                return [self cellHeight2];
            }else{
            
                return [self cellHeight3];
            }
        }
    }else if (indexPath.section == 6){
        
        if (indexPath.row == 0) {
            return 44;
        }else{
        
//           if (indexPath.section == 6) {
//
//                return 100 + 10*5;
//            }else{
            
                return 80 + 10*10;
//            }
        }
    }else{
    
        return 44;
    }
}

- (CGFloat)cellHeight{
    
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
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:22], NSParagraphStyleAttributeName:paraStyle};
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 15 -15 - 20 - 20 - 1 - 18, CGFLOAT_MAX);
    CGSize size = [titleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    if (size.height < 27) {
        
        self.headHeight = 118;
        
    }else{
        
        self.headHeight = size.height + 15 + 20 + 20 + 10;
        DDLog(@"%f",size.height);
    }
    
    return self.headHeight;
}

- (CGFloat)cellHeight1{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    /** 行高 */
    paraStyle.lineSpacing = 5;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle};
    CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 15 -15, CGFLOAT_MAX);
    CGSize size = [instroduceStr boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.subjectHeight = size.height + 44 + 15 + 15;
    return self.subjectHeight;
}

- (CGFloat)cellHeight2{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    /** 行高 */
    paraStyle.lineSpacing = 4;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle};
    
    DDLog(@"%@",self.examCell.headLb.text);
    CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 15 -15, CGFLOAT_MAX);
    CGSize size = [examTime boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    self.subjectHeight = size.height + 20;
    return self.subjectHeight;
}

-(CGFloat)cellHeight3{

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    /** 行高 */
    paraStyle.lineSpacing = 5;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle};
    CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 15 -15, CGFLOAT_MAX);
    CGSize size = [testAddress boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.subjectHeight = size.height + 20;
    return self.subjectHeight;
}

-(void)shareCell:(testdetailCell *)cell{
    
    if (self.netStatus1 == YES) {
        
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
        
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            [self shareWebPageToPlatformType:platformType];
        }];
    }else{
    
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pictureImg]];
    UIImage *thumImage = [UIImage imageWithData:data];
    
    if (!thumImage) {
        
        thumImage = [UIImage imageNamed:@"lianjie"];
    }
    
    UILabel * lable = [[UILabel alloc]init];
    lable.textAlignment = NSTextAlignmentRight;
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:instroduceStr thumImage:thumImage];
    
    //设置网页地址
    NSString *baseStr1 = [NSString stringWithFormat:@"http://www.uujz.me:8082/neworld/user/162?userId=%@",userId];
    NSString *baseStr2 = [NSString stringWithFormat:@"&taskId=%@",subId];
    NSString *str = [baseStr1 stringByAppendingString:baseStr2];
    DDLog(@"%@",str);
    
    shareObject.webpageUrl = str;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark -- 底视图的收藏
-(void)collectFootView:(detailFootCellView *)footView{
    
    if (footView.collectBtn.selected == YES) {
        
        [footView.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
        collectCount = collectCount -1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",collectCount];
        DDLog(@"%@",likeStr);
        [footView.collectBtn setTitle:likeStr forState:UIControlStateNormal];
        collectNumber = 0;
        collectStatus = 1;
        footView.collectBtn.selected = NO;
    }else{
        
        [footView.collectBtn setImage:[UIImage imageNamed:@"nices2"] forState:UIControlStateNormal];
        collectCount = collectCount +1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",collectCount];
        DDLog(@"%@",likeStr);
        [footView.collectBtn setTitle:likeStr forState:UIControlStateNormal];
        collectNumber = 1;
        collectStatus = 0;
        footView.collectBtn.selected = YES;
    }
    
    [self loadDetailCollectData];
}

-(void)loadDetailCollectData{
    
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSString *subjectStr = [NSString stringWithFormat:@"%@",self.subjectId];
    NSString *collectStr = [NSString stringWithFormat:@"%d",collectNumber];
    
    NSDictionary *param = @{@"taskId":subjectStr,@"userId":userId,@"type":@"2",@"status":collectStr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:collectURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 点赞
-(void)likeFootView:(detailFootCellView *)footView{
    
    DDLog(@"%d",likeCount);
    if (footView.likeBtn.selected == YES) {
        
        [self.footView.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        likeCount = likeCount -1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeCount];
        DDLog(@"%@",likeStr);
        [footView.likeBtn setTitle:likeStr forState:UIControlStateNormal];
        collectNumber = 0;
        footView.likeBtn.selected = NO;
    }else{
        
        [footView.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
        likeCount = likeCount + 1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeCount];
        DDLog(@"%@",likeStr);
        [footView.likeBtn setTitle:likeStr forState:UIControlStateNormal];
        collectNumber = 1;
        footView.likeBtn.selected = YES;
    }
    
    [self loadDetailLikeData];
}

-(void)loadDetailLikeData{
    
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSString *subjectStr = [NSString stringWithFormat:@"%@",self.subjectId];
    NSString *collectStr = [NSString stringWithFormat:@"%d",collectNumber];
    DDLog(@"%@",collectStr);
    
    NSDictionary *param = @{@"taskId":subjectStr,@"userId":userId,@"type":@"2",@"status":collectStr,@"typeStatus":@"1"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:testLikeURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20.f;
}

-(void)presentVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
