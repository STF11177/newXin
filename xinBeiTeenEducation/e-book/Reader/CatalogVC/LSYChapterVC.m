//
//  LSYChapterVC.m
//  LSYReader

//  Created by okwei on 16/6/2.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYChapterVC.h"
#import "LSYCatalogViewController.h"
#import "eBookPictureModel.h"

static  NSString *chapterCell = @"chapterCell";
@interface LSYChapterVC ()<UITableViewDelegate,UITableViewDataSource>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tabView;
@property (nonatomic) NSUInteger readChapter;
@property (nonatomic,strong) NSString *bookStr;
@property (nonatomic,strong) NSMutableArray *chapterArray;
@end

@implementation LSYChapterVC
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chapterClick:) name:@"1" object:nil];
    
    [self.view addSubview:self.tabView];
    [self addObserver:self forKeyPath:@"readModel.record.chapter" options:NSKeyValueObservingOptionNew context:NULL];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self createHttpRequest];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)chapterClick:(NSNotification*)text{
    
    self.bookStr = [NSString stringWithFormat:@"%@",text.userInfo[@"bookId"]];
    NSDictionary *param = @{@"userId":userId,@"bookId":self.bookStr};
    [self loadCatalogDataWithParam:param];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [_tabView reloadData];
    
}
-(UITableView *)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ViewSize(self.view).width, ViewSize(self.view).height) style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tabView;
}

-(NSMutableArray *)chapterArray{
    if (!_chapterArray) {
        
        _chapterArray = [[NSMutableArray alloc]init];
    }
    return _chapterArray;
}

#pragma mark -- loading
-(void)loadCatalogDataWithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:eBookPictURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSArray *typeListArray = dict[@"typeList"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            for ( NSDictionary *appDict in typeListArray) {
                
                eBookPictureModel *model = [[eBookPictureModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.chapterArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.tabView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark - UITableView Delagete DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _readModel.chapters.count;
//    return self.chapterArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chapterCell];
    }
    
    cell.textLabel.text = _readModel.chapters[indexPath.row].title;
    if (indexPath.row == _readModel.record.chapter) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
//    eBookPictureModel *model = self.chapterArray[indexPath.row];
//    cell.textLabel.text = model.typeName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(catalog:didSelectChapter:page:)]) {
        [self.delegate catalog:nil didSelectChapter:indexPath.row page:0];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0f;
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"readModel.record.chapter"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"1" object:nil];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tabView.frame = CGRectMake(0, 0, ViewSize(self.view).width, ViewSize(self.view).height);
}

@end

