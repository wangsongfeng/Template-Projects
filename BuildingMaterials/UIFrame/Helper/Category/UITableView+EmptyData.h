//
//  UITableView+EmptyData.h
//  KMEEN.ZF
//
//  Created by Rookie on 16/5/12.
//  Copyright © 2016年 郑州仟米科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewEmptyDataDelegate <NSObject>

- (void)tableViewEmptyDataButtonClick;

@end

@interface UITableView (EmptyData)

@property (nonatomic, assign) id<TableViewEmptyDataDelegate> emptyDataDelegate;

- (void)tableViewDisplayWitMsg:(NSString *)message widthButtonMessage:(NSString *)btnMessage widthImagePicName:(NSString *)name dataArrayCount:(NSUInteger)count;

@end
