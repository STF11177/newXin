//
//  testifyController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "testifyController.h"

@interface testifyController ()

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UITextField *headtextField;

@end

@implementation testifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor colorWithHexString:@"#f2f2f2"];
    [self createNavBarItem];
    [self createView];
    [self layoutUI];
}

-(void)createNavBarItem{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"朋友验证";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 19)];
   [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 19)];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(completeBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item1;
}

- (void)createView{
    
    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = @"你需要发送验证申请，等对方通过";
    self.nameLable.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:self.nameLable];
    
    self.headView = [[UIView alloc]init];
    self.headView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.headView];
    
    self.headtextField = [[UITextField alloc]init];
    self.headtextField.text = @"bshkdhvfg";
    [self.headView addSubview:self.headtextField];
}

- (void)layoutUI{
    
    __weak typeof(self)weakSelf = self;
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(70);
        make.left.equalTo(weakSelf.view).offset(10);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(50);
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLable.mas_bottom);
        make.left.equalTo(weakSelf.view).offset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.headtextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLable.mas_bottom);
        make.left.equalTo(weakSelf.view).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

-(void)goback{
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)completeBtn{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
