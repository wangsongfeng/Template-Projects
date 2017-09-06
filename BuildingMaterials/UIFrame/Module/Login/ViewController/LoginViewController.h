//
//  LoginViewController.h
//  BuildingMaterials
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 刘志远. All rights reserved.
//

#import "BaseViewController.h"

//登录成功的回到主页刷新数据
typedef void(^LoginSuccessClick)(BOOL isSuccess);

@interface LoginViewController : BaseViewController

@property (nonatomic, copy) LoginSuccessClick loginSuccessClick;

@property (nonatomic, copy) NSString *isNormalLogin;

@end
