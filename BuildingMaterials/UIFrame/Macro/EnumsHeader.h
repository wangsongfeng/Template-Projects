//
//  EnumsHeader.h
//  RealEstate
//
//  Created by mac on 2017/6/30.
//  Copyright © 2017年 刘志远. All rights reserved.
//

#ifndef EnumsHeader_h
#define EnumsHeader_h

#pragma mark 表刷新类型
typedef NS_ENUM(NSInteger) {
    RefreshTypeNone = 0,//默认从0开始  没有上拉加载下拉刷新
    RefreshTypeHeader ,//只有下拉刷新
    RefreshTypeFooter ,//只有上拉加载
    RefreshTypeBoth ,//上拉加载下拉刷新都有
}kRefreshType;

#pragma mark 表种类类型
typedef NS_ENUM(NSInteger) {
    TableViewType = 0,
    CollectionViewType,
}kTableType;

#pragma mark 充值支付提现
typedef NS_ENUM(NSInteger) {
    kWeChat = 0,//微信支付
    kAlipay = 1,//支付宝支付
    kUnionpay = 2,//银联支付
}kPayWay;

#pragma mark 自定义导航栏按钮点击
typedef NS_ENUM(NSInteger) {
    LeftButtonClick = 0,//左边按钮
    SearchButtonClick ,//搜索框按钮
    RightButtonClick ,//右边按钮
}kNavButtonClick;

#pragma mark 轮播图跳转类型
typedef NS_ENUM(NSInteger) {
    BannerJumpType_Goods = 0,// 跳转商品详情
    BannerJumpType_Sho,// 跳转店铺
    BannerJumpType_Web,// 跳转web
}BannerJumpType;

#pragma mark 添加收货地址类型 修改 还是 新添加
typedef NS_ENUM(NSInteger) {
    AddAddressInfo = 0,// 添加收货地址
    EditAddressInfo,// 编辑收货地址
}AddOrEditAddressType;

#pragma mark 首页模块分类
typedef NS_ENUM(NSInteger) {
    WuJin_Type = 0,// 五金
    ShuiNuan_Type = 1, // 水暖
    GangCai_Type = 2, // 钢材
    ChuFang_Type = 3, // 厨房
    DengShi_Type = 4, // 灯饰
    WeiYu_Type = 5, // 卫浴
    DianQi_Type = 6, // 电器
    JiaJu_Type = 7, // 家具
    TeJia_Type = 8, // 今日特价
}kModuleVCType;

#endif /* EnumsHeader_h */
