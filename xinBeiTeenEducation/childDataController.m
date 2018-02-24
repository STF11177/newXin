//
//  childDataController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/15.
//  Copyright © 2017年 user. All rights reserved.
//

#import "childDataController.h"
#import "personDataCell.h"
#import "sexController.h"
#import "nameController.h"
#import "HMDatePickView.h"
#import "childSexController.h"
#import "mySonModel.h"
#import "mySonController.h"
#import "ETRegularUtil.h"
#import "payController.h"
#import "gradeController.h"
#import "mySonSchoolModel.h"
#import "IQActionSheetPickerView.h"
#import "textFieldCell.h"
#import "CommonSheet.h"
#import "AlbumController.h"
#import "AlbumEditController.h"
#import "ETMessageView.h"
#import "UIImage+FixOrientation.h"
#import "personDataOtherCell.h"

#define MaxNum 9
@interface childDataController ()<UITableViewDelegate,UITableViewDataSource,CommonSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,textFieldCellDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,AlbumControllerDelegate,personDataDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) NSMutableArray *schollIdArray;

@property (nonatomic,strong) HMDatePickView *dataPickerView;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) IQActionSheetPickerView *picker;
@property (nonatomic,strong) NSMutableArray *selectedImgs;
@property (nonatomic,strong) textFieldCell *fieldCell;

@end

@implementation childDataController
static NSString *dateStr;
static NSString *nameStr;
static NSString *sexStr;
static NSString *babyId;
static NSString *userId;

static NSString *fromWhere1;
static NSString *titleStr;
static NSString *levelStr;
static NSString *examTime;
static NSString *adressStr;
static NSString *willTestTime;
static NSString *getAdress;
static NSString *money;
static NSString *subjectId;
static NSString *taskId;
static NSString *orderId;
static NSString *phoneNumber;
static NSString *pictureImg;
static NSString *schoolStr;
static NSString *schoolId;
static NSString *signStr;//标记
static NSString *iconString;
static NSString *imageStr;//图片
static NSString *idCardStr;//身份证
static NSString *fieldStr;//身份证
static NSString *imagType;
static NSString *iconString;
//原始尺寸
static CGRect oldframe;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createHttp];
    
    self.fd_interactivePopDisabled = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    [self.tableView registerClass:[personDataCell class] forCellReuseIdentifier:@"personDataCell"];
    [self.tableView registerClass:[textFieldCell class] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView registerClass:[personDataOtherCell class] forCellReuseIdentifier:@"personDataOtherCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    DDLog(@"%@",orderId);
    DDLog(@"%@",self.orderId);
    DDLog(@"%@",self.babyId);
    NSDictionary *param = @{@"babyId":self.babyId};
    [self loadChildDataWithParam:param];
}

