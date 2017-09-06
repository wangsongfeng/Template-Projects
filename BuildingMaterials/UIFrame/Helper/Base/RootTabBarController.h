//
//  RootTabBarController.h
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainViewController.h"
#import "NewsViewController.h"
#import "ShoppingCartViewController.h"
#import "PersonalViewController.h"

@interface RootTabBarController : UITabBarController

@property (nonatomic, strong) MainViewController    *mainVC;
@property (nonatomic, strong) NewsViewController   *newsVC;
@property (nonatomic, strong) ShoppingCartViewController   *shoppingVC;
@property (nonatomic, strong) PersonalViewController *personalVC;

SingletonH(RootTabBarController)


@end
