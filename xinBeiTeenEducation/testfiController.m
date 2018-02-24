//
//  testfiController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "testfiController.h"
#import "TableViewCell.h"
#import "messDetailModel.h"
#import "personController.h"

@interface testfiController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;

}

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *sexView;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UIView *vepeView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *messageLable;
@property (nonatomic,strong) UILabel *sourceLable;
@property (nonatomic,strong) UILabel *messageContLab;
@property (nonatomic,strong) UILabel *sourceContLab;
@property (nonatomic,strong) UIView *sepeView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *testBtn;
@property (nonatomic,strong) UIButton *blackBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) messDetailModel *detailModel;

@end

@implementation testfiController
static NSString *addressStr;
static NSString *atcleCount;
static NSString *personStr;
static NSString *userId;
static int count;
static int os;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createTableView];
    [self createHttpRequest];
    [self loadData];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"详细资料";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 10, 19);
    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
}

-(void)createTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)goBack{

    [self.navigationController popViewControllerAnimated:NO];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    self.headView = headView;
    self.headView.backgroundColor = [UIColor whiteColor];
    
    self.vepeView = [[UIView alloc]init];
    self.vepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.headView addSubview:self.vepeView];
    
    self.imgView = [[UIImageView alloc]init];
    self.imgView.image =[UIImage imageNamed:@"ride_snap_default"];
    [self.headView addSubview:self.imgView];
    
    self.titleLable = [[UILabel alloc]init];
    self.titleLable.text = @"张三";
    self.titleLable.font = [UIFont systemFontOfSize:15];
    [self.headView addSubview:self.titleLable];
    
    self.sexView = [[UIImageView alloc]init];
    self.sexView.image =[UIImage imageNamed:@"ride_snap_default"];
    [self.headView addSubview:self.sexView];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.headView addSubview:self.lineView];
    
    self.messageLable = [[UILabel alloc]init];
    self.messageLable.text = @"请求信息";
    [self.headView addSubview:self.messageLable];
    
    self.messageContLab = [[UILabel alloc]init];
    self.messageContLab.text = @"请求添加好友";
    self.messageContLab.textColor = [UIColor lightGrayColor];
    [self.headView addSubview:self.messageContLab];
    
    self.sourceLable = [[UILabel alloc]init];
    self.sourceLable.text = @"来源方式";
    [self.headView addSubview:self.sourceLable];
    
    self.sourceContLab = [[UILabel alloc]init];
    self.sourceContLab.text = @"来自你发表的文章,或家长圈";
    self.sourceContLab.textColor = [UIColor lightGrayColor];
    [self.headView addSubview:self.sourceContLab];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.headView addSubview:self.sepeView];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_detailModel.faceImg]placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    
    NSString *sexStr = [NSString stringWithFormat:@"%@",_detailModel.sex];
    if ([sexStr isEqualToString: @"0"]) {
        
        self.sexView.image = [UIImage imageNamed:@"girl"];
    }else {
        
        self.sexView.image = [UIImage imageNamed:@"boy"];
    }
    
    if (os == 1) {
        
        self.titleLable.text = _detailModel.nickName;
    }else{
        
        if (self.detailModel.remarkName) {
            
            self.titleLable.text = _detailModel.remarkName;
        }else{
            
            self.titleLable.text = _detailModel.nickName;
        }
        
    }

    [self layoutUI];
    return self.headView;
}

-(void)layoutUI{
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
        make.bottom.equalTo(weakSelf.titleLable.mas_bottom);
        make.left.equalTo(weakSelf.titleLable.mas_right).offset(10);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.vepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
        
    }];

    [self.messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.vepeView.mas_bottom);
        make.left.equalTo(weakSelf.headView).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(70);
    }];
    
    [self.messageContLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.messageLable.mas_right).offset(10);
        make.top.equalTo(weakSelf.messageLable.mas_top);
        make.right.equalTo(weakSelf.headView).offset(-15);
        make.height.mas_equalTo(40);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.messageLable.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.headView).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.sourceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.messageLable.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.headView).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(70);
    }];

    [self.sourceContLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.sourceLable.mas_right).offset(10);
        make.top.equalTo(weakSelf.sourceLable.mas_top);
        make.right.equalTo(weakSelf.headView).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sourceContLab.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    self.footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 60)];
    [self.footView setBackgroundColor:[UIColor colorWithHexString:@"#f2f2f2"]];
    
    self.testBtn =[[UIButton alloc]init];
    [self.testBtn setTitle:@"通过验证" forState:UIControlStateNormal];
    [self.testBtn addTarget:self action:@selector(testMessage) forControlEvents:UIControlEventTouchUpInside];
    self.testBtn.backgroundColor = [UIColor colorWithRed:0.164 green:0.657 blue:0.915 alpha:1.000];
    [self.footView addSubview:self.testBtn];
    
    self.blackBtn = [[UIButton alloc]init];
    [self.blackBtn setTitle:@"加入黑名单" forState:UIControlStateNormal];
    [self.blackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.blackBtn.backgroundColor = [UIColor whiteColor];
    [self.footView addSubview:self.blackBtn];
    
    [self layoutUI1];
    return self.footView;
}

-(void)testMessage{

}

-(void)layoutUI1{

    __weak typeof(self)weakSelf = self;
    [self.testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.footView).offset(20);
        make.left.equalTo(weakSelf.footView).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
        make.height.mas_equalTo(40);
    }];
    
    [self.blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.testBtn.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.footView).offset(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 60);
        
    }];
}

#pragma mark --详细资料
-(void)loadData{
    
    self.detailModel = [[messDetailModel alloc]init];
    __weak typeof(self) weakSelf = self;
    
    DDLog(@"%@",self.from_target);
    //请求参数
    NSDictionary *param = @{@"userId":userId,@"target_uid":self.from_target,@"status":@"0"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:isFriendURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
       int status = [dict[@"status"]intValue];
        os = [dict[@"os"]intValue];
        DDLog(@"%d",os);
        count = [dict[@"count"]intValue];
        
        if (status == 0) {
            NSDictionary *menuList = dict[@"menuList"];
            
            [weakSelf.detailModel yy_modelSetWithDictionary:menuList];
            addressStr = _detailModel.address;
            personStr = _detailModel.sdasd;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell =[[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *atcleCount = [NSString stringWithFormat:@"%d",count];
    
    if (indexPath.row == 0) {
        
        [cell setCellInfowithTitle:@"所在地区" withSubTitle:addressStr withArrow:NO];
    }else if (indexPath.row == 1){
        
        [cell setCellInfowithTitle:@"发表文章" withSubTitle:atcleCount withArrow:YES];
    }else if(indexPath.row == 2){
        
        [cell setCellInfowithTitle:@"个性签名" withSubTitle:personStr withArrow:NO];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [tableView deselectRowAtIndexPath:indexPath animated:YES];

    personController *person = [[personController alloc]init];
    person.target_uid = self.from_target;
    person.artCount = [NSString stringWithFormat:@"%d",count];
    person.titleStr = self.titleLable.text;
    [self.navigationController pushViewController:person animated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 180;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 140;
}

//#pragma mark -- 对头视图的处理使之不滚动
////去掉UItableview headerview黏性  ，table滑动到最上端时，header view消失掉。
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 180;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

@end
