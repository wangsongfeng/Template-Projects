//
//  HDDeviceInfo.h
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  与设备相关的类：设备信息，调用设备功能
 */

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

// 屏幕相关
#define kJFAppWidth  [[UIScreen mainScreen] bounds].size.width
#define kJFAppHeight [[UIScreen mainScreen] bounds].size.height

#define fJFScreen(x)   ((x)/2 * [JFDeviceInfo screenMultipleIn6])     // 项目中使用的屏幕适配(货不错: px)
#define fJFFontSize(x) (x/2 > 12 ? ((x)/2 * [JFDeviceInfo screenMultipleIn6]) : x/2)
#define fJFScreen6(x)  ((x) * [JFDeviceInfo screenMultipleIn6])       // 4.7 屏幕下的值
#define fJFScreen6p(x) ((x) * [JFDeviceInfo screenMultipleIn6p])      // 5.5 屏幕下的值

// 系统版本
#define kJFSystem_iOS_6 6
#define kJFSystem_iOS_7 7
#define kJFSystem_iOS_8 8
#define kJFSystem_iOS_9 9
#define kJFSystem_iOS_10 10

@interface JFDeviceInfo : NSObject

@property (nonatomic, assign) NSInteger currentOSVersion;       // 当前系统版本

#pragma mark - 屏幕相关
+ (float)screenMultipleIn6;
+ (float)screenMultipleIn6p;

#pragma mark - 判断设备
+ (BOOL)isIPhone4Size;
+ (BOOL)isIPhone5Size;
+ (BOOL)isIPhone6Size;
+ (BOOL)isIPhone6PSize;

#pragma mark - 调用设备功能
/**
 *  调用电话功能拨打电话
 *
 *  @param phoneNumber 要拨打的电话号码
 */
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber;

@end
