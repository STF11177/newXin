//
//  gradeDetailController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "gradeDetailController.h"
#import "blockController.h"
#import "IQActionSheetPickerView.h"
#import "ETRegularUtil.h"
#import "gradeSchoolModel.h"
#import "gradeClassModel.h"
#import "addClassController.h"
#import "gradeController.h"
#import "CommonSheet.h"
#import "personDataOtherCell.h"

@interface gradeDetailController ()<UITableViewDataSource,UITableViewDelegate,IQActionSheetPickerViewDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *classArray;
@property (nonatomic,strong) NSMutableArray *schoolIdArray;
@property (nonatomic,strong) NSMutableArray *schoolArray;
@property (nonatomic,strong) personDataOtherCell *personCell;
@property (nonatomic,strong) NSString *signStr;
@property (nonatomic,strong) IQActionSheetPickerView *picker;
@property (nonatomic,strong) UIButton *footBtn;

@end

@implementation gradeDetailController
static NSString *schoolId;
static NSString *gradeStr;
static NSString *classStr1;
static NSString *babyId;
static NSString *babyString;
static NSString *brithDay;
static int yearInt;
static int dateInt;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createHttp];
    
    DDLog(@"%@",self.babyId);
    babyString = self.babyId;
    
    NSDictionary *param = @{@"babyId":self.babyId};
    [self loadChildDataWithParam:param];
    
    if ([self.fromAddClass isEqualToString:@"addClass"]) {
        
    }else{
    
    [self loadAllData];
}
    
    [self.tableView registerClass:[personDataOtherCell class] forCellReuseIdentifier:@"personDataOtherCell"];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = self.nameStr;
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
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
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)createBtn{

    if (![ETRegularUtil isEmptyString:schoolId]) {
        
        self.footBtn = [[UIButton alloc]initWithFrame:CGRectMake( 15, 200, SCREEN_WIDTH - 30, 44)];
        [self.footBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.footBtn addTarget:self action:@selector(footClick) forControlEvents:UIControlEventTouchUpInside];
        self.footBtn.backgroundColor = [UIColor colorWithHexString:@"#3696d3"];
        self.footBtn.layer.cornerRadius = 5;
        [self.tableView addSubview:self.footBtn];
    }
}

-(void)footClick{
    
    if ([ETRegularUtil isEmptyString:schoolId]) {
        
        [self showAlertWithMessage:@"请选择学校"];
    }else{
    
        [self loadDeleteSchoolData];
    }
}

-(void)loadDeleteSchoolData{

    NSDictionary *param = @{@"babySchoolId":schoolId};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:childSchoolDeleteURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                gradeController *grade = [[gradeController alloc]init];
                
                if ([ETRegularUtil isEmptyString:self.babyId]) {
                    
                    grade.babyId = babyId;
                }else{
                    grade.babyId = self.babyId;
                }
                
                schoolId = @"";
                grade.signStr = self.detailStr;
                [self.navigationController pushViewController:grade animated:YES];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)classArray{
    
    if (!_classArray) {
        
        _classArray = [[NSMutableArray alloc]init];
    }
    return _classArray;
}

-(NSMutableArray *)schoolIdArray{
    
    if (!_schoolIdArray) {
        
        _schoolIdArray = [[NSMutableArray alloc]init];
    }
    return _schoolIdArray;
}

