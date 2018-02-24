//
//  NSObject+ETObject.h
//  iYepu
//
//  Created by Omiyang on 13-12-8.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (ETObject)

#pragma mark - PerformSelector
- (void)performSelector:(SEL)selector onTarget:(id)target;
- (void)performSelector:(SEL)selector onTarget:(id)target withObject:(id)object;
- (void)performSelector:(SEL)selector onTarget:(id)target withObject:(id)object withObject:(id)object1;


@end
