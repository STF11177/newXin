//
//  interReplyView.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/10.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface interReplyView : UIView

@property(nonatomic,strong) UILabel *titleLable;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,assign) CGFloat cellHeight;

-(CGFloat)cellHeightWithString:(NSString *)titleStr;

@end
