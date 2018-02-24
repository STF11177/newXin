//
//  defaultCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class defaultCell;
@protocol defaultCellDelegate <NSObject>

- (void)onSwitchInCell:(defaultCell *)cell;

@end

@interface defaultCell : UITableViewCell

@property (nonatomic,strong) UILabel *headLable;
@property (nonatomic,strong) UISwitch *switchBtn;
@property (nonatomic, weak) id<defaultCellDelegate> delegate;

@end
