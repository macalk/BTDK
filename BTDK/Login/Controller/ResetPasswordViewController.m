//
//  ResetPasswordViewController.m
//  BTDK
//
//  Created by xiaoning on 2018/12/4.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

Strong UITextField *passwordInput;
Strong UITextField *rPasswordInput;


@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    
    self.navigationItem.title = @"设置新密码";
    [self configNavigationBarTitleWithColor:BTDKHexColor(@"#ffffff")];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBarShow];
    [self configLeftBarButtonWithImage:@"return" Title:nil];
    [self configNavigationBarImage:[UIImage new]];
    [self configNavigationBarShadow:[UIImage new]];
    [self configStatusBarLight];
}

- (void)configView {
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = BTDKHexColor(@"#14a0ff");
    topView.frame = CGRectMake(0, 0, ScreenWidth, StatusBarHeight);
    [self.view addSubview:topView];
    
    UIImageView *topImg = [[UIImageView alloc]initWithImage:BTDKImage(@"jx")];
    [self.view addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.width.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(@175);
    }];
    
    UIImageView *shieldImg = [[UIImageView alloc]initWithImage:BTDKImage(@"password")];
    [self.view addSubview:shieldImg];
    [shieldImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImg);
        make.bottom.equalTo(topImg.mas_bottom).with.offset(-31);
        make.size.mas_offset(CGSizeMake(78, 89));
    }];
    
    UIImageView *passwordIcon = [[UIImageView alloc]initWithImage:BTDKImage(@"icon3")];
    [self.view addSubview:passwordIcon];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(32);
        make.top.equalTo(topImg.mas_bottom).with.offset(40);
        make.size.mas_offset(CGSizeMake(16, 19));
    }];
    
    UITextField *password = [[UITextField alloc]init];
    password.textAlignment = NSTextAlignmentLeft;
    password.placeholder = @"请输入新密码";
    password.placeholderColor = BTDKHexColor(@"#a6a6a6");
    password.textColor = BTDKHexColor(@"#a6a6a6");
    password.secureTextEntry = YES;
    self.passwordInput = password;
    [self.view addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordIcon.mas_right).with.offset(16);
        make.right.equalTo(self.view).with.offset(-22);
        make.centerY.equalTo(passwordIcon);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BTDKHexColor(@"#cdcdcd");
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(22);
        make.right.equalTo(self.view).with.offset(-22);
        make.top.equalTo(password.mas_bottom).with.offset(12);
        make.height.mas_offset(@1);
    }];
    
    UIImageView *rPasswordIcon = [[UIImageView alloc]initWithImage:BTDKImage(@"icon4")];
    [self.view addSubview:rPasswordIcon];
    [rPasswordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordIcon);
        make.top.equalTo(lineView.mas_bottom).with.offset(36);
        make.size.mas_offset(CGSizeMake(16, 19));
    }];
    
    UITextField *rPassword = [[UITextField alloc]init];
    rPassword.textAlignment = NSTextAlignmentLeft;
    rPassword.placeholder = @"请再次输入新密码";
    rPassword.placeholderColor = BTDKHexColor(@"#a6a6a6");
    rPassword.textColor = BTDKHexColor(@"#a6a6a6");
    rPassword.secureTextEntry = YES;
    self.rPasswordInput = rPassword;
    [self.view addSubview:rPassword];
    [rPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(password);
        make.centerY.equalTo(rPasswordIcon);
        make.width.equalTo(password);
    }];
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = BTDKHexColor(@"#cdcdcd");
    [self.view addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(22);
        make.right.equalTo(self.view).with.offset(-22);
        make.top.equalTo(rPasswordIcon.mas_bottom).with.offset(12);
        make.height.mas_offset(@1);
    }];
    
    
    NSMutableAttributedString *nextString = [[NSMutableAttributedString alloc] initWithString:@"完 成"];
    [nextString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:18.0f] range:NSMakeRange(0, 3)];
    [nextString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] range:NSMakeRange(0, 3)];
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:BTDKImage(@"jx") forState:normal];
    [nextBtn setAttributedTitle:nextString forState:normal];
    nextBtn.layer.cornerRadius = 4;
    nextBtn.clipsToBounds = YES;
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-62);
        make.size.mas_offset(CGSizeMake(ScreenWidth-60, 45));
    }];
    
}

- (void)nextBtnClick {
    if (![self.passwordInput.text isEqualToString:self.rPasswordInput.text]) {
        [UIView hudWithMessage:@"密码输入不一致"];
        return;
    }
    [self onNextBtnClick];
}
- (void)onNextBtnClick {
    
    NSDictionary *param = @{@"phone":self.phone, @"password":self.passwordInput.text,@"confirmPassword":self.rPasswordInput.text};
    [ApiManager requestWithTpye:nil path:s1_clientUser_updatePassword parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
            [UIView hudWithMessage:BTDKString(@"%@", response[ResponseMessage])];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView hudWithMessage:BTDKString(@"%@", error.domain)];
    }];

}

@end
