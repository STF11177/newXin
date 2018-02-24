//
//  inviteController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "inviteController.h"
#import "inviteCodeView.h"
#import "BlurView.h"
#import "CommonSheet.h"

@interface inviteController ()<CommonSheetDelegate>

@property (nonatomic,strong) BlurView *messageView;
@property (nonatomic,strong) CommonSheet *sheet;

@property (nonatomic,strong) UILabel *headLb;
@property (nonatomic,strong) UIButton *inviteBtn;
@property (nonatomic,strong) UILabel *inviteLb;
@property (nonatomic,strong) UILabel *introduceLb;
@property (nonatomic,strong) UIImageView *inviteImg;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *inviteView;

@property (nonatomic,strong) UIView *sepView1;
@property (nonatomic,strong) UIView *sepView2;
@property (nonatomic,strong) UILabel *titleLb1;

@property (nonatomic,strong) UIButton *ruleBtn;

@end

@implementation inviteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLb.text = @"邀请码";
//    [self createNav];
    [self createView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    [self setupWithShare];
}

//-(void)createNav{
//
//    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
//    lable1.textAlignment = NSTextAlignmentCenter;
//    lable1.text = @"邀请码";
//    lable1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
//    lable1.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lable1;
//
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(presentToBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = item;
//}

-(void)createView{
    
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor colorWithHexString:@"#1b82d2"];
    [self.view addSubview:self.backView];
    
    self.headLb = [[UILabel alloc]init];
    self.headLb.text = @"您的邀请码";
    self.headLb.font = [UIFont systemFontOfSize:17];
    self.headLb.textColor = [UIColor whiteColor];
    [self.view addSubview:self.headLb];
    
    self.inviteBtn = [[UIButton alloc]init];
    self.inviteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.inviteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.inviteBtn.layer.borderWidth = 1;
    self.inviteBtn.layer.cornerRadius = 3;
    [self.inviteBtn addTarget:self action:@selector(inviteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteBtn setTitle:@"复制" forState:UIControlStateNormal];
    [self.view addSubview:self.inviteBtn];
    
    self.inviteImg = [[UIImageView alloc]init];
    self.inviteImg.image = [UIImage imageNamed:@"diyq"];
    [self.view addSubview:self.inviteImg];
    
    self.inviteView = [[UIView alloc]init];
    self.inviteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inviteView];
    
    self.inviteLb = [[UILabel alloc]init];
    self.inviteLb.text = @"UUJZYQ9868N";
    [self.view addSubview:self.inviteLb];
    
    self.introduceLb = [[UILabel alloc]init];
    self.introduceLb.text = @"每成功邀请一个好友，即可获得一张抵用券";
    self.introduceLb.font = [UIFont systemFontOfSize:13];
    self.introduceLb.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.introduceLb];
    
    self.sepView1 = [[UIView alloc]init];
    self.sepView1.backgroundColor = [UIColor colorWithHexString:@"#1b82d2"];
    [self.view addSubview:self.sepView1];
    
    self.sepView2 = [[UIView alloc]init];
    self.sepView2.backgroundColor = [UIColor colorWithHexString:@"#1b82d2"];
    [self.view addSubview:self.sepView2];
    
    self.titleLb1 = [[UILabel alloc]init];
    self.titleLb1.text = @"将邀请码发送给好友";
    self.titleLb1.font = [UIFont systemFontOfSize:17];
    self.titleLb1.textColor = [UIColor colorWithHexString:@"#1b82d2"];
    [self.view addSubview:self.titleLb1];
    
    [self layOutUI];
}

