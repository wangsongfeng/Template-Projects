//
//  BaseViewController.m
//  ZhongYouShangLian
//
//  Created by Showtime on 2017/3/9.
//  Copyright © 2017年 JoyFate. All rights reserved.
//

#import "BaseViewController.h"

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import <AFNetworking.h>
#import "HYBNetworking.h"

#import "LoginViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController {
    
    kRefreshType refType;
}

#pragma mark
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    __weak typeof(self) weakSelf = self;
    
    // 自定义返回按钮添加返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

#pragma mark -
#pragma mark 接口请求
-(void)setParam:(NSString *)key model:(NSObject *)value{
    if(self.params == nil){
        self.params = [[NSMutableDictionary alloc] init];
    }
    [self.params setObjectSafe:value forKey:key];
}

-(void)setTableParams:(NSString *)key model:(NSObject *)value {
    if(self.tableParams == nil){
        self.tableParams = [[NSMutableDictionary alloc] init];
    }
    [self.tableParams setObjectSafe:value forKey:key];
}

#pragma mark 正常接口请求
- (void)loadDataApi:(NSString *)api block:(void (^)(NSInteger status,NSDictionary *modelData))finishBlock {
    
    // 检测网络状态
    if ([[YYReachability reachability] isReachable] == NO) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"亲，好像没有网络哦~" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        [self.hud hide:YES];
        return;
    }
    
    self.api = api;
    [self requestNetWork:finishBlock];
}

-  (void)requestNetWork:(void(^)(NSInteger status,NSDictionary*modelData))finishBlock {
    
    if (self.api == nil) {
        return;
    }
        
    NSString *token = [UserInfo getAccessToken];
    if (token != nil) {
        [self setParam:@"token" model:token];
    }
    NSString *userID = (NSString *)[UserInfo getUserInfoValue:kUserID];
    if (userID != nil) {
        [self setParam:@"m_id" model:userID];
    }
    
    if (self.openDebug) {
        [HYBNetworking enableInterfaceDebug:YES];
    }
    
    [HYBNetworking updateBaseUrl:Server_Int_Url];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSLog(@"请求参数:%@",self.params);

    [HYBNetworking postWithUrl:self.api
                  refreshCache:YES
                        params:self.params
                       success:^(id response) {
                           [self.hud hide:YES];
                           
                           //请求结束 清除参数集合
                           [self.params removeAllObjects];
                           
                           [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           
                           NSInteger status = 10000;
                           
                           if ([[response objectForKey:@"flag"] isEqualToString:@"success"]) {//成功
                               status = Success_Status;
                           }
                           if ([[response objectForKey:@"flag"] isEqualToString:@"error"]) {//失败
                               status = Failure_Status;
                               if ([[response objectForKey:@"message"] isEqualToString:@"无效token"] || [[response objectForKey:@"message"] isEqualToString:@"用户未登录"]) {//异常登录
                                   status = AbnormalLogin_State;
                               }
                           }
                           
                           NSDictionary *dataDic = response;
                           
                           NSLog(@"非表类接口请求的第一次打印--%@",dataDic);
                           
                           if (status == AbnormalLogin_State) {
                               // 账号异常登录
                               [self showLoginAbnormalAlertView];
                               return ;
                           }
                           
                           if (finishBlock != nil) {
                               finishBlock(status,dataDic);
                           }

                       }
                          fail:^(NSError *error) {
                              
                              //请求结束 清除参数集合
                              [self.params removeAllObjects];
                              
                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                              
                              [self showMessage:@"服务器开小差了~请稍后再试"];
                          }];
}

#pragma mark 需要上拉下拉刷新请求(表类请求,数据一般为数组形式)
- (void)loadDataApi:(NSString*)api refresh:(kRefreshType)type model:(Class)modelClass {
    
    // 检测网络状态
    if ([[YYReachability reachability] isReachable] == NO) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"亲，好像没有网络哦~" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        [self.hud hide:YES];
        return;
    }
    
    self.tableApi = api;
    self.modelClass = modelClass;
    self.page = 1;
    
    refType = type;
    
    if (self.pageSize == 0) {
        self.pageSize = 10;
    }
    switch (type) {
        case RefreshTypeNone:
        {
            if (self.tableType == TableViewType) {
                self.baseTableView.mj_header = nil;
                self.baseTableView.mj_footer = nil;
            }
            else {
                self.baseColloectionView.mj_header = nil;
                self.baseColloectionView.mj_footer = nil;
            }
            [self requestTableViewNetWork];
        }
            break;
        case RefreshTypeHeader:
        {
            if (self.tableType == TableViewType) {
                self.baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
                self.baseTableView.mj_footer = nil;
                
                if (self.isStartRefresh) {
                    [self.baseTableView.mj_header beginRefreshing];
                }
                else {
                    [self requestTableViewNetWork];
                }
            }
            else {
                self.baseColloectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
                self.baseColloectionView.mj_footer = nil;
                
                if (self.isStartRefresh) {
                    [self.baseColloectionView.mj_header beginRefreshing];
                }
                else {
                    [self requestTableViewNetWork];
                }
            }
        }
            break;
        case RefreshTypeFooter:
        {
            if (self.tableType == TableViewType) {
                self.baseTableView.mj_header = nil;
                self.baseTableView.mj_footer = nil;
            }
            else {
                self.baseColloectionView.mj_header = nil;
                self.baseColloectionView.mj_footer = nil;
            }
            [self requestTableViewNetWork];
        }
            break;
        case RefreshTypeBoth:
        {
            if (self.tableType == TableViewType) {
                self.baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
                self.baseTableView.mj_footer = nil;
                
                if (self.isStartRefresh) {
                    [self.baseTableView.mj_header beginRefreshing];
                }
                else {
                    [self requestTableViewNetWork];
                }
            }
            else {
                self.baseColloectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
                self.baseColloectionView.mj_footer = nil;
                
                if (self.isStartRefresh) {
                    [self.baseColloectionView.mj_header beginRefreshing];
                }
                else {
                    [self requestTableViewNetWork];
                }
            }
        }
            break;
        default:
            break;
    }
}

