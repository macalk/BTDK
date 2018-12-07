//
//  RegisterViewController.m
//  BTDK
//
//  Created by xiaoning on 2018/12/4.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "RegisterViewController.h"
#import "BaseWebViewController.h"

@interface RegisterViewController()

Strong UITextField *phoneInput;
Strong UITextField *codeInput;
Strong UITextField *passwordInput;
Strong UIButton *sendSMSBtn;
Strong UIButton *registerBtn;
Assign BOOL hasPhoneInput;
Assign BOOL hasCodeInput;
Assign BOOL hasPasswordInput;
Strong dispatch_source_t timer;
Assign NSInteger time;
Copy LoginSuccessBlock successBlock;

@end

@implementation RegisterViewController

- (instancetype)initWithSuccessBlock:(LoginSuccessBlock)successBlock {
    self = [super init];
    if (self) {
        self.successBlock = successBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDefaultData];
    [self configViews];
    NSLog(@"viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configLeftBarButtonWithImage:@"return" Title:nil];
    [self configNavigationBarImage:[UIImage new]];
    [self configNavigationBarShadow:[UIImage new]];
    [self configNavigationBarHidden];
    [self configStatusBarLight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configDefaultData {
    self.time = 60;
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
    
    UIImageView *mainTitImg = [[UIImageView alloc]init];
    mainTitImg.image = BTDKImage(@"btdk");
    [self.view addSubview:mainTitImg];
    [mainTitImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(deleteBtn.mas_bottom).with.offset(84);
    }];
    
    UIView *registerView = [[UIView alloc]init];
    registerView.backgroundColor = [UIColor colorWithHexString:@"#41a5ff" alpha:0.8];
    registerView.layer.cornerRadius = 8;
    registerView.clipsToBounds = YES;
    [self.view addSubview:registerView];
    [registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mainTitImg);
        make.top.equalTo(mainTitImg.mas_bottom).with.offset(60);
        make.size.mas_offset(CGSizeMake(ScreenWidth-60, 188));
    }];
    
    UIImageView *topLineImgView = [[UIImageView alloc]init];
    topLineImgView.image = BTDKImage(@"xt");
    [self.view addSubview:topLineImgView];
    [topLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerView).with.offset(62);
        make.left.equalTo(registerView);
        make.width.equalTo(registerView);
        make.height.mas_offset(@1);
    }];
    
    UIImageView *centerLineImgView = [[UIImageView alloc]init];
    centerLineImgView.image = BTDKImage(@"xt");
    [self.view addSubview:centerLineImgView];
    [centerLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineImgView.mas_bottom).with.offset(62);
        make.left.equalTo(registerView);
        make.width.equalTo(registerView);
        make.height.mas_offset(@1);
    }];
    
    UITextField *account = [[UITextField alloc]init];
    account.textAlignment = NSTextAlignmentLeft;
    account.placeholder = @"请输入手机号码";
    account.placeholderColor = BTDKHexColor(@"#ffffff");
    account.textColor = BTDKHexColor(@"#ffffff");
    self.phoneInput = account;
    account.keyboardType = UIKeyboardTypeNumberPad;
    [registerView addSubview:account];
    [account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerView).with.offset(14);
        make.top.equalTo(registerView).with.offset(26);
        make.width.equalTo(registerView);
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
    [registerView addSubview:self.sendSMSBtn];
    [sendSMSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(registerView).with.offset(-5);
        make.top.equalTo(topLineImgView.mas_bottom).with.offset(15);
        make.size.mas_offset(CGSizeMake(97, 33));
    }];
    
    UITextField *code = [[UITextField alloc]init];
    code.textAlignment = NSTextAlignmentLeft;
    code.placeholder = @"请输入验证码";
    code.placeholderColor = BTDKHexColor(@"#ffffff");
    code.textColor = BTDKHexColor(@"#ffffff");
    self.codeInput = code;
    code.keyboardType = UIKeyboardTypeNumberPad;
    [registerView addSubview:code];
    [code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(account);
        make.centerY.equalTo(sendSMSBtn);
        make.right.equalTo(sendSMSBtn.mas_left);
    }];
    
    
    UITextField *password = [[UITextField alloc]init];
    password.textAlignment = NSTextAlignmentLeft;
    password.placeholder = @"请输入登录密码";
    password.placeholderColor = BTDKHexColor(@"#ffffff");
    password.textColor = BTDKHexColor(@"#ffffff");
    password.secureTextEntry = YES;
    [registerView addSubview:password];
    self.passwordInput = password;
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerView).with.offset(14);
        make.top.equalTo(centerLineImgView.mas_bottom).with.offset(26);
        make.width.equalTo(registerView);
    }];
    
    
    NSMutableAttributedString *registerString = [[NSMutableAttributedString alloc] initWithString:@"立 即 注 册"];
    [registerString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:18.0f] range:NSMakeRange(0, 7)];
    [registerString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0f/255.0f green:111.0f/255.0f blue:211.0f/255.0f alpha:1.0f] range:NSMakeRange(0, 7)];
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setAttributedTitle:registerString forState:normal];
    [registerBtn setBackgroundColor:BTDKHexColor(@"#ffffff")];
    registerBtn.layer.cornerRadius = 8;
    registerBtn.clipsToBounds = YES;
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn = registerBtn;
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(registerView.mas_bottom).with.offset(40);
        make.width.equalTo(registerView);
        make.height.mas_offset(@45);
        make.left.equalTo(registerView);
    }];
    
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.titleLabel.font = BTDKFont(12);
    [protocolBtn setTitleColor:BTDKHexColor(@"#ededed") forState:UIControlStateNormal];
    [protocolBtn setTitle:@"点击“注册”按钮，代表您已同意《白条贷款用户服务协议》" forState:normal];
    [protocolBtn addTarget:self action:@selector(onProtocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protocolBtn];
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(registerBtn);
        make.top.equalTo(registerBtn.mas_bottom).with.offset(10);
    }];
    
}

- (void)deleteBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendSMSBtnClick {
    [self onSendSMSBtnClick];
}

- (void)registerBtnClick {
    [self onRegisterBtnClick];
}

- (void)onProtocolBtnClick {
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.url = [BTDKTool getHTMLWithPath:RegisterProtocol_HTMLUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)onSendSMSBtnClick {
    
    if (self.phoneInput.text.length != 11) {
        [UIView hudWithMessage:@"请输入正确的手机号码"];
        return;
    }
    
    NSDictionary *param = @{@"phone":self.phoneInput.text, @"type":@(1)};
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

- (void)onRegisterBtnClick {
    
    if (NULLString(self.phoneInput.text) || NULLString(self.codeInput.text) || NULLString(self.passwordInput.text)) {
        [UIView hudWithMessage:@"账号或验证码或密码不能为空"];
        return;
    }
    
    NSDictionary *param = @{@"phone":self.phoneInput.text, @"code":self.codeInput.text,@"password":self.passwordInput.text};
    [ApiManager requestWithTpye:nil path:s1_clientUser_register_app parameters:param success:^(NSURLSessionDataTask *task, id response) {
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
    NSDictionary *param = @{@"userId":userId,@"action":@"register.login.button"};
    [ApiManager requestWithTpye:nil path:s1_action_save parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}



@end
