//
//  textViewCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"

@class textViewCell;

@protocol textViewDelegate <NSObject>

-(void)selectTextView:(textViewCell *)textCell;

@end

@interface textViewCell : UITableViewCell<YYTextViewDelegate>

@property (nonatomic,strong) YYTextView *textView;
@property (nonatomic,weak) id<textViewDelegate> delegate;

@end
