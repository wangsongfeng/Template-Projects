//
//  Utils.h
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

// 工具类

#import <Foundation/Foundation.h>

@interface Utils : NSObject

/* *
 * 判断字符串是否为空
 * string 文本内容
 */
+ (BOOL)isBlankString:(NSString *)string;

/* *
 * 格式化时间戳
 * format 时间格式
 * timeStr 时间戳字符串
 */
+ (NSString *)formatTimeStamp:(NSString *)format withTime:(NSString *)timeStr;

//拨打电话
+ (void)makeCallWithPhoneNum:(NSString *)num target:(UIViewController *)target;

//字典转json
+ (NSString *)jsonFromDictionary:(NSDictionary *)dic;

//检测手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber;

//判断字符串是否为浮点型
+ (BOOL)isPureFloat:(NSString *)string;

//判断字符串是为整型
+ (BOOL)isPureInt:(NSString *)string;

// 1.计算单个文件大小
+ (float)fileSizeAtPath:(NSString *)path;

// 2.计算文件夹大小(要利用上面的1提供的方法)
+ (float)folderSizeAtPath:(NSString *)path;

// 3.清除缓存
+ (void)clearCache:(NSString *)path;

@end