-(void)createNav{
    
    self.dataSource = [[NSMutableArray alloc]init];
    self.dataSourceArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    self.schollIdArray = [[NSMutableArray alloc]init];
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    self.titleLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleLable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 , 10, 40, 40)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(UITableView *)tableView{

    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        gestureRecognizer.numberOfTapsRequired = 1;
        gestureRecognizer.cancelsTouchesInView = NO;
        self.tableView.userInteractionEnabled = YES;
        [self.tableView addGestureRecognizer:gestureRecognizer];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)hideKeyboard{

    [self.view endEditing:YES];
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadChildDataWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:seeChildMesURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            NSDictionary *result = dict[@"results"];
            dateStr = result[@"birthday"];
            nameStr = result[@"name"];
            sexStr = result[@"sex"];
            imageStr = result[@"imgs"];
            idCardStr = result[@"cardID"];
            self.titleLable.text = nameStr;
            
            DDLog(@"%@",imageStr);
            NSArray *babyList = dict[@"babyList"];
            
            for (NSDictionary *appDict in babyList) {
                
                mySonSchoolModel *mdoel = [[mySonSchoolModel alloc]init];
                [mdoel yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:mdoel.type];
                [self.schollIdArray addObject:mdoel.id];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setValue:mdoel.schoolName forKey:mdoel.type];
                [self.dataSourceArray addObject:dict];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSNumber *max = [self.dataArray valueForKeyPath:@"@max.floatValue"];
                NSString *str= [NSString stringWithFormat:@"%@",max];
                if ([ETRegularUtil isEmptyString:str]) {
                    
                    schoolStr = @"";
                }else if ([str isEqualToString:@"1"]) {
            
                    signStr = @"sign";
                    for (NSDictionary *dict in self.dataSourceArray) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",[dict allKeys][0]];
                        if ([keyStr isEqualToString:@"1"]) {
                            
                            NSString *str = [dict objectForKey:[dict allKeys][0]];
                            schoolStr = str;
                
                        }
                    }
                }else if ([str isEqualToString:@"0"]){
                
                    signStr = @"sign";
                    
                    for (NSDictionary *dict in self.dataSourceArray) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",[dict allKeys][0]];
                        if ([keyStr isEqualToString:@"0"]) {
                            
                            NSString *str = [dict objectForKey:[dict allKeys][0]];
                            schoolStr = str;
        
                        }
                    }
                }else if ([str isEqualToString:@"2"]){
                
                    signStr = @"sign";
                    for (NSDictionary *dict in self.dataSourceArray) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",[dict allKeys][0]];
                        if ([keyStr isEqualToString:@"2"]) {
                            
                            NSString *str = [dict objectForKey:[dict allKeys][0]];
                            schoolStr = str;
                        }
                    }
                }

                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 5) {
        textFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        if (!cell) {
            
            cell = [[textFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textFieldCell"];
        }
        cell.delegate = self;
        cell.headLb.text = @"身份证号码";
        cell.contentField.placeholder = @"请填写身份证号码";

        NSString *str = [NSString stringWithFormat:@"%@",idCardStr];
        if ([ETRegularUtil isEmptyString:idCardStr]) {
        
            cell.contentField.text = @"";
        }else{
            
            cell.contentField.text = str;
        }
        cell.contentField.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 4){
    
        personDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personDataCell"];
        if (!cell) {
            
            cell = [[personDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personDataCell"];
        }
    
        cell.titleLb.text = @"照片";
        DDLog(@"%@",imageStr);
        
        cell.delegate = self;
        NSString *imgStr = [NSString stringWithFormat:@"%@",imageStr];
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"moren_imgs"]];
        
        [cell.headImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.mas_equalTo(30);
        }];

        return cell;
    }else{
    
        personDataOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personDataOtherCell"];
        if (!cell) {
            
            cell = [[personDataOtherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personDataOtherCell"];
        }
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.row == 0) {
            
            cell.titleLb.text = @"姓名";
            cell.headLb.text = nameStr;
            
        }else if(indexPath.row == 1){
            
            cell.titleLb.text = @"性别";
            NSString *sex = [NSString stringWithFormat:@"%@",sexStr];
            if ([sex isEqualToString:@"0"]) {
                
                cell.headLb.text = @"男";
            }else if([sex isEqualToString:@"1"]){
                
                cell.headLb.text = @"女";
            }
        }else if(indexPath.row == 2){
            
            cell.titleLb.text = @"出生年月";
            cell.headLb.text = dateStr;
        }else{
            
            cell.titleLb.text = @"学校";
            cell.headLb.text = schoolStr;
        }        return cell;
    }
}
 
-(void)pressHeadView:(personDataCell *)cell{

    [self scanBigImageWithImageView:cell.headImgView];
}

- (void)scanBigImageWithImageView:(UIImageView *)currentImageview{
    //当前imageview的图片
    UIImage *image = currentImageview.image;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    [imageView setTag:0];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
//    UIImageView *imageView = [tap.view viewWithTag:0];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
//        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        nameController *name = [[nameController alloc]init];
        name.babyId = self.babyId;
        name.fromWhere = self.fromWhere;
        
        name.getAdress = self.getAdress;
        name.money = self.money;
        name.subjectId = self.subjectId;
        name.taskId = self.taskId;
        name.orderId = self.orderId;
        name.pictureImg = self.pictureImg;
        name.nameStr = nameStr;
        
        [self.navigationController pushViewController:name animated:YES];
        
    }else if(indexPath.row == 1){
        
        if ([ETRegularUtil isEmptyString:nameStr]) {
            
            [self showHint:@"请填写考生姓名"];
        }else {
        
            childSexController *sex =[[childSexController alloc]init];
            sex.babyId = self.babyId;
            sex.sexStr = sexStr;
            sex.fromWhere = self.fromWhere;
            
            sex.money = self.money;
            sex.subjectId = self.subjectId;
            sex.taskId = self.taskId;
            sex.orderId = self.orderId;
            sex.pictureImg = self.pictureImg;
            [self.navigationController pushViewController:sex animated:YES];
        }

    }else if(indexPath.row == 2){
        
        
        NSString *sexString = [NSString stringWithFormat:@"%@",sexStr];
        if ([ETRegularUtil isEmptyString:nameStr]) {
            
            [self showHint:@"请填写考生姓名"];
        }else if ([ETRegularUtil isEmptyString:sexString]){
            
            [self showHint:@"请选择考生性别"];
        }else{
            
            self.dataPickerView = [[HMDatePickView alloc] initWithFrame:self.view.frame];
            //距离当前日期的年份差（设置最大可选日期）
            self.dataPickerView.maxYear = 0;
            //设置最小可选日期(年分差)
            self.dataPickerView.minYear = 20;
            self.dataPickerView.date = [NSDate date];
            
            //设置字体颜色
            self.dataPickerView.fontColor = [UIColor blackColor];
            
            fromWhere1 = self.fromWhere;
            money = self.money;
            subjectId = self.subjectId;
            taskId = self.taskId;
            orderId = self.orderId;
            self.orderId = orderId;
            pictureImg = self.pictureImg;
            
            //日期回调
            __weak typeof (self) weakSelf = self;
            self.dataPickerView.completeBlock = ^(NSString *selectDate,NSString *fromWhere) {
                
                DDLog(@"%@",selectDate);
                NSDictionary *param = @{@"userId":userId,@"name":@"",@"sex":@"",@"birthday":selectDate,@"babyId":weakSelf.babyId};
                [weakSelf loadBirthDayWith:param];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
//                    DDLog(@"%@",weakSelf.schollIdArray);
//                    if (self.schollIdArray.count!=0) {
//                        
//                        for (int i = 0; i< self.schollIdArray.count; i++) {
//
//                            schoolId = weakSelf.schollIdArray[i];
//                            NSDictionary *param = @{@"babySchoolId":schoolId};
//                            [weakSelf loadDeleteDataWithparam:param];
//                        }
//                    }
                    [weakSelf.tableView reloadData];
                });
            };
            //配置属性
            [self.dataPickerView configuration];
            DDLog(@"%@",self.fromWhere);
            [self.view addSubview:self.dataPickerView];
        }
        
    }else if (indexPath.row == 3){
    
        NSString *sexString = [NSString stringWithFormat:@"%@",sexStr];
        if ([ETRegularUtil isEmptyString:nameStr]) {
            
            [self showHint:@"请填写考生姓名"];
        }else if ([ETRegularUtil isEmptyString:sexString]){
            
            [self showHint:@"请选择考生性别"];
        }else if([ETRegularUtil isEmptyString:
                  dateStr]){
            
            [self showHint:@"请选择考生出生日期"];
        }else{
        

//            NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
//            NSInteger dateMonth = [dateArray[1]integerValue];
//             NSInteger dVaule = dateMonth - 9;

//
//            DDLog(@"%@",dateStr);
            NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
            NSDate *nowDate = [NSDate date];

            NSString *birth = dateStr;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            //生日
            NSDate *birthDay = [dateFormatter dateFromString:birth];

            //用来得到详细的时差
            unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];

            NSString *yearStr = [NSString stringWithFormat:@"%ld",(long)[date year]];
            int yearInt = [yearStr intValue];
//
//
            if (yearInt < 3) {

                [self showAlertWithMessage:@"尚未达到入学年龄"];
            }
//            else if (yearInt == 3){
//                    if (dVaule <= 0) {
//
//                        gradeController *grade = [[gradeController alloc]init];
//                        grade.babyId = self.babyId;
//                        grade.signStr = @"1";
//                        [self.navigationController pushViewController:grade animated:NO];
//                    }else{
//
//                        [self showAlertWithMessage:@"尚未达到入学年龄"];
//                    }
            else{
//
                gradeController *grade = [[gradeController alloc]init];
//
//                if (3 <= yearInt && yearInt < 8 ) {
//
//                    grade.signStr = @"1";//幼儿园
//                }else if ( yearInt >= 7 && yearInt <13){
//
//                    grade.signStr = @"2";//小学
//                }else{
//
//                    grade.signStr = @"3";//初中
//                }
//
//                if (yearInt == 7) {
//
//                    if (dVaule <= 0) {
//
//                        grade.signStr = @"2";
//                    }else{
//
//                        grade.signStr = @"1";
//                    }
//                }
//
//                if (yearInt == 7) {
//
//                    if (dVaule <= 0) {
//
//                        grade.signStr = @"2";
//                    }else{
//
//                        grade.signStr = @"1";
//                    }
//                }
//
                grade.babyId = self.babyId;
                [self.navigationController pushViewController:grade animated:NO];
//
            }
        
        }
    }else if(indexPath.row == 4){
        
        NSString *sexString = [NSString stringWithFormat:@"%@",sexStr];
        if ([ETRegularUtil isEmptyString:nameStr]) {
            
            [self showHint:@"请填写考生姓名"];
        }else if ([ETRegularUtil isEmptyString:sexString]){
            
            [self showHint:@"请选择考生性别"];
        }else if([ETRegularUtil isEmptyString:
                  dateStr]){
            
            [self showHint:@"请选择考生出生日期"];
        }else{
        
        CommonSheet *sheet = [[CommonSheet alloc]initWithDelegate:self];
        [sheet setupWithTitles:@[@"",@"拍照",@"从手机相册选择"]];
        [sheet showInView:self.view];
        }
    }else{
    
        NSString *sexString = [NSString stringWithFormat:@"%@",sexStr];
        if ([ETRegularUtil isEmptyString:nameStr]) {
            
            [self showHint:@"请填写考生姓名"];
        }else if ([ETRegularUtil isEmptyString:sexString]){
            
            [self showHint:@"请选择考生性别"];
        }else if([ETRegularUtil isEmptyString:
                  dateStr]){
            
            [self showHint:@"请选择考生出生日期"];
        }else{
            
            }
    }
}


