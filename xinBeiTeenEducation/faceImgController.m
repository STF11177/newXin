//
//  faceImgController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/17.
//  Copyright © 2017年 user. All rights reserved.
//

#import "faceImgController.h"
#import "CommonSheet.h"
#import "UIImage+FixOrientation.h"
#import "ETMessageView.h"
#import "personDataController.h"
#import "loginMessageController.h"

@interface faceImgController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,CommonSheetDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UIImageView *imagView;
@property (nonatomic,strong) CommonSheet *sheet;

@end

@implementation faceImgController
static NSString *headLbString;
static NSString *headImageStr;
static NSString *userId;
static NSString *iconString;
static NSString *faceImage;
static NSString *tokenStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createHttp];
    self.view.backgroundColor = [UIColor blackColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];
    
    NSDictionary *param = @{@"userId":userId,@"token":tokenStr};
    [self loadDatawithParam:param];
    
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"头像";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 19, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"arrow-fx"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)createView{

    _imagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.2, SCREEN_WIDTH, SCREEN_HEIGHT*0.56)];
    [_imagView setBackgroundColor:[UIColor whiteColor]];
    _imagView.clipsToBounds = YES;
    _imagView.contentMode = UIViewContentModeScaleAspectFill;
    if ([self.fromWhere isEqualToString:@"1000"]) {
        
        [self.imagView sd_setImageWithURL:[NSURL URLWithString:faceImage] placeholderImage:[UIImage imageNamed:@"background"]];
        self.fromWhere = @"10001";
    }else{
        
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:faceImage]]];
        _imagView.image = image;
    }
    [self.view addSubview:_imagView];
}

-(void)loadDatawithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:mineURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        int tokenStuts = [dict[@"tokenStatus"]intValue];
        if (status == 0) {
            
                NSDictionary *menuList = dict[@"menuList"];
                if (![menuList[@"faceImg"] isKindOfClass:[NSNull class]]) {
                    
                    faceImage = menuList[@"faceImg"];

                    [self createView];
                }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (tokenStuts == 2) {
                    
                    self.hidesBottomBarWhenPushed=YES;
                    loginMessageController *login = [[loginMessageController alloc]init];
                    login.loginStatus = @"1";
                    [self presentViewController:login animated:NO completion:^{
                        
                    }];
                    
                    self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，t
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)presentBack{

    if ([self.fromWhere isEqualToString:@"10001"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
            personDataController *personVC = [[personDataController alloc]init];
            personVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personVC animated:YES];
    }
}

-(void)rightBtnClick{

    [self.sheet removeFromSuperview];
    self.sheet = [[CommonSheet alloc]initWithDelegate:self];
    [self.sheet setupWithTitles:@[@"",@"拍照",@"从手机相册选择",@"保存图片"]];
    [self.sheet showInView:self.view];
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark - *************PhotoEditDelegate*****************
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"%@",info);
    //    返回一个编辑后的图片 UIImagePickerControllerOriginalImage
    UIImage *selectedImage = info[@"UIImagePickerControllerEditedImage"];
    
    //    上传照片
    NSMutableArray *images = [NSMutableArray arrayWithObject:@[selectedImage,@"jpeg"]];
    //    [[ETMessageView sharedInstance] showSpinnerMessage:MESSAGE_LOADING onView:self.view];
     DDLog(@"%@",images);
    
    NSMutableArray *uploadDatas = [NSMutableArray array];
    for (NSArray *item in images) {
        NSData *data;
        id meta = [item firstObject];
        NSString *type = [item lastObject];
        
        if ([meta isKindOfClass:[NSData class]]) {
            [uploadDatas safelyAddObject:@[meta,type]];
            continue;
        }
        
        UIImage *image =meta;
        CGSize imgSize = image.size;
        
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

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *param = @{@"userId":userId,@"iconString":iconString,@"imageType":@""};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    [[ETMessageView sharedInstance] showSpinnerMessage:@"图片上传中" onView:self.view];
    
    [_manager POST:upLoadImageURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            DDLog(@"上传成功");
            dispatch_async(dispatch_get_main_queue(), ^{
            
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *userId = [userDefaults objectForKey:@"userName"];
                NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
                tokenStr = [userDefaults1 objectForKey:@"tokenName"];
                
                NSDictionary *param = @{@"userId":userId,@"token":tokenStr};
                [self loadDatawithParam:param];
                
                //关闭相册界面
                [[ETMessageView sharedInstance] hideMessage];
                [picker dismissViewControllerAnimated:YES completion:nil];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
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
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            //设置选择后的图片可被编辑
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 2:{
            
            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(_imagView.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo
{
    
    NSString*message =@"呵呵";
    if(!error) {
        
        message =@"成功保存到相册";
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else
        
    {
    
        message = [error description];

        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
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
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
        //无权限
        CommonAlert * alertView  = [[CommonAlert alloc]initWithMessage:[NSString stringWithFormat:@"请在设备的\"设置-隐私-相机\"选项中，允许%@访问你的手机相机", appName] withBtnTitles:@[@"知道了"]];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断当前设备是否有照相功能
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //判断如果没有相机就调用图片库
        CommonAlert * alertView  = [[CommonAlert alloc]initWithMessage:@"设备不支持照相功能." withBtnTitles:@[@"知道了"]];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self presentViewController:picker animated:YES completion:nil];
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

#pragma mark -- 判断是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
