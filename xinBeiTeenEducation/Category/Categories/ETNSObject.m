//
//  NSObject+ETObject.m
//  iYepu
//
//  Created by Omiyang on 13-12-8.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import "ETNSObject.h"


@implementation NSObject (ETNSObject)

#pragma mark - PerformSelector
- (void)performSelector:(SEL)selector onTarget:(id)target {
    if (target && [target respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
            [target performSelector:selector]
        );
    }
}

- (void)performSelector:(SEL)selector onTarget:(id)target withObject:(id)object{
    if (target && [target respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
           [target performSelector:selector withObject:object]
        );
    }
}

- (void)performSelector:(SEL)selector onTarget:(id)target withObject:(id)object withObject:(id)object1{
    if (target && [target respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
           [target performSelector:selector withObject:object withObject:object1]
        );
    }
}


//
//                                  _oo8oo_
//                                 o8888888o
//                                 88" . "88
//                                 (| -_- |)
//                                 0\  =  /0
//                               ___/'==='\___
//                             .' \\|     |// '.
//                            / \\|||  :  |||// \
//                           / _||||| -:- |||||_ \
//                          |   | \\\  -  /// |   |
//                          | \_|  ''\---/''  |_/ |
//                          \  .-\__  '-'  __/-.  /
//                        ___'. .'  /--.--\  '. .'___
//                     ."" '<  '.___\_<|>_/___.'  >' "".
//                    | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//                    \  \ `-.   \_ __\ /__ _/   .-` /  /
//                =====`-.____`.___ \_____/ ___.`____.-`=====
//                                  `=---=`
//
//
//               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//                          佛祖保佑         永不宕机/永无bug
//

@end
