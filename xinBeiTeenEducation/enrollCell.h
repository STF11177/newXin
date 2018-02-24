//
//  enrollCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "copyLable.h"

@interface enrollCell : UITableViewCell

@property (nonatomic,strong) UIView  *sepeBtnView;
@property (nonatomic,strong) copyLable *contentLb;
@property (nonatomic,strong) UILabel *introduceLb;
@property (nonatomic,strong) UIView *lineView;

@end
