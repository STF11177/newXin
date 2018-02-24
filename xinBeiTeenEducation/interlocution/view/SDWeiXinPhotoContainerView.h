//
//  SDWeiXinPhotoContainerView.h
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface SDWeiXinPhotoContainerView : UIView

@property (nonatomic, strong) NSArray *picPathStringsArray;
@property (nonatomic, assign) CGFloat fixedHeight;

- (instancetype)initWithWidth:(CGFloat)width;

@end
