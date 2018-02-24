//
//  eduDetailController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduDetailController.h"
#import "detailHeadCell.h"
#import "authorCell.h"
#import "eduDetailFootView.h"
#import "eduPayController.h"
#import "detailTextCell.h"
#import "ETRegularUtil.h"
#import "eduImageCell.h"
#import "eduButtonCell.h"
#import "UIImage+Extension.h"
#import "educationVIew.h"
#import "eduDetailModel.h"
#import "eduHeadView.h"

@interface eduDetailController ()<UITableViewDelegate,UITableViewDataSource,eduDetailFootViewDelete,UIGestureRecognizerDelegate>
{
  AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) eduDetailFootView *footView;
@property (nonatomic,strong) detailTextCell *detailCell;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) eduHeadView *photoView;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) NSArray *imageArray;//头视图的图片
@property (nonatomic,strong) NSMutableArray *eduImgArray;//简介
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic) CGFloat imageHeight;
@property (nonatomic,assign) BOOL imageSign;

@end

@implementation eduDetailController
static int number;
static NSString *userId;
static NSString *titleStr;
static NSString *authorStr;
static NSString *summaryStr;
static NSString *priceStr;
static NSString *saleStr;
static NSString *publishTime;
static NSString *contentStr;
static NSString *imgStr;
static NSString *likeStatus;
static NSString *collectStatus;
static NSString *instroduceImg;
static NSString *expressFeeStr;
static NSString *saleCount;
static int likeNum;
static int collectNum;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self createHttp];
    [self createFootView];
    [self loadDataParam];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    number = 1;
    
    self.fd_interactivePopDisabled = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];

    if (iOS11) {
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    [self loadDataParam];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.tableView registerClass:[detailHeadCell class] forCellReuseIdentifier:@"detailHeadCell"];
    [self.tableView registerClass:[authorCell class] forCellReuseIdentifier:@"authorCell"];
    [self.tableView registerClass:[eduImageCell class] forCellReuseIdentifier:@"eduImageCell"];
    [self.tableView registerClass:[eduButtonCell class] forCellReuseIdentifier:@"eduButtonCell"];
    
    [self createView];
}

-(void)createNav{
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.imageArray = [[NSArray alloc]init];
    self.eduImgArray = [[NSMutableArray alloc]init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"商品";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor blackColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 19, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"arrow-fx1"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(goRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)goRightBtn{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    
    return UIStatusBarStyleDefault;
}

- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,44,44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
        firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5 *kScreenWidth /375.0,0,0)];
    }
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -30) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:_tableView];
}

