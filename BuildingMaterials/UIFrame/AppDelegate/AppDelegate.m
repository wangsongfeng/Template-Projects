//
//  AppDelegate.m
//  RealEstate
//
//  Created by mac on 2017/5/26.
//  Copyright © 2017年 刘志远. All rights reserved.
//

#import "AppDelegate.h"

#import "RootTabBarController.h"
#import "BaseNavViewController.h"
#import "IQKeyboardManager.h"

//Mob分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initloadRootVC];// 初始化加载跟视图
    
    [self IQKeyboardManagerInit];// 初始化IQ键盘设置
    
//    [self setShareSdk];//分享SDK配置
    
    return YES;
}

#pragma mark - 加载跟试图
- (void)initloadRootVC {
    RootTabBarController *tabBarController = [RootTabBarController sharedRootTabBarController];
    self.window.rootViewController = tabBarController;
}

#pragma mark - 初始化IQKeyboardManager
- (void)IQKeyboardManagerInit {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

#pragma mark - ShareSDK SetUp Mob 分享
//- (void)setShareSdk {
//    
//    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformSubTypeQQFriend),
//                                        @(SSDKPlatformSubTypeWechatSession),
//                                        @(SSDKPlatformSubTypeWechatTimeline),
//                                        @(SSDKPlatformTypeSinaWeibo)]
//                             onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//                 case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//                 case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                 break;
//                 case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         switch (platformType)
//         {
//                 case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:APPKey_Sina
//                                           appSecret:APPSecret_Sina
//                                         redirectUri:Url_Sina
//                                            authType:SSDKAuthTypeBoth];
//                 break;
//                 case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:APPID_WX
//                                       appSecret:APPSecret_WX];
//                 break;
//                 case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:APPID_QQ
//                                      appKey:APPKey_QQ
//                                    authType:SSDKAuthTypeBoth];
//                 break;
//             default:
//                 break;
//         }
//     }];
//    
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    if ([UserInfo checkLoginStatus] == NO) {
        if (NSUserDf_Get(kUserPhone) != nil) {
            NSUserDf_Remove(kUserPhone);//移除单存的手机号
        }
    }
}

@end
