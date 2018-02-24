//
//  bookController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "bookController.h"

@interface bookController ()

@end

@implementation bookController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.titleLb.text = @"小升初必读";
//    [super viewDidLoad];
//    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
//    lable1.textAlignment = NSTextAlignmentCenter;
//    lable1.text = @"小升初必读";
//    lable1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
//    lable1.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lable1;
//
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(presentToBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = item;
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake( 0,SCREEN_HEIGHT/3 - 20 , SCREEN_WIDTH, 30)];
    lable2.text = @"暂无图书";
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor lightGrayColor];
    [self.view addSubview:lable2];
}

//-(void)presentToBack{
//
//    [self.navigationController popViewControllerAnimated:NO];
//}


@end
