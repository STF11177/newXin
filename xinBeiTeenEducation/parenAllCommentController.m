//
//  parenAllCommentController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/21.
//  Copyright © 2017年 user. All rights reserved.
//

#import "parenAllCommentController.h"
#import "parentCommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "replyCommentCell.h"
#import "replyFootView.h"
#import "keyBoardView.h"
#import "parentdiscussModel.h"
#import "replyCommentModel.h"
#import "commentController.h"
#import "messageDetailController.h"
#import "CommonSheet.h"
#import "NSString+emojiy.h"

@interface parenAllCommentController ()<UITableViewDelegate,UITableViewDataSource,parentCommentDelegate,replyCommentDelegate,keyBoardViewDelegate,CommonSheetDelegate>
{
    BOOL _isHide;
    AFHTTPRequestOperationManager *_manager;
    CGFloat _totalKeybordHeight;
}
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) keyBoardView *keyBoard;
@property (nonatomic,strong) NSNotification *notication;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) replyCommentCell *replCell;
@property (nonatomic,strong) parentCommentCell *parentCell;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic,copy)NSIndexPath *currentIndexPath;

@end

@implementation parenAllCommentController
static NSString *userId;
static NSString *imageStr;
static NSString *titleStr;
static NSString *timeStr;
static NSString *contentStr;
static NSString *pictureImg;
static NSString *commentId;
static NSString *detailCommentId;
static NSString *likeStatus;
static NSString *taskId;
static NSString *likeStr;
static NSString *from_userId;
static NSString *navStr;
static NSString *from_uid;
static NSString *replyFrom_uid;
static NSString *sexStr;
static int likeCount;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    pictureImg = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _isHide = YES;
    self.fd_interactivePopDisabled = YES;
    
    
    [self createHttpRequest];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self loadReplyCommentData];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake( 0, 0, ScreenWidth, ScreenHeight - 44) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
