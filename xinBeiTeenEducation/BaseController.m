//
//  BaseController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"我";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
}

@end
