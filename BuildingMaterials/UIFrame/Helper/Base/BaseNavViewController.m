//
//  BaseNavViewController.m
//  ZhongYouShangLian
//
//  Created by xll on 2017/3/22.
//  Copyright © 2017年 JoyFate. All rights reserved.
//

#import "BaseNavViewController.h"
#import "UINavigationBar+Lzy7575.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 默认隐藏navigationBar
    [self.navigationBar setHidden:YES];
}

//#pragma mark - UINavigationController 方法重载
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
