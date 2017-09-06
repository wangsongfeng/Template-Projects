//
//  UITableView+EmptyData.m
//  KMEEN.ZF
//
//  Created by Rookie on 16/5/12.
//  Copyright © 2016年 郑州仟米科技. All rights reserved.
//

#import "UITableView+EmptyData.h"

#import <objc/runtime.h>

@implementation UITableView (EmptyData)

- (void)tableViewDisplayWitMsg:(NSString *)message widthButtonMessage:(NSString *)btnMessage widthImagePicName:(NSString *)name dataArrayCount:(NSUInteger)count {
    if (count == 0) {
        // Display a message when the table is empty
        UIView *bgView;
        if (!bgView) {
            bgView = [UIView new];
            bgView.backgroundColor = [UIColor whiteColor];
        }
        
        UIImageView *imagePic;
        if (!imagePic) {
            imagePic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        }
        [bgView addSubview:imagePic];
        
        NSLog(@"%f",imagePic.image.size.height);
        
        NSInteger height;
        if ([btnMessage isEqualToString:@""]) {
            height = (kJFAppHeight - (fJFScreen(200*2) + imagePic.image.size.height)) / 2 - fJFScreen(20*2);
        }
        else {
            height = (kJFAppHeight - (fJFScreen(277*2) + imagePic.image.size.height)) / 2 - fJFScreen(20*2);
        }
        
        imagePic.sd_layout
        .topSpaceToView(bgView,height)
        .centerXEqualToView(bgView)
        .heightIs(imagePic.image.size.height);
        
        UILabel *messageLab;
        if (!messageLab) {
            messageLab = [UILabel new];
        }
        messageLab.textColor = RGB(100, 100, 100);
        messageLab.textAlignment = NSTextAlignmentCenter;
        messageLab.font = [UIFont systemFontOfSize:fJFScreen(14*2)];
        messageLab.text = message;
        messageLab.numberOfLines = 0;
        [bgView addSubview:messageLab];
        
        CGSize SizeHeight = [message textHeightWithTextWidth:kJFAppWidth-fJFScreen(30*2) withFontsize:fJFScreen(14*2)];
        
        messageLab.sd_layout
        .topSpaceToView(imagePic,fJFScreen(30*2))
        .centerXEqualToView(bgView)
        .leftSpaceToView(bgView,fJFScreen(15*2))
        .rightSpaceToView(bgView,fJFScreen(15*2))
        .heightIs(SizeHeight.height);
        
        if ([btnMessage isEqualToString:@""] == NO) {
            UIButton *button;
            if (!button) {
                button = [UIButton buttonWithType:UIButtonTypeSystem];
            }
            button.backgroundColor = Main_Color;
            [button setTitle:btnMessage forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:fJFScreen(14*2)];
            button.clipsToBounds = YES;
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = fJFScreen(5*2);
            [bgView addSubview:button];
            
            CGSize SizeWidth = [btnMessage sizeForFontsize:fJFScreen(14*2)];
            
            button.sd_layout
            .topSpaceToView(messageLab,fJFScreen(30*2))
            .centerXEqualToView(bgView)
            .widthIs(SizeWidth.width+fJFScreen(50*2))
            .heightIs(fJFScreen(35*2));
        }
        
        self.backgroundView = bgView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else {
        
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

#pragma mark - 类别添加属性时的配置  运行时机制
- (id<TableViewEmptyDataDelegate>)emptyDataDelegate {
    return objc_getAssociatedObject(self, @selector(emptyDataDelegate));
}

- (void)setEmptyDataDelegate:(id<TableViewEmptyDataDelegate>)emptyDataDelegate {
    objc_setAssociatedObject(self, @selector(emptyDataDelegate), emptyDataDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 空数据时按钮代理
- (void)buttonClick {
    [self.emptyDataDelegate tableViewEmptyDataButtonClick];
}

@end
