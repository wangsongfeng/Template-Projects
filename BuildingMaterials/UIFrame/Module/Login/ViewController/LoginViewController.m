//
//  LoginViewController.m
//  BuildingMaterials
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 刘志远. All rights reserved.
//

#import "LoginViewController.h"

#import "IQKeyboardManager.h"

//#import "RegisterViewController.h"
//#import "ForgetPassViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *bgImagView;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *passTextField;
@property (nonatomic, strong) UILabel *noPhoneLab;
@property (nonatomic, strong) UIButton *goRegisterBtn;
@property (nonatomic, strong) UIButton *forgetPassBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [self.phoneTextField endEditing:YES];
    [self.passTextField endEditing:YES];
}

#pragma mark -  nav back
- (void)backButtonClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    self.topView = [self addTitleViewWithTitle:@"登录"];
    self.lineView.backgroundColor = [UIColor clearColor];
    self.topView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 去注册
- (void)goRegisterButtonClick {
//    RegisterViewController *registerVC = [RegisterViewController new];
//    [self.navigationController pushViewController:registerVC animated:YES];
//    
//    registerVC.passTelNumBer = ^(NSString *telString) {
//        self.phoneTextField.text = telString;
//    };
}

#pragma mark - 忘记密码
- (void)forgetPassButtonClick {
//    ForgetPassViewController *forgetPassVC = [ForgetPassViewController new];
//    [self.navigationController pushViewController:forgetPassVC animated:YES];
//    
//    forgetPassVC.forgetPassTelNumber = ^(NSString *telString) {
//        self.phoneTextField.text = telString;
//    };
}

#pragma mark - 登录
- (void)loginButtonClick {
    [self.phoneTextField endEditing:YES];
    [self.passTextField endEditing:YES];
    
    if ([Utils isBlankString:self.phoneTextField.text] == YES) {
        [self showMessage:@"请输入您的手机号"];
        return;
    }
    
    if ([Utils checkTelNumber:self.phoneTextField.text] == NO) {
        [self showMessage:@"手机号格式不正确"];
        return;
    }
    
    if ([Utils isBlankString:self.passTextField.text] == YES) {
        [self showMessage:@"请输入登录密码"];
        return;
    }
    
    if (self.passTextField.text.length < 6 || self.passTextField.text.length > 12) {
        [self showMessage:@"登录失败!用户名或密码错误!"];
        return;
    }
    
    [self setParam:@"m_account" model:self.phoneTextField.text];
    [self setParam:@"m_password" model:self.passTextField.text];
    [self showLoadding:@"正在登录" time:20];
    [self loadDataApi:Login_Api
                block:^(NSInteger status, NSDictionary *modelData) {
                    
                    NSLog(@"登录 --- %@",modelData);
                    
                    if (status == Success_Status) {
                        
                        [self showMessage:@"登录成功"];
                        
                        //存入登录状态
                        NSUserDf_Set(kYesLogin, FCIsLogin);
                        //存入用户token
                        [UserInfo setAccessToken:modelData[@"data"][kToken]];
                        //存入用户基础信息
                        [UserInfo updateUserInfo:modelData[@"data"]];
                        
                        [self performSelector:@selector(SuccessBack) withObject:nil afterDelay:1.5];
                    }
                    else {
                        NSString *messageStr = modelData[@"message"];
                        if ([Utils isBlankString:messageStr] == NO) {
                            [self showMessage:messageStr];
                        }
                    }
                    
                }];
}