//    tap.cancelsTouchesInView = NO;
//    [self.tableview addGestureRecognizer:tap];
    [self.view addSubview:_tableview];

    if (iOS11) {
        
        self.tableview.estimatedRowHeight = 0;
        self.tableview.estimatedSectionHeaderHeight = 0;
        self.tableview.estimatedSectionFooterHeight = 0;
    }
    
    [self.tableview registerClass:[parentCommentCell class] forCellReuseIdentifier:@"parentCommentCell"];
    [self.tableview registerClass:[replyCommentCell class] forCellReuseIdentifier:@"replyCommentCell"];
    
    _keyBoard = [[keyBoardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    _keyBoard.delegate = self;
    [self.view addSubview:_keyBoard];
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
       
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)loadReplyCommentData{
    
    NSDictionary *param = @{@"userId":userId,@"commentId":self.comemntId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:replyCommentURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            [self.dataArray removeAllObjects];
            
            NSDictionary *menuList = dict[@"menuList"];
            
            imageStr = menuList[@"faceImg"];
            titleStr = menuList[@"from_nickName"];
            contentStr = menuList[@"content"];
            timeStr = menuList[@"createDate"];
            pictureImg = menuList[@"commentImg"];
            taskId = menuList[@"taskId"];
            from_userId = menuList[@"from_userId"];
            commentId = menuList[@"commentId"];
            navStr = menuList[@"commentCount"];
            from_uid = menuList[@"from_userId"];
            sexStr = menuList[@"sex"];
            DDLog(@"%@",pictureImg);
            
            NSDictionary *commentDict = menuList[@"commmentTwo"];
            for (NSDictionary *appDict in commentDict) {
             
                replyCommentModel *model = [[replyCommentModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.titleLb.text = [NSString stringWithFormat:@"%@条回复",navStr];
            
                [self.tableview reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        [self.tableview.mj_footer endRefreshing];
         [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark --键盘隐藏出现通知
-(void)keyBoardHiden:(NSNotification*)noti
{
    _isHide = YES;
    
//    NSDictionary *dict = noti.userInfo;
//    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    _keyBoard.frame = CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44);
}

-(void)keyBoardShow:(NSNotification*)noti
{
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
//        [self adjustTableViewToFitKeyboard];
    }
    
//    [self adjustSelfFrame:rect.size.height];
    _isHide = NO;
}


//- (void)adjustTableViewToFitKeyboard
//{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
//    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
//    [self adjustTableViewToFitKeyboardWithRect:rect];
//}

-(void)adjustSelfFrame:(CGFloat)diff{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (_isHide)
        {
            CGRect frame = self.view.frame;
            frame.origin.y -= diff;
            self.view.frame = frame;
        }
    }];
}

-(void)onCommentInKeyBoard:(keyBoardView *)view{
    
    NSDictionary *param = @{@"userId":userId,@"from_userId":from_userId,@"taskId":taskId,@"content":view.textView.text,@"comment_id":commentId,@"maodian":@"0"};
    [self loadCommentDataWithParam:param];
    view.textView.text = @"";
}

#pragma mark -- 评论
-(void)loadCommentDataWithParam:(NSDictionary*)param{
    
    __weak typeof(self) weakSelf = self;
 
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    [_manager POST:detailCommetURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
        
        [weakSelf showHint:@"发表评论成功"];
            
        [self loadReplyCommentData];
        // 滚动到底部
        [self scrollsToBottomAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showHint:@"发表评论失败"];
    }];
}

#pragma mark -- tableView 自动滚动到底部
- (void)scrollsToBottomAnimated:(BOOL)animated{
    
    //构建indexPath，数据源要判断下，如果数据源数组里面元素为0，会崩溃
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count inSection:0];

    [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count +1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.keyBoard.textView resignFirstResponder];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        self.parentCell = [tableView dequeueReusableCellWithIdentifier:@"parentCommentCell"];
        if (!self.parentCell) {
            
            self.parentCell = [[parentCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"parentCommentCell"];
        }
        
        self.parentCell.timeLable.text = timeStr;
        [self.parentCell.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
        self.parentCell.labelName.text = titleStr;
        self.parentCell.labelContent.text = contentStr;
        
        NSString *sexStr1 = [NSString stringWithFormat:@"%@",sexStr];
        if ([sexStr1 isEqualToString: @"1"]) {
            
            self.parentCell.imgSex.image = [UIImage imageNamed:@"girl"];
        }else {
            
            self.parentCell.imgSex.image = [UIImage imageNamed:@"boy"];
        }
        
        if (![ETRegularUtil isEmptyString:pictureImg]) {
            
            NSArray *picViews =[pictureImg componentsSeparatedByString:@"|"];
            NSMutableArray *oriPArr = [NSMutableArray new];
            for (NSString *pName in picViews) {
                
                [oriPArr addObject:[NSURL URLWithString:pName]];
            }
            self.parentCell.picContainerView.picUrlArray = picViews;
            
            [self.parentCell.picContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(67);
            }];
        }else{
            
            [self.parentCell.picContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(0);
            }];
        }
        
        self.currentIndexPath = indexPath;
        self.parentCell.delegate = self;
        self.parentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.parentCell;
    }else{
        
        self.replCell = [tableView dequeueReusableCellWithIdentifier:@"replyCommentCell"];
        if (!self.replCell) {
            self.replCell = [[replyCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"replyCommentCell"];
        }
        self.replCell.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        
        if (self.dataArray.count !=0) {
            
            replyCommentModel *model = self.dataArray[indexPath.row - 1];
            self.replCell.replyModel = model;
        }
        self.replCell.indexPath = indexPath;
        self.replCell.delegate = self;
        self.replCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.replCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    replyCommentModel *model = self.dataArray[indexPath.row -1];
    detailCommentId = model.commentId;
    
    CommonSheet *sheet = [[CommonSheet alloc]initWithDelegate:self];
    [sheet setupWithTitles:@[@"",@"删除"]];
    [sheet showInView:self.view];
}

#pragma mark - ***********CommonSheetDelegate***********
- (void)commonSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag{
    
    switch ([index integerValue]) {
        case 0:{
            /* 删除 */
            
            [self loadDeleteData];
        }
            break;

        default:
            break;
    }
}

#pragma mark -- 删除
-(void)loadDeleteData{
    
    NSDictionary *param = @{@"userId":userId,@"commentId":detailCommentId,@"type":@"1"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:detailCommentDeteleURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.dataArray removeObjectAtIndex:_replCell.indexPath.row];
                [self.tableview reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.tableview.mj_footer endRefreshing];
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        return [self cellHeight];
    }else{
    
        return [self.replCell cellHeight];
    }
}

-(CGFloat)cellHeight{
    
    // 文字的最大尺寸(设置内容label的最大size，这样才可以计算label的实际高度，需要设置最大宽度，但是最大高度不需要设置，只需要设置为最大浮点值即可)，53为内容label到cell左边的距离
    CGSize maxSize = CGSizeMake(ScreenWidth - 85, CGFLOAT_MAX);
    
    //  计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
    CGRect contenRect = [self.parentCell.labelContent.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    if (self.parentCell.picContainerView.picUrlArray.count !=0) {
        
        _cellHeight = contenRect.size.height + 80 + 60 + 40;
    }else{
        
        _cellHeight = contenRect.size.height + 80 + 40;
    }
    return _cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}

- (void)onImageInCell:(parentCommentCell *)cell {
    
    [self.keyBoard.textView resignFirstResponder];
    
    messageDetailController *detail =[[messageDetailController alloc]init];
    detail.target_uid = from_uid;
    [self.navigationController pushViewController:detail animated:NO];
}

-(void)onAvatarInCell:(replyCommentCell *)cell{
    
    [self.keyBoard.textView resignFirstResponder];
    
    replyCommentModel *model = self.dataArray[cell.indexPath.row-1];
    messageDetailController *detail =[[messageDetailController alloc]init];
    detail.target_uid = model.from_userId;
    [self.navigationController pushViewController:detail animated:NO];
}

- (void)onCheckInCell:(parentCommentCell *)cell {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCommentInCell:(parentCommentCell *)cell {
    
    commentController *comment = [[commentController alloc]init];
    comment.commentTaskId = taskId;
    [self.navigationController pushViewController:comment animated:YES];
}

#pragma mark -- 点赞
- (void)onLikeInCell:(replyCommentCell *)cell{
    
    commentId = cell.replyModel.commentId;
    DDLog(@"%@",commentId);
    DDLog(@"%d",likeCount);
    
    likeStr = cell.replyModel.commentLike;
    likeCount = [likeStr intValue];
    
    if (cell.likeBtn.selected == YES) {
        
        [cell.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        likeCount = likeCount - 1;
        NSString *likeStr1 = [NSString stringWithFormat:@"%d",likeCount];
        [cell.likeBtn setTitle:likeStr1 forState:UIControlStateNormal];
        likeStatus = @"0";
        cell.likeBtn.selected = NO;
    }else{
        
        [cell.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
        likeCount = likeCount + 1;
        NSString *likeStr1 = [NSString stringWithFormat:@"%d",likeCount];
        [cell.likeBtn setTitle:likeStr1 forState:UIControlStateNormal];
        likeStatus = @"1";
      cell.likeBtn.selected = YES;
    }
    
    NSDictionary *param = @{@"userId":userId,@"commentId":commentId,@"type":@"1",@"status":likeStatus};
    [self loadCommentLikeWithParam:param];
}

-(void)loadCommentLikeWithParam:(NSDictionary*)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:commentLikeURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 刷新
-(void)refresh{
    __weak __typeof(self) weakSelf = self;
    self.tableview.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
    
            [self loadReplyCommentData];
            [weakSelf.tableview.mj_footer beginRefreshing];
        }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
