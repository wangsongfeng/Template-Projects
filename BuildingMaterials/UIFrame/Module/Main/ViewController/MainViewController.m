//
//  MainViewController.m
//  RealEstate
//
//  Created by mac on 2017/5/26.
//  Copyright © 2017年 刘志远. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UIView *topView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_Color;
    
    [self initUI];//初始化视图
}

#pragma mark - 初始化视图
- (void)initUI {
    
    //导航栏
    self.topView = [self addTitleViewWithTitle:@"首页"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end