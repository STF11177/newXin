//
//  collectController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/12.
//  Copyright © 2017年 user. All rights reserved.
//

#import "collectController.h"
#import "collectCell.h"
#import "collectCircleController.h"
#import "hotCollectController.h"
#import "testCollectController.h"

@interface collectController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation collectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createNav];
}

-(void)createNav{

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"我的收藏";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createTableView{

    _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    collectCell *cell =[tableView dequeueReusableCellWithIdentifier:@"collectCell"];
    if (!cell) {
        cell =[[collectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectCell"];
    }
    
    if (indexPath.row == 0) {
        
    cell.titleLb.text = @"圈子的收藏";
    cell.arrowImg.image =[UIImage imageNamed:@"jiantou"];
    }else if(indexPath.row == 1){
    
    cell.titleLb.text = @"热文的收藏";
    cell.arrowImg.image =[UIImage imageNamed:@"jiantou"];
    }else{
    
    cell.titleLb.text = @"考证的收藏";
    cell.arrowImg.image =[UIImage imageNamed:@"jiantou"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        collectCircleController *circle = [[collectCircleController alloc]init];
        [self.navigationController pushViewController:circle animated:YES];
    }else if(indexPath.row == 1){
    
        hotCollectController *hot = [[hotCollectController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
    }else{
    
        testCollectController *test = [[testCollectController alloc]init];
        [self.navigationController pushViewController:test animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

-(void)presentVC{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
