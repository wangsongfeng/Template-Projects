//
//  HDDeviceInfo.m
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "JFDeviceInfo.h"

#import <UIKit/UIKit.h>

@implementation JFDeviceInfo

// 4.7寸屏幕为基准的适配比例
+ (float)screenMultipleIn6
{
    return kJFAppHeight/667.0;
}

// 5.5寸屏幕为基准的适配比例
+ (float)screenMultipleIn6p
{
    return kJFAppHeight/736.0;
}

// 判断设备
+ (BOOL)isIPhone4Size
{
    return kJFAppHeight == 480.0 ? YES : NO;
}

+(BOOL)isIPhone5Size
{
    return kJFAppHeight == 568.0 ? YES : NO;
}

+(BOOL)isIPhone6Size
{
    return kJFAppHeight == 667.0 ? YES : NO;
}

+(BOOL)isIPhone6PSize
{
    return kJFAppHeight == 736.0 ? YES : NO;
}

// 调用电话功能拨打电话
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber
{
    if ([phoneNumber isEqualToString:@""]) {
#ifdef DEBUG
        NSAssert(NO, @"empty number string!");
#endif
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma Getter

// 当前系统版本
- (NSInteger)currentOSVersion
{
    NSInteger version;
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (systemVersion >= 10.0) {
        version = kJFSystem_iOS_10;
    }
    else if (systemVersion >= 9.0) {
        version = kJFSystem_iOS_9;
    }
    else if (systemVersion >= 8.0) {
        version = kJFSystem_iOS_8;
    }
    else if (systemVersion >= 7.0) {
        version = kJFSystem_iOS_7;
    }
    else {
        version = kJFSystem_iOS_6;
    }
    
    return version;
}

@end
