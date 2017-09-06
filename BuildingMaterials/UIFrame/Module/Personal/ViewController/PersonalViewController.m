//
//  PersonalViewController.m
//  BuildingMaterials
//
//  Created by mac on 2017/6/30.
//  Copyright © 2017年 刘志远. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@property (nonatomic, strong) UIView *topView;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BG_Color;
    
    [self initUI];//初始化视图
}

#pragma mark - 初始化视图
- (void)initUI {
    self.topView = [self addTitleViewWithTitle:@"购物车"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
