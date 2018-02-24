//
//  beiZhuCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/5.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "copyLable.h"

@class beiZhuCell;
@protocol beiZhuCellDelegate <NSObject>

- (void)onPhoneInCell:(beiZhuCell *)cell;

@end

@interface beiZhuCell : UITableViewCell

@property (nonatomic,strong) copyLable *headLb;;//第一个
@property (nonatomic,strong) copyLable *headLb1;//第二个
@property (nonatomic,strong) copyLable *headLb2;//第三个

@property (nonatomic, weak) id<beiZhuCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;



@end
