//
//  contentImageController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "contentImageController.h"
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

@interface contentImageController ()<YYTextViewDelegate,ImagePanelDelegate,CommonSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AlbumControllerDelegate,AlbumEditControllerDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) YYTextView *textView;
@property (nonatomic, strong) ImagePanel *imagePanel;
@property (nonatomic, strong) BottomPanel *bottomPanel;
@property (nonatomic, strong) UIImageView *topMargin;
@property (nonatomic, strong) NSMutableArray *selectedImgs;

@end

@implementation contentImageController
static NSString *userId;
static NSString *imagType;
static NSString *iconString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createTextView];
    
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
    self.textView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_textView];
    
    _imagePanel = [[ImagePanel alloc]initWithFrame:CGRectMake(0,150 +10, kScreenWidth, ItemW+15)];
    _imagePanel.delegate = self;
    _imagePanel.backgroundColor = [UIColor redColor];
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
        
        
    }
}


- (void)dealloc{
    [_bottomPanel removeFromSuperview];
    [_imagePanel removeAllSubviews];
    [_imagePanel removeFromSuperview];
    _bottomPanel = nil;
    _imagePanel = nil;
}


@end
