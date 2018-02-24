//
//  sexController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "sexController.h"
#import "personDataController.h"

@interface sexController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) UITableView *sexTableView;
@property (nonatomic,strong) NSIndexPath *selectPath;//存放被点击哪一行的标志

@end

@implementation sexController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self createView];
    [self createTableView];
    [self createHttp];
}

-(void)createView{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"性别";
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

-(void)createTableView{

    _sexTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 149) style:UITableViewStylePlain];
    _sexTableView.delegate = self;
    _sexTableView.dataSource = self;
    _sexTableView.scrollEnabled = NO;
    [self.view addSubview:_sexTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"男";
    }else{
    
    cell.textLabel.text = @"女";
    }
    
    NSString *indexPathStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSString *sexString = [NSString stringWithFormat:@"%@",self.sexStr];
    if ([indexPathStr isEqualToString:sexString]) {
        
        _selectPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }else{
    
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int newRow = (int)[indexPath row];
    int oldRow = (int)[_selectPath row];
    
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_selectPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    _selectPath = [indexPath copy];
    DDLog(@"%@",_selectPath);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)loadData{

    DDLog(@"%@",[NSString stringWithFormat:@"%ld",[_selectPath row]]);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userName"];
    NSDictionary *param = @{@"userId":userId,@"nickName":@"",@"phone":@"",@"sdasd":@"",@"sex":[NSString stringWithFormat:@"%ld",(long)[_selectPath row]]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:nickURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            DDLog(@"成功");
            personDataController *person = [[personDataController alloc]init];
            [self.navigationController pushViewController:person animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)saveMessage{
    
    [self loadData];
}


-(void)presentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

@end