-(NSMutableArray *)schoolArray{

    if (!_schoolArray) {
        
        _schoolArray = [[NSMutableArray alloc]init];
    }
    return _schoolArray;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark --查看所有的信息
-(void)loadAllData{
    
    DDLog(@"%@",self.fromWhere);
    NSString *str = [NSString stringWithFormat:@"%@",self.babyId];
    DDLog(@"%@",str);
    NSDictionary *param = @{@"type":self.fromWhere,@"userbayId":str};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:myChildGradeURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            NSDictionary *menListDict = dict[@"menuList"];
            self.addressStr = menListDict[@"districtName"];
            self.schoolStr = menListDict[@"schoolName"];
            self.timeStr = menListDict[@"intake_time"];
            self.classStr = menListDict[@"grade_class"];
            DDLog(@"%@",self.classStr);
            schoolId = menListDict[@"id"];
            babyId = menListDict[@"babyId"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self createBtn];
                [self.tableView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 学校
-(void)loadSchoolData{
    
    DDLog(@"%@",self.fromWhere);
    DDLog(@"%@",self.addressStr);
    NSDictionary *param = @{@"type":self.fromWhere,@"districtName":self.addressStr};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:myChildSchoolURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            [self.dataArray removeAllObjects];
            [self.schoolIdArray removeAllObjects];
            NSArray *menuList = dict[@"menuList"];
            for (NSDictionary *dict in menuList) {
                
                gradeSchoolModel *model = [[gradeSchoolModel alloc]init];
                [model yy_modelSetWithDictionary:dict];
                [self.dataArray addObject:model.school_name];
                [self.schoolIdArray addObject:model.id];
                
                NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
                [dict1 setValue:model.school_name forKey:model.district_name];
                [self.schoolArray addObject:dict];
            }
            
            _picker = [[IQActionSheetPickerView alloc]initWithTitle:@"选择板块" delegate:self];
            _picker.backgroundColor =[UIColor blackColor];
            _picker.titleFont = [UIFont systemFontOfSize:18];
            _picker.titleColor = [UIColor blackColor];
            _picker.delegate = self;
            [_picker dismiss];
            
            self.signStr = @"111";
            _picker.addBtn.hidden = YES;
            [_picker setTag:1];
            [_picker setTitlesForComponents:@[_dataArray]];
            [_picker show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 班级
-(void)loadClassData{
    
    NSDictionary *param = @{@"type":self.fromWhere,@"schoolName":self.schoolStr};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:myChildclassURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            [self.classArray removeAllObjects];
            
            NSArray *menuList = dict[@"menuList"];
            for (NSDictionary *dict in menuList) {
                
                gradeClassModel *model = [[gradeClassModel alloc]init];
                [model yy_modelSetWithDictionary:dict];
                [self.classArray addObject:model.class_name];
            }
            
            _picker = [[IQActionSheetPickerView alloc]initWithTitle:@"选择板块" delegate:self];
            _picker.backgroundColor =[UIColor blackColor];
            _picker.titleFont = [UIFont systemFontOfSize:18];
            _picker.titleColor = [UIColor blackColor];
            _picker.delegate = self;
            [_picker dismiss];
            
            self.signStr = @"113";
//            NSDate *currentDate = [NSDate date];
            [_picker setTag:1];
            
            
            if ([self.fromWhere isEqualToString:@"0"]) {
                
               [_picker setTitlesForComponents:@[@[@"托班入园",@"小班入园"]]];
            }else{
             
               [_picker setTitlesForComponents:@[self.classArray]];
            }
            
            [_picker show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -- 保存
-(void)loadSavemessageData{
    
    DDLog(@"%@",self.fromWhere);
    DDLog(@"%@",self.schoolStr);
    DDLog(@"%@",self.classStr);
    DDLog(@"%@",self.timeStr);
    
    DDLog(@"%@",self.addressStr);
    DDLog(@"%@",babyId);
    DDLog(@"%@",schoolId);
    
    NSString *babyStr;
    if ([ETRegularUtil isEmptyString:self.babyId]) {
    
        babyStr = [NSString stringWithFormat:@"%@",babyId];
    }else{
    
        babyStr = [NSString stringWithFormat:@"%@",self.babyId];
    }
    
    NSString *schoolIdStr = [NSString stringWithFormat:@"%@",schoolId];
    
    if ([ETRegularUtil isEmptyString:schoolIdStr]) {
        
        schoolIdStr = @"0";
    }
    
    NSDictionary *param = @{@"babySchoolId":schoolIdStr,@"babyId":babyStr,@"districtName":self.addressStr,@"intake_time":self.timeStr,@"grade_type":self.classStr,@"type":self.fromWhere,@"schoolName":self.schoolStr};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    DDLog(@"jsonString:%@",jsonString);
    [_manager POST:saveAllMessageURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
           
//            for (UIViewController *temp in self.navigationController.viewControllers) {
//                if ([temp isKindOfClass:[gradeController class]]) {
            
                    gradeController *grade = [[gradeController alloc]init];
                    grade.babyId = babyStr;
                    grade.signStr = self.detailStr;
                    [self.navigationController pushViewController:grade animated:YES];
//        }
//          }
            
//            [self.navigationController popViewControllerAnimated:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    personDataOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personDataOtherCell"];
    if (!cell) {
        
        cell = [[personDataOtherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personDataOtherCell"];
    }
    
    self.personCell.indexPath = indexPath;
    if (indexPath.row == 0) {
        
        cell.titleLb.text = @"所在区";
        cell.headLb.text = self.addressStr;
    }else if(indexPath.row == 1){
        
        cell.titleLb.text = @"学校";
        cell.headLb.text = self.schoolStr;
    }else if(indexPath.row == 2){
        
        if ([self.fromWhere isEqualToString:@"0"]) {
            
            cell.titleLb.text = @"入园时间";
        }else{
        
            cell.titleLb.text = @"入校时间";
        }
    
        cell.headLb.text = self.timeStr;
    }else{
      
        if ([self.fromWhere isEqualToString:@"0"]) {
            
            cell.titleLb.text = @"入园年级";
        }else{
            
            cell.titleLb.text = @"年级";
        }
        
            if ([self.fromAddClass isEqualToString:@"addClass"]) {
    
                if ([self.fromWhere isEqualToString:@"0"]) {
                    
                    cell.headLb.text = self.classStr;
                }else{
                
//                  NSString *string = [gradeStr stringByAppendingString:@"/"];
                    cell.headLb.text = self.classStr;
                }
                 self.fromAddClass = @"";
            }else{
                
                cell.headLb.text = self.classStr;
            }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        _picker = [[IQActionSheetPickerView alloc]initWithTitle:@"选择板块" delegate:self];
        _picker.backgroundColor =[UIColor blackColor];
        _picker.titleFont = [UIFont systemFontOfSize:18];
        _picker.titleColor = [UIColor blackColor];
        _picker.delegate = self;
        [_picker dismiss];
        
        self.signStr = @"110";
        
        _picker.addBtn.hidden = YES;
        
        NSArray *dataArray = @[@"浦东新区",@"徐汇区",@"长宁区",@"普陀区",@"黄浦区",@"静安区",@"虹口区",@"杨浦区",@"闵行区",@"宝山区",@"嘉定区",@"金山区",@"松江区",@"青浦区",@"奉贤区",@"崇明区"];
        [_picker setTag:1];
        [_picker setTitlesForComponents:@[dataArray]];
        [_picker show];
        
    }else if(indexPath.row == 1){
        if ([ETRegularUtil isEmptyString:self.self.addressStr]) {
            
            [self showHint:@"请选择所在地区"];
        }else{
            
            [self loadSchoolData];
        }
        
    }else if (indexPath.row == 2) {
        
        _picker = [[IQActionSheetPickerView alloc]initWithTitle:@"选择板块" delegate:self];
        _picker.backgroundColor =[UIColor blackColor];
        _picker.titleFont = [UIFont systemFontOfSize:18];
        _picker.titleColor = [UIColor blackColor];
        _picker.delegate = self;
        [_picker dismiss];
        
        self.signStr = @"112";
       
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM"];

        NSDate *datenow = [NSDate date];
        NSString *nowtimeStr = [formatter stringFromDate:datenow];
        DDLog(@"nowtimeStr =  %@",nowtimeStr);

        NSArray *dateArray = [nowtimeStr componentsSeparatedByString:@"-"];
        dateInt = [dateArray[1]intValue];
        yearInt = [dateArray[0]intValue];

        int differenceInt = yearInt -2002;
        int yearStr = 2002;
        int countInt;
        if (dateInt <9) {
            
            countInt = differenceInt;
        }else{
            
            countInt = differenceInt +1;
        }
        
        NSMutableArray *array = [NSMutableArray array];
     
            for (int i =0; i < countInt; i++) {

                NSString *str = [NSString stringWithFormat:@"%d",yearStr];
                NSString *monthStr = [str stringByAppendingString:@"-9"];

                [array addObject:monthStr];
                yearStr = yearStr + 1;
            }
    
        array = (NSMutableArray*)[[array reverseObjectEnumerator]allObjects];
        _picker.addBtn.hidden = YES;
        [_picker setTag:1];
        [_picker setTitlesForComponents:@[array]];
        [_picker show];
        
    
    }else if (indexPath.row == 3){
        
        if ([ETRegularUtil isEmptyString:self.addressStr]) {
            
            [self showHint:@"请选择所在地区"];
        } else if([ETRegularUtil isEmptyString:self.schoolStr]){
            
            [self showHint:@"请选择学校"];
        }else if([ETRegularUtil isEmptyString:self.timeStr]){
            
            [self showHint:@"请选择入校时间"];
        }else{
            
            [self loadClassData];
        }
    }
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
            
            NSDictionary *results = dict[@"results"];
            brithDay = results[@"birthday"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles{
    
    if ([self.signStr isEqualToString:@"110"]) {
        
        if (![self.addressStr isEqualToString:[titles componentsJoinedByString:@" - "]]) {
            
            self.schoolStr = nil;
            self.classStr = nil;
        }
        self.addressStr = [titles componentsJoinedByString:@" - "];
        
    }else if ([self.signStr isEqualToString:@"111"]){
        
        self.schoolStr = [titles componentsJoinedByString:@" - "];
    }
    
    else if ([self.signStr isEqualToString:@"112"]){
        
        self.timeStr = [titles componentsJoinedByString:@" - "];
        
        NSArray *timeArray = [self.timeStr componentsSeparatedByString:@"-"];
        int title = [timeArray[0]intValue];
        
        NSArray *array1 = [self.classStr componentsSeparatedByString:@"/"];
        NSString *string = array1[1];
        
        if ([self.fromWhere isEqualToString:@"2"]) {
            
            if (title < yearInt - 1) {
                
                if (dateInt > 9) {
                    
                    gradeStr = @"初三";
                }else{
                    
                    gradeStr = @"初二";
                }
            }else if (title == yearInt - 1){
                
                if (dateInt > 9) {
                    
                    gradeStr = @"初二";
                }else{
                    
                    gradeStr = @"初一";
                }
            }else if (title == yearInt){
                
                    gradeStr = @"初一";
            }
            
            if (![ETRegularUtil isEmptyString:classStr1]) {
                
                self.classStr = [gradeStr stringByAppendingPathComponent:classStr1];
            } else if([self.fromAddClass isEqualToString:@"addClass"]){
                
                self.classStr = [gradeStr stringByAppendingString:self.addClass];
            }else{
                
                NSString *str = [NSString stringWithFormat:@"/%@",string];
                if ([ETRegularUtil isEmptyString:string]) {
                    
                    self.classStr = @"";
                }else{
                    
                    self.classStr = [gradeStr stringByAppendingString:str];
                }
            }
        }else if ([self.fromWhere isEqualToString:@"0"]){
    
            gradeStr = @"";
            if (title == yearInt){
                    
                    gradeStr = @"托班入园";
            }else{
                
                if (dateInt >9) {
                    
                    gradeStr = @"托班入园";
                }else{
                    
                    gradeStr = @"小班入园";
                }
            }
        }else if([self.fromWhere isEqualToString:@"1"]){
            
            if (title < yearInt -4){
                
                gradeStr = @"五年级";
            }else if (title == yearInt -4){

                if (dateInt >9) {
                    
                    gradeStr = @"五年级";
                }else{
                    
                    gradeStr = @"四年级";
                }
            }else if (title == yearInt -3){
                
                if (dateInt >9) {
                    
                    gradeStr = @"四年级";
                }else{
                    
                    gradeStr = @"三年级";
                }
            }else if (title == yearInt -2) {
                
                if (dateInt >9) {
                    
                    gradeStr = @"三年级";
                }else{
                    
                    gradeStr = @"二年级";
                }
            }else if (title == yearInt -1){
                
                if (dateInt >9) {
                    
                    gradeStr = @"二年级";
                }else{
                    
                    gradeStr = @"一年级";
                }
            }else if (title == yearInt){
                
                gradeStr = @"一年级";
            }
            
            if (![ETRegularUtil isEmptyString:classStr1]) {
                
                self.classStr = [gradeStr stringByAppendingPathComponent:classStr1];
            } else if([self.fromAddClass isEqualToString:@"addClass"]){
                
                self.classStr = [gradeStr stringByAppendingString:self.addClass];
            }else{
                
                NSString *str = [NSString stringWithFormat:@"/%@",string];
                if ([ETRegularUtil isEmptyString:string]) {
                    
                    self.classStr = @"";
                }else{
                    
                    self.classStr = [gradeStr stringByAppendingString:str];
                }
            }
        }
        
    }else{
        
        if ([titles containsObject:@"添加"]) {
            
            DDLog(@"%@",self.babyId);
            [_picker dismiss];
            addClassController *addClass = [[addClassController alloc]init];
            addClass.typeStr = self.fromWhere;
            addClass.schoolStr = self.schoolStr;
            addClass.babyId = self.babyId;
            addClass.addressStr = self.addressStr;
            addClass.classStr = self.classStr;
            addClass.timeStr = self.timeStr;
            addClass.nameStr = self.nameStr;
            addClass.gradeStr = gradeStr;
            DDLog(@"%@",gradeStr);
            DDLog(@"%@",self.classStr);
            [self.navigationController pushViewController:addClass animated:YES];
        
        }else{
            
            NSArray *classArray = [self.classStr componentsSeparatedByString:@"/"];
            NSString *string = classArray[0];

            if ([self.fromWhere isEqualToString:@"0"]){
               
                if([self.fromAddClass isEqualToString:@"addClass"]&&![ETRegularUtil isEmptyString:self.addClass]){
                
                    self.classStr = self.addClass;
                   
                }else{
                
                    self.classStr =  [titles componentsJoinedByString:@" - "];
                }
            }else{

                classStr1 = [titles componentsJoinedByString:@" - "];
                DDLog(@"%@",classStr1);
                DDLog(@"%@",gradeStr);
                
                if([self.fromAddClass isEqualToString:@"addClass"]){
                    
                    NSString *string1 = [gradeStr stringByAppendingString:@"/"];
                    self.classStr = [string1 stringByAppendingString:self.addClass];
                    
                } else{
                    
                    if ([ETRegularUtil isEmptyString:string]) {
                        
                       self.classStr = [gradeStr stringByAppendingPathComponent: [titles componentsJoinedByString:@" - "]];
                    }else{
                    
                        DDLog(@"%@",string);
                        self.classStr = [string stringByAppendingPathComponent: [titles componentsJoinedByString:@" - "]];
                    }
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

-(void)addBtn{
    
    addClassController *addClass = [[addClassController alloc]init];
    addClass.typeStr = self.fromWhere;
    addClass.self.schoolStr = self.schoolStr;
    [_picker dismiss];
    [self.navigationController pushViewController:addClass animated:YES];
}

-(void)presentBack{
    
    if ([ETRegularUtil isEmptyString:self.addressStr]||[ETRegularUtil isEmptyString:self.schoolStr]||[ETRegularUtil isEmptyString:self.timeStr]||[ETRegularUtil isEmptyString:self.classStr]) {
    
    
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息未保存，确认返回" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];

        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            gradeController *grade = [[gradeController alloc]init];
            if ([ETRegularUtil isEmptyString:self.babyId]) {
                
                grade.babyId = babyId;
            }else{
                grade.babyId = self.babyId;
            }
            grade.signStr = self.detailStr;
            [self.navigationController pushViewController:grade animated:YES];
        }];

        [alertControl addAction:action];
        [alertControl addAction:action1];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
                gradeController *grade = [[gradeController alloc]init];
                if ([ETRegularUtil isEmptyString:self.babyId]) {

                    grade.babyId = babyId;
                }else{
                    grade.babyId = self.babyId;
                }
                grade.signStr = self.detailStr;
                [self.navigationController pushViewController:grade animated:YES];
    }
}

-(void)saveMessage{
    if ([ETRegularUtil isEmptyString:self.addressStr]) {
        
        [self showHint:@"请选择所在地区"];
    } else if([ETRegularUtil isEmptyString:self.schoolStr]){
        
        [self showHint:@"请选择学校"];
    }else if([ETRegularUtil isEmptyString:self.timeStr]){
        
        [self showHint:@"请选择入校时间"];
    }else if ([ETRegularUtil isEmptyString:self.classStr]){
        
        [self showHint:@"请选择年级"];
    }else{
        
        [self loadSavemessageData];
    }
}

@end