#pragma mark - ***********CommonSheetDelegate***********
- (void)commonSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag{
    
    self.selectedImgs = [[NSMutableArray alloc]init];
    
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
            albumVC.remainNum = 1;
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
    
    NSLog(@"infoxxxxx%@",info);
    // 返回一个编辑后的图片 UIImagePickerControllerOriginalImage
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    image = [image fixOrientation];
    
    DDLog(@"%@",image);
    [self.selectedImgs addObject:image];
    DDLog(@"%@",self.selectedImgs);
    

    [picker dismissViewControllerAnimated:NO completion:^{
        
        [UIView animateWithDuration:0.6 animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }];
    
    [self loadTextViewData];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:NO completion:^{
        
        [UIView animateWithDuration:0.6 animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }];
}

#pragma  mark - **************AlbumControllerDelegate************
- (void)selectedImagesFinished:(NSMutableArray *)images{
    
    DDLog(@"images:%@",images);
    [self.selectedImgs safelyAddObjectsFromArray:images];
    DDLog(@"self.selectedImgs:%@",self.selectedImgs);
    
    [self loadTextViewData];
}

-(void)loadTextViewData{
    
            dispatch_async(dispatch_get_main_queue(), ^{
                
                DDLog(@"%ld",(unsigned long)self.selectedImgs.count);
                DDLog(@"%@",self.selectedImgs);
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
                            DDLog(@"%@",iconString);
                        }
                        
                        __weak typeof(self) weakSelf = self;
                        dispatch_queue_t mainQueue = dispatch_get_main_queue();
                        //异步返回主线程，根据获取的数据，更新UI
                        dispatch_async(mainQueue, ^{
                            
                            DDLog(@"%@",imagType);
                            NSString *selectedImgCount = [NSString stringWithFormat:@"%ld",(unsigned long)self.selectedImgs.count];
                            DDLog(@"%@",selectedImgCount);
                            
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            NSString * userId = [userDefaults objectForKey:@"userName"];
                            DDLog(@"%@",self.babyId);
                            DDLog(@"%@",userId);
                        
                             NSDictionary *param = @{@"userId":userId,@"iconString":iconString,@"imageType":@"",@"babyId":self.babyId};
                            [weakSelf loadImageDataWithParam:param];
                            
                        });
                    }];
                });
             
            });
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

