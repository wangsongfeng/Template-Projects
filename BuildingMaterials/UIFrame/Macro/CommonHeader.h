//
//  JFCommonHeader.h
//  ZhongYouShangLian
//
//  Created by Showtime on 2017/3/9.
//  Copyright © 2017年 JoyFate. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h

/********** Xcode8 解决打印不全 **************/
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

/********** 各种系统界面的高度大小 **************/
#pragma mark - Frame
#define Width_Screen               [UIScreen mainScreen].bounds.size.width
#define Height_Screen              [UIScreen mainScreen].bounds.size.height
#define Height_Statusbar           20
#define Height_Tabbar              49
#define Height_Navbar              44
#define Nav_Total                  64

/********** 本地存储 **************/
#define NSUserDf_Set(Value,Key) {[[NSUserDefaults standardUserDefaults] setObject:Value forKey:Key]; [[NSUserDefaults standardUserDefaults] synchronize];}
#define NSUserDf_Remove(Key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key]
#define NSUserDf_Get(Key) [[NSUserDefaults standardUserDefaults] objectForKey:Key]

/********** block self **************/
#define WeakSelf    __weak __typeof(self) wself = self;

/********** AppDelegate **************/
#define APP_DELEGETE   ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define Main_Win       [UIApplication sharedApplication].windows[0];

/********** 版本判断 **************/
#define IOS(Num) ([[UIDevice currentDevice].systemVersion doubleValue] >= Num)
#define IOS_VERSIONS [[[UIDevice currentDevice] systemVersion] floatValue]
// 是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

/********** 高度相对于宽度为16:9 **************/
#define Height_SixteenToNine (Width_Screen/16)*9

/********** 用户信息 **************/
#define kUserID @"m_id"                // 用户id
#define kUserPhone @"m_account"           // 用户手机号
#define kUserNickName @"m_nickname"     // 用户昵称
#define kUserPhoto @"m_head"           // 用户头像地址
#define kUserBalance @"balance"       // 用户余额

#define kToken @"token"         // 用户token

/********** 登录状态 **************/
#define FCIsLogin @"JRIsLogin"
#define kYesLogin @"yes"
#define kNoLogin @"no"

/********** 当前所在根视图是谁 主页 还是 个人中心  这个决定了 如果登录异常 的处理 逻辑 **************/
#define Curr_Main_VC @"CurrentMianVC"

#endif /* CommonHeader_h */
