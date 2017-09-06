//
//  Utils.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "Utils.h"

@implementation Utils

//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if (    [string isEqual:nil]
        ||  [string isEqual:Nil]){
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (0 == [string length]){
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if([string isEqualToString:@"(null)"]){
        return YES;
    }
    return NO;
}

//格式化时间戳
+ (NSString *)formatTimeStamp:(NSString *)format withTime:(NSString *)timeStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr integerValue]];
    formatter.dateFormat = format;
    NSString *time = [formatter stringFromDate:date];
    
    return time;
}

//拨打电话
+ (void)makeCallWithPhoneNum:(NSString *)num target:(UIViewController *)target {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
//        UIWebView *callPhoneWebVw = [[UIWebView alloc] init];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",num]]];
//        [callPhoneWebVw loadRequest:request];
//        [target.view addSubview:callPhoneWebVw];
        //解决 打电话弹出 慢的 问题
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", num];
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"对不起!" message:@"你的设备不支持打电话" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

////字典转json
+ (NSString *)jsonFromDictionary:(NSDictionary *)dic {
    NSMutableString *jsonString = [NSMutableString string];
    [jsonString appendString:@"{"];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [jsonString appendFormat:@"\"%@\":",key];
        //NSString *valueStr = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [jsonString appendFormat:@"\"%@\",",value];
    }];
    [jsonString replaceCharactersInRange:NSMakeRange(jsonString.length - 1, 1) withString:@""];
    [jsonString appendString:@"}"];
    return jsonString;
}

//判断字符串是为整型
+ (BOOL)isPureInt:(NSString *)string {
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断字符串是为浮点型
+ (BOOL)isPureFloat:(NSString*)string {
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//检测手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber {
    
    if (telNumber.length != 11) {
        
        return NO;
    }
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL isMOBILE = [regextestmobile evaluateWithObject:telNumber];
    BOOL isCM     = [regextestcm evaluateWithObject:telNumber];
    BOOL isCU     = [regextestcu evaluateWithObject:telNumber];
    BOOL isCT     = [regextestct evaluateWithObject:telNumber];
    
    if (isMOBILE || isCM || isCU || isCT) {
        
        if (isCM) {
            NSLog(@"China Mobile");
        }
        else if (isCU) {
            NSLog(@"China Telecom");
        }
        else if (isCT) {
            NSLog(@"China Unicom");
        }
        else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else {
        
        return NO;
    }
}

// 1.计算单个文件大小
+ (float)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

// 2.计算文件夹大小(要利用上面的1提供的方法)
+ (float)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        // SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

// 3.清除缓存
+ (void)clearCache:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

@end
