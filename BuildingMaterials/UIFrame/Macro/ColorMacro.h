//
//  ColorMacro.h
//  ZhongYouShangLian
//
//  Created by xll on 2017/4/7.
//  Copyright © 2017年 JoyFate. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

/********** 颜色 **************/
//  随机数
#define kRandom(a,b)        (arc4random() % a / b)
// RGB颜色设置
#define RGBCA(c,a)          [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)          RGBA(r, g, b, 1.0f)
// 随机颜色
#define KMRC              [UIColor colorWithHue:kRandom(256,256.0) saturation:kRandom(128,256.0)  + 0.5 brightness:kRandom(128,256.0)  + 0.5 alpha:1]

//整体主色调
#define Main_Color RGB(226, 28, 95)

//主页背景色
#define MainView_BG_Color RGB(245, 245, 245)

//整体背景色
#define BG_Color  MainView_BG_Color

//cell 分割线
#define CellLine_Color  RGB(235, 235, 235)

//整体灰色字体
#define Hui_Color  RGB(153, 153, 153)

//整体主黑色字
#define Text_Color  RGB(50, 50, 50)

//红色字
#define Red_Color  Main_Color

//导航栏颜色
#define Nav_Color  RGB(255, 255, 255)

//导航栏 标题颜色
#define Nav_Title_Color  RGB(50, 50, 50)

//导航栏左右 按钮颜色
#define RL_Nav_Color  RGB(50, 50, 50)

//导航栏标题字大小
#define Nav_Title_Font fJFScreen(18*2)

//导航左右按钮字大小
#define RL_Nav_Font fJFScreen(16*2)

#endif /* ColorMacro_h */
