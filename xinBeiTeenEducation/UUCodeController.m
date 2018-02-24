//
//  UUCodeController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "UUCodeController.h"
#import "textFieldCell.h"

@interface UUCodeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *comfirmBtn;

@end

@implementation UUCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createView];
    [self.tableView registerClass:[textFieldCell class] forCellReuseIdentifier:@"textFieldCell"];
}

-(void)createNav{
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = @"UU密码";
    lable1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable1.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable1;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    textFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
    
    if (!cell) {
        
        cell = [[textFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textFieldCell"];
    }
    
    if (indexPath.section == 0) {
        
        cell.headLb.text = @"设置密码";
        
    }else{
    
        cell.headLb.text = @"确认密码";
    }
    cell.contentField.placeholder = @"";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section ==1) {
        
        self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        self.comfirmBtn = [[UIButton alloc]initWithFrame:CGRectMake( 40,40, SCREEN_WIDTH - 80, 40)];
        [self.comfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        self.comfirmBtn.layer.cornerRadius = 10;
        [self.comfirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#3696d3"]];
        [self.comfirmBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.footView addSubview:self.comfirmBtn];
        [self.view addSubview:self.footView];
        return self.footView;
    }else{
        
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        
        return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 0) {
        
        return 20;
    }else{
        
        return 100.f;
    }
}

-(void)backBtnClick{


}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:NO];
}

@end
