//
//  BaseViewController.h
//  ZhongYouShangLian
//
//  Created by Showtime on 2017/3/9.
//  Copyright © 2017年 JoyFate. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MBProgressHUD.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;  // 通过addTitleViewWithTitle创建的头 titleLabel 为标题

@property (nonatomic, strong) MBProgressHUD *hud;//透明指示层

// tabBariItem
@property (nonatomic, strong) UIImage *itemNormalImage;
@property (nonatomic, strong) UIImage *itemSelectImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIView *lineView;

// navigationController
@property (nonatomic, strong) UINavigationController *currNavigationController;

@property (nonatomic, strong) NSMutableDictionary *params;//请求所需全部参数的集合
@property (nonatomic, copy) NSString *api;//请求接口非公共部分的URL
@property (nonatomic, assign) BOOL openDebug;//是否开启调试模式

/* *
 * !!!!!! 如果要调用表类请求的话,必须把子类的表赋值给父类,而且要根据表类型给 TableType 赋值,才可使用
 * !!!!!! 调用非表类请求,就不管你不需要的属性和方法
 */

//表类请求需要的属性设置
@property (nonatomic, copy)void (^baseFinishBlock)(NSInteger status);//表类请求成功后返回的回调Block

@property (nonatomic, assign) kTableType tableType;//表类型
@property (nonatomic, strong) UITableView *baseTableView;//把子类tableView赋值给它
@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, strong) UICollectionView *baseColloectionView;//把子类colloectionView赋值给它
@property (nonatomic, assign)  BOOL isStartRefresh;//是否立即刷新 默认为NO 不立即执行下拉状态刷新
@property (nonatomic, assign) int page;//页数 默认为1
@property (nonatomic, assign) int pageSize;//每页多少条 默认为15
@property (nonatomic, assign) Class modelClass;//所需model类

//区分表类请求数据  目的是  两个请求都存在时  防止 数据 冲突
@property (nonatomic, copy) NSString *tableApi;//请求接口非公共部分的URL
@property (nonatomic, strong) NSMutableDictionary *tableParams;//请求所需全部参数的集合

#pragma mark - 接口请求
/* *
 * 添加某个请求参数到参数集合里(此集合是个字典)
 * key 参数的字段名
 * value 字段对应的值
 */
-(void)setParam:(NSString *)key model:(NSObject *)value;

/* *
 * 表类  ----  添加某个请求参数到参数集合里(此集合是个字典)
 * key 参数的字段名
 * value 字段对应的值
 */
-(void)setTableParams:(NSString *)key model:(NSObject *)value;

/* *
 * 非表类请求,数据一般为字典形式,不需要model类
 * api 接口Url(除去共用部分)
 * params 接口所需加密参数字符串
 * block 请求成功后的回调(注 : 返回的参数,可根据具体服务器情况去修改)
 */
- (void)loadDataApi:(NSString *)api block:(void (^)(NSInteger status,NSDictionary *modelData))finishBlock;

/* *
 * 表类请求,数据一般为数组形式(有上拉下拉刷新)
 * api 接口Url(除去共用部分)
 * type 刷新类型 RefreshTypeNone = 无上下拉刷新 详见枚举宏注释
 * modelClass 存储数据所需的model类
 */
- (void)loadDataApi:(NSString*)api refresh:(kRefreshType)type model:(Class)modelClass;

/**
 创建 navigationBar 的返回按钮
 */
- (UIButton *)makeBackButton;
- (void)backButtonClick:(UIButton *)sender;

- (UILabel *)makeTitleLabelWithTitle:(NSString *)title;


/**
 创建controller 的title 视图
 
 @param titleText title 文字
 
 @return 创建后的视图
 */
- (UIView *)addTitleViewWithTitle:(NSString *)titleText;


/**
 获取最顶部的 viewController
 
 @return 当前控制器的最顶层的 viewController
 */
- (UIViewController *)topViewController;

#pragma mark - 报错的AlertView
- (void)showError:(NSString*)str;

#pragma mark - 登录异常AlertView
- (void)showLoginAbnormalAlertView;

#pragma mark - 未登录的AlertView
- (void)showNoLoginAlertView;

#pragma mark - 透明指示层
/* *
 * 显示一个自定时间的,上图下文的
 * name 图片名字
 * time 显示时间
 * message 提示文字
 */
- (void)showImage:(NSString *)name time:(NSTimeInterval)time message:(NSString *)message;

/* *
 * 显示一个时间为1.5秒的,纯文字的
 * message 提示文字
 */
- (void)showMessage:(NSString *)message;

/* *
 * 显示一个自定时间的,纯文字的
 * message 提示文字
 * time 显示时间
 */
- (void)showMessage:(NSString *)message time:(NSTimeInterval)time;


/* *
 * 显示一个自定时间的,纯文字的,可自定父视图
 * message 提示文字
 * time 显示时间
 * view 父视图
 */
- (void)showMessage:(NSString *)message time:(NSTimeInterval)time view:(UIView *)view;

/* *
 * 显示一个时间为3秒的,菊花加载样式的,纯文字的,可自定父视图
 * message 提示文字
 */
- (void)showLoadding:(NSString *)message;

/* *
 * 显示一个自定时间的,菊花加载样式的,纯文字的
 * message 提示文字
 * time 显示时间
 */
- (void)showLoadding:(NSString *)message time:(NSTimeInterval)time;

/* *
 * 显示一个自定时间的,菊花加载样式的,纯文字的,可自定父视图
 * message 提示文字
 * time 显示时间
 * view 父视图
 */
- (void)showLoadding:(NSString *)message time:(NSTimeInterval)time view:(UIView *)view;

@end
