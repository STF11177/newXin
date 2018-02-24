//
//  ADCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ADCell.h"

@implementation ADCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createScrollview];
    }
    return self;
}

-(void)createScrollview{

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 157)];
    
    // 往scroll view上面加三个imageView
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, SCREEN_WIDTH, 157)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pag%d.png", i]];
        [_scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*3, _scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES; // 分页方式打开
    _scrollView.delegate = self;
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_scrollView];
   
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(-20,134,SCREEN_WIDTH, 20)];
    _pageControl.numberOfPages = 3; // 这样写了之后，它就有3个圆点
    self.pageControl.currentPage=0;
    _pageControl.backgroundColor = [UIColor clearColor];
    // _pageControl.tintColor = [UIColor purpleColor];
    [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}

- (void)pageControlClick:(UIPageControl *)pageControl {
    // 根据pageControl当前的页码，用代码滚动scrollView，以显示相对应的图片
    NSInteger currentPage = pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(currentPage*_scrollView.frame.size.width, 0) animated:YES];
}

// 滑动结束，减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark -- 有网络请求
//-(void)createScrollView{
//
//    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*(self.ADDataArr.count+1), 200);
//    for (int i=0; i<self.ADDataArr.count+1; i++) {
//        UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(i*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, 200)];
//     
////        ADModel *model = nil;
////        if (i != self.ADDataArr.count) {
////            model = weakSelf.ADDataArr[i];
////        }else{
////            model = weakSelf.ADDataArr[0];
////        }
//      
//        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 160, kScreenSize.width-40-5, 30)];
////        lable.text = model.title;
//        lable.textAlignment = NSTextAlignmentLeft;
//        lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:13];
//        lable.textColor = [UIColor whiteColor];
//        [imageView addSubview:lable];
//        [self.scrollView addSubview:imageView];
//    }
//    [self.contentView addSubview:self.scrollView];
//    self.scrollView.delegate = self;
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.bounces = NO;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(kScreenSize.width-40,170, 40, 30)];
//    self.pageControl.currentPage=0;
//    
//    self.pageControl.numberOfPages=self.ADDataArr.count+1;
//    [self.contentView addSubview:self.pageControl];
//    [self createTimer];
//}
//
//-(void)createTimer{
//
//    if (!_timer) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
//    }
//    [_timer setFireDate:[NSDate distantPast]];
//}
//
//-(void)timerRun:(NSTimer *)timer{
//
//    CGPoint point = self.scrollView.contentOffset;
//    CGFloat adWidth = SCREEN_WIDTH;
//    if (self.scrollView.contentOffset.x == self.scrollView.bounds.size.width*(self.ADDataArr.count)) {
//        [self.scrollView setContentOffset:CGPointMake(0, 0)];
//        self.pageControl.currentPage=0;
//    }else{
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.scrollView.contentOffset = CGPointMake(point.x + adWidth, 0);
//        }];
//    }
//}

@end
