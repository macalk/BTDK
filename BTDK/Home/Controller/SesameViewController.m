//
//  SesameViewController.m
//  BTDK
//
//  Created by xiaoning on 2018/12/5.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "SesameViewController.h"

@interface SesameViewController ()

Strong UITextField *sesame;


@end

@implementation SesameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    
    self.navigationItem.title = @"芝麻分";
    [self configNavigationBarTitleWithColor:BTDKHexColor(@"#ffffff")];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configStatusBarLight];
    [self configNavigationBarShow];
    [self configLeftBarButtonWithImage:@"return" Title:nil];
    [self configNavigationBarImage:[UIImage new]];
    [self configNavigationBarShadow:[UIImage new]];
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
    
    UIImageView *shieldImg = [[UIImageView alloc]initWithImage:BTDKImage(@"1233")];
    [self.view addSubview:shieldImg];
    [shieldImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).with.offset(80);
        make.width.mas_offset(ScreenWidth-60);
        make.left.equalTo(self.view).with.offset(30);
        make.height.mas_equalTo(shieldImg.mas_width).multipliedBy(0.08);
    }];
    
    UILabel *peopleLabel = [[UILabel alloc]init];
    peopleLabel.textAlignment = NSTextAlignmentCenter;
    peopleLabel.text = @"紧急联系人";
    peopleLabel.textColor = BTDKHexColor(@"#ffffff");
    peopleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:peopleLabel];
    [peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(shieldImg.mas_bottom).with.offset(15);
    }];
    
    UILabel *idCardLabel = [[UILabel alloc]init];
    idCardLabel.textAlignment = NSTextAlignmentCenter;
    idCardLabel.text = @"身份验证";
    idCardLabel.textColor = BTDKHexColor(@"#ffffff");
    idCardLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:idCardLabel];
    [idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(peopleLabel);
        make.left.equalTo(shieldImg).with.offset(-25+shieldImg.height/2);
        make.size.mas_offset(CGSizeMake(50, 12));
    }];
    
    UILabel *sesameLabel = [[UILabel alloc]init];
    sesameLabel.textAlignment = NSTextAlignmentCenter;
    sesameLabel.text = @"芝麻分";
    sesameLabel.textColor = BTDKHexColor(@"#ffffff");
    sesameLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:sesameLabel];
    [sesameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(peopleLabel);
        make.right.equalTo(shieldImg).with.offset(20-shieldImg.height/2);
        make.size.mas_offset(CGSizeMake(40, 12));
    }];
    
    UIImageView *sesameImg = [[UIImageView alloc]initWithImage:BTDKImage(@"zhima")];
    [self.view addSubview:sesameImg];
    [sesameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImg.mas_bottom).with.offset(52);
        make.centerX.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(86, 116));
    }];
    
    UIImageView *sesameIcon = [[UIImageView alloc]initWithImage:BTDKImage(@"Sesamepoints")];
    [self.view addSubview:sesameIcon];
    [sesameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(30);
        make.top.equalTo(sesameImg.mas_bottom).with.offset(56);
        make.size.mas_offset(CGSizeMake(20, 23));
    }];
    
    UITextField *sesame = [[UITextField alloc]init];
    sesame.textAlignment = NSTextAlignmentLeft;
    sesame.placeholder = @"请填写你的芝麻分";
    sesame.keyboardType = UIKeyboardTypeNumberPad;
    sesame.font = BTDKFont(12);
    sesame.placeholderColor = BTDKHexColor(@"#a6a6a6");
    sesame.textColor = BTDKHexColor(@"#a6a6a6");
    self.sesame = sesame;
    [self.view addSubview:sesame];
    [sesame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sesameIcon.mas_right).with.offset(13);
        make.centerY.equalTo(sesameIcon);
        make.width.mas_offset(@100);
    }];
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = BTDKHexColor(@"#cdcdcd");
    [self.view addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(22);
        make.right.equalTo(self.view).with.offset(-22);
        make.top.equalTo(sesameIcon.mas_bottom).with.offset(12);
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
    
    if (NULLString(self.sesame.text)) {
        [UIView hudWithMessage:@"请填写您的芝麻分"];
        return;
    }
    
    NSString *userId = [BTDKHandle shareHandle].userId;
    NSDictionary *param = @{@"userId":userId, @"score":self.sesame.text};
    [ApiManager requestWithTpye:nil path:s1_credit_score_saveZhiMa parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            [self orderSubmit];
        } else {
            [UIView hudWithMessage:BTDKString(@"%@", response[ResponseMessage])];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView hudWithMessage:BTDKString(@"%@", error.domain)];
    }];
    
}

- (void)orderSubmit {
    NSString *userId = [BTDKHandle shareHandle].userId;
    NSDictionary *param = @{@"userId":userId, @"amount":self.moneyNum};
    [ApiManager requestWithTpye:nil path:s1_order_submit parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"successApplyFor" object:nil userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [UIView hudWithMessage:BTDKString(@"%@", response[ResponseMessage])];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView hudWithMessage:BTDKString(@"%@", error.domain)];
    }];
}


@end
