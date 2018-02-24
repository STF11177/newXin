//
//  issueController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "issueController.h"
#import "CommonSheet.h"
#import "AlbumController.h"
#import "AlbumEditController.h"
#import "UIImage+FixOrientation.h"
#import "YYControl.h"
#import "ETRegularUtil.h"
#import "ETMessageView.h"
#import "bugController.h"

#define ItemW (kScreenWidth- 60)*0.25
#define MaxNum 9

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

@interface issueController ()<YYTextViewDelegate,ImagePanelDelegate,CommonSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AlbumControllerDelegate,AlbumEditControllerDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) YYTextView *textView;
@property (nonatomic, strong) ImagePanel *imagePanel;
@property (nonatomic, strong) BottomPanel *bottomPanel;
@property (nonatomic, strong) UIImageView *topMargin;
@property (nonatomic, strong) NSMutableArray *selectedImgs;

@end

@implementation issueController
static NSString *userId;
static NSString *imagType;
static NSString *iconString;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNav];
    [self createTextView];
    [self createHttpRequest];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
}

-(void)createNav{
    
    self.selectedImgs = [NSMutableArray array];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = @"信息发布";
    lable1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable1.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable1;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 10, 60, 50, 50)];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createTextView{
    
    self.textView = [[YYTextView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH -30,150)];
    _textView.textColor = [UIColor colorWithHexString:@"#000000"];
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.showsVerticalScrollIndicator = NO;
    self.textView.placeholderText = @"请输入内容";
    self.textView.placeholderFont = [UIFont systemFontOfSize:17];
    self.textView.placeholderTextColor = [UIColor colorWithHexString:@"#828282"];
    [self.view addSubview:self.textView];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_textView];
    
    _imagePanel = [[ImagePanel alloc]initWithFrame:CGRectMake(0,_textView.bottom +10, kScreenWidth, ItemW+15)];
    _imagePanel.delegate = self;
    [self.view addSubview:_imagePanel];
    
    _bottomPanel = [[BottomPanel alloc]initWithFrame:CGRectMake(0, _imagePanel.bottom+15, kScreenWidth, kScreenHeight * 0.06) touchBlock:^(BottomPanel *pannel) {
        
    }];
    [self.view addSubview:_bottomPanel];
}

#pragma mark - **********ImagePanelDelegate***********
- (void)cellDidClickImageAtIndex:(NSInteger)index{
    
    AlbumEditController *editVC = [[AlbumEditController alloc]init];
    editVC.delegate = self;
    editVC.indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)imagePanelAddTap{
    
    [self.textView resignFirstResponder];
    CommonSheet *sheet = [[CommonSheet alloc]initWithDelegate:self];
    [sheet setupWithTitles:@[@"",@"拍照",@"从手机相册选择"]];
    [sheet showInView:self.view];
}

#pragma  mark - **************AlbumEditControllerDelegate************
- (void)editedImagesFinished:(NSMutableArray *)images{
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.selectedImgs = images;
    [self updateUI];
}

#pragma  mark - **************AlbumControllerDelegate************
- (void)selectedImagesFinished:(NSMutableArray *)images{
    
    [self.selectedImgs safelyAddObjectsFromArray:images];
    [self updateUI];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
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
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"%@",info);
    // 返回一个编辑后的图片 UIImagePickerControllerOriginalImage
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    image = [image fixOrientation];
    
    [self.selectedImgs addObject:image];
    
    [self updateUI];
    [picker dismissViewControllerAnimated:NO completion:^{
        
        [UIView animateWithDuration:0.6 animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }];
}

- (void)updateUI{
    
    [self.imagePanel refreshImagePanlWithImages:self.selectedImgs];
    self.bottomPanel.top = self.imagePanel.bottom + 10;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:NO completion:^{
        
        [UIView animateWithDuration:0.6 animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }];
}

-(void)presentToBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendMessage{
    
    if ([ETRegularUtil isEmptyString:self.textView.text]) {
        
        [self showAlertWithMessage:@"请填写所反馈的内容"];
    }else{
    
        [self loadTextViewData];
    }
}

-(void)loadTextViewData{

    NSDictionary *params = @{@"userId":userId,@"content":self.textView.text,@"bugId":@"0"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",jsonString);
    
    [_manager POST:bugtextURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            DDLog(@"成功");
            
            NSString *bugStr;
            bugStr = dict[@"bugId"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                DDLog(@"xxxxx%@",self.selectedImgs)
                if(self.selectedImgs.count>0){

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
                            
                            DDLog(@"hhhhhhh%@",uploadImgs);
                            
                            for (NSArray *item in uploadImgs) {
                                NSData *data;
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
                            
                                NSString *selectedImgCount = [NSString stringWithFormat:@"%ld",(unsigned long)self.selectedImgs.count];
                           
                                NSDictionary *imgparams = @{@"userId":userId,@"bugId":bugStr,@"iconString":iconString,@"imageType":imagType,@"sumCount":selectedImgCount,@"sum":selectedImgCount};
                                [weakSelf loadDataWithParam:imgparams];
                            });
                        }];
                    });
                }else{
                    
                    [[ETMessageView sharedInstance] hideMessage];
                    bugController *bug = [[bugController alloc]init];
                    [self.navigationController pushViewController:bug animated:NO];
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 上传图片
-(void)loadDataWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData1 = [jsonData1 base64EncodedDataWithOptions:0];
    NSString *jsonString1 = [[NSString alloc]initWithData:baseData1 encoding:NSUTF8StringEncoding];
    
    [_manager POST:bugImgURL parameters:jsonString1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"%@",dict);
        int status = [dict[@"status"]intValue];
        NSString *result = dict[@"result"];
        if (status == 0) {
            
            DDLog(@"上传成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                
              if (![ETRegularUtil isEmptyString:result]) {
                
                [[ETMessageView sharedInstance] hideMessage];
                bugController *bug = [[bugController alloc]init];
                [self.navigationController pushViewController:bug animated:NO];
            }
          });
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

- (void)dealloc{
    [_bottomPanel removeFromSuperview];
    [_imagePanel removeAllSubviews];
    [_imagePanel removeFromSuperview];
    _bottomPanel = nil;
    _imagePanel = nil;
}

@end

