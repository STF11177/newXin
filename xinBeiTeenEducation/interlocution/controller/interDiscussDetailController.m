//
//  interDiscussDetailController.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interDiscussDetailController.h"
#import "discussDetailCell.h"
#import "interDiscussCommentCell.h"
#import "discussDetailView.h"
#import "keyBoardView.h"
#import "interReplyController.h"
#import "MBProgressHUD.h"

#define userDefault [NSUserDefaults standardUserDefaults]

@interface interDiscussDetailController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,discussDetailDelegate,keyBoardViewDelegate,discussDetailViewDelegate>
{
    
    BOOL _isHide;
    AFHTTPRequestOperationManager *_manager;
    CGFloat _totalKeybordHeight;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *minDateArray;
@property (nonatomic,strong) NSMutableArray *commentIdDateArray;
@property (nonatomic,strong) NSMutableArray *commentIdArray;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) CGFloat webHeight;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) discussDetailView *footView;
@property (nonatomic,strong) keyBoardView *keyBoard;
@property (nonatomic,strong) NSString *currentConmmentId;
@property (nonatomic,strong) discussDetailCell *detailCell;
@property (nonatomic,strong) interDiscussCommentCell *headCell;
@property (nonatomic,strong) MBProgressHUD *progressHud;
@property (nonatomic,strong) detailCommentModel *detailModel;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) NSString *createNewDate;
@property (nonatomic,assign) BOOL nextStr;
@property (nonatomic,assign) BOOL fromDiscuss;//从上一个界面
@property (nonatomic,assign) BOOL commentIdIsTen;//10条数据加载完

@end

