//
//  searchHotController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import "searchHotController.h"
#import "hotSearchBar.h"
#import "hotAticleController.h"
#import "hotCell.h"
#import "hotArticleModel.h"
#import "hotAticleDetailController.h"

#define searchURL @"http://106.14.251.200:8082/neworld/user/135"
@interface searchHotController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) hotSearchBar *hotSearchBar;
@property (nonatomic,strong) UITableView *searchTalbeView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIView *sepView;
@property (nonatomic,strong) UIImageView *artcleImg;
@property (nonatomic,strong) UIImageView *topicImg;
@property (nonatomic,strong) NSMutableArray *dataArray;//搜索结果
@property (nonatomic,strong) NSMutableArray *heightArray;
@property (nonatomic,strong) NSString *createDate;

@end

@implementation searchHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    
    [self createHotView];
    [self layoutUI];
    
    
    //设置背景图是为了去掉上下黑线
    self.hotSearchBar.backgroundImage = [[UIImage alloc] init];
    // 设置SearchBar的颜色主题为白色
    self.hotSearchBar.barTintColor = [UIColor whiteColor];
//    [self refresh];
    [self.searchTalbeView registerClass:[hotCell class] forCellReuseIdentifier:@"hotCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createField];
}

-(void)viewWillDisappear:(BOOL)animated{

    self.hotSearchBar.hidden = YES;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadDataWithparam:(NSDictionary *)param{
    
    [self.dataArray removeAllObjects];
    DDLog(@"%@",self.dataArray);
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:searchURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"%@",dict);
        NSArray *menuList = dict[@"menuList"];
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            NSDictionary *dateDic = [menuList lastObject];
            _createDate = dateDic[@"createDate"];
            
            for (NSDictionary *appDict in menuList) {
                hotArticleModel *model = [[hotArticleModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
            
            DDLog(@"%@",self.dataArray);
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if (self.dataArray.count ==0) {
                    
                    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH,40)];
                    lable.text = @"暂无搜索结果";
                    lable.textColor = [UIColor lightGrayColor];
                    lable.textAlignment = NSTextAlignmentCenter;
                    [self.view addSubview:lable];
                }
                
                [weakSelf getCellHeight];
                [weakSelf.searchTalbeView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)createField{
    
    _hotSearchBar = [[hotSearchBar alloc]initWithFrame:CGRectMake( 30, 30, self.view.frame.size.width -60, 30)];
    _hotSearchBar.backgroundColor = [UIColor clearColor];
    _hotSearchBar.placeholder = @"请输入要搜索的内容";
    _hotSearchBar.delegate = self;
    
    _hotSearchBar.searchBarField.layer.cornerRadius = 15;
    _hotSearchBar.searchBarField.layer.masksToBounds = YES;
    _hotSearchBar.searchBarField.layer.borderWidth = 1.0;
    _hotSearchBar.cursorColor = [UIColor whiteColor];
    [_hotSearchBar setSearchButtonImage:[UIImage imageNamed:@"re_such"]];
    
    
    [_hotSearchBar setClearButtonImage:[UIImage imageNamed:@"re_runt"]];
    _hotSearchBar.showsCancelButton = YES;
    [_hotSearchBar.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
      [_hotSearchBar.cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_hotSearchBar.cancleButton addTarget:self action:@selector(pushClick) forControlEvents:UIControlEventTouchUpInside];
    _hotSearchBar.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    //去掉取消按钮灰色背景
    _hotSearchBar.hideSearchBarBackgroundImage = YES;
    [self.navigationController.view addSubview:_hotSearchBar];
}

-(void)createHotView{
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.heightArray = [[NSMutableArray alloc]init];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.text = @"搜索感兴趣的内容";
    _titleLb.textAlignment = NSTextAlignmentCenter;
    _titleLb.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_titleLb];
    
    _sepView = [[UIView alloc]init];
    _sepView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_sepView];
    
    _artcleImg = [[UIImageView alloc]init];
    _artcleImg.image = [UIImage imageNamed:@"re_pagr"];
    [self.view addSubview:_artcleImg];
    
    _topicImg = [[UIImageView alloc]init];
    _topicImg.image = [UIImage imageNamed:@"re_huati"];
    [self.view addSubview:_topicImg];
}

-(void)layoutUI{
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(120);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.top.equalTo(self.titleLb.mas_bottom).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 60);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.artcleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sepView.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset((SCREEN_WIDTH - 90)/2);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(39);
    }];
    
    [self.topicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sepView.mas_bottom).offset(15);
        make.left.equalTo(self.artcleImg.mas_right).offset(30);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(38);
    }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self createHttp];
    [self createTableView];
    NSDictionary *param = @{@"title":_hotSearchBar.searchBarField.text,@"userId":@"10001",@"createDate":@""};
    [self loadDataWithparam:param];
    [_hotSearchBar resignFirstResponder];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    
}

