//
//  blockController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "blockController.h"
#import "personDataCell.h"

@interface blockController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation blockController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self.tableView registerClass:[personDataCell class] forCellReuseIdentifier:@"personDataCell"];
}

-(void)createNav{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"所在区";
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

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    personDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personDataCell"];
    if (!cell) {
        
        cell = [[personDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personDataCell"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)presentBack{

    [self.navigationController popViewControllerAnimated:NO];
}

-(void)saveMessage{

}

@end