@implementation interDiscussDetailController
static NSString *userId;
static NSString *from_uid;//变量
static NSString *commentCount;
static NSString *likeCount;
static NSString *commentLike;
static NSString *commentId;
static NSString *faceImge;
static NSString *nickName;
static NSString *remarkName;
static NSString *remarkContent;
static NSString *commentIdDate;
static int commnetIdCount;
static int fromDisCussCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createHttp];
    [self createNav];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self createWebViewWithCommentStr:self.commentStr];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //nextBtn
    self.fromDiscuss = YES;
    self.commentIdIsTen = YES;
    commnetIdCount = 0;
    commentId = self.commentStr;
    fromDisCussCount = 0;
    
    _keyBoard = [[keyBoardView alloc]initWithFrame:CGRectMake(0, ScreenHeight , ScreenWidth, 44)];
    _keyBoard.delegate = self;
    [self.view addSubview:_keyBoard];
    
    [self loadMore];
    
    NSDictionary *param = @{@"userId":userId,@"commentId":self.commentStr,@"createDate":@""};
    [self createCommentWithParam:param];
    
    [self.tableView registerClass:[discussDetailCell class] forCellReuseIdentifier:@"discussDetailCell"];
    [self.tableView registerClass:[interDiscussCommentCell class] forCellReuseIdentifier:@"interDiscussCommentCell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
//    [self createCommentIdData];
    
    DDLog(@"%@",self.createArray);
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createNav{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"问答详情";
    lable.font = [UIFont systemFontOfSize:20];
    lable.textColor = [UIColor blackColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)presentVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (iOS11) {
            
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

-(discussDetailView *)footView{
    
    if (!_footView) {
     
        _footView = [[discussDetailView alloc]initWithFrame:CGRectMake(0, ScreenHeight, SCREEN_WIDTH, 44)];
        _footView.delegate = self;
    }
    return _footView;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)minDateArray{
    
    if (!_minDateArray) {
        
        _minDateArray = [[NSMutableArray alloc]init];
    }
    return _minDateArray;
}

-(NSMutableArray *)commentIdArray{

    if (!_commentIdArray) {
        
        _commentIdArray = [[NSMutableArray alloc]init];
    }
    return _commentIdArray;
}

-(NSMutableArray *)commentIdDateArray{
    
    if (!_commentIdDateArray) {
        
        _commentIdDateArray = [[NSMutableArray alloc]init];
    }
    return _commentIdDateArray;
}

-(void)createWebViewWithCommentStr:(NSString *)commentStr{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.tableHeaderView = _headView;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.scrollEnabled = YES;
    _webView.scrollView.bounces = NO;
    [_webView sizeToFit];
    _webView.backgroundColor = [UIColor brownColor];
    
    DDLog(@"%@",userId);
    NSString *bodyView = [NSString stringWithFormat:@"userId=%@&commentId=%@",userId,commentStr];
    DDLog(@"bodyView:%@",bodyView);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:interDiscussDetailURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyView dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest:request];
    
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    for (UIView *_aView in [_webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:YES];
            //右侧的滚动条
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    [_headView addSubview:self.webView];
}

#pragma mark -- WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURL *URL = navigationAction.request.URL;
    DDLog(@"%@",URL);
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if([strRequest containsString:@"http://106.14.251.200/neworld/user/143"]) {//主页面加载内容
        
        interReplyController *reply = [[interReplyController alloc]init];
        reply.titleStr = self.titleStr;
        [self.navigationController pushViewController:reply animated:NO];
        
        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
    } else if([strRequest containsString:@"http://106.14.251.200/neworld/user/153"]) {//截获页面里面的链接点击
        
        [_keyBoard resignFirstResponder];
        [self.navigationController popViewControllerAnimated:NO];
//        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);//允许跳转
    }
        else{
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHud.mode = MBProgressHUDModeText;
    self.progressHud.progress = 0.4;
    
    self.progressHud.dimBackground = NO; //设置有遮罩
    self.progressHud.labelText = @"加载中"; //设置进度框中的提示文字
    [self.progressHud show:YES]; //显示进度框
    //添加ProgressHUD到界面中
    [self.view addSubview:self.progressHud];
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __weak __typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable any, NSError * _Nullable error) {

        NSString *heightStr = [NSString stringWithFormat:@"%@",any];
        weakSelf.webHeight = heightStr.floatValue;

        weakSelf.webView.frame = CGRectMake(0, 0, ScreenWidth, weakSelf.webHeight);

        CGRect newFrame=_webView.frame;
        newFrame.size.height= weakSelf.webHeight;
        _webView.frame = newFrame;
        [_webView.scrollView setContentSize:CGSizeMake(ScreenWidth,weakSelf.webHeight)];
        
        _headView.frame= newFrame;
        [self.tableView setTableHeaderView:_headView];//这句话才是重点
        
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight - 44);
        _footView.frame = CGRectMake(0, ScreenHeight - 44, SCREEN_WIDTH, 44);

        
        [[ETMessageView sharedInstance] hideMessage];
        [self.tableView reloadData];
        
        [self.progressHud hide:YES];
    }];
}

- (void)textFieldDelegate:(discussDetailView *)field {
   
}

#pragma mark -- 底部的评论
- (void)commentBtnInView:(discussDetailView *)view{
    
    if (self.tableView.contentOffset.y == 0) {
        
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }else{
        
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    }
}

#pragma mark -- 底部的点赞
- (void)likeBtnInView:(discussDetailView *)view{
    
    NSString *likeStatus;
    int likeCount;
    if (view.likeBtn.selected == YES) {
    
        likeStatus = @"0";
        view.likeBtn.selected = NO;
        
        likeCount = [commentLike intValue] -1;
        
    }else{
        
        likeStatus = @"1";
        view.likeBtn.selected = YES;
        likeCount = [commentLike intValue] +1;
    }
    
    commentLike = [NSString stringWithFormat:@"%d",likeCount];
    self.headCell.likeLb.text = [NSString stringWithFormat:@"%@ 赞",commentLike];
    
    NSDictionary *param = @{@"userId":userId,@"commentId":self.commentStr,@"type":@"5",@"status":likeStatus};
    [self createLikeWithParam:param];
}

