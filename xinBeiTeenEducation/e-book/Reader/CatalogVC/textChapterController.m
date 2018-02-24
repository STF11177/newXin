//
//  textChapterController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import "textChapterController.h"
#import "LSYCatalogViewController.h"
#import "eBookPictureModel.h"

static  NSString *chapterCell = @"chapterCell";
@interface textChapterController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tabView;
@property (nonatomic) NSUInteger readChapter;
@property (nonatomic,strong) NSString *bookStr;
@property (nonatomic,strong) NSMutableArray *chapterArray;
@end

@implementation textChapterController
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tabView];
    [self addObserver:self forKeyPath:@"readModel.record.chapter" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [_tabView reloadData];
    
}
-(UITableView *)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc] init];
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


#pragma mark - UITableView Delagete DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chapterArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chapterCell];
    }
    
    eBookPictureModel *model = self.chapterArray[indexPath.row];
    
    cell.textLabel.text = model.typeName;
    
    if ([self.delegate respondsToSelector:@selector(catalog:didSelectChapter:)]) {
        [self.delegate catalog:nil didSelectChapter:indexPath.row];
    }
    
    //    if (indexPath.row == _readModel.record.chapter) {
    //        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    //    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if ([self.delegate respondsToSelector:@selector(catalog:didSelectChapter:page:)]) {
    //        [self.delegate catalog:nil didSelectChapter:indexPath.row page:0];
    //    }
    
    
    if ([self.delegate respondsToSelector:@selector(catalog:didSelectChapter:)]) {
        [self.delegate catalog:nil didSelectChapter:indexPath.row];
    }
    
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
