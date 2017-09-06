//
//  KMButton.h
//  Bus
//
//  Created by Rookie on 15/9/9.
//  Copyright (c) 2015年 河南省863软件孵化器有限公司  com.863soft.gjx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KMButtonType) {
    KMButtonLeft                = 0,//靠左 左图右文字
    KMButtonLeftInvert          = 1,//靠左 左文字右图
    KMButtonRight               = 2,//靠右 左文字右图
    KMButtonRightInvert         = 3,//靠右 左图右文字
    KMButtonCenter              = 4,//居中 上图下文字
    KMButtonCenterInvert        = 5,//居中 上文字下图
    KMButtonCenterLeft          = 6,//居中靠左 上图下文字
    KMButtonCenterRight         = 7,//居中靠右 上文字下图
};

@interface KMButton : UIButton
@property (nonatomic)   CGFloat         spacing;//间距
@property (nonatomic)   CGFloat         margin;//距离
@property (nonatomic)   KMButtonType    kMButtonType;
@end
