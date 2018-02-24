//
//  NSArray+ExtraMethod.m
//  HaoZu
//
//  Created by luochenhao on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ETArray.h"

@implementation NSArray (ETArray)

- (id)objectSafetyAtIndex:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

@end
