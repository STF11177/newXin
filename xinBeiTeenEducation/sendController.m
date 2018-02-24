//
//  sendController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/8.
//  Copyright © 2017年 user. All rights reserved.
//

#import "sendController.h"
#import "MBProgressHUD.h"
#import "titleButton.h"
#import "IQActionSheetPickerView.h"
#import "AlbumController.h"
#import "AlbumEditController.h"
#import "ImgUpLoadModel.h"
#import "YYControl.h"
#import "CommonAlert.h"
#import "YYTextLayout.h"
#import "ETMessageView.h"
#import "SBJson.h"
#import "UIImage+FixOrientation.h"
#import "ImageData.h"
#import "sendTextJudgeModel.h"
#import "newController.h"
#import "choseModel.h"
#import "parentsCircleController.h"
#import "ETMessageView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "NSString+emojiy.h"

#define ItemW (kScreenWidth- 60)*0.25
#define MaxNum 9
 #define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000

//图片面板
@class ImagePanel;
@protocol ImagePanelDelegate <NSObject>
- (void)cellDidClickImageAtIndex:(NSInteger)index;
- (void)imagePanelAddTap;
@end

@interface ImagePanel : UIView
@property (nonatomic, weak) id<ImagePanelDelegate> delegate;
@property (nonatomic, strong)NSMutableArray *items;
@property (nonatomic, strong)UIButton *addBtn;

- (void)refreshImagePanlWithImages:(NSArray *)images;
@end

/* 底部位置面板 */
@class BottomPanel;
typedef void (^TouchBlock)(BottomPanel *pannel);
@interface BottomPanel : UIView
@property (nonatomic, strong)UILabel *localLab;
@property (nonatomic, strong)UILabel *canSeeLab;
@property (nonatomic, strong)UIView *seView;
@property (nonatomic, strong)UIView *seview2;
@property (nonatomic, copy)TouchBlock touchBlock;
- (id)initWithFrame:(CGRect)frame touchBlock:(TouchBlock)touchBlock;
@end


@interface sendController ()<IQActionSheetPickerViewDelegate,YYTextViewDelegate,ImagePanelDelegate,CommonSheetDelegate,AlbumControllerDelegate,AlbumEditControllerDelegate,UITextViewDelegate
,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    AFHTTPRequestOperationManager *_manager;
    
}

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView *topMargin;
@property (nonatomic, strong) ImagePanel *imagePanel;
@property (nonatomic, strong) BottomPanel *bottomPanel;
@property (nonatomic, strong) titleButton *titleBtn;
@property (nonatomic, strong) UIView *sendView;
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) YYTextView *YtextView;
@property (nonatomic, strong) YYTextView *titleTextView;
@property (nonatomic, strong) choseModel *choseModel;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSMutableArray *judgeArray;
@property (nonatomic, strong) sendTextJudgeModel *judgeModel;
@end

@implementation sendController
static NSString *typeStr;
static NSString *typeId;
static NSString *taskId;
static NSString *imagType;
static NSString *iconString;
static NSString *imagType;
static NSString *iconString;
static NSString *userId;
static NSString *maskName;

-(void)viewDidLoad{

    [self createNavItem];
    [self setUpCenterTitle];
    [self createHttpRequest];

    self.fd_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardAction)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    self.judgeArray = [[NSMutableArray alloc]init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
}

