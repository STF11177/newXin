//
//  mineViewController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "mineViewController.h"
#import "headCell.h"
#import "mineModel.h"
#import "collectController.h"
#import "personDataController.h"
#import "ETMessageView.h"
#import "UIImage+FixOrientation.h"
#import "mySonController.h"
#import "settingController.h"
#import "orderController.h"
#import "inviteController.h"
#import "cashController.h"
#import "bookController.h"
#import "faceImgController.h"
#import "loginMessageController.h"
#import "bugController.h"
#import "queryResultController.h"
#import "myOrderController.h"

@interface mineViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *headLab;
@property (nonatomic,strong) mineModel *mdoel;
@property (nonatomic,strong) NSMutableArray *messageArray;

@end

@implementation mineViewController
static NSString *headLbString;
static NSString *headImageStr;
static NSString *userId;
static NSString *iconString;
static NSString *tokenStr;
static NSString *statusStr;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createView];
    [self createHttp];
    [self.tableView registerClass:[headCell class] forCellReuseIdentifier:@"headCell"];
    
    [self.navigationItem setHidesBackButton:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    DDLog(@"userId:%@",userId);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadDta];

    [self loadMessageData];
}

-(void)createView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[mineModel mineData] mutableCopy];
    }
    return _dataArray;
}

-(NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc]init];
    }
    return _messageArray;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark --数据请求
-(void)loadDta{
    
    self.mdoel = [[mineModel alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];

    //请求参数
    NSDictionary *param = @{@"userId":userId,@"token":tokenStr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:mineURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        int status = [dict[@"status"]intValue];
        int tokenStuts = [dict[@"tokenStatus"]intValue];
        DDLog(@"%d",status);
    
        NSDictionary *menuDict = dict[@"menuList"];
        if (status == 0) {
            
            headLbString = menuDict[@"nickName"];
            headImageStr = menuDict[@"faceImg"];
            DDLog(@"headLbString:%@",headLbString);
            DDLog(@"headImageStr:%@",headImageStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (tokenStuts == 2) {
                    
                    self.hidesBottomBarWhenPushed=YES;
                    loginMessageController *login = [[loginMessageController alloc]init];
                    login.loginStatus = @"1";
                    [self presentViewController:login animated:NO completion:^{
                        
                    }];
                    
                    self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，t
                }
                
                if ([ETRegularUtil isEmptyString:headImageStr]) {
                   
                    _headImg.image = [UIImage imageNamed:@"moren_imgs"];
                }else{
                
                    [_headImg sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"moren_imgs"]];
                }
                    _headLab.text = headLbString;
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 消息的标记
-(void)loadMessageData{
    
    DDLog(@"userId:%@",userId);
    //请求参数
    NSDictionary *param = @{@"userId":userId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    
    [_manager POST:messageSignURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict1:%@",dict);
        
        int status = [dict[@"status"]intValue];
        
        if (status == 0) {
            
            statusStr = dict[@"newMeStatus"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                //一个section刷新
                
                NSIndexSet *indexSetA = [[NSIndexSet alloc]initWithIndex:3];    //刷新第3段
                [self.tableView reloadSections:indexSetA withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        
        return 2;
    }else if (section == 1||section == 2)
    {
        return 2;
    }else{
    
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    headCell *cell =[tableView dequeueReusableCellWithIdentifier:@"headCell"];
    if (!cell) {
        cell =[[headCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCell"];
    }
    
    mineModel *model = [[mineModel alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        
            model = self.dataArray[0];
        }else{

            model = self.dataArray[1];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            model = self.dataArray[2];
          }
    else{
    
        model = self.dataArray[3];
    }
}
    else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            
            model = self.dataArray[4];
        }
        else{
            
            model = self.dataArray[5];
        }
    }else{
    
        model = self.dataArray[6];
        
        NSString *str = [NSString stringWithFormat:@"%@",statusStr];
        if ([str isEqualToString:@"1"]) {
            
            cell.pointImg.backgroundColor = [UIColor redColor];
//            cell.pointImg.image = [UIImage imageNamed:@"ride_snap_default"];
        }else{
            
            cell.pointImg.hidden = YES;
        }
    }
    [cell setCellWithModel:model];
    return cell;
}

-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    //圆的边框宽度为2，颜色为红色
    CGContextSetLineWidth(context,2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    //在圆区域内画出image原图
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0 ) {
        
        if (indexPath.row == 0) {
            personDataController *personData = [[personDataController alloc]init];
            personData.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personData animated:YES];
            self.hidesBottomBarWhenPushed = NO;

        }else{
        
            mySonController *mySonVc = [[mySonController alloc]init];
            mySonVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mySonVc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }else if (indexPath.section ==1) {
        
        if (indexPath.row == 0) {
            
            myOrderController *allOrder = [[myOrderController alloc]init];
            allOrder.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:allOrder animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
       else{
           
            collectController *collect = [[collectController alloc]init];
            collect.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collect animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }else if (indexPath.section == 2) {
       
        if (indexPath.row ==0) {
            
            bugController *bug = [[bugController alloc]init];
            bug.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bug animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else{
            
            queryResultController *query = [[queryResultController alloc]init];
            query.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:query animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        }else{
                
            settingController *setting = [[settingController alloc]init];
            setting.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setting animated:YES];
            self.hidesBottomBarWhenPushed = NO;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    _headView = [[UIView alloc]init];
    if (section == 0) {
        
        _headView.backgroundColor = [UIColor whiteColor];
        _headImg = [[UIImageView alloc]init];
        _headImg.layer.cornerRadius = 32.5;
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.borderWidth = 1;
        _headImg.layer.borderColor = [UIColor colorWithHexString:@"#f2f2f2"].CGColor;
        _headImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeadImg)];
        [_headImg addGestureRecognizer:tapGuesture];
        _headLab = [[UILabel alloc]init];
        _headLab.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:_headImg];
        [_headView addSubview:_headLab];
        [self.view addSubview:_headView];
        [self layout];
    }
    
    return _headView;
}

#pragma mark -- 头视图
-(void)layout{
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView).offset(15);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.height.mas_equalTo(65);
    }];
    
    [self.headLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_bottom).offset(10);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo(200);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        
        return 128;
    }else{
    
        return 0.1f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 20;
}

-(void)onHeadImg{

    self.hidesBottomBarWhenPushed=YES;
    faceImgController *chat =[[faceImgController alloc]init];
    chat.imageStr = headImageStr;
    chat.fromWhere = @"1000";
    [self.navigationController pushViewController:chat animated:YES];
    self.hidesBottomBarWhenPushed=NO;//最后一句话，可以保证在back回到A时，tabBar会恢复正常显示
}

#pragma mark - *************PhotoEditDelegate*****************

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        DDLog(@"%@",image);
        //调整图片方向，防止上传后图片方向不对
        image = [image fixOrientation];
        DDLog(@"image:%@",image);
        
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
        NSData *data;

          data = [self imageWithImage:image scaledToSize:imgSize toCompression:1.0 isPngType:YES];
            if (data.length>300000) {
                data = [self getJpegTypeScaleImageWithImage:data toMaxFileSize:300000];
            }
        
        iconString = [data base64EncodedStringWithOptions:0];
        NSDictionary *param = @{@"userId":userId,@"iconString":iconString,@"imageType":@""};
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
        NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
        NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
        DDLog(@"%@",jsonString);
        [_manager POST:upLoadImageURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            DDLog(@"dict:%@",dict);
            int status = [dict[@"status"]intValue];
            if (status == 0) {
                
                DDLog(@"上传成功");
            //关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
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
