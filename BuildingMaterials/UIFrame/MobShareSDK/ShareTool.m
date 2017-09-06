//
//  ShareTool.m
//  RealEstate
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 刘志远. All rights reserved.
//

#import "ShareTool.h"

//Mob设置-安全域名地址 这个地址要到Mob添加设置 一定要一样  不然 无法进行微博等网页形式分享
#define Security_IP_Address @"http://www.tangchaoke.com"

@implementation ShareTool

SingletonM(ShareTool)

#pragma mark - 分享参数配置
- (void)showHomeDetailShare:(NSArray *)images withText:(NSString *)text withTitle:(NSString *)title withUrl:(NSString *)url {

    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (images) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@",text,Security_IP_Address]
                                         images:images
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        
        
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //设置显示平台 只能分享视频的YouTube MeiPai 不显示
        NSArray *items = @[@(SSDKPlatformSubTypeQQFriend),
                           @(SSDKPlatformSubTypeWechatSession),
                           @(SSDKPlatformSubTypeWechatTimeline),
                           @(SSDKPlatformTypeSinaWeibo)];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:items
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                               
                               case SSDKResponseStateBegin:
                           {
                               //设置UI等操作
                               break;
                           }
                               case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                               case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                               case SSDKResponseStateCancel:
                           {
                               //                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                               //                                                                                   message:nil
                               //                                                                                  delegate:nil
                               //                                                                         cancelButtonTitle:@"确定"
                               //                                                                         otherButtonTitles:nil];
                               //                               [alertView show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}


@end
