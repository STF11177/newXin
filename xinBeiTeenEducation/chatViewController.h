//
//  chatViewController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *firendTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *headImage;

@end





