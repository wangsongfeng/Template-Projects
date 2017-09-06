//
//  HDPageViewController.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/25.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "JFPageViewController.h"

#import "JFDeviceInfo.h"

#import <Masonry.h>

#define kTitleViewHeight 36

@interface JFPageViewController ()

@property (nonatomic, strong) UIView *titleBottomLine;                   //  标题底部横线
@property (nonatomic, assign) CGFloat titleMargin;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat firstMargin;
@property (nonatomic, assign) CGFloat titleFontSize;

@end

@implementation JFPageViewController

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                  titleMargin:(CGFloat)titleMargin
                  titleHeight:(CGFloat)titleHeight
             firstTitleMargin:(CGFloat)firstMargin
                titleFontSize:(CGFloat)fontSize
                  controllers:(NSArray *)controllers
{
    if (self = [super init]) {
#ifdef DEBUG
        NSAssert(titles.count == controllers.count, @"标题数量要与控制器数量相等!");
#endif
        
        self.titles = titles;
        self.controllers = controllers;
        
        self.titleMargin = titleMargin;
        self.titleHeight = titleHeight;
        self.firstMargin = firstMargin;
        self.titleFontSize = fontSize;
        
//        self.view.frame = frame;
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    // topView
    CGRect titleFrame = CGRectMake(0, 0, kJFAppWidth, self.titleHeight == 0 ? kTitleViewHeight : self.titleHeight);
    self.titleView = [[JFTitleView alloc] initWithFrame:titleFrame titles:self.titles buttonMargin:self.titleMargin firstButtonMargin:self.firstMargin fontSize:self.titleFontSize];
    
    self.titleView.backgroundColor = [UIColor whiteColor];
    
    // viewController
    self.childControllerView = [[JFControllersView alloc] initFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), kJFAppWidth, self.view.frame.size.height - titleFrame.size.height - 20) controllers:self.controllers];
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.childControllerView];

    //    [self.childControllerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.mas_equalTo(self.view).offset(self.titleView.frame.size.height);
//    }];

    
    __weak typeof(self) weakSelf = self;
    
    self.currTitle = self.titles[0];
    self.currController = self.controllers[0];
    
    self.titleView.buttonClickBlock = ^(NSInteger index) {
        [weakSelf.childControllerView moveToController:index];
        weakSelf.currTitle = [weakSelf.titles objectAtIndex:index];
        weakSelf.currController = [weakSelf.controllers objectAtIndex:index];
        [weakSelf.delegate pageViewController:weakSelf index:index];
    };
    
    self.childControllerView.viewMoveBlock = ^(NSInteger index) {
        [weakSelf.titleView moveToButtonWithIndex:index];
        weakSelf.currTitle = [weakSelf.titles objectAtIndex:index];
        weakSelf.currController = [weakSelf.controllers objectAtIndex:index];
        [weakSelf.delegate pageViewController:weakSelf index:index];
    };
}


#pragma mark - Setter
- (void)setCurrTitleColor:(UIColor *)currTitleColor
{
    self.titleView.selectButtonColor = currTitleColor;
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    self.titleView.normalButtonColor = normalTitleColor;
}

- (void)setTitleLineColor:(UIColor *)TitleLineColor
{
    self.titleView.bottomLineColor = TitleLineColor;
}

- (void)setIsShowTitleLine:(BOOL)isShowTitleLine
{
    self.titleView.isShowBottomLine = isShowTitleLine;
}

- (void)setTitleLineHeight:(CGFloat)titleLineHeight
{
    self.titleView.bottomLineHeight = titleLineHeight;
}

#pragma mark - Public
- (UIView *)getCurrentTitleView
{
    return self.titleView;
}

- (void)moveToIndex:(NSInteger)index
{
    [self.titleView moveToButtonWithIndex:index];
    [self.childControllerView moveToController:index];
}

@end
