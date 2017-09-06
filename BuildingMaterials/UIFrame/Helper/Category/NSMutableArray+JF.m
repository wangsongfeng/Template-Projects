//
//  NSMutableArray+HD.m
//  Huobucuo
//
//  Created by hudan on 16/8/31.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "NSMutableArray+JF.h"

@implementation NSMutableArray (JF)

- (void)addObjectSafe:(id)object
{
    if (object) {
        [self addObject:object];
    }
    else {
#ifdef DEBUG
        NSAssert(NO, @"插入对象为空!");
#endif
    }
}

- (id)objectAtIndexSafe:(NSUInteger)index
{
    if (index > [self count] - 1) {
#ifdef DEBUG
        NSAssert(NO, @"索引值越界了!");
#endif
        return nil;
    }
    else {
        return [self objectAtIndex:index];
    }
}

@end
