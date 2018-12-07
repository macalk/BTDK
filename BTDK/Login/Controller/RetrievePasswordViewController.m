//
//  RetrievePasswordViewController.m
//  BTDK
//
//  Created by xiaoning on 2018/12/4.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "RetrievePasswordViewController.h"
#import "ResetPasswordViewController.h"

@interface RetrievePasswordViewController ()

Strong UITextField *phoneInput;
Strong UITextField *codeInput;
Strong dispatch_source_t timer;
Assign NSInteger time;
Strong UIButton *sendSMSBtn;


@end

@implementation RetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    
    self.time = 60;
    self.navigationItem.title = @"验证手机";
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
    
    UIImageView *shieldImg = [[UIImageView alloc]initWithImage:BTDKImage(@"validation")];
    [self.view addSubview:shieldImg];
    [shieldImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImg);
        make.bottom.equalTo(topImg.mas_bottom).with.offset(-31);
        make.size.mas_offset(CGSizeMake(78, 89));
    }];
    
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:BTDKImage(@"icon1")];
    [self.view addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(32);
        make.top.equalTo(topImg.mas_bottom).with.offset(40);
        make.size.mas_offset(CGSizeMake(14, 22));
    }];
    
    UITextField *account = [[UITextField alloc]init];
    account.textAlignment = NSTextAlignmentLeft;
    account.placeholder = @"请输入手机号码";
    account.placeholderColor = BTDKHexColor(@"#a6a6a6");
    account.textColor = BTDKHexColor(@"#a6a6a6");
    account.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneInput = account;
    [self.view addSubview:account];
    [account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneIcon.mas_right).with.offset(16);
        make.right.equalTo(self.view).with.offset(-22);
        make.centerY.equalTo(phoneIcon);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BTDKHexColor(@"#cdcdcd");
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(22);
        make.right.equalTo(self.view).with.offset(-22);
        make.top.equalTo(phoneIcon.mas_bottom).with.offset(12);
        make.height.mas_offset(@1);
    }];
    
    UIButton *sendSMSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSMSBtn.titleLabel.font = BTDKFont(12);
    [sendSMSBtn setTitleColor:BTDKHexColor(@"#a6a6a6") forState:UIControlStateNormal];
    [sendSMSBtn addTarget:self action:@selector(sendSMSBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sendSMSBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    sendSMSBtn.layer.cornerRadius = 11.8;
    sendSMSBtn.layer.borderColor = [BTDKHexColor(@"#6c6c6c") CGColor];
    sendSMSBtn.layer.borderWidth = 0.5;
    self.sendSMSBtn = sendSMSBtn;
    [self.view addSubview:sendSMSBtn];
    [sendSMSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView).with.offset(-3);
        make.top.equalTo(lineView.mas_bottom).with.offset(32);
        make.size.mas_offset(CGSizeMake(76, 24));
    }];
    
    UIImageView *codeIcon = [[UIImageView alloc]initWithImage:BTDKImage(@"icon2")];
    [self.view addSubview:codeIcon];
    [codeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneIcon);
        make.centerY.equalTo(sendSMSBtn);
        make.size.mas_offset(CGSizeMake(18, 20));
    }];
    
    UITextField *code = [[UITextField alloc]init];
    code.textAlignment = NSTextAlignmentLeft;
    code.placeholder = @"请输入验证码";
    code.placeholderColor = BTDKHexColor(@"#a6a6a6");
    code.textColor = BTDKHexColor(@"#a6a6a6");
    code.keyboardType = UIKeyboardTypeNumberPad;
    self.codeInput = code;
    [self.view addSubview:code];
    [code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(account);
        make.centerY.equalTo(sendSMSBtn);
        make.right.equalTo(sendSMSBtn.mas_left);
    }];
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = BTDKHexColor(@"#cdcdcd");
    [self.view addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(22);
        make.right.equalTo(self.view).with.offset(-22);
        make.top.equalTo(codeIcon.mas_bottom).with.offset(12);
        make.height.mas_offset(@1);
    }];
    
    
    NSMutableAttributedString *nextString = [[NSMutableAttributedString alloc] initWithString:@"下 一 步"];
    [nextString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:18.0f] range:NSMakeRange(0, 5)];
    [nextString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] range:NSMakeRange(0, 5)];
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

- (void)sendSMSBtnClick {
    [self onSendSMSBtnClick];
}

- (void)nextBtnClick {
    [self onNextBtnClick];
}


- (void)onSendSMSBtnClick {
    if (self.phoneInput.text.length != 11) {
        [UIView hudWithMessage:@"请输入正确的手机号码"];
        return;
    }
    
    NSDictionary *param = @{@"phone":self.phoneInput.text, @"type":@(0)};
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

- (void)onNextBtnClick {
    if (self.phoneInput.text.length != 11) {
        [UIView hudWithMessage:@"请输入正确的手机号码"];
        return;
    }else if (self.codeInput.text.length != 4) {
        [UIView hudWithMessage:@"请输入正确的验证码"];
        return;
    }
    
    NSDictionary *param = @{@"phone":self.phoneInput.text, @"type":@(0),@"code":self.codeInput.text};
    [ApiManager requestWithTpye:nil path:s1_sms_checkCode parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            ResetPasswordViewController *resetVC = [[ResetPasswordViewController alloc]init];
            resetVC.phone = self.phoneInput.text;
            [self.navigationController pushViewController:resetVC animated:YES];
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

@end