//请求成功后执行的事件
- (void)SuccessBack {
    
    if ([self.isNormalLogin isEqualToString:@"正常登陆"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSString *phoneOldStr = NSUserDf_Get(kUserPhone);//上次登录的手机号
        NSString *phoneNewStr = self.phoneTextField.text;//本次登录的手机号
        
        //如果 手机号为改变 那么 登陆后就返回上层控制器 如果改变 根据清空 就返回第一层控制器
        if ([phoneOldStr isEqualToString:phoneNewStr]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            //单独存入手机号 处理 异常登录 是否切换账号 而进行不同的处理方式
            NSUserDf_Set(self.phoneTextField.text,kUserPhone);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    self.loginSuccessClick(YES);//登录成功后刷新用户数据
}

#pragma mark--
#pragma mark           UITextFildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [self.view addSubview:self.bgImagView];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.passTextField];
    [self.view addSubview:self.noPhoneLab];
    [self.view addSubview:self.forgetPassBtn];
    [self.view addSubview:self.goRegisterBtn];
    [self.view addSubview:self.loginBtn];
    
    self.bgImagView.sd_layout
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
    self.phoneTextField.sd_layout
    .topSpaceToView(self.view, fJFScreen(190*2))
    .rightSpaceToView(self.view, fJFScreen(50*2))
    .leftSpaceToView(self.view, fJFScreen(50*2))
    .heightIs(fJFScreen(47*2));
    
    self.passTextField.sd_layout
    .topSpaceToView(self.phoneTextField, fJFScreen(24*2))
    .rightSpaceToView(self.view, fJFScreen(50*2))
    .leftSpaceToView(self.view, fJFScreen(50*2))
    .heightIs(fJFScreen(47*2));
    
    self.noPhoneLab.sd_layout
    .topSpaceToView(self.passTextField, fJFScreen(5*2))
    .leftSpaceToView(self.view, fJFScreen(50*2))
    .widthIs(fJFScreen(63*2))
    .heightIs(fJFScreen(20*2));
    
    self.goRegisterBtn.sd_layout
    .topSpaceToView(self.passTextField, fJFScreen(5*2))
    .leftSpaceToView(self.noPhoneLab, fJFScreen(3*2))
    .widthIs(fJFScreen(38*2))
    .heightIs(fJFScreen(20*2));
    
    self.forgetPassBtn.sd_layout
    .topSpaceToView(self.passTextField, fJFScreen(5*2))
    .rightSpaceToView(self.view, fJFScreen(50*2))
    .widthIs(fJFScreen(63*2))
    .heightIs(fJFScreen(20*2));
    
    self.loginBtn.sd_layout
    .topSpaceToView(self.noPhoneLab, fJFScreen(50*2))
    .rightSpaceToView(self.view, fJFScreen(50*2))
    .leftSpaceToView(self.view, fJFScreen(50*2))
    .heightIs(fJFScreen(47*2));
}

#pragma mark - 懒加载
- (UIImageView *)bgImagView {
    if (!_bgImagView) {
        _bgImagView = [UIImageView new];
        _bgImagView.image = [UIImage imageNamed:@"login_bg"];
        _bgImagView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImagView;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [UITextField new];
        _phoneTextField.placeholder = @"手机号";
        _phoneTextField.textAlignment = NSTextAlignmentCenter;
        _phoneTextField.backgroundColor = RGBA(246,246,246,0.8);
        _phoneTextField.font = [UIFont systemFontOfSize:fJFScreen(14*2)];
        _phoneTextField.textColor = Text_Color;
        _phoneTextField.delegate = self;
        _phoneTextField.clipsToBounds = YES;
        _phoneTextField.layer.cornerRadius = fJFScreen(3*2);
        _phoneTextField.returnKeyType = UIReturnKeyDone;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneTextField;
}

- (UITextField *)passTextField {
    if (!_passTextField) {
        _passTextField = [UITextField new];
        _passTextField.placeholder = @"密码";
        _passTextField.textAlignment = NSTextAlignmentCenter;
        _passTextField.backgroundColor = RGBA(246,246,246,0.8);
        _passTextField.font = [UIFont systemFontOfSize:fJFScreen(14*2)];
        _passTextField.textColor = Text_Color;
        _passTextField.delegate = self;
        _passTextField.clipsToBounds = YES;
        _passTextField.layer.cornerRadius = fJFScreen(3*2);
        _passTextField.secureTextEntry = YES;
        _passTextField.returnKeyType = UIReturnKeyDone;
        _passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _passTextField;
}

- (UILabel *)noPhoneLab {
    if (!_noPhoneLab) {
        _noPhoneLab = [UILabel new];
        _noPhoneLab.text = @"没有账号？";
        _noPhoneLab.textColor = Hui_Color;
        _noPhoneLab.font = [UIFont systemFontOfSize:fJFScreen(12*2)];
    }
    return _noPhoneLab;
}

- (UIButton *)goRegisterBtn {
    if (!_goRegisterBtn) {
        _goRegisterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        //下划线 设置
        NSMutableAttributedString *registerBtn = [[NSMutableAttributedString alloc] initWithString:@"去注册"];
        NSRange registerBtnRange = {0,[registerBtn length]};
        [registerBtn addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:registerBtnRange];
        [_goRegisterBtn setAttributedTitle:registerBtn forState:UIControlStateNormal];
        
        [_goRegisterBtn setTintColor:Main_Color];
        _goRegisterBtn.titleLabel.font = [UIFont systemFontOfSize:fJFScreen(12*2)];
        [_goRegisterBtn setTitleColor:Main_Color forState:UIControlStateNormal];
        [_goRegisterBtn addTarget:self action:@selector(goRegisterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goRegisterBtn;
}

- (UIButton *)forgetPassBtn {
    if (!_forgetPassBtn) {
        _forgetPassBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_forgetPassBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetPassBtn setTintColor:Hui_Color];
        _forgetPassBtn.titleLabel.font = [UIFont systemFontOfSize:fJFScreen(12*2)];
        [_forgetPassBtn setTitleColor:Hui_Color forState:UIControlStateNormal];
        [_forgetPassBtn addTarget:self action:@selector(forgetPassButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPassBtn;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginBtn.backgroundColor = RGBA(226, 28, 95, 0.8);
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTintColor:[UIColor whiteColor]];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:fJFScreen(16*2)];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.clipsToBounds = YES;
        _loginBtn.layer.cornerRadius = fJFScreen(47);
    }
    return _loginBtn;
}

@end