-(void)createNavItem{
    
   UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, 50, 50)];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 10, 60, 50, 50)];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)setUpCenterTitle{
    //创建导航中间标题按钮
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.dataName = [[NSMutableArray alloc]init];
    self.dictArray = [[NSMutableArray alloc]init];
    
    _titleBtn = [[titleButton alloc]init];
    _titleBtn.height = DSNavigationItemOfTitleViewHeight;
    
    //设置文字
    [_titleBtn setTitle: @"请选择" forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];

    //设置图标
    UIImage *mainImage = [[UIImage imageWithName:@"list"] scaleImageWithSize:CGSizeMake(13, 8)];
    
    [_titleBtn setImage:mainImage forState:UIControlStateNormal];
    
    //监听点击
    [_titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleBtn;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark -- 选择器
-(void)titleBtnClick{
    DDLog(@"下拉菜单");
    __weak typeof(self) weakSelf = self;
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc]initWithTitle:@"选择板块" delegate:self];
    picker.backgroundColor =[UIColor blackColor];
    picker.titleFont = [UIFont systemFontOfSize:18];
    picker.titleColor = [UIColor blackColor];
    picker.delegate = self;
    [picker setTag:1];
    
    picker.addBtn.hidden = YES;
    [picker dismiss];
    
    //类别的请求
    [_manager POST:typeNameURl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
         weakSelf.status = [dict[@"status"]intValue];
        if (weakSelf.status == 0) {
            
            NSArray *menuList = dict[@"menuList"];
            for ( NSDictionary *appDict in menuList) {
                
                weakSelf.choseModel = [[choseModel alloc]init];
                [weakSelf.choseModel yy_modelSetWithDictionary:appDict];
                [weakSelf.dataArray addObject:weakSelf.choseModel];
                [weakSelf.dataName addObject:weakSelf.choseModel.typeName];
                [weakSelf.dataTypeId addObject:weakSelf.choseModel.id];
                
               NSMutableDictionary *dictType = [[NSMutableDictionary alloc]init];
                dictType = [NSMutableDictionary dictionaryWithObject:weakSelf.choseModel.id forKey:weakSelf.choseModel.typeName];
                [weakSelf.dictArray addObject:dictType];
                
                DDLog(@"weakSelf.dictArray:%@",weakSelf.dictArray);
            }
        
            [picker setTitlesForComponents:@[weakSelf.dataName]];
            [picker show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      [[ETMessageView sharedInstance] showMessage:@"网路不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
    
    [weakSelf.dataName removeAllObjects];
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles{
    
    [self.titleBtn setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal];
    
    for (NSDictionary *appDic in self.dictArray) {
    
        if ([[appDic allKeys] containsObject:[titles componentsJoinedByString:@" - "]]) {
            typeStr = [appDic objectForKey:[titles componentsJoinedByString:@" - "]];
        }
    }
}

#pragma mark -- 取消
-(void)presentBack{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -- 发送
-(void)sendMessage{
    
    [self keyboardAction];
    
    DDLog(@"%@",typeStr);
    NSString *type = [NSString stringWithFormat:@"%@",typeStr];
    if ([ETRegularUtil isEmptyString:type]){
        
        [self showAlertWithMessage:@"请您选择类型"];
        return;
        
    }else if(![ETRegularUtil isEmptyString:_titleTextView.text]&&[ETRegularUtil isEmptyString:_YtextView.text]){
        
        [self showAlertWithMessage:@"您不能发送空内容，请您发布一段正文"];
        return;
    }
    else{
    
        [self loadillLegalWorld];
    }
}

#pragma mark -- 上传图片
-(void)loadDataWithParam:(NSDictionary *)param{

    NSError *error;
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData1 = [jsonData1 base64EncodedDataWithOptions:0];
    NSString *jsonString1 = [[NSString alloc]initWithData:baseData1 encoding:NSUTF8StringEncoding];

    [_manager POST:imageUPLoadURL parameters:jsonString1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"%@",dict);
        int status = [dict[@"status"]intValue];
        NSString *result = dict[@"result"];
        if (status == 0) {
            
            DDLog(@"上传成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                
            typeStr = @"";
            if (![ETRegularUtil isEmptyString:result]) {
                
            [[ETMessageView sharedInstance] hideMessage];
            newController *new = [[newController alloc]init];
            [self.navigationController pushViewController:new animated:NO];
         }
      });
    }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 上传文本
-(void)loadDataWithText{

    NSDictionary *params = @{@"userId":userId,@"typeId":typeStr,@"title":_titleTextView.text,@"content":_YtextView.text,@"ip_address":@""};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    
    [_manager POST:textURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            DDLog(@"成功");
            taskId = dict[@"taskId"];

            DDLog(@"%@",taskId);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self.selectedImgs.count>0){
                    DDLog(@"%ld",(unsigned long)self.selectedImgs.count);
                    //上传
                    [[ETMessageView sharedInstance] showSpinnerMessage:@"图片上传中" onView:self.view];
                    
                    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(globalQueue, ^{
                        
                        NSMutableArray *uploadImgs = [NSMutableArray array];
                        [self.selectedImgs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            if ([obj isKindOfClass:[UIImage class]]) {
                                
                                [uploadImgs safelyAddObject:@[obj,@"jpeg"]];
                            }
                            if([obj isKindOfClass:[ALAsset class]]){
                                
                                NSArray *item= [UIImage getMetaFromAlasset:obj];
                                [uploadImgs safelyAddObject:item];
                            }
                
                            for (NSArray *item in uploadImgs) {
                                NSData *data;
                                DDLog(@"%@",item);
                                id meta = [item firstObject];
                                imagType = [item lastObject];
                                
                                if ([meta isKindOfClass:[NSData class]]) {
                                    [uploadImgs safelyAddObject:@[meta,imagType]];
                                    continue;
                                }
                                
                                UIImage *image =meta;
                                CGFloat scale = image.size.height/image.size.width;
                                CGSize imgSize = image.size;
                                
                                //1280宽或高的直接压缩到1242（1080P）(长图小于2M，普通300k)
                                if (scale>3) {
                                    if (imgSize.width>1080) {
                                        imgSize = CGSizeMake(1080,1080*scale);
                                    }
                                }else if (scale<(1.0/3)) {
                                    if (imgSize.width>1920) {
                                        imgSize = CGSizeMake(1920,floorf(imgSize.height*1920/imgSize.width));
                                    }
                                }else{
                                    if(imgSize.height>1920&&imgSize.width<=1080) {
                                        imgSize = CGSizeMake(floorf(imgSize.width*1920/imgSize.height),1920);
                                    }else if (imgSize.width>1080&&imgSize.height<=1920) {
                                        imgSize = CGSizeMake(1080,1080*scale);
                                    }else if(imgSize.height>1920&&imgSize.width>1080) {
                                        if (scale>(1920/1080)) {
                                            imgSize = CGSizeMake(floorf(imgSize.width*1920/imgSize.height),1920);
                                        }else{
                                            imgSize = CGSizeMake(1080,1080*scale);
                                        }
                                    }
                                }
                                
                                if ([@"png" isEqualToString:[item lastObject]]) {
                                    data = [self imageWithImage:image scaledToSize:imgSize toCompression:1.0 isPngType:YES];
                                    if (data.length>300000) {
                                        data = [self getJpegTypeScaleImageWithImage:data toMaxFileSize:300000];
                                    }
                                }else{
                                    data = [self imageWithImage:image scaledToSize:imgSize toCompression:1.0 isPngType:NO];
                                    if (data.length>300000) {
                                        data = [self getJpegTypeScaleImageWithImage:data toMaxFileSize:300000];
                                    }
                                }
                                iconString = [data base64EncodedStringWithOptions:0];
                            }
                            
                            __weak typeof(self) weakSelf = self;
                            dispatch_queue_t mainQueue = dispatch_get_main_queue();
                            //异步返回主线程，根据获取的数据，更新UI
                            dispatch_async(mainQueue, ^{
                                
                                DDLog(@"%@",taskId);
                                DDLog(@"%@",imagType);
                                
                                NSString *selectedImgCount = [NSString stringWithFormat:@"%ld",(unsigned long)self.selectedImgs.count];
                                DDLog(@"%@",selectedImgCount);
                                NSDictionary *imgparams = @{@"userId":userId,@"typeId":typeStr,@"taskId":taskId,@"iconString":iconString,@"imageType":imagType,@"sum":selectedImgCount};
                                [weakSelf loadDataWithParam:imgparams];
                                
                            });
                        }];
                    });
                }else{
                
                    newController *new = [[newController alloc]init];
                    [self.navigationController pushViewController:new animated:NO];
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 敏感词汇
-(void)loadillLegalWorld{

    //判断是否有敏感词汇
    [_manager POST:sendJudgeURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            DDLog(@"%@",@"成功");
        }
        
        NSArray *dictArray = dict[@"results"];
        for (NSDictionary *resultDict in dictArray) {
            
            _judgeModel = [[sendTextJudgeModel alloc]init];
            [_judgeModel yy_modelSetWithDictionary:resultDict];
            [_judgeArray addObject:_judgeModel.maskName];
        }
        
        DDLog(@"%@",_YtextView.text);
        DDLog(@"%@",_judgeArray);
        if ([_judgeArray containsObject:_YtextView.text]||[_judgeArray containsObject:_titleTextView.text]){
            
            [self showAlertWithMessage:@"你所发布的消息中含有敏感词汇，请重新发布"];
        }else{
            
            [self loadDataWithText];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//JPEG及其它类型的图片压缩
- (NSData *)getJpegTypeScaleImageWithImage:(NSData *)imageData toMaxFileSize:(NSInteger)maxFileSize{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    if ([imageData length] > maxFileSize){
        UIImage *imageTemp = [UIImage imageWithData:imageData];
        while ([imageData length] > maxFileSize && compression > maxCompression) {
            imageData = UIImageJPEGRepresentation(imageTemp, compression);
            compression -= 0.1;
        }
    }
    return imageData;
}


//图片大小压缩
- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize toCompression:(CGFloat)compression isPngType:(BOOL)type;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (type)
        return UIImagePNGRepresentation(newImage);
    return UIImageJPEGRepresentation(newImage, compression);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.selectedImgs = [NSMutableArray array];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        [self.view addSubview:_scrollView];
        
        _topMargin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _topMargin.clipsToBounds = YES;
        
        [_scrollView addSubview:_topMargin];
        
        
        _titleTextView = [[YYTextView alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth-30, 50)];
        _titleTextView.font = [UIFont systemFontOfSize:17];
        _titleTextView.textColor = [UIColor colorWithHexString:@"#000000"];
        _titleTextView.showsVerticalScrollIndicator = NO;
        
        _titleTextView.placeholderFont = [UIFont systemFontOfSize:17];
        _titleTextView.placeholderText = @"添加主题";
        _titleTextView.placeholderTextColor = [UIColor colorWithHexString:@"#828282"];
        _titleTextView.delegate = self;

        _titleTextView.returnKeyType = UIReturnKeyDone;
        _sepView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleTextView.bottom, kScreenWidth, 0.5)];
        _sepView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        [_scrollView addSubview:_sepView];
        
        _YtextView = [[YYTextView alloc]initWithFrame:CGRectMake(15, _titleTextView.bottom +10, kScreenWidth - 30, 100)];
        _YtextView.font = [UIFont systemFontOfSize:17];
        _YtextView.textColor = [UIColor colorWithHexString:@"#000000"];
        _YtextView.showsVerticalScrollIndicator = NO;
        _YtextView.placeholderFont = [UIFont systemFontOfSize:17];
        _YtextView.placeholderText = @"请输入正文";
        _YtextView.placeholderTextColor = [UIColor colorWithHexString:@"#828282"];
        _YtextView.delegate = self;
        _YtextView.returnKeyType = UIReturnKeyDone;
        
        [self.scrollView addSubview:_titleTextView];
        [self.scrollView addSubview:_YtextView];
        
        _imagePanel = [[ImagePanel alloc]initWithFrame:CGRectMake(0,_YtextView.bottom +10, kScreenWidth, ItemW+15)];
        _imagePanel.delegate = self;
        _topMargin.height = _YtextView.height+25+ItemW;
        [self.scrollView addSubview:_imagePanel];
        
        _bottomPanel = [[BottomPanel alloc]initWithFrame:CGRectMake(0, _imagePanel.bottom+15, kScreenWidth, kScreenHeight * 0.06) touchBlock:^(BottomPanel *pannel) {
            
        }];
        [self.scrollView addSubview:_bottomPanel];
    }
    return self;
}

- (void)updateUI{
    
    [self.imagePanel refreshImagePanlWithImages:self.selectedImgs];
    _topMargin.height = _YtextView.height+25+_imagePanel.height;
    self.bottomPanel.top = self.imagePanel.bottom + 10;
}

//滑动界面隐藏键盘
- (void)keyboardAction {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.YtextView becomeFirstResponder];
    if ([self.selectedImgs count]>0) {
        [self updateUI];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.YtextView resignFirstResponder];
    [self.titleTextView resignFirstResponder];
}

#pragma  mark - **************AlbumEditControllerDelegate************
- (void)editedImagesFinished:(NSMutableArray *)images{
    
    self.navigationController.navigationBar.hidden = NO;
    self.selectedImgs = images;
    [self updateUI];
}

#pragma  mark - **************AlbumControllerDelegate************
- (void)selectedImagesFinished:(NSMutableArray *)images{
    
    DDLog(@"images:%@",images);
    [self.selectedImgs safelyAddObjectsFromArray:images];
    DDLog(@"self.selectedImgs:%@",self.selectedImgs);
    [self updateUI];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    

    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.YtextView resignFirstResponder];
        [self.titleTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark - **********CommonAlertDelegate***********
-(void)itemCertain:(CommonAlert *)alert{
    
    typeStr = @"";
}

#pragma mark - **********ImagePanelDelegate***********
- (void)cellDidClickImageAtIndex:(NSInteger)index{
    
    AlbumEditController *editVC = [[AlbumEditController alloc]init];
    editVC.delegate = self;
    editVC.indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)imagePanelAddTap{
    [self.YtextView resignFirstResponder];
    [self.titleTextView resignFirstResponder];
    CommonSheet *sheet = [[CommonSheet alloc]initWithDelegate:self];
    [sheet setupWithTitles:@[@"",@"拍照",@"从手机相册选择"]];
    [sheet showInView:self.view];
}

#pragma mark - ***********CommonSheetDelegate***********
- (void)commonSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag{
    
    switch ([index integerValue]) {
        case 0:{
            /* 拍照 */
            [self openCameraAction];
        }
            
            break;
        case 1:{
            /* 相册 */
            AlbumController *albumVC = [[AlbumController alloc]init];
            albumVC.delegate = self;
            albumVC.remainNum = MaxNum - [self.selectedImgs count];
//            ETNavigationController *navi = [[ETNavigationController alloc]initWithRootViewController:albumVC];
            [self.navigationController presentViewController:albumVC animated:YES completion:nil];
        }
            
            break;
        default:
            break;
    }
}

#pragma  mark - **************UIImagePickerController************
//打开相机获取权限
- (void)openCameraAction{
    
    //是否获得权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        // 展示提示语
        [self showAlertWithMessage:@"请在iPhone的\"设置-隐私-相机\"中，允许访问相机。"];
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断当前设备是否有照相功能
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //判断如果没有相机就调用图片库
        
        [self showAlertWithMessage:@"设备不支持照相功能。"];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


-(UIStatusBarAnimation) preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"%@",info);
    // 返回一个编辑后的图片 UIImagePickerControllerOriginalImage
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    image = [image fixOrientation];
    
    [self.selectedImgs addObject:image];
    DDLog(@"%@",self.selectedImgs);

    [self updateUI];
    [picker dismissViewControllerAnimated:NO completion:^{
        
        [UIView animateWithDuration:0.6 animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:NO completion:^{
//        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
        [UIView animateWithDuration:0.6 animations:^{
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }];
}

- (void)dealloc{
    [_bottomPanel removeFromSuperview];
    [_imagePanel removeAllSubviews];
    [_imagePanel removeFromSuperview];
    _bottomPanel = nil;
    _imagePanel = nil;
}

@end

/*********底部定位pannel**********/
@implementation BottomPanel
- (id)initWithFrame:(CGRect)frame touchBlock:(TouchBlock)touchBlock{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.touchBlock = touchBlock;
        //定位
        UIImageView *localImgV= [ETUIUtil drawCustomImgViewInView:self Frame:CGRectMake(0, 0, frame.size.width, frame.size.height) BundleImgName:@"find_issue_local.png"];
        localImgV.contentMode = UIViewContentModeScaleAspectFit;
        
        
        _seView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 0.5)];
        _seView.backgroundColor =[UIColor colorWithHexString:@"#f1f1f1"];
        [localImgV addSubview:_seView];
    }
    return self;
}

- (void)setTouchBlock:(TouchBlock)touchBlock{
    _touchBlock = [touchBlock copy];
}

- (void)tapAction{
    if (self.touchBlock) {
        (self.touchBlock)(self);
    }
}

- (void)dealloc{
    self.touchBlock = nil;
}

@end


/*********图片面板**************/
@implementation ImagePanel
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.addBtn = [ETUIUtil drawButtonInView:self Frame:CGRectMake(20, 0, ItemW, ItemW) IconName:@"add-pick" Target:self Action:@selector(addTapAction:)];
        
    }
    return self;
}

- (void)refreshImagePanlWithImages:(NSArray *)images{
    
    for (YYControl *yycontrol in self.items) {
        yycontrol.image = nil;
        [yycontrol removeFromSuperview];
    }
    self.items = [NSMutableArray array];
    
    if ([images count]==0) {
        self.addBtn.origin = CGPointMake(20, 0);
    }
    
    if([images count]>=9){                                                                                                                                                                                                                                                                                                                                                                                      
        self.addBtn.hidden = YES;
    }else{
        self.addBtn.hidden = NO;
    }
    
    
    CGFloat ItemY = 0;
    CGFloat ItemX = 0;
    @weakify(self);
    for (int i = 0; i < [images count]; i++) {
        YYControl *imageView = [YYControl new];
        imageView.size = CGSizeMake(ItemW, ItemW);
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.exclusiveTouch = YES;
        imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (![weak_self.delegate respondsToSelector:@selector(cellDidClickImageAtIndex:)]) return;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [weak_self.delegate cellDidClickImageAtIndex:i];
                }
            }
        };
        
        id imageObj = [images objectSafetyAtIndex:i];
        if ([imageObj isKindOfClass:[UIImage class]]) {
            imageView.image = imageObj;
        }
        if([imageObj isKindOfClass:[ALAsset class]]){
            //获取到相片、视频的缩略图
            CGImageRef cgImage = [imageObj aspectRatioThumbnail];
            imageObj = [UIImage imageWithCGImage:cgImage];
            imageView.image = imageObj;
        }
        
        //计算位置
        if (i%4>0) {
            ItemX = (10+ItemW) *(i%4)+20;
            ItemY = (10+ItemW)*(i/4);
        }else{
            ItemX = 20;
            ItemY = (10+ItemW)*(i/4);
        }
        
        if ((i+1)%4>0) {
            self.addBtn.origin = CGPointMake((10+ItemW)*((i+1)%4)+20, (10+ItemW)*((i+1)/4));
        }else{
            self.addBtn.origin = CGPointMake(20, (10+ItemW)*((i+1)/4));
        }
        
        imageView.origin = CGPointMake(ItemX, ItemY);
        [self.items addObject:imageView];
        [self addSubview:imageView];
        
    }
    self.height = self.addBtn.bottom +15;
}

- (void)addTapAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(imagePanelAddTap)]){
        [self.delegate imagePanelAddTap];
    };
}

-(void)keyboardHide:(UITapGestureRecognizer *)tap{

}

-(void)dealloc{
    self.delegate = nil;
    [self.items removeAllObjects];
    self.items = nil;
}

@end
