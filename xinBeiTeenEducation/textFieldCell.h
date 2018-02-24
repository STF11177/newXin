//
//  textFieldCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class textFieldCell;
@protocol textFieldCellDelegate <NSObject>

- (void)idCardInCell:(textFieldCell *)cell;

@end

@interface textFieldCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *headLb;
@property (nonatomic,strong) UITextField *contentField;
@property (nonatomic, weak) id<textFieldCellDelegate> delegate;
@property (nonatomic) NSIndexPath *indexPath;

@end
