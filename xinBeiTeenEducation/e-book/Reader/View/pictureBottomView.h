//
//  pictureBottomView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pictureBottomView;
@protocol pictureColorDelegate<NSObject>

-(void)themWithColor:(NSString *)view;

@end

@interface pictureBottomView : UIView

@property(nonatomic,weak) id<pictureColorDelegate> delegate;

@end