#pragma mark -- 底部的下一条
- (void)nextBtnInView:(discussDetailView *)view {
    
    //从上一个界面进入
    if (self.fromDiscuss == YES) {
        for (int i =0; i<self.createArray.count; i++) {
            
            NSString *string = [NSString stringWithFormat:@"%@",self.createArray[i]];
            NSString *string1 = [NSString stringWithFormat:@"%@",commentId];
            if ([string isEqualToString:string1]) {
                
                fromDisCussCount = i;
            }
        }
    }else{
        
        if (commnetIdCount != self.commentIdArray.count && self.commentIdArray.count != 0) {
            
            commentId = self.commentIdArray[commnetIdCount];
            commnetIdCount = commnetIdCount +1;
            _commentIdIsTen = YES;
        }
    }
    
    DDLog(@"%d",fromDisCussCount);
    DDLog(@"%lu",(unsigned long)self.createArray.count);
    if (fromDisCussCount != self.createArray.count -1) {
       
        commentId = self.createArray[fromDisCussCount + 1];
    }else{
        
        if (commnetIdCount == self.commentIdArray.count) {
        self.fromDiscuss = NO;
        [self createCommentIdData];
        }
    }
    
    if (_commentIdIsTen == YES) {
     
        self.commentStr = commentId;
        self.tableView.frame = CGRectZero;
        self.footView.frame = CGRectZero;
        [self createWebViewWithCommentStr:commentId];
        self.nextStr = YES;
        NSDictionary *param = @{@"userId":userId,@"commentId":self.commentStr,@"createDate":@""};
        [self createCommentWithParam:param];
    }
}

-(void)createCommentIdData{
    
    DDLog(@"%@",self.minDateStr);
    NSDictionary *param = @{@"userId":userId,@"taskId":self.taskStr,@"createDate":self.minDateStr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:interDetailNextURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        [self.commentIdArray removeAllObjects];
        
        NSArray *menuListArray = dict[@"menuList"];
        for (NSDictionary *appDict in menuListArray) {
            
            [self.commentIdArray addObject:appDict[@"commentId"]];
            [self.commentIdDateArray addObject:appDict[@"createDate"]];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
          
            if (self.commentIdDateArray.count >0) {
                for (int i = 0; i < self.commentIdDateArray.count; ++i) {
                    
                    //遍历数组的每一个`索引`（不包括最后一个,因为比较的是j+1）
                    for (int j = 0; j < self.commentIdDateArray.count -1 - i; ++j) {
                        
                        if ([self compareDate:self.commentIdDateArray[j] withDate:self.commentIdDateArray[j+1]] == -1) {
                            
                            [self.commentIdDateArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        }
                    }
                }
            }
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
              
                if (self.commentIdArray.count != 0) {
                 
                    commnetIdCount = 0;
                    commentId = self.commentIdArray[0];
                    commnetIdCount = commnetIdCount +1;
                    
                    DDLog(@"%@",commentId);
                    self.commentStr = commentId;
                    
                    self.tableView.frame = CGRectZero;
                    self.footView.frame = CGRectZero;
                    [self createWebViewWithCommentStr:commentId];
                    self.nextStr = YES;
                    NSDictionary *param = @{@"userId":userId,@"commentId":self.commentStr,@"createDate":@""};
                    [self createCommentWithParam:param];
                    
                    self.commentIdIsTen = NO;
                    self.minDateStr = [self.commentIdDateArray firstObject];
                }else{
                    
                    [self showHint:@"已是最后一页"];
                }
            });
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 回复
-(void)replyBtnInCell:(discussDetailCell *)cell{
    
    detailCommentModel *model = self.dataArray[cell.indexPath.row -1];
    self.currentConmmentId = model.commentId;
    from_uid = model.from_userId;
    [self.footView.commentField becomeFirstResponder];
    remarkContent = model.content;
    remarkName = model.from_nickName;

}

-(void)onCommentInKeyBoard:(keyBoardView *)view{
    
    if ([ETRegularUtil isEmptyString:self.currentConmmentId]) {
        
        self.currentConmmentId = @"";
    }
    
    if ([ETRegularUtil isEmptyString:from_uid]) {
        
        from_uid = self.from_uid;
    }
    
    //把当前要发布的数据记录
    self.detailModel = [[detailCommentModel alloc]init];
    
    self.detailModel.likeCommentStatus = @"1";
    self.detailModel.commentLike = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    self.detailModel.createDate = currentTimeString;
    self.detailModel.faceImg = faceImge;
    self.detailModel.from_nickName = nickName;
    self.detailModel.remarkContent = remarkContent;
    self.detailModel.content = view.textView.text;
    self.detailModel.from_userId = userId;
    self.detailModel.remarkName = remarkName;
    
    NSDictionary *param = @{@"userId":userId,@"from_userId":from_uid,@"taskId":self.commentStr,@"content":view.textView.text,@"comment_id":self.currentConmmentId};
    [self createMessageWithParam:param];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.keyBoard.textView resignFirstResponder];
    [self.footView.commentField resignFirstResponder];
}

#pragma mark --键盘隐藏出现通知
-(void)keyBoardHiden:(NSNotification*)noti{
    
    _isHide = YES;
    _keyBoard.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 44);
}

