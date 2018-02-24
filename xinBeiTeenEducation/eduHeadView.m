//
//  eduHeadView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduHeadView.h"
#import "SDPhotoBrowser.h"

@interface eduHeadView()<SDPhotoBrowserDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation eduHeadView

-(void)setPicArray:(NSArray *)picArray{

    _picArray = picArray;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 150, 17, 300, 300)];
    
    for (int i = 0; i < self.picArray.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, 300, 300)];
        
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
        PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView addGestureRecognizer:PrivateLetterTap];
        
        [imageView sd_setImageWithURL:picArray[i] placeholderImage:[UIImage imageNamed:@"edubook"]];
        [_scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*_picArray.count, _scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES; // 分页方式打开
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 50,240,100, 20)];
    _pageControl.numberOfPages = self.picArray.count; // 这样写了之后，它就有3个圆点
    self.pageControl.currentPage=0;
    self.pageControl.backgroundColor = [UIColor clearColor];
    //只有一页的时候隐藏
    _pageControl.hidesForSinglePage = YES;//默认为NO
//  _pageControl.backgroundColor = [UIColor clearColor];
    [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}

- (void)pageControlClick:(UIPageControl *)pageControl {
    // 根据pageControl当前的页码，用代码滚动scrollView，以显示相对应的图片
    NSInteger currentPage = pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(currentPage*SCREEN_WIDTH, 0) animated:YES];
}

// 滑动结束，减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self.scrollView;
    browser.imageCount = self.picArray.count;
    browser.delegate = self;
    browser.photoSign = @"edu";
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSURL *url = [NSURL new];
    if (index < self.picOriArray.count) {
        url = self.picOriArray[index];
    }
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    UIImageView *imageView = self.scrollView.subviews[index];
    
    _pageControl.currentPage = index;
    return imageView.image;
}

@end
