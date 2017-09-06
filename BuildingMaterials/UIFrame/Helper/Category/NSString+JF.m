//
//  NSString+HD.m
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "NSString+JF.h"

@implementation NSString (JF)

- (CGSize)sizeForFontsize:(CGFloat)fontsize {
    CGRect titleRect = [self boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontsize]}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

- (CGSize)textHeightWithTextWidth:(CGFloat)width withFontsize:(CGFloat)fontsize  {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil];
    
    CGSize size = rect.size;
    
    return size;
}

@end
