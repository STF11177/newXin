//
//  pictureTopView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pictureTopView;
@protocol topViewDelete <NSObject>

-(void)menuViewDidHidden:(pictureTopView *)menu;
-(void)menuViewInvokeCatalog:(pictureTopView *)menu;

@end

@interface pictureTopView : UIView

@property (nonatomic,weak) id<topViewDelete> delegate;

-(void)showAnimation:(BOOL)animation;
-(void)hiddenAnimation:(BOOL)animation;

@end
