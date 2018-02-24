//
//  appListController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "appListController.h"

@interface appListController ()

@end

@implementation appListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
}

-(void)createNav{
    
    self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    self.titleLb.textAlignment = NSTextAlignmentCenter;
    self.titleLb.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    self.titleLb.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleLb;
    
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(presentToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)presentToBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
