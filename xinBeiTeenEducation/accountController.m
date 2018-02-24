//
//  accountController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "accountController.h"
#import "payDetailCell.h"
#import "TableViewCell.h"
#import "UUCodeController.h"

@interface accountController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation accountController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNav];
    [self createView];
}

-(void)createNav{
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = @"账户安全";
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

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        
        return 2;
    }else{
    
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        
        payDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell = [[payDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        if (indexPath.row == 0) {
            
            cell.headLb.text = @"昵称";
            cell.contentLb.text = @"流潋紫";
        }else{
        
            cell.headLb.text = @"手机号";
            cell.contentLb.text = @"12345678901";
        }
        
        return cell;
    }else{
    
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
        if (!cell) {
            
            cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
        }
        cell.nameLable.text = @"UU密码";
        cell.textLable1.text = @"未设置";
        cell.textLable1.textAlignment = NSTextAlignmentRight;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
        UUCodeController *code = [[UUCodeController alloc]init];
        [self.navigationController pushViewController:code animated:NO];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        
        return 0.1f;
    }else{
    
        return 10.f;
    }
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:NO];
}

@end
