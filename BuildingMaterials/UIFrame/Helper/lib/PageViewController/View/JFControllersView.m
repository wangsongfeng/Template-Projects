//
//  HDControllersView.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/25.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "JFControllersView.h"
#import "JFDeviceInfo.h"
#import <Masonry.h>

@interface JFControllersView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currIndex;

@end

@implementation JFControllersView

- (instancetype)initFrame:(CGRect)frame controllers:(NSArray *)controllers
{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.bounces       = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate      = self;
        self.childControllers = controllers;
    }
    return self;
}

- (void)setChildControllers:(NSArray *)childControllers
{
    [self updateChildControllers:childControllers];
    
    _childControllers = childControllers;
}

- (void)updateChildControllers:(NSArray *)controllers
{
    if ([self.subviews count] > 0) {
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
    }
    
    CGFloat x = 0;
    
    for (UIViewController *controller in controllers) {
        UIView *subView = controller.view;
        [subView setFrame:CGRectMake(x, 0, kJFAppWidth, self.frame.size.height)];
        [self addSubview:subView];
        
        x += kJFAppWidth;
    }
    
    self.contentSize = CGSizeMake(x, 0);
    self.currIndex = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat tmpIndex = scrollView.contentOffset.x/kJFAppWidth;
    NSInteger index = [[NSNumber numberWithFloat:tmpIndex] integerValue];
    
//    DLog(@"index = %ld",index);
    
    if (index != self.currIndex) {
        self.currIndex = index;
        if (self.viewMoveBlock) {
            self.viewMoveBlock(index);
        }
    }
}

- (void)moveToController:(NSInteger)index
{
    if (index == self.currIndex) {
        return;
    }
    
    if (self.currIndex > index) {
        CGPoint tOffset = CGPointMake((index + 1)*kJFAppWidth, 0);
        self.contentOffset = tOffset;
    }
    else if (self.currIndex < index) {
        CGPoint tOffset = CGPointMake((index - 1)*kJFAppWidth, 0);
        self.contentOffset = tOffset;
    }
    
    CGPoint offset = CGPointMake(index * kJFAppWidth, 0);
    [UIView animateWithDuration:0.3f animations:^{
        self.contentOffset = offset;
    }];
}

@end