-(void)loadImageDataWithParam:(NSDictionary*)param{

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    [[ETMessageView sharedInstance] showSpinnerMessage:@"图片上传中" onView:self.view];
    [_manager POST:childImageURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            DDLog(@"上传成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *param = @{@"babyId":self.babyId};
                [self loadChildDataWithParam:param];
                //关闭相册界面
                [[ETMessageView sharedInstance] hideMessage];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//#pragma mark - ***********CommonSheetDelegate***********
//- (void)commonSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag{
//
//    switch ([index integerValue]) {
//        case 0:{
//            /* 拍照 */
//            [self openCameraAction];
//        }
//
//            break;
//        case 1:{
//            /* 相册 */
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            picker.delegate = self;
//            //设置选择后的图片可被编辑
//            picker.allowsEditing = YES;
//            [self presentViewController:picker animated:YES completion:nil];
//        }
//            
//            break;
//        default:
//            break;
//    }
//}
//
//#pragma  mark - **************UIImagePickerController************
////打开相机获取权限
//- (void)openCameraAction{
//    
//    //是否获得权限
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
//    {
//        // 展示提示语
//
//        [self showAlertWithMessage:@"请在iPhone的\"设置-隐私-相机\"中，允许访问相机。"];
//        return;
//    }
//    
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    //判断当前设备是否有照相功能
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        //判断如果没有相机就调用图片库
// 
//        [self showAlertWithMessage:@"设备不支持照相功能。"];
//        return;
//    }
//    
//    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//    picker.sourceType = sourceType;
//    picker.allowsEditing = YES;
//    picker.delegate = self;
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    [self presentViewController:picker animated:YES completion:nil];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [picker dismissViewControllerAnimated:NO completion:^{
//        
//        [UIView animateWithDuration:0.6 animations:^{
//            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//        }];
//    }];
//}
//
//#pragma mark - *************PhotoEditDelegate*****************
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    NSLog(@"%@",info);
//    //    返回一个编辑后的图片 UIImagePickerControllerOriginalImage
//    UIImage *selectedImage = info[@"UIImagePickerControllerEditedImage"];
//    //    上传照片


#pragma mark -- 身份证
-(void)idCardInCell:(textFieldCell *)cell{

    fieldStr = cell.contentField.text;
    
    DDLog(@"%@",fieldStr);

}

- (void)LoadIDCardDataWithParam:(NSDictionary*)param{

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:childDataURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                if ([self.fromWhere isEqualToString:@"112"]||[fromWhere1 isEqualToString:@"112"]) {
//
////                    [self loadNameData];
//                }else{
                
                mySonController *mySon = [[mySonController alloc]init];
                if ([ETRegularUtil isEmptyString:self.orderId]) {
                    
                    mySon.orderId = orderId;
                }else{
                    
                    mySon.orderId = self.orderId;
                }
                if ([self.fromWhere isEqualToString:@"112"]||[fromWhere1 isEqualToString:@"112"]) {
                    
                    mySon.fromStr = @"112";
                }else{
                 
                    mySon.fromStr = @"";
                }
                [self.navigationController pushViewController:mySon animated:YES];


            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (BOOL)checkUserID:(NSString *)userID
{
    //长度不为18的都排除掉
    if (userID.length!=18) {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
}

/**
 * 开始到结束的时间差
 */
- (NSString *)getTotalTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    //按照日期格式创建日期格式句柄
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    //将日期字符串转换成Date类型
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    //将日期转换成时间戳
    NSTimeInterval start = [startDate timeIntervalSince1970]*1;
    NSTimeInterval end = [endDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    //计算具体的天，时，分，秒
    int second = (int)value %60;//秒
    int minute = (int)value / 60 % 60;
    int house = (int)value / 3600;
    int day = (int)value / (24 * 3600);
    //将获取的int数据重新转换成字符串
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d天",day];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"%d秒",second];
    }
    //返回string类型的总时长
    return str;
}

#pragma mark -- 生日
-(void)loadBirthDayWith:(NSDictionary *)param{
    
    __weak typeof (self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:childDataURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        babyId = dict[@"babyId"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            DDLog(@"成功");
            childDataController *child = [[childDataController alloc]init];
            child.babyId = babyId;
            [weakSelf.navigationController pushViewController:child animated:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)presentBack{
    
    DDLog(@"%@",self.titleStr);
    DDLog(@"%@",self.money);
    DDLog(@"%@",self.fromWhere);
    
    DDLog(@"%@",self.dataArray);
    NSString *sexString = [NSString stringWithFormat:@"%@",sexStr];
    
    
        if ([ETRegularUtil isEmptyString:nameStr]&&[ETRegularUtil isEmptyString:sexString]&&[ETRegularUtil isEmptyString:dateStr]&&(self.dataArray.count ==0)){
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([ETRegularUtil isEmptyString:nameStr]||[ETRegularUtil isEmptyString:sexString]||[ETRegularUtil isEmptyString:dateStr]||(self.dataArray.count ==0)) {
            
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息未保存，确认返回"message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[mySonController class]]) {
                            
                            DDLog(@"%@",self.babyId);
                            NSDictionary *param = @{@"babyId":self.babyId};
                            [self loadDeleteDataWithparam:param];
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
            }];
            
            [alertControl addAction:action];
            [alertControl addAction:action1];
            [self presentViewController:alertControl animated:YES completion:nil];
        }else{
            
            DDLog(@"%@",phoneNumber);
//            if ([self.fromWhere isEqualToString:@"112"]||[fromWhere1 isEqualToString:@"112"]) {
//
////                [self loadNameData];
//            }else{
            
            mySonController *mySon = [[mySonController alloc]init];
            if ([ETRegularUtil isEmptyString:self.orderId]) {
                
                mySon.orderId = orderId;
            }else{
                
                mySon.orderId = self.orderId;
            }
            if ([self.fromWhere isEqualToString:@"112"]||[fromWhere1 isEqualToString:@"112"]) {
                
                mySon.fromStr = @"112";
            }else{
                
                mySon.fromStr = @"";
            }
            
            [self.navigationController pushViewController:mySon animated:YES];
//            }
        }
}

#pragma mark -- 保存
-(void)saveMessage{
    
    DDLog(@"%@",nameStr);
    DDLog(@"%@",sexStr);
    DDLog(@"%@",dateStr);
    NSString *sexString = [NSString stringWithFormat:@"%@",sexStr];
    if ([ETRegularUtil isEmptyString:nameStr]) {
        
        [self showHint:@"请填写姓名"];
    }else if ([ETRegularUtil isEmptyString:sexString]){
        
        [self showHint:@"请选择性别"];
    }else if([ETRegularUtil isEmptyString:
              dateStr]){
        
        [self showHint:@"请选择出生日期"];
    }else if([ETRegularUtil isEmptyString:schoolStr]){
        
        [self showHint:@"请选择学校"];
    }else {

        DDLog(@"%@",fieldStr);
        if(![ETRegularUtil isEmptyString:fieldStr]){

                if ([self checkUserID:fieldStr]) {
                    
                    NSString *cardStr = [NSString stringWithFormat:@"%@",fieldStr];
                    NSDictionary *dict = @{@"cardID":cardStr, @"userId":userId,@"name":@"",@"sex":@"",@"birthday":@"",@"babyId":self.babyId};
                    [self LoadIDCardDataWithParam:dict];
                }else{
                    
                    [self showAlertWithMessage:@"身份证号码错误，请重新输入"];
                }
        }else{
            
            mySonController *mySon = [[mySonController alloc]init];
            if ([ETRegularUtil isEmptyString:self.orderId]) {
                
                mySon.orderId = orderId;
            }else{
                
                mySon.orderId = self.orderId;
            }
            if ([self.fromWhere isEqualToString:@"112"]||[fromWhere1 isEqualToString:@"112"]) {

                mySon.fromStr = @"112";
            }else{
                
                mySon.fromStr = @"";
            }
            
            [self.navigationController pushViewController:mySon animated:YES];
        }
    }
}

#pragma mark -- 姓名，电话号码
-(void)loadNameData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *param = @{@"userId":userId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:addchildDataURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        NSArray *results = dict[@"results"];
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            for (NSDictionary *appDict in results) {
                
                mySonModel *model = [[mySonModel alloc]init];
                [model yy_modelSetWithDictionary:appDict];
                [self.dataSource addObject:model];
                phoneNumber = model.userName;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[payController class]]) {
                            
                            payController *pay = [[payController alloc]init];
                            pay.payNameStr = nameStr;
                            pay.phoneNumber = phoneNumber;
                            
                            pay.titleStr = titleStr;
                            pay.typeName = levelStr;
                            pay.examDate = examTime;
                            pay.address = adressStr;
                            pay.getTime = willTestTime;
                            pay.getAddress = getAdress;
                            pay.money = money;
                            pay.type = subjectId;
                            pay.subjectStr = taskId;
                            pay.orderId = orderId;
                            pay.pictureImg = pictureImg;
                            
                            
                            pay.titleStr = self.titleStr;
                            pay.typeName = self.levelStr;
                            pay.examDate = self.examTime;
                            pay.address = self.adressStr;
                            
                            fromWhere1 = nil;
                            self.fromWhere = nil;
                            [self.navigationController pushViewController:pay animated:YES];
                        }
                    }
                
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark -- 删除
-(void)loadDeleteDataWithparam:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:deletePersonURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [weakSelf.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
