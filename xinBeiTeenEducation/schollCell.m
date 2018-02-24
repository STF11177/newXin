////
////  schollCell.m
////  xinBeiTeenEducation
////
////  Created by user on 2017/6/29.
////  Copyright © 2017年 user. All rights reserved.
////
//
//#import "schollCell.h"
//
//@implementation schollCell
//
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//        [self createView];
//        [self layoutUI];
//    }
//    return self;
//}
//
//-(void)createView{
//    
//    self.headLb = [[UILabel alloc]init];
//    self.headLb.numberOfLines = 0;
//    self.headLb.font = [UIFont systemFontOfSize:15];
//    [self.contentView addSubview:self.headLb];
//}
//
//-(void)layoutUI{
//
//    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.left.equalTo(self.contentView).offset(15);
//        make.right.equalTo(self.contentView).offset(70);
//    }];
//}
//
//-(void)setModel:(schoolModel *)model{
//
////    NSString * nameStr = model.name;
////    NSString *str = [nameStr stringByAppendingString:@" "];
////    NSString *str1 = [str stringByAppendingString:model.school];
////    NSString *str2 = [str1 stringByAppendingString:@"\n"];
////    NSString *str3 = [str2 stringByAppendingString:model.address_name];
////    
////    self.headLb.text = str3;
//}
//
//@end
