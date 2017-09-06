//
//  ApiNetworkInterfaceMacro.h
//  BuildingMaterials
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 刘志远. All rights reserved.
//

#ifndef ApiNetworkInterfaceMacro_h
#define ApiNetworkInterfaceMacro_h

/********** 加载图片拼接宏 **************/
#define SetNSURLImage(urlstring) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Server_Int_Url,urlstring]]

/********** 网络请求状态码 **************/
#define Success_Status 1 //请求成功
#define Failure_Status 0 //请求失败
#define AbnormalLogin_State 9 //异常登录

/********** 通知标识符 **************/
//1.1 登陆后发送的通知  刷新当前页面的用户相关数据
#define RefreshAlreadyLoginStatus @"RefreshAlreadyLoginStatus"
//1.2 取消登录发送的通知 刷新当前页面的登录状态
#define RefreshNoLoginStatus @"RefreshNoLoginStatus"

/*********  公共前缀 api接口  ********/
// 测试地址
//#define Server_Web_Url @""//Web接口地址
#define Server_Int_Url @"http://jcshop.tangchaoke.com/index.php/Api/"//IP接口地址

//// 正式地址
//#define Server_Web_Url @"" //Web接口地址
//#define Server_Int_Url @"" //IP接口地址

/*********  [用户模块] api接口  ********/

//1.1 发送验证码 register:注册发送验证码,retrieve:忘记密码
#define Send_Verify_Api @"Login/send_verify"
//1.2 注册
#define Register_Api @"Login/register"
//1.3 登录
#define Login_Api @"Login/login"
//1.4 退出登录 - 此接口没有调,暂时用不到
#define Logout_Api @"Login/logout"
//1.5 个人信息
#define User_Base_Data_Api @"Member/user_base_data"
//1.6 修改头像
#define Edit_Base_Data_Api @"Member/edit_base_data"
//1.7 修改昵称
#define Edit_Base_Name_Api @"Member/edit_base_name"
//1.8 我的余额
#define Member_Balance_Api @"Member/member_balance"
//1.9 修改密码（第一步）
#define Modify_Passwd_Step1_Api @"Member/modify_passwd_step1"
//2.0 修改密码（第二步）
#define Modify_Passwd_Step2_Api @"Member/modify_passwd_step2"
//2.1 忘记密码
#define Reset_Passwd_Step1_Api @"Login/reset_passwd_step1"
//2.2 意见反馈
#define Feedback_Add_Api @"FeedBack/feedback_add"
//2.3 用户提现
#define Withdraw_Api @"Member/withdraw"
//2.4 充值 - 此接口还没有
//#define _Api @""
//2.5 收支记录
#define Withdraw_Record_Api @"Member/withdraw_record"

///*********  [地址模块] api接口  ********/

//3.1 收货地址列表
#define Address_List_Api @"Address/address_list"
//3.2 新增收货地址
#define Address_Add_Api @"Address/address_add"
//3.3 地址详情 - 此接口没有调,暂时用不到
#define Address_Info_Api @"Address/address_info"
//3.4 修改收货地址（需要先调用3.3接口展示数据）
#define Address_Edit_Api @"Address/address_edit"
//3.5 删除地址信息
#define Address_Del_Api @"Address/address_del"
//3.6 设置默认地址
#define Address_Is_Default_Api @"Address/is_default"


#endif /* ApiNetworkInterfaceMacro_h */