-(void)headerRefresh {
    self.page = 1;
    [self requestTableViewNetWork];
}

-(void)footerRefresh {
    self.page ++ ;
    [self requestTableViewNetWork];
}

- (void)requestTableViewNetWork {
    
    if (self.tableApi == nil) {
        return;
    }
    
    NSString *token = [UserInfo getAccessToken];
    if (token != nil) {
        [self setTableParams:@"token" model:token];
    }
    NSString *userID = (NSString *)[UserInfo getUserInfoValue:kUserID];
    if (userID != nil) {
        [self setTableParams:@"m_id" model:userID];
    }
    
    [self setTableParams:@"page" model:[NSString stringWithFormat:@"%d",self.page]];
    [self setTableParams:@"page.num" model:[NSString stringWithFormat:@"%d",self.pageSize]];
    
    if (self.openDebug) {
        [HYBNetworking enableInterfaceDebug:YES];
    }
    
    [HYBNetworking updateBaseUrl:Server_Int_Url];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [HYBNetworking postWithUrl:self.tableApi
                  refreshCache:YES
                        params:self.tableParams
                       success:^(id response) {
                           [self.hud hide:YES];
                           
                           NSLog(@"表类接口请求的第一次打印--%@",response);

                           [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           
                           if(self.dataSource == nil){
                               self.dataSource = [[NSMutableArray alloc] init];
                           }
                           
                           NSInteger status = 10000;
                           
                           NSArray *dataAry;
                           
                           if ([[response objectForKey:@"flag"] isEqualToString:@"success"]) {//成功
                               status = Success_Status;
                               
                               dataAry = response[@"data"][@"list"];
                               
                           }
                           if ([[response objectForKey:@"flag"] isEqualToString:@"error"]) {//失败
                               status = Failure_Status;
                               if ([[response objectForKey:@"message"] isEqualToString:@"无效token"] || [[response objectForKey:@"message"] isEqualToString:@"用户未登录"]) {//异常登录
                                   status = AbnormalLogin_State;
                               }
                               
                               dataAry = @[];
                           }
                           
                           if (status == Success_Status) {
                               
                               if (self.page == 1) {
                                   [self.dataSource removeAllObjects];
                               }
                               
                               NSArray *data = nil;
                               if (self.modelClass == nil) {
                                   data = dataAry;
                               }
                               else {
                                   data = [NSArray modelArrayWithClass:self.modelClass json:dataAry];
                               }
                               
                               [self.dataSource addObjectsFromArray:data];
                               
                           }
                           else if (status == AbnormalLogin_State) {
                               // 账号异常登录
                               [self showLoginAbnormalAlertView];
                           }
                           else {
                               NSString *messageStr = response[@"message"];
                               [self showMessage:messageStr];
                           }
                           
                           if (self.tableType == TableViewType) {
                               
                               if (refType != RefreshTypeNone && refType != RefreshTypeHeader) {
                                   if (self.dataSource.count >= self.pageSize) {
                                       self.baseTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
                                   }
                               }
                           }
                           else {
                               
                               if (refType != RefreshTypeNone && refType != RefreshTypeHeader) {
                                   if (self.dataSource.count >= self.pageSize) {
                                       self.baseColloectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
                                   }
                               }
                           }
                           
                           if (self.tableType == TableViewType) {
                               if (self.baseTableView.mj_footer != nil) {
                                   
                                   
                                   if (self.pageSize > dataAry.count) {
                                       [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                                   }
                                   else {
                                       [self.baseTableView.mj_footer endRefreshing];
                                   }
                               }
                               
                               if (self.baseTableView.mj_header != nil) {
                                   [self.baseTableView.mj_header endRefreshing];
                               }
                               
                               [self.baseTableView reloadData];
                           }
                           else {
                               if (self.baseColloectionView.mj_footer != nil) {
                                   if (self.pageSize > dataAry.count) {
                                       [self.baseColloectionView.mj_footer endRefreshingWithNoMoreData];
                                   }
                                   else {
                                       [self.baseColloectionView.mj_footer endRefreshing];
                                   }
                               }
                               
                               if (self.baseColloectionView.mj_header != nil) {
                                   [self.baseColloectionView.mj_header endRefreshing];
                               }
                               
                               [self.baseColloectionView reloadData];
                           }
                           
                           if (self.baseFinishBlock != nil) {
                               
                               self.baseFinishBlock(status);
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                              
                              [self showMessage:@"服务器开小差了~请稍后再试"];
                              
                              if (self.tableType == TableViewType) {
                                  if (self.baseTableView.mj_header != nil) {
                                      [self.baseTableView.mj_header endRefreshing];
                                  }
                                  if (self.baseTableView.mj_footer != nil) {
                                      [self.baseTableView.mj_footer endRefreshing];
                                  }
                              }
                              else {
                                  if (self.baseColloectionView.mj_header != nil) {
                                      [self.baseColloectionView.mj_header endRefreshing];
                                  }
                                  if (self.baseColloectionView.mj_footer != nil) {
                                      [self.baseColloectionView.mj_footer endRefreshing];
                                  }
                              }
                              
                              if (self.page == 1) {
                                  if (self.baseFinishBlock != nil) {
                                      self.baseFinishBlock(0);
                                  }
                              }
                        }];
}

#pragma mark
#pragma mark - Public
- (UIButton *)makeBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setImage:[UIImage imageNamed:@"nav_back_icon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTintColor:RL_Nav_Color];
    return backButton;
}

- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)makeTitleLabelWithTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont systemFontOfSize:Nav_Title_Font]];
    [titleLabel setTextColor:Nav_Title_Color];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    return titleLabel;
}