-(void)loadDataParam{

    //请求参数
    NSDictionary *param = @{@"userId":userId,@"bookId":self.bookStr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:eduBookDetailURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
    
        NSDictionary *menuList = dict[@"menuList"];
        titleStr = menuList[@"bookName"];
        summaryStr = menuList[@"title"];
        
        float price = [menuList[@"constPrice"] floatValue];
        priceStr = [NSString stringWithFormat:@"¥%.2f",price];
        
        float salePrice = [menuList[@"price"] floatValue];
        saleStr = [NSString stringWithFormat:@"¥ %.2f",salePrice];
        
        authorStr = menuList[@"author"];
        publishTime = menuList[@"publishDate"];
        
        contentStr = menuList[@"suggest"];
        imgStr = menuList[@"contentImg"];
        likeStatus = dict[@"likeStatus"];
        collectStatus = dict[@"collectStatus"];
        likeNum = [menuList[@"likeSum"]intValue];
        collectNum = [menuList[@"collectSum"]intValue];
        instroduceImg = [NSString stringWithFormat:@"%@",menuList[@"introduceImg"]];
        
        float expressPrice = [menuList[@"expressFee"] floatValue];
        expressFeeStr = [NSString stringWithFormat:@"快递：%.2f",expressPrice];
        saleCount = [NSString stringWithFormat:@"销售%@笔",menuList[@"count"]];
        
        eduDetailModel *model = [[eduDetailModel alloc]init];
        [model yy_modelSetWithDictionary:menuList];
        [self.dataArray addObject:model];
        
        NSString *footLikeStus = [NSString stringWithFormat:@"%@",likeStatus];
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeNum];
        [self.footView.likeBtn setTitle:likeStr forState:UIControlStateNormal];
        NSString *collectStr = [NSString stringWithFormat:@"%d",collectNum];
        [self.footView.collectBtn setTitle:collectStr forState:UIControlStateNormal];
        if ([footLikeStus isEqualToString:@"0"]) {
            
            [self.footView.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
            self.footView.likeBtn.selected = YES;
        }else{
            
            [self.footView.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
            self.footView.likeBtn.selected = NO;
        }
        
        NSString *footCollectStus = [NSString stringWithFormat:@"%@",collectStatus];
        if ([footCollectStus isEqualToString:@"0"]) {
            
            [self.footView.collectBtn setImage:[UIImage imageNamed:@"nices2"] forState:UIControlStateNormal];
            self.footView.collectBtn.selected = YES;
        }else{
            
            [self.footView.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
            self.footView.collectBtn.selected = NO;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 1) {
        
        return 3;
    }else{
    
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = self.headView;
    headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];

    if (section == 0) {
        
        headView.frame = CGRectMake(0, 0, ScreenWidth, 334);
        self.imageArray = [imgStr componentsSeparatedByString:@"|"];
        
        self.photoView = [[eduHeadView alloc]init];
        self.photoView.frame = CGRectMake(0, 0, 300, 300);
        
        NSMutableArray *oriPArr = [NSMutableArray new];
        for (NSString *pName in self.imageArray) {
        
            [oriPArr addObject:[NSURL URLWithString:pName]];
        }
        self.photoView.picArray = self.imageArray;
        [headView addSubview:self.photoView];
    }
        return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark-- 点赞
-(void)loadLikeData{

    NSDictionary *param = @{@"userId":userId,@"taskId":_bookStr,@"type":@"4",@"status":likeStatus,@"typeStatus":@"1"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:testLikeURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)loadCollectData{

    NSDictionary *param = @{@"userId":userId,@"taskId":_bookStr,@"type":@"4",@"status":collectStatus,@"typeStatus":@"2"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:testLikeURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
       
        detailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailHeadCell"];
        if (!cell) {
            cell = [[detailHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailHeadCell"];
        }

        cell.titleLb.text = titleStr;
        cell.saleLb.text = saleStr;
        cell.expressLb.text = expressFeeStr;
        cell.monthSaleLb.text = saleCount;
        if (![ETRegularUtil isEmptyString:cell.saleLb.text]) {

            NSArray *array = [cell.saleLb.text componentsSeparatedByString:@"."];
            NSString *str = array[0];
            NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:cell.saleLb.text];

            [centStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 1)];
            [centStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(1, str.length)];
            [centStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(str.length+1, 2)];
            cell.saleLb.attributedText = centStr;
        }
    
        //给文字添加贯穿横线
//            NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",priceStr]];
//            [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
//            cell.originPriceLb.attributedText = newPrice;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           return cell;
    }else if(indexPath.section == 1){
          
        if (indexPath.row == 2) {
            
            eduButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eduButtonCell"];
            if (!cell) {
                cell = [[eduButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eduButtonCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            
            authorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"authorCell"];
            if (!cell) {
                cell = [[authorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"authorCell"];
            }
            if (indexPath.row == 0) {
                
                cell.titleLb.text = @"作   者";
                cell.contentLb.text = authorStr;
            }else{
                cell.titleLb.text = @"出版社";
                if ([ETRegularUtil isEmptyString:publishTime]) {
                
                    cell.contentLb.text = @"";
                }else{

                    cell.contentLb.text = [NSString stringWithFormat:@"%@",publishTime];
                }
            }
            cell.lineView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
    
        if ([ETRegularUtil isEmptyString:instroduceImg]) {
            
            self.detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailTextCell"];
            if (!self.detailCell) {
                
                self.detailCell = [[detailTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailTextCell"];
            }
            self.detailCell.contentLb.text = contentStr;
            
            if (![ETRegularUtil isEmptyString:contentStr]) {
                
                NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
                paraStyle.alignment = NSTextAlignmentLeft;
                paraStyle.lineSpacing = 5; //设置行间距
                //设置字间距 NSKernAttributeName:@1.5f
                NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paraStyle};
                NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.detailCell.contentLb.text attributes:dic];
                self.detailCell.contentLb.attributedText = attributeStr;
            }
            
            self.detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.detailCell;
        }else{
        
            eduImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eduImageCell"];
            if (!cell) {
                
                cell = [[eduImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eduImageCell"];
                
                if (self.dataArray.count !=0) {
                    
                    eduDetailModel *model = self.dataArray[0];
                    cell.eduModel = model;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

//底部的delegate
-(void)createFootView{

    self.footView = [[eduDetailFootView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    self.footView.delegate = self;
    [self.view addSubview:self.footView];
}

-(void)payFootView{

    [self loadOrderData];
}

-(void)loadOrderData{

    //请求参数
    NSDictionary *param = @{@"userId":userId,@"bookId":self.bookStr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:eduBookOrderURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        NSString *orderStr = dict[@"orderId"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            eduPayController *pay = [[eduPayController alloc]init];
            pay.bookStr = _bookStr;
            pay.orderIdStr = orderStr;
            [self.navigationController pushViewController:pay animated:YES];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)backFootView:(eduDetailFootView *)footView{
    
   [self.navigationController popViewControllerAnimated:YES];
}

-(void)likeFootView:(eduDetailFootView *)footView{

    if (footView.likeBtn.selected == YES) {
        
        [footView.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        likeNum = likeNum - 1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeNum];
        DDLog(@"%@",likeStr);
        [footView.likeBtn setTitle:likeStr forState:UIControlStateNormal];
        likeStatus = @"0";
    }else{
        
        [footView.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];

        likeNum = likeNum + 1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",likeNum];
        DDLog(@"%@",likeStr);
        [footView.likeBtn setTitle:likeStr forState:UIControlStateNormal];
        likeStatus = @"1";
    }
    footView.likeBtn.selected = !self.footView.likeBtn.selected;
    footView.likeBtn = self.footView.likeBtn;
    [self loadLikeData];
}

-(void)collectFootView:(eduDetailFootView *)footView{

    if (footView.collectBtn.selected == YES) {
        
        [footView.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
        collectNum = collectNum -1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",collectNum];
        [footView.collectBtn setTitle:likeStr forState:UIControlStateNormal];
        collectStatus = @"0";
        footView.collectBtn.selected = NO;
    }else{
        
        [footView.collectBtn setImage:[UIImage imageNamed:@"nices2"] forState:UIControlStateNormal];
        collectNum = collectNum +1;
        NSString *likeStr = [NSString stringWithFormat:@"%d",collectNum];
        DDLog(@"%@",likeStr);
        [footView.collectBtn setTitle:likeStr forState:UIControlStateNormal];
        collectStatus = @"1";
        footView.collectBtn.selected = YES;
    }
    [self loadCollectData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 123;
    }else if(indexPath.section == 1){
    
        return 50;
    }else{
    
        if ([ETRegularUtil isEmptyString:instroduceImg]) {
            
            return [self cellHeight];
        }else{

            
            NSArray *array = [instroduceImg componentsSeparatedByString:@"|"];
            __weak typeof(self) weakSelf = self;
            
            self.imageHeight = 0;
            for (int i = 0; i<array.count; i++) {
                
                UIImageView *imageView = [[UIImageView alloc]init];
                
                [imageView sd_setImageWithURL:array[i] placeholderImage:[UIImage imageNamed:@"edubook"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    [imageView setFrame:CGRectMake(0, weakSelf.imageHeight, ScreenWidth, image.size.height*0.5)];
                    weakSelf.imageHeight  = weakSelf.imageHeight + image.size.height*0.5;
                }];
            }
            DDLog(@"%f",self.imageHeight);
            return self.imageHeight;
        }
    }
}

-(CGFloat)cellHeight{
    
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
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle};
    // 文字的最大尺寸(设置内容label的最大size，这样才可以计算label的实际高度，需要设置最大宽度，但是最大高度不需要设置，只需要设置为最大浮点值即可)，53为内容label到cell左边的距离
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    
    //  计算内容label的高度
    CGRect contenRect = [self.detailCell.contentLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    float cellHeight = contenRect.size.height + 15.0 + 15;
    
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section ==0){
        
        return 334;
    }else{
     
        return 0.1f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 1) {
        
        return 10.f;
    }else{
       
        return 1.0f;
    }
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:YES];
}

@end
