//
//  RTArray.m
//  Anjuke
//
//  Created by Wang Qiansheng on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ETMutableArray.h"

@implementation NSMutableArray (ETMutableArray)


- (void)addInteger:(NSInteger)integer
{
    NSNumber *number = [NSNumber numberWithInteger:integer];
    [self safelyAddObject:number];
}

- (id)safelyObjectAtIndex:(NSUInteger)index {
    if (self &&[self isKindOfClass:[NSArray class]] && self.count > index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (void)safelyAddObject:(id)object {
    if (self &&[self isKindOfClass:[NSArray class]] && object) {
        [self addObject:object];
    }
}

- (void)safelyAddObjectsFromArray:(NSArray *)array{
    if (self &&[self isKindOfClass:[NSArray class]] &&
        [array isKindOfClass:[NSArray class]] && array.count>0){
        [self addObjectsFromArray:array];
    }
}

- (void)safelyRemoveAtIndex:(NSUInteger)index {
    if (self &&[self isKindOfClass:[NSMutableArray class]] && self.count > index) {
        [self removeObjectAtIndex:index];
    }
}

@end
