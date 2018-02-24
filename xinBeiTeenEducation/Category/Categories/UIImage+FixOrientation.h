#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage(fixOrientation)
//图片为Up状态
- (UIImage *)fixOrientation;

//左右镜像翻转
- (UIImage *)overTurnLeftOrRight;

//上下镜像翻转
- (UIImage *)overTurnUpOrDown;

//旋转一定的角度
- (UIImage *)rotationWithAngle:(CGFloat)angle;

//解压图
+ (UIImage *)decodedImageWithImage:(UIImage *)image;

//获取相册对象里的data／image
+ (NSArray *)getMetaFromAlasset:(ALAsset *)alasset;

//头像忽略动画
+ (NSArray *)getHeadMetaFromAlasset:(ALAsset *)alasset;

//获取动画数据
+ (NSData *)getGifDataFromAlasset:(ALAssetRepresentation *)alasset;

//获取封面
+ (UIImage *)getVideoCoverImage:(NSURL *)fileUrl;

@end


