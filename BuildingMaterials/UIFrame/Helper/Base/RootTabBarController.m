//
//  RootTabBarController.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "RootTabBarController.h"

#import "BaseNavViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

SingletonM(RootTabBarController)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
    
    [self.tabBar setTintColor:Main_Color];
    
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, kJFAppWidth, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   RGB(255, 255, 255).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    //阴影
    self.tabBar.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
    self.tabBar.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
    self.tabBar.layer.shadowOpacity = 0.5;//不透明度
    self.tabBar.layer.shadowRadius = 5.0;//半径
    
    [self initControl];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"tabBar - item.title - %@", item.title);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initControl {
    
    BaseNavViewController *nav1 = [[BaseNavViewController alloc] initWithRootViewController:self.mainVC];
    
    BaseNavViewController *nav2 = [[BaseNavViewController alloc] initWithRootViewController:self.newsVC];
    
    BaseNavViewController *nav3 = [[BaseNavViewController alloc] initWithRootViewController:self.shoppingVC];
    
    BaseNavViewController *nav4 = [[BaseNavViewController alloc] initWithRootViewController:self.personalVC];
    
    
    NSArray *array = @[nav1,nav2,nav3,nav4];
    self.viewControllers = array;
    self.selectedIndex = 0;
}

/*
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"tabBar - item.title - %@", item.title);
    if ([item.title isEqualToString:@"学术交流"]) {
        NSLog(@"badgeValue - %@", item.badgeValue);
        if (item.badgeValue.integerValue > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LLTabBarDidClickNotification" object:nil userInfo:nil];
        }
    }
}
*/

#pragma mark - Getter and Setter
/**
 *  首页
 */
- (MainViewController *)mainVC
{
    if (!_mainVC) {
        _mainVC = [[MainViewController alloc] init];
        [_mainVC.tabBarItem setTitle:@"首页"];
        [_mainVC.tabBarItem setImage:[UIImage imageNamed:@"main_tabar_icon"]];
        [_mainVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"main_tabar_icon_sel"]];
    }
    return _mainVC;
}

/**
 *  资讯
 */
- (NewsViewController *)newsVC
{
    if (!_newsVC) {
        _newsVC = [[NewsViewController alloc] init];
        [_newsVC.tabBarItem setTitle:@"资讯"];
        [_newsVC.tabBarItem setImage:[UIImage imageNamed:@"news_tabar_icon"]];
        [_newsVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"news_tabar_icon_sel"]];
    }
    return _newsVC;
}

/**
 *  购物车
 */
- (ShoppingCartViewController *)shoppingVC
{
    if (!_shoppingVC) {
        _shoppingVC = [[ShoppingCartViewController alloc] init];
        [_shoppingVC.tabBarItem setTitle:@"购物车"];
        [_shoppingVC.tabBarItem setImage:[UIImage imageNamed:@"shopping_tabar_icon"]];
        [_shoppingVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"shopping_tabar_icon_sel"]];
    }
    return _shoppingVC;
}

/**
 *  我的
 */
- (PersonalViewController *)personalVC
{
    if (!_personalVC) {
        _personalVC = [[PersonalViewController alloc] init];
        [_personalVC.tabBarItem setTitle:@"我的"];
        [_personalVC.tabBarItem setImage:[UIImage imageNamed:@"personal_tabar_icon"]];
        [_personalVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"personal_tabar_icon_sel"]];
    }
    return _personalVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
