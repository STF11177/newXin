//
//  copyLable.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/5.
//  Copyright © 2017年 user. All rights reserved.
//

#import "copyLable.h"

@implementation copyLable

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
    [self pressAction];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIMenuControllerWillHideMenuNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.backgroundColor = [UIColor clearColor];
        }];
    }
    return self;
}

-(void)pressAction{

    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
}

// 使label能够成为响应事件
- (BOOL)canBecomeFirstResponder {
    
    return YES;
}
// 控制响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(customCopy:);
}

- (void)longPressAction:(UIGestureRecognizer *)recognizer {
//    [self becomeFirstResponder];
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"111");
        return;
    }else if (recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"222");

        [self becomeFirstResponder];
        self.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(customCopy:)];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [UIMenuController sharedMenuController].menuItems = @[item];
        [UIMenuController sharedMenuController].menuVisible = YES;
    }
}

- (void)customCopy:(id)sender {
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
   
    //  有些时候只想取UILabel的text中的一部分
    if (objc_getAssociatedObject(self, @"expectedText")) {
        pBoard.string = objc_getAssociatedObject(self, @"expectedText");
    } else {
        
        //  因为有时候 label 中设置的是attributedText
        //  而 UIPasteboard 的string只能接受 NSString 类型
        //  所以要做相应的判断
        if (self.text) {
            pBoard.string = self.text;
        } else {
            pBoard.string = self.attributedText.string;
        }
    }
}


@end
