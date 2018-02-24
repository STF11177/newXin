//
//  eduTextFieldCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/9/12.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eduTextFieldCell;

@protocol eduTextFieldCellDelegate <NSObject>

-(void)nameTextField:(eduTextFieldCell*)cell;
-(void)phoneTextField:(eduTextFieldCell*)cell;

@end

@interface eduTextFieldCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameHeadLb;
@property (nonatomic,strong) UITextField *nameField;
@property (nonatomic,strong) UILabel *phoneHeadLb;
@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic,strong) UIView *sepeView;
@property (nonatomic,strong) UIView *sepeView1;
@property (nonatomic,  weak) id<eduTextFieldCellDelegate> delegate;

@end
