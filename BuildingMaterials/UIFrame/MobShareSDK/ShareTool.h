//
//  ShareTool.h
//  RealEstate
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 刘志远. All rights reserved.
//

//调用分享视图的单例类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ShareTool : NSObject

SingletonH(ShareTool)

/**
 * 显示分享视图
 * images 要分享的图片组
 * text 要分享的内容
 * title 要分享标题
 * url 要分享的链接
 */
- (void)showHomeDetailShare:(NSArray *)images withText:(NSString *)text withTitle:(NSString *)title withUrl:(NSString *)url;

@end
