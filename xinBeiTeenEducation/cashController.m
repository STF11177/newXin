//
//  cashController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "cashController.h"
#import "settingCashCell.h"

@interface cashController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation cashController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNav];
    [self createView];
    
    [self.tableView registerClass:[settingCashCell class] forCellReuseIdentifier:@"settingCashCell"];
}

-(void)createNav{
 
    self.titleLb.text = @"抵用劵";
    [self.leftBtn addTarget:self action:@selector(presentToBack) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
//    lable1.textAlignment = NSTextAlignmentCenter;
//    lable1.text = @"抵用劵";
//    lable1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
//    lable1.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lable1;

//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(presentToBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"规则" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(presentToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)createView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    settingCashCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCashCell"];
    if (!cell) {
        
        cell = [[settingCashCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCashCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
    
        return 10.f;
    }else{
    
        return 0.1f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10.f;
}

-(void)presentToBack{
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