- (UIView *)addTitleViewWithTitle:(NSString *)titleText
{
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:Nav_Color];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(65);
    }];
    
    if (self.navigationController.viewControllers.count > 1) {
        _backButton = [self makeBackButton];
        [titleView addSubview:_backButton];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleView.mas_left);
            make.centerY.equalTo(titleView.mas_centerY).offset(10);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(fJFScreen((28 + 38/2)*2));
        }];
    }
    
    UILabel *titleLabel = [self makeTitleLabelWithTitle:titleText];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(titleView);
        make.height.mas_equalTo(44);
    }];
    self.titleLabel = titleLabel;
    
    UIView *line = [UIView new];
    line.backgroundColor = BG_Color;
    [titleView addSubview:line];
    line.sd_layout
    .bottomSpaceToView(titleView, 0)
    .widthIs(Width_Screen)
    .heightIs(1);
    self.lineView = line;

    return titleView;
}


- (UIViewController *)topViewController {
    UIViewController *rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        // navigationController
        return [rootVC.navigationController topViewController];
    }
    else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // tabbarController
        return (UIViewController *)[(UITabBarController *)rootVC selectedViewController];
    }
    else {
        // viewController
        return rootVC;
    }
}

#pragma mark 报错的AlertView
- (void)showError:(NSString*)str {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark 登录异常的AlertView
- (void)showLoginAbnormalAlertView {

    //存入登录状态
    NSUserDf_Set(kNoLogin, FCIsLogin);
    //移除用户信息
    [UserInfo removeUserInfo];
    //移除token
    [UserInfo removeAccessToken];
    
    NSArray *vcArray = self.navigationController.viewControllers;
    UIViewController *currController = vcArray.lastObject;
    UIViewController *firstController = vcArray.firstObject;
    
    NSLog(@"%@------%@",currController.className,firstController.className);
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"账号异常!" message:@"您的帐号已在其它设备登录!" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDf_Remove(kUserPhone);//移除单存的手机号
        
        //判断当前 所在 视图 和 跟视图  是谁 处理  异常登陆后  点击取消的处理方式
        if ([firstController.className isEqualToString:@"PersonalViewController"]) {
            if ([currController.className isEqualToString:@"PersonalViewController"]) {//个人中心
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNoLoginStatus object:nil userInfo:nil];//发送一个通知：刷新未登录状态
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        else if ([firstController.className isEqualToString:@"MKJShoppingCartViewController"]) {
            if ([currController.className isEqualToString:@"MKJShoppingCartViewController"]) {//购物车
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNoLoginStatus object:nil userInfo:nil];//发送一个通知：刷新未登录状态
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        else if ([firstController.className isEqualToString:@"MainViewController"]) {//主页
            
            if ([currController.className isEqualToString:@"AskPriceViewController"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                NSInteger orderDetailNum = 0;
                int i = 0;
                for (UIViewController *controller in vcArray) {
                    if ([controller.className isEqualToString:@"GoodsInfoViewController"]) {
                        orderDetailNum = i;
                        break;//回到第一个商品信息控制器（也许会有很有重复，所以未登录状态处理结果，回到最初的一个）
                    }
                    i++;
                }
                [self.navigationController popToViewController:[vcArray objectAtIndex:orderDetailNum] animated:YES];
            }
        }
    }];
    [alertVC addAction:action];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去登录" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        LoginViewController *loginVC = [LoginViewController new];
        [self.navigationController pushViewController:loginVC animated:YES];
        
        //登录成功后的回调 加载用户数据
        loginVC.loginSuccessClick = ^(BOOL isSuccess) {
            [self loadDataApi:User_Base_Data_Api
                        block:^(NSInteger status, NSDictionary *modelData) {
                            
                            NSLog(@"获取用户个人信息 --- %@",modelData);
                            
                            if (status == Success_Status) {
                                //存入用户个人信息
                                [UserInfo updateUserInfo:modelData[@"data"]];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAlreadyLoginStatus object:nil userInfo:nil];//发送一个通知：刷新登录后状态
                            }
                            else {
                                NSString *messageStr = modelData[@"message"];
                                if ([Utils isBlankString:messageStr] == NO) {
                                    [self showMessage:messageStr];
                                }
                            }
                            
                        }];
        };
        
    }];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark 未登录的AlertView
