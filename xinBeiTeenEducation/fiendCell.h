//
//  fiendCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatViewModel.h"

@protocol fiendCellDelegate <NSObject>

- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface fiendCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLable;
@property (nonatomic) NSIndexPath *indexPath;

@property (nonatomic,strong) chatViewModel *chatViewModel;

@property (weak, nonatomic) id<fiendCellDelegate> delegate;

@end
