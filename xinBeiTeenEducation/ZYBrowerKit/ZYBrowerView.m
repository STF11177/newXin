//
//  ZYBrowerView.m
//  ZYPictureBrowerKit
//
//  Created by 周智勇 on 2017/4/7.
//  Copyright © 2017年 ZhouZhiYong. All rights reserved.
//

#import "ZYBrowerView.h"
#import "ZYLoadingView.h"
#import "ZYBrowerConfiger.h"
#import "UIImageView+WebCache.h"

#define kMaxZoomScale 2
#define kMinZoomScale 1
@interface ZYBrowerView ()<UIScrollViewDelegate>
@property (nonatomic, strong)UILabel * pageNumlable;
@property (nonatomic, strong)UIActivityIndicatorView * indicatorView;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray * imagesUrlAry;
@property (nonatomic, strong)NSMutableArray * smallScrollViewAry;
@property (nonatomic, strong)NSMutableArray * imageViewsAry;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, strong)ZYLoadingView *waitingView;
@end

@implementation ZYBrowerView

- (instancetype)initWithFrame:(CGRect)frame imagesUrlAry:(NSArray *)imagesUrlAry currentIndex:(NSInteger)currentIndex{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor =  RGBAColor(0, 0, 0, 0.9);
        self.smallScrollViewAry = [NSMutableArray array];
        self.imageViewsAry = [NSMutableArray array];
        
        self.offsetX = 0;
        self.imagesUrlAry = imagesUrlAry;
        self.currentIndex = currentIndex;
        [self configerToolBars];
        [self setUpSubViews];
    }
    return self;
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)configerToolBars{
    UILabel * pageNumlable = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2 - 40, 30, 80, 30)];
    pageNumlable.textColor = RGBColor(255, 255, 255);
    pageNumlable.backgroundColor = RGBColor(0, 0, 0);
    pageNumlable.textAlignment = NSTextAlignmentCenter;
    pageNumlable.font = [UIFont systemFontOfSize:15];
    pageNumlable.layer.masksToBounds = YES;
    pageNumlable.layer.cornerRadius = 10;
    self.pageNumlable = pageNumlable;
    [self insertSubview:pageNumlable aboveSubview:self.scrollView];
    
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(kUIScreenWidth - 80, kUIScreenHeight - 80, 40, 30);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    saveBtn.layer.cornerRadius = 5;
    [saveBtn setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:saveBtn aboveSubview:self.scrollView];
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(kUIScreenWidth * self.imagesUrlAry.count, kUIScreenHeight);
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)setUpSubViews{
    self.pageNumlable.text = [NSString stringWithFormat:@"%zd/%zd",(_currentIndex == 0 ? 1 : _currentIndex),_imagesUrlAry.count];
    
    for (int i = 0; i < _imagesUrlAry.count; i++) {
        UIScrollView * smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kUIScreenWidth * i, 0, kUIScreenWidth, kUIScreenHeight)];
        smallScrollView.delegate = self;
        smallScrollView.tag = 1000;
        smallScrollView.maximumZoomScale = kMaxZoomScale;
        smallScrollView.minimumZoomScale = kMinZoomScale;
        [_scrollView addSubview:smallScrollView];
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [smallScrollView addSubview:imageView];
        
        [self.smallScrollViewAry addObject:smallScrollView];
        [self.imageViewsAry addObject:imageView];
        
        [self configerImageViewRecongnizerWithImageView:imageView];
    }
    _scrollView.contentOffset = CGPointMake(_currentIndex * kUIScreenWidth, 0);
    [self setImageForImageView:self.imageViewsAry[_currentIndex] scrollView:self.smallScrollViewAry[_currentIndex] imageUrl:self.imagesUrlAry[_currentIndex]];
}

- (void)configerImageViewRecongnizerWithImageView:(UIImageView *)imageView{
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
    [imageView addGestureRecognizer:singleRecognizer];

    UITapGestureRecognizer * doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapedGesture:)];
    doubleRecognizer.numberOfTapsRequired = 2;
    [imageView addGestureRecognizer:doubleRecognizer];
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
}

#pragma mark --- 手势

- (void)tapClicked{
//    [UIView animateWithDuration:0.15 animations:^{
//        self.alpha = 0.5;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
      
      self.alpha = 0.5;
    } completion:^(BOOL finished) {
      
        [self removeFromSuperview];
    }];
    
}

- (void)twoTapedGesture:(UITapGestureRecognizer *)gesture{
    UIScrollView * scrollView = (UIScrollView *)gesture.view.superview;
    CGFloat currentScale = scrollView.zoomScale;
    
    if (currentScale > kMinZoomScale) {
        currentScale = kMinZoomScale;
        [scrollView setZoomScale:kMinZoomScale animated:YES];
    }else if (currentScale < kMinZoomScale) {
        [scrollView setZoomScale:kMaxZoomScale animated:YES];
    }else if (currentScale == kMinZoomScale){
        [scrollView setZoomScale:kMaxZoomScale animated:YES];
    }else if (currentScale == kMaxZoomScale){
        [scrollView setZoomScale:kMinZoomScale animated:YES];
    }
}

#pragma mark -- UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 1000) {
        return;
    }
    
    CGFloat x = scrollView.contentOffset.x;
    if (x == self.offsetX) {
        
    }else{
        self.offsetX = x;
        NSInteger currentIndex = x/kUIScreenWidth;
        self.pageNumlable.text = [NSString stringWithFormat:@"%zd/%zd",(currentIndex + 1),_imagesUrlAry.count];
        UIImageView * imageView = self.imageViewsAry[currentIndex];
        UIScrollView * smallScrollView = self.smallScrollViewAry[currentIndex];
        NSString * imageUrl = self.imagesUrlAry[currentIndex];

        [self setImageForImageView:imageView scrollView:smallScrollView imageUrl:imageUrl];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{    
    return [scrollView.subviews firstObject];
}

#pragma mark - 图片放大后不居中,所需的方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    http://blog.sina.com.cn/s/blog_6ae8b50d0100yret.html
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    [scrollView.subviews firstObject].center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}

/**
 请求对应图片

 @param imageView 图片控件
 @param scrollView 图片父视图
 @param imageUrl 图片链接
 */
- (void)setImageForImageView:(UIImageView *)imageView scrollView:(UIScrollView *)scrollView imageUrl:(NSString *)imageUrl{
    
    if (imageView.image != nil) {
        return;
    }
    
    ZYLoadingView *waitingView = [[ZYLoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    waitingView.center = self.center;
    waitingView.mode = SDWaitingViewProgressMode;
    [self addSubview:waitingView];
    [self bringSubviewToFront:waitingView];
    _waitingView = waitingView;
    
    __weak typeof(self)weakSelf = self;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        weakSelf.waitingView.progress = (CGFloat)receivedSize / expectedSize;
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [waitingView removeFromSuperview];
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        if (width > kUIScreenWidth) {
            height = height * kUIScreenWidth/width;
            width = kUIScreenWidth;
        }
        imageView.frame = CGRectMake(0, 0, width, height);
        if (height < kUIScreenHeight) {
            imageView.center = self.center;
        }
        scrollView.contentSize = CGSizeMake(0, height);
    }];
}


#pragma mark --- 保存图片

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index].subviews[0];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}


@end
