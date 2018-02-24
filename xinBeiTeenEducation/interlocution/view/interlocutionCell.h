//
//  interDiscussCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "interlocutionView.h"
#import "interlocutionModel.h"

@interface interlocutionCell : UITableViewCell

@property (nonatomic,strong) UILabel *contentLb;
@property (nonatomic,strong) UILabel *discussCountLb;
@property (nonatomic,strong) interlocutionView *photoContainer;
@property (nonatomic,strong) interlocutionModel *model;
@property (nonatomic,assign) CGFloat cellHeight;

-(CGFloat)cellHeightWithModel:(interlocutionModel *)model;

@end