-(void)createTableView{
    
    _searchTalbeView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 5, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _searchTalbeView.delegate = self;
    _searchTalbeView.dataSource = self;
    _searchTalbeView.tableFooterView = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:_searchTalbeView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    DDLog(@"%ld",_dataArray.count);
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    hotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    if (!cell) {
        
        cell = [[hotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
    }
    
    hotArticleModel *model = self.dataArray[indexPath.row];
    cell.indexpath = indexPath;
    cell.hotModel = model;
    
    // 原始搜索结果字符串.
    NSString *originResult = model.title;
    // 获取关键字的位置
    NSRange range = [model.title rangeOfString:self.hotSearchBar.text];
    // 转换成可以操作的字符串类型.
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:originResult];
    // 添加属性(粗体)
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
    // 关键字高亮
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    
    // 将带属性的字符串添加到cell.textLabel上.
    [cell.contentLb setAttributedText:attribute];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    hotAticleDetailController *hotDetail = [[hotAticleDetailController alloc]init];
    hotArticleModel *model = self.dataArray[indexPath.row];
    hotDetail.taskId = model.id;
    hotDetail.hidesBottomBarWhenPushed = YES;
    self.hotSearchBar.hidden = YES;
    [self.navigationController pushViewController:hotDetail animated:NO];
    self.hidesBottomBarWhenPushed = NO;
    self.hotSearchBar.hidden = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    hotArticleModel *model = self.dataArray[indexPath.row];
    return  model.cellHeight;
}

#pragma mark -- 计算cell的高度
-(void)getCellHeight{
    
    DDLog(@"%@",_dataArray);
    for (int i = 0; i< _dataArray.count; i++) {
        hotArticleModel *model = _dataArray[i];
        
        CGFloat HotcellHeight = 0;
        CGSize maxSize = CGSizeMake(self.view.frame.size.width - 30 - 60, CGFLOAT_MAX);
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
        CGRect contenRect = [model.title boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        HotcellHeight = HotcellHeight + contenRect.size.height;
        HotcellHeight = HotcellHeight + 5 + 30 + 5;
        [_heightArray addObject:[NSString stringWithFormat:@"%f",HotcellHeight]];
    }
}

//#pragma mark -- 刷新
//-(void)refresh{
//    
//    __weak __typeof(self) weakSelf = self;
//    self.searchTalbeView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        NSDictionary *param = @{@"title":_hotSearchBar.searchBarField.text,@"userId":@"10001",@"createDate":@""};
//        [weakSelf loadDataWithparam:param];
//        [weakSelf.dataArray removeAllObjects];
//    }];
//    [self.searchTalbeView.mj_header beginRefreshing];
//    
//    self.searchTalbeView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        
//        NSDictionary *param =@{@"title":_hotSearchBar.searchBarField.text,@"userId":@"10001",@"createDate":_createDate};
//        [weakSelf loadDataWithparam:param];
//    }];
//    [self.searchTalbeView.mj_footer beginRefreshing];
//}

-(void)pushClick{
    
    [self.navigationController popViewControllerAnimated:NO];
    self.hotSearchBar.hidden = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_hotSearchBar.searchBarField resignFirstResponder];
}

//点击cancel 按钮调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //收键盘
    [_hotSearchBar resignFirstResponder];
}

@end
