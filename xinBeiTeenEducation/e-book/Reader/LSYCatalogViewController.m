//
//  LSYCatalogViewController.m
//  LSYReader
//
//  Created by okwei on 16/6/2.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYCatalogViewController.h"
#import "LSYChapterVC.h"
#import "LSYNoteVC.h"
#import "LSYMarkVC.h"
#import "ePictureController.h"
#import "picChapterController.h"

@interface LSYCatalogViewController ()<LSYViewPagerVCDelegate,LSYViewPagerVCDataSource,LSYCatalogViewControllerDelegate>
@property (nonatomic,copy) NSArray *titleArray;
@property (nonatomic,copy) NSArray *VCArray;
@property (nonatomic,strong) NSString *bookIdStr;

@end

@implementation LSYCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"目录"];
    _VCArray = @[({
        picChapterController *chapterVC = [[picChapterController alloc]init];
//        chapterVC.readModel = _readModel;
        chapterVC.delegate = self;
        chapterVC;
    }),({
        LSYNoteVC *noteVC = [[LSYNoteVC alloc] init];
//      noteVC.readModel = _readModel;
        noteVC.delegate = self;
        noteVC;
    }),({
        LSYMarkVC *markVC =[[LSYMarkVC alloc] init];
//      markVC.readModel = _readModel;
        markVC.delegate = self;
        markVC;
    })];
    self.forbidGesture = YES;
    self.delegate = self;
    self.dataSource = self;
}

-(NSInteger)numberOfViewControllersInViewPager:(LSYViewPagerVC *)viewPager
{
    return _titleArray.count;
}
-(UIViewController *)viewPager:(LSYViewPagerVC *)viewPager indexOfViewControllers:(NSInteger)index
{
    return _VCArray[index];
}
-(NSString *)viewPager:(LSYViewPagerVC *)viewPager titleWithIndexOfViewControllers:(NSInteger)index
{
    return _titleArray[index];
}
-(CGFloat)heightForTitleOfViewPager:(LSYViewPagerVC *)viewPager
{
    return 40.0f;
}
-(void)catalog:(LSYCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    if ([self.catalogDelegate respondsToSelector:@selector(catalog:didSelectChapter:page:)]) {
        [self.catalogDelegate catalog:self didSelectChapter:chapter page:page];
    }
}

@end
