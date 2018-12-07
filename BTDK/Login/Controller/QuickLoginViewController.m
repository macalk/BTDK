//
//  QuickLoginViewController.m
//  BTDK
//
//  Created by xiaoning on 2018/12/4.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "QuickLoginViewController.h"
#import "RegisterViewController.h"

@interface QuickLoginViewController ()

Strong UITextField *phoneInput;
Strong UITextField *codeInput;
Strong UIButton *sendSMSBtn;
Strong UIButton *loginBtn;
Assign BOOL hasPhoneInput;
Assign BOOL hasCodeInput;
Strong dispatch_source_t timer;
Assign NSInteger time;
Copy LoginSuccessBlock successBlock;

@end

@implementation QuickLoginViewController

- (instancetype)initWithSuccessBlock:(LoginSuccessBlock)successBlock {
    self = [super init];
    if (self) {
        self.successBlock = successBlock;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.time = 60;
    [self configViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configLeftBarButtonWithImage:@"return" Title:nil];
    [self configNavigationBarImage:[UIImage new]];
    [self configNavigationBarShadow:[UIImage new]];
    [self configNavigationBarHidden];
    [self configStatusBarLight];
}

- (void)configViews {
    UIImageView *backView = [[UIImageView alloc] init];
    backView.contentMode = UIViewContentModeScaleAspectFill;
    backView.clipsToBounds = YES;
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    backView.image = BTDKImage(@"bg");
    backView.frame = self.view.bounds;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(19, TopBarHeight-44+10, 40, 40);
    [deleteBtn setImage:BTDKImage(@"return") forState:normal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
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
    
    UIButton *sendSMSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSMSBtn.titleLabel.font = BTDKFont(12);
    [sendSMSBtn setTitleColor:BTDKHexColor(@"#FFFFFF") forState:UIControlStateNormal];
    [sendSMSBtn addTarget:self action:@selector(sendSMSBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sendSMSBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendSMSBtn setBackgroundColor:BTDKHexColor(@"#67b6ff")];
    sendSMSBtn.layer.cornerRadius = 16;
    sendSMSBtn.clipsToBounds = YES;
    self.sendSMSBtn = sendSMSBtn;
    [loginView addSubview:self.sendSMSBtn];
    [sendSMSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginView).with.offset(-5);
        make.top.equalTo(lineImgView.mas_bottom).with.offset(15);
        make.size.mas_offset(CGSizeMake(97, 33));
    }];
    
    UITextField *code = [[UITextField alloc]init];
    code.textAlignment = NSTextAlignmentLeft;
    code.placeholder = @"请输入验证码";
    code.placeholderColor = BTDKHexColor(@"#ffffff");
    code.textColor = BTDKHexColor(@"#ffffff");
    self.codeInput = code;
    code.keyboardType = UIKeyboardTypeNumberPad;
    [loginView addSubview:code];
    [code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(account);
        make.centerY.equalTo(sendSMSBtn);
        make.right.equalTo(sendSMSBtn.mas_left);
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
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(loginView.mas_bottom).with.offset(40);
        make.width.equalTo(loginView);
        make.height.mas_offset(@45);
        make.left.equalTo(loginView);
    }];
    
    UIButton *passwordLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [passwordLogin setTitle:@"密码登录" forState:normal];
    passwordLogin.backgroundColor = [UIColor clearColor];
    passwordLogin.titleLabel.font = BTDKFont(12);
    [self.view addSubview:passwordLogin];
    [passwordLogin addTarget:self action:@selector(passwordLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [passwordLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).with.offset(17);
    }];
    
    
}

- (void)deleteBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerBtnClick {
    RegisterViewController *reg = [[RegisterViewController alloc]initWithSuccessBlock:^{
        self.successBlock();
    }];
    [self.navigationController pushViewController:reg animated:YES];
}

- (void)sendSMSBtnClick {
    [self onSendSMSBtnClick];
}

- (void)loginBtnClick {
    [self onLoginBtnClick];
}

- (void)passwordLoginClick {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)onSendSMSBtnClick {
    
    if (self.phoneInput.text.length != 11) {
        [UIView hudWithMessage:@"请输入正确的手机号码"];
        return;
    }
    
    NSDictionary *param = @{@"phone":self.phoneInput.text, @"type":@(2)};
    [ApiManager requestWithTpye:nil path:s1_sms_sendSms parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            [self fireTimer];
        } else {
            [UIView hudWithMessage:BTDKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView hudWithMessage:BTDKString(@"%@", error.domain)];
    }];
}

- (void)onLoginBtnClick {
    
    if (NULLString(self.phoneInput.text) || NULLString(self.codeInput.text)) {
        [UIView hudWithMessage:@"账号或验证码为空"];
        return;
    }
    
    NSDictionary *param = @{@"phone":self.phoneInput.text, @"code":self.codeInput.text};
    [ApiManager requestWithTpye:nil path:s1_clientUser_smsLogin_app parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            [[NSUserDefaults standardUserDefaults] setObject:response[ResponseData] forKey:UserData_CacheKey];
            [BTDKHandle shareHandle].isLogin = YES;
            [BTDKHandle shareHandle].userId = response[ResponseData][@"userId"];
            [BTDKHandle shareHandle].phone = response[ResponseData][@"account"];
            [BTDKHandle shareHandle].userName = response[ResponseData][@"userName"];
            if (self.successBlock) {
                self.successBlock();
            }
            [self loginPoint];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
        } else {
            [UIView hudWithMessage:BTDKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView hudWithMessage:BTDKString(@"%@", error.domain)];
    }];
}

- (void)fireTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (self.time > 0) {
                self.sendSMSBtn.enabled = NO;
                [self.sendSMSBtn setTitle:BTDKString(@"%02zds", self.time) forState:UIControlStateNormal];
                self.time--;
            } else {
                self.time = 0;
                self.sendSMSBtn.enabled = YES;
                [self.sendSMSBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                dispatch_source_cancel(self.timer);
            }
        });
    });
    dispatch_resume(self.timer);
}

- (void)loginPoint {
    NSString *userId = [BTDKHandle shareHandle].userId;
    NSDictionary *param = @{@"userId":userId,@"action":@"sms.login.button"};
    [ApiManager requestWithTpye:nil path:s1_action_save parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