- (void)showNoLoginAlertView {
    
    if ([UserInfo checkLoginStatus] == NO) {
        
        LoginViewController *loginVC = [LoginViewController new];
        loginVC.isNormalLogin = @"正常登陆";
        [self.navigationController pushViewController:loginVC animated:YES];
        
        //登录成功后的回调 加载用户数据
        loginVC.loginSuccessClick = ^(BOOL isSuccess) {
            [self loadDataApi:User_Base_Data_Api
                        block:^(NSInteger status, NSDictionary *modelData) {
                            
                            NSLog(@"获取用户个人信息 --- %@",modelData);
                            
                            if (status == Success_Status) {
                                //存入用户个人信息
                                [UserInfo updateUserInfo:modelData[@"data"]];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAlreadyLoginStatus object:nil userInfo:nil];//发送一个通知：刷新登录后状态
                            }
                            else {
                                NSString *messageStr = modelData[@"message"];
                                if ([Utils isBlankString:messageStr] == NO) {
                                    [self showMessage:messageStr];
                                }
                            }
                            
                        }];
        };
        
        
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 透明指示层
- (void)showImage:(NSString *)name time:(NSTimeInterval)time message:(NSString *)message {
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the custom view mode to show any view.
    self.hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    self.hud.square = YES;
    // Optional label text.
    self.hud.labelText = message;
    self.hud.margin = 20.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hide:YES afterDelay:time];
}

- (void)showMessage:(NSString *)message {
    [self showMessage:message time:1.5];
}

- (void)showMessage:(NSString *)message time:(NSTimeInterval)time {
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = message;
    self.hud.labelFont = [UIFont systemFontOfSize:14];
    //self.hud.yOffset = -(WIDTH_SCREEN / 2 - HEIGHT_NAVBAR - 30);
    self.hud.margin = 15.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hide:YES afterDelay:time];
}

- (void)showMessage:(NSString *)message time:(NSTimeInterval)time view:(UIView *)view {
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = message;
    self.hud.labelFont = [UIFont systemFontOfSize:14];
    self.hud.yOffset = -(kJFAppWidth / 2 - kJFAppHeight - 80);
    self.hud.margin = 15.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    if(time != 0){
        [self.hud hide:YES afterDelay:time];
    }
}

- (void)showLoadding:(NSString *)message {
    [self showLoadding:message time:3];
}

- (void)showLoadding:(NSString *)message time:(NSTimeInterval)time {
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    self.hud.labelText = message;
    self.hud.margin = 20.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    if(time != 0){
        [self.hud hide:YES afterDelay:time];
    }
}

- (void)showLoadding:(NSString *)message time:(NSTimeInterval)time view:(UIView *)view {
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:view
                                    animated:YES];
    self.hud.labelText = message;
    self.hud.labelFont = [UIFont systemFontOfSize:12];
    self.hud.margin = 8.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    if(time != 0){
        [self.hud hide:YES afterDelay:time];
    }
}

@end
