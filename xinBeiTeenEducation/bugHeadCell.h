//
//  bugHeadCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class bugHeadCell;

@protocol bugHeadCellDelegate <NSObject>

- (void)issueBtnInCell:(bugHeadCell *)cell;

@end

@interface bugHeadCell : UITableViewCell

@property (nonatomic,strong) UIButton *issueBtn;
@property (nonatomic, weak) id<bugHeadCellDelegate> delegate;

@end
