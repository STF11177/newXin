//
//  myOrderController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/15.
//  Copyright © 2017年 user. All rights reserved.
//

#import "myOrderController.h"
#import "collectCell.h"
#import "orderController.h"
#import "eduOrderController.h"

@interface myOrderController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation myOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    [self.tableView registerClass:[collectCell class] forCellReuseIdentifier:@"collectCell"];
}

-(void)createView{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"我的订单";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
            }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    collectCell *cell =[tableView dequeueReusableCellWithIdentifier:@"collectCell"];
    if (!cell) {
        cell =[[collectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectCell"];
    }
    
    if (indexPath.row == 0) {
        
        cell.titleLb.text = @"我的考证";
        cell.arrowImg.image =[UIImage imageNamed:@"jiantou"];
    }else {
        
        cell.titleLb.text = @"图书订单";
        cell.arrowImg.image =[UIImage imageNamed:@"jiantou"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        orderController *circle = [[orderController alloc]init];
        [self.navigationController pushViewController:circle animated:YES];
    }else{
        
        eduOrderController *hot = [[eduOrderController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(void)presentVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