-(void)layOutUI{
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(64 +34);
        make.left.equalTo(self.view).offset(SCREEN_WIDTH*0.07);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(SCREEN_WIDTH - SCREEN_WIDTH*0.07*2);
    }];
    
    [self.inviteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backView.mas_bottom).offset(-3);
        make.left.equalTo(self.backView.mas_left);
        make.right.equalTo(self.backView.mas_right);
    }];
    
    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backView.mas_left).offset(20);
        make.top.equalTo(self.backView.mas_top).offset(20);
    }];
 
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backView.mas_top).offset(20);
        make.right.equalTo(self.backView.mas_right).offset(-20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    
    [self.inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.inviteImg.mas_bottom);
        make.left.equalTo(self.backView.mas_left);
        make.right.equalTo(self.backView.mas_right);
        make.height.mas_equalTo(100);
    }];
    
    [self.inviteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.inviteView.mas_top).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    [self.introduceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.inviteLb.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.inviteView.mas_bottom).offset(40);
        make.left.equalTo(self.inviteView.mas_left);
        make.right.equalTo(self.titleLb1.mas_left).offset(-3);
        make.height.mas_equalTo(1);
    }];
    
    [self.titleLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sepView1.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
    }];

    [self.sepView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.inviteView.mas_bottom).offset(40);
        make.left.equalTo(self.titleLb1.mas_right).offset(3);
        make.right.equalTo(self.inviteView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

-(void)inviteClick{
    
}

- (void)setupWithShare{
 
    CGFloat titleTop = 365;
    CGFloat itemSpace =  (kScreenWidth-200)/3;
    
    //微信
   UIButton * weixingBtn = [ETUIUtil drawButtonInView:self.view Frame:CGRectMake(itemSpace, titleTop-25, 50, 50) IconName:@"weixin" Target:self Action:@selector(shareAction:) Tag:1];
    UILabel * weixin = [ETUIUtil drawLabelInView:self.view Frame:CGRectMake(itemSpace, titleTop+25, 50, 30) Font:[UIFont systemFontOfSize:12] Text:@"微信"];
    weixin.textColor = TextColor;
    weixin.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:weixingBtn];
    [self.view addSubview:weixin];
    
    //微信朋友圈
    UIButton * weixinTimeBtn = [ETUIUtil drawButtonInView:self.view Frame:CGRectMake(itemSpace*2+50, titleTop-25, 50, 50) IconName:@"frand" Target:self Action:@selector(shareAction:) Tag:2];
    UILabel *weixinTime = [ETUIUtil drawLabelInView:self.view Frame:CGRectMake(itemSpace*2+50, titleTop+25, 50, 30) Font:[UIFont systemFontOfSize:12] Text:@"朋友圈"];
    weixinTime.textColor = TextColor;
    weixinTime.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:weixinTimeBtn];
    [self.view addSubview:weixinTime];
    
    //QQ
   UIButton *qqBtn = [ETUIUtil drawButtonInView:self.view Frame:CGRectMake(itemSpace*3+100, titleTop-25, 50, 50) IconName:@"qq" Target:self Action:@selector(shareAction:) Tag:3];
    UILabel *qq = [ETUIUtil drawLabelInView:self.view Frame:CGRectMake(itemSpace*3+100, titleTop+25, 50, 30) Font:[UIFont systemFontOfSize:12] Text:@"QQ好友"];
    qq.textColor = TextColor;
    qq.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:qqBtn];
    [self.view addSubview:qq];
    
    //qq空间
    UIButton * qqContentBtn = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(itemSpace, titleTop + 70, 50, 50) IconName:@"qq_z" Target:self Action:@selector(shareAction:) Tag:4];
    UILabel *qqContent =[ETUIUtil drawLabelInView:self.view Frame:CGRectMake(itemSpace, titleTop+25 + 90, 50, 30) Font:[UIFont systemFontOfSize:12] Text:@"QQ空间"];
    qqContent.textColor = TextColor;
    qqContent.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:qqContentBtn];
    [self.view addSubview:qqContent];
    
    //复制链接
    UIButton * copyBtn = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(itemSpace*2 +50, titleTop + 70, 50, 50) IconName:@"lianjie1" Target:self Action:@selector(shareAction:) Tag:4];
    UILabel *copyContent =[ETUIUtil drawLabelInView:self.view Frame:CGRectMake(itemSpace*2 +50, titleTop+25 + 90, 50, 30) Font:[UIFont systemFontOfSize:12] Text:@"复制链接"];
    copyContent.textColor = TextColor;
    copyContent.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:copyBtn];
    [self.view addSubview:copyContent];
    
    self.ruleBtn = [[UIButton alloc]init];
    [self.ruleBtn setTitle:@"邀请规则 >>" forState:UIControlStateNormal];
    [self.ruleBtn setTitleColor:[UIColor colorWithHexString:@"#1b82d2"] forState:UIControlStateNormal];
    self.ruleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.ruleBtn];
    
    [self.ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(365 +30 +50 +80);
    }];
}

-(void)shareAction:(UIButton *)button{
    
}

-(void)presentToBack{

    [self.navigationController popViewControllerAnimated:NO];
}

@end
