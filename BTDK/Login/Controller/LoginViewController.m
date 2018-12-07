//
//  LoginViewController.m
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/27.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "QuickLoginViewController.h"
#import "RetrievePasswordViewController.h"

@interface LoginViewController()

Strong UITextField *phoneInput;
Strong UITextField *passwordInput;
Strong UIButton *loginBtn;
Copy LoginSuccessBlock successBlock;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBarHidden];
    [self configStatusBarLight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithSuccessBlock:(LoginSuccessBlock)successBlock {
    self = [super init];
    if (self) {
        self.successBlock = successBlock;
    }
    return self;
}

- (void)configViews {
    UIImageView *backView = [[UIImageView alloc] init];
    backView.contentMode = UIViewContentModeScaleAspectFill;
    backView.clipsToBounds = YES;
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    backView.image = BTDKImage(@"bg");
    backView.frame = self.view.bounds;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"注册"];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:15.0f] range:NSMakeRange(0, 2)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] range:NSMakeRange(0, 2)];
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setAttributedTitle:attributedString forState:normal];
    [self.view addSubview:registerBtn];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(TopBarHeight-44+15);
        make.right.equalTo(self.view).with.offset(-19);
        make.size.mas_offset(CGSizeMake(40, 20));
    }];
    
    UIImageView *mainTitImg = [[UIImageView alloc]init];
    mainTitImg.image = BTDKImage(@"btdk");
    [self.view addSubview:mainTitImg];
    [mainTitImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(registerBtn.mas_bottom).with.offset(84);
    }];
    
    UIView *loginView = [[UIView alloc]init];
    loginView.backgroundColor = [UIColor colorWithHexString:@"#41a5ff" alpha:0.8];
    loginView.layer.cornerRadius = 8;
    loginView.clipsToBounds = YES;
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mainTitImg);
        make.top.equalTo(mainTitImg.mas_bottom).with.offset(60);
        make.size.mas_offset(CGSizeMake(ScreenWidth-60, 136));
    }];
    
    UIImageView *lineImgView = [[UIImageView alloc]init];
    lineImgView.image = BTDKImage(@"xt");
    [self.view addSubview:lineImgView];
    [lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loginView);
        make.left.equalTo(loginView);
        make.width.equalTo(loginView);
        make.height.mas_offset(@1);
    }];
    
    UITextField *account = [[UITextField alloc]init];
    account.textAlignment = NSTextAlignmentLeft;
    account.placeholder = @"请输入手机号码";
    account.placeholderColor = BTDKHexColor(@"#ffffff");
    account.textColor = BTDKHexColor(@"#ffffff");
    self.phoneInput = account;
    account.keyboardType = UIKeyboardTypeNumberPad;
    [loginView addSubview:account];
    [account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView).with.offset(14);
        make.top.equalTo(loginView).with.offset(26);
        make.width.equalTo(loginView);
    }];
    
    UITextField *password = [[UITextField alloc]init];
    password.textAlignment = NSTextAlignmentLeft;
    password.placeholder = @"请输入登录密码";
    password.placeholderColor = BTDKHexColor(@"#ffffff");
    password.textColor = BTDKHexColor(@"#ffffff");
    [loginView addSubview:password];
    password.secureTextEntry = YES;
    self.passwordInput = password;
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView).with.offset(14);
        make.top.equalTo(lineImgView).with.offset(26);
        make.width.equalTo(loginView);
    }];
    
    
    NSMutableAttributedString *loginString = [[NSMutableAttributedString alloc] initWithString:@"登 录"];
    [loginString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:18.0f] range:NSMakeRange(0, 3)];
    [loginString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0f/255.0f green:111.0f/255.0f blue:211.0f/255.0f alpha:1.0f] range:NSMakeRange(0, 3)];
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setAttributedTitle:loginString forState:normal];
    [loginBtn setBackgroundColor:BTDKHexColor(@"#ffffff")];
    loginBtn.layer.cornerRadius = 8;
    loginBtn.clipsToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(loginView.mas_bottom).with.offset(40);
        make.width.equalTo(loginView);
        make.height.mas_offset(@45);
        make.left.equalTo(loginView);
    }];
    
    UIButton *quickLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [quickLogin setTitle:@"快捷登录" forState:normal];
    quickLogin.backgroundColor = [UIColor clearColor];
    quickLogin.titleLabel.font = BTDKFont(12);
    [self.view addSubview:quickLogin];
    [quickLogin addTarget:self action:@selector(quickLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [quickLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).with.offset(17);
    }];
    
    UIButton *retrievePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [retrievePassword setTitle:@"找回密码" forState:normal];
    retrievePassword.backgroundColor = [UIColor clearColor];
    retrievePassword.titleLabel.font = BTDKFont(12);
    [self.view addSubview:retrievePassword];
    [retrievePassword addTarget:self action:@selector(retrievePasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [retrievePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(quickLogin);
        make.right.equalTo(loginBtn);
    }];
    
}

- (void)registerBtnClick {
    RegisterViewController *reg = [[RegisterViewController alloc]initWithSuccessBlock:^{
        self.successBlock();
    }];
    [self.navigationController pushViewController:reg animated:YES];
}

- (void)loginBtnClick {
    [self onLoginBtnClick];
}

- (void)quickLoginClick {
    QuickLoginViewController *quickVC = [[QuickLoginViewController alloc]initWithSuccessBlock:^{
        self.successBlock();
    }];
    [self.navigationController pushViewController:quickVC animated:YES];
}

- (void)retrievePasswordClick {
    RetrievePasswordViewController *RPVC = [[RetrievePasswordViewController alloc]init];
    [self.navigationController pushViewController:RPVC animated:YES];
}

- (void)onLoginBtnClick {
    
    if(NULLString(self.phoneInput.text) || NULLString(self.passwordInput.text)) {
        [UIView hudWithMessage:@"账号或密码为空"];
        return;
    }
    
    NSDictionary *param = @{@"phone":self.phoneInput.text, @"password":self.passwordInput.text};
    [ApiManager requestWithTpye:nil path:s1_clientUser_login parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            [[NSUserDefaults standardUserDefaults] setObject:response[ResponseData] forKey:UserData_CacheKey];

            [self loginPoint];
            [BTDKHandle shareHandle].isLogin = YES;
            [BTDKHandle shareHandle].userId = response[ResponseData][@"userId"];
            [BTDKHandle shareHandle].phone = response[ResponseData][@"account"];
            [BTDKHandle shareHandle].userName = response[ResponseData][@"userName"];
            if (self.successBlock) {
                self.successBlock();
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
        } else {
            [UIView hudWithMessage:BTDKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView hudWithMessage:BTDKString(@"%@", error.domain)];
    }];
}

- (void)loginPoint {
    NSString *userId = [BTDKHandle shareHandle].userId;
    NSDictionary *param = @{@"userId":userId,@"action":@"password.login.button"};
    [ApiManager requestWithTpye:nil path:s1_action_save parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
