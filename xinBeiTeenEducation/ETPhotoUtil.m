//
//  ETPhotoUtil.m
//  Bike
//
//  Created by yizheming on 16/5/8.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "ETPhotoUtil.h"

@implementation ETPhotoUtil
+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static ETPhotoUtil *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[ETPhotoUtil alloc] init];
    });
    return sharedInstance;
}

- (ALAssetsLibrary *)library{
    _allPhotos = [NSMutableArray array];
    _cameraRoll = [NSMutableString string];
    if(_library== nil){
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}


+ (void)springAnimation:(UIView *)animateView{
    animateView.transform = CGAffineTransformMake(0.8, 0, 0, 0.8, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        //动画1
        animateView.transform = CGAffineTransformMake(1.1, 0, 0, 1.1, 0, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            animateView.transform = CGAffineTransformMake(0.9, 0, 0, 0.9, 0, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                animateView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}


+ (void)getImagesFromALAssetsLibraryCompletion:(void(^)(void))completion{
    
    NSMutableArray *allGroups = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取完数据去主线程刷新表格
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            //获取完数据去主线程刷新表格
            NSLog(@"******相册获取失败！");
            completion();
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL)
            {
              [allGroups insertObject:result atIndex:0];
            }
        };
        
        //获取对应的组
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            if (group!=nil)
            {
                
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                
                //按时间正序
//                [group enumerateAssetsUsingBlock:groupEnumerAtion];
                //按时间倒序
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (groupEnumerAtion) { groupEnumerAtion(result,index,stop); }
                
                }];
                
                //获取相簿的组
                NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                [[[ETPhotoUtil sharedInstance] allPhotos] addObjectsFromArray:allGroups];
                [[[ETPhotoUtil sharedInstance] cameraRoll] appendString:name];
                
                completion();
            }
        };
        ALAssetsLibrary *library = [[ETPhotoUtil  sharedInstance] library];
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        [ALAssetsLibrary disableSharedPhotoStreamsSupport];
    });
}

+ (void)getAllImagesFromALAssetsLibrary{
    
    NSMutableArray *allGroups = [NSMutableArray array];
    NSMutableArray *titlesGroups = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取完数据去主线程刷新表格
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            //获取完数据去主线程刷新表格
            NSLog(@"******相册获取失败！");
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL)
            {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
                {
                    NSMutableArray *array = [allGroups  firstObject];
                    NSLog(@"  ******:%@",result);
                    
                    [array safelyAddObject:result];
                }
            }
        };
        //获取对应的组
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            if (group!=nil)
            {
                
                //有一个新的group的时候就新建一个数组 用来存放这个group里边的多有的资源
                NSMutableArray *photoALAssetArray = [NSMutableArray array];
                [allGroups insertObject:photoALAssetArray atIndex:0];
                
                //获取相册名称
                NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                NSLog(@"  :%@",name);
                [titlesGroups insertObject:name atIndex:0];
                //获取完数据去主线程刷新表格
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
        };
        
        ALAssetsLibrary *library = [[ETPhotoUtil  sharedInstance] library];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        [ALAssetsLibrary disableSharedPhotoStreamsSupport];
    });
}

@end

