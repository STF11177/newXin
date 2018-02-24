//
//  eduImageCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/26.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "educationVIew.h"
#import "eduDetailModel.h"

@interface eduImageCell : UITableViewCell

@property(nonatomic,strong) educationVIew *eduImageView;
@property(nonatomic,strong) eduDetailModel *eduModel;

@end