-(void)keyBoardShow:(NSNotification*)noti
{
    
    [_keyBoard.textView becomeFirstResponder];
    
    NSDictionary *dict = noti.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - 44, rect.size.width, 44);
    
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _keyBoard.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + 44;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
    //    [self adjustTableViewToFitKeyboard];
    }
    
    //    [self adjustSelfFrame:rect.size.height];
    _isHide = NO;
}

#pragma mark --电池的颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    
    return UIStatusBarStyleDefault;
}

#pragma mark -- 评论List
-(void)createCommentWithParam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:interDetailCommentURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        if (self.nextStr == YES) {
            
            [self.dataArray removeAllObjects];
        }
            
        self.nextStr = NO;
        
        [self.minDateArray removeAllObjects];
        
        NSArray *mulistArray = dict[@"menuList"];
//      NSDictionary *dateDic = [mulistArray lastObject];
//      _createDate = dateDic[@"createDate"];
        
        NSDictionary *commentDict = dict[@"commentBean"];
        NSDictionary *userBeanDict = dict[@"userbean"];
        commentCount = commentDict[@"commentCount"];
        commentLike = commentDict[@"commentLike"];
        faceImge = userBeanDict[@"faceImg"];
        nickName = userBeanDict[@"nickName"];
        
        NSString *likeStatus = [NSString stringWithFormat:@"%@",commentDict[@"likeCommentStatus"]];
        if ([likeStatus isEqualToString:@"1"]) {
            
            [self.footView.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
            self.footView.likeBtn.selected = NO;
        }else{
            
            [self.footView.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateSelected];
            self.footView.likeBtn.selected = YES;
        }
        
        for (NSDictionary *appDict in mulistArray) {
            
            detailCommentModel *model = [[detailCommentModel alloc]init];
            [model yy_modelSetWithDictionary:appDict];
            [self.dataArray addObject:model];
            [self.minDateArray addObject:model.createDate];
        }
        
                if (self.minDateArray.count >0) {
                    for (int i = 0; i < self.minDateArray.count; ++i) {
                        
                        //遍历数组的每一个`索引`（不包括最后一个,因为比较的是j+1）
                        for (int j = 0; j < self.minDateArray.count -1 - i; ++j) {
                            
                            if ([self compareDate:self.minDateArray[j] withDate:self.minDateArray[j+1]] == -1) {
                                
                                [self.minDateArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                            }
                        }
                    }
                }
        
        self.createDate = [self.minDateArray firstObject];
       
        if ([ETRegularUtil isEmptyString:self.createDate]) {
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [weakSelf.tableView.mj_footer endRefreshing];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
          
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 发布消息
-(void)createMessageWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:interSendCommentURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSString *commentStr = dict[@"comentId"];
        self.detailModel.commentId = commentStr;
        [self.dataArray insertObject:self.detailModel atIndex:0];
        
        int count = [commentCount intValue] +1;
        commentCount = [NSString stringWithFormat:@"%d",count];
        self.headCell.commentLb.text = [NSString stringWithFormat:@"评论 %@",commentCount];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.keyBoard.textView.text = @"";
            self.footView.commentField.text = @"";
            remarkContent = @"";
            
            [self.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 删除
-(void)deleteInCell:(discussDetailCell *)cell{
    
    detailCommentModel *model = self.dataArray[cell.indexPath.row -1];
    self.currentConmmentId = model.commentId;
    
    self.detailCell = [[discussDetailCell alloc]init];
    self.detailCell = cell;
    
    NSDictionary *param = @{@"userId":userId,@"commentId":self.currentConmmentId,@"taskId":self.commentStr};
    [self createdeleteWithParam:param];
}

-(void)createdeleteWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:interDetailDeleteURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            int count = [commentCount intValue] -1;
            commentCount = [NSString stringWithFormat:@"%d",count];
            self.headCell.commentLb.text = [NSString stringWithFormat:@"评论 %@",commentCount];
            
            [self.dataArray removeObjectAtIndex:self.detailCell.indexPath.row -1];
            [self.tableView deselectRowAtIndexPath:self.detailCell.indexPath animated:NO];
            [self.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 点赞
-(void)likeInCell:(discussDetailCell *)cell{

    self.detailCell = [[discussDetailCell alloc]init];
    self.detailCell = cell;
    
    detailCommentModel *model = self.dataArray[cell.indexPath.row -1];

    NSString *likeStatus;
    if ([model.likeCommentStatus isEqualToString:@"0"]) {

        model.likeCommentStatus = @"1";
        likeStatus = @"0";
        model.commentLike -= 1;
        [self.detailCell.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    }else{

        model.likeCommentStatus = @"0";
        likeStatus = @"1";
        model.commentLike += 1;
        [self.detailCell.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
    }
    
     [cell.likeBtn setTitle:[NSString stringWithFormat:@"%d",model.commentLike] forState:UIControlStateNormal];
    
    NSDictionary *param = @{@"userId":userId,@"commentId":model.commentId,@"type":@"5",@"status":likeStatus};
    [self createLikeWithParam:param];
}

-(void)createLikeWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:commentLikeURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- uitableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count +1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        self.headCell = [tableView dequeueReusableCellWithIdentifier:@"interDiscussCommentCell"];
        if (!self.headCell) {
            
            self.headCell = [[interDiscussCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"interDiscussCommentCell"];
        }
        
        self.headCell.commentLb.text = [NSString stringWithFormat:@"评论 %@",commentCount];
        self.headCell.likeLb.text = [NSString stringWithFormat:@"%@ 赞",commentLike];
        return self.headCell;
    }else{
        
        discussDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discussDetailCell"];
        if (!cell) {
            
            cell = [[discussDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"discussDetailCell"];
        }
        
        detailCommentModel *model = self.dataArray[indexPath.row -1];
        cell.model = model;
        cell.indexPath = indexPath;
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 40;
    }else{
        
        discussDetailCell *cell = [[discussDetailCell alloc]init];
        detailCommentModel *model = self.dataArray[indexPath.row -1];
        return [cell cellHeightWithModel:model];
    }
}

#pragma mark -- 下拉加载
-(void)loadMore{
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
}

-(void)loadLastData{
    
    DDLog(@"%@",self.minDateArray);
    
    self.createDate = [self.minDateArray firstObject];
    
    if ([ETRegularUtil isEmptyString:self.createDate]) {
        
        self.createDate = @"";
    }
    NSDictionary *param = @{@"userId":userId,@"commentId":self.commentStr,@"createDate":self.createDate};
                [self createCommentWithParam:param];
}

//2个时间字符串的比较
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc]init];
    NSDate *dt2 = [[NSDate alloc]init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result){
            
            //date02比date01大
        case NSOrderedAscending: ci = 1;
            break;
            //date02比date01小
        case NSOrderedDescending: ci = -1;
            break;
            //date02=date01
        case NSOrderedSame: ci=0;
            break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
    return ci;
}

@end
