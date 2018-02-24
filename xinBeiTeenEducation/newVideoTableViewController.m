////
////  newVideoTableViewController.m
////  xinBeiTeenEducation
////
////  Created by user on 2017/11/3.
////  Copyright © 2017年 user. All rights reserved.
////
//
//#import "newVideoTableViewController.h"
//
//@interface newVideoTableViewController ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
//{
//
//    NSIndexPath *currentIndexPath;
//
//}
//@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic, strong) ZFPlayerView        *playerView;
//@property (nonatomic, strong) ZFPlayerControlView *controlView;
//
//@end
//
//@implementation newVideoTableViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.view.backgroundColor = [UIColor blackColor];
//    self.navigationController.navigationBar.translucent = YES;
//
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//    [self.view addSubview:self.tableView];
//    [self.tableView registerClass:[newVideoCell class] forCellReuseIdentifier:@"newVideoCell"];
//
//    [self createNav];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//
//    self.navigationController.navigationBar.translucent = NO;
//}
//
//-(void)createNav{
//
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
////  [leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(presentLeftMenuViewController) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = item;
//}
//
//-(void)presentLeftMenuViewController{
//
//    [self.navigationController popViewControllerAnimated:NO];
//}
//
//-(UITableView *)tableView{
//    if (!_tableView) {
//
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
//
//        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
//        _tableView.backgroundColor = [UIColor blackColor];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return _tableView;
//}
//
//- (ZFPlayerView *)playerView {
//    if (!_playerView) {
//        _playerView = [ZFPlayerView sharedPlayerView];
//        _playerView.delegate = self;
//        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
//        _playerView.cellPlayerOnCenter = NO;
//
//        //         当cell划出屏幕的时候停止播放
//        //         _playerView.stopPlayWhileCellNotVisable = YES;
//        //        （可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
//        //         _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
//        //         静音
//        //         _playerView.mute = YES;
//        //         移除屏幕移除player
//        //         _playerView.stopPlayWhileCellNotVisable = YES;
//    }
//    return _playerView;
//}
//
//- (ZFPlayerControlView *)controlView {
//    if (!_controlView) {
//        _controlView = [[ZFPlayerControlView alloc] init];
//
//    }
//    return _controlView;
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return 5;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    newVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newVideoCell"];
//
//    if (!cell) {
//        cell = [[newVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newVideoCell"];
//    }
//
//    __block newVideoCell *weakCell     = cell;
//    __block NSIndexPath *weakIndexPath = indexPath;
//    __weak typeof(self)  weakSelf      = self;
//
//    cell.playBlock = ^(UIButton *btn) {
//
//        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
//        NSString *urlString = [NSString stringWithFormat:@"http://baobab.wdjcdn.com/1455968234865481297704.mp4"];
//        playerModel.videoURL =  [NSURL URLWithString:urlString];
//        playerModel.scrollView = weakSelf.tableView;
//        playerModel.indexPath = weakIndexPath;
//
//        playerModel.fatherViewTag = weakCell.backImageView.tag;
//        weakCell.backImageView.userInteractionEnabled = YES;
//        [weakSelf.playerView playerControlView:nil playerModel:playerModel];
//        weakSelf.playerView.hasDownload = NO;
//        [weakSelf.playerView autoPlayTheVideo];
//    };
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 320;
//}
//
//
//@end

