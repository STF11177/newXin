//
//  fiendCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "fiendCell.h"

@implementation fiendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        [self createView];
        [self layoutUI];
        
        UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:headerLongPress];
        
        
    }
    return self;
}

-(void)createView{

    self.headImageView = [[UIImageView alloc]init];
    self.headImageView.layer.cornerRadius = 22.5;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    
    [self addSubview:self.headImageView];
    
    self.nameLable = [[UILabel alloc]init];
    self.nameLable.font =[UIFont systemFontOfSize:16];
    [self addSubview:self.nameLable];
    
    self.contentLab = [[UILabel alloc]init];
    self.contentLab.textColor = [UIColor lightGrayColor];
    self.contentLab.font =[UIFont systemFontOfSize:14];
    [self addSubview:self.contentLab];
    
    self.timeLable = [[UILabel alloc]init];
    self.timeLable.font =[UIFont systemFontOfSize:12];
    [self addSubview:self.timeLable];

}

-(void)layoutUI{
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(45);
    }];

    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.right.equalTo(self.timeLable.mas_left).offset(-5);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLable.mas_bottom).offset(5);
        make.left.equalTo(self.nameLable.mas_left);
        make.right.equalTo(self.timeLable.mas_left).offset(-5);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-10);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
}

-(void)setChatViewModel:(chatViewModel *)chatViewModel{

    _chatViewModel = chatViewModel;
    DDLog(@"%@",chatViewModel);
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_chatViewModel.faceImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    
    if (_chatViewModel.remarkName == nil) {
        
        self.nameLable.text = _chatViewModel.nickName;
    }else {
        
        self.nameLable.text = _chatViewModel.remarkName;
    }
    
}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellLongPressAtIndexPath:)])
        {
            [_delegate cellLongPressAtIndexPath:self.indexPath];
        }
    }
}


@end
