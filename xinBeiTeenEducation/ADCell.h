//
//  ADCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *ADDataArr;

//存放本地的图片
@property (nonatomic,strong) NSArray *oriPName;

@end
