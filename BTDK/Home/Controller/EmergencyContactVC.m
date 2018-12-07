//
//  EmergencyContactVC.m
//  BTDK
//
//  Created by xiaoning on 2018/12/5.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "EmergencyContactVC.h"
#import "SesameViewController.h"

@interface EmergencyContactVC ()

Strong UITextField *name;
Strong UITextField *phone;


@end

@implementation EmergencyContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    
    self.navigationItem.title = @"紧急联系人";
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
    
    UIImageView *shieldImg = [[UIImageView alloc]initWithImage:BTDKImage(@"1232")];
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
    
    
    UIImageView *peopleIcon = [[UIImageView alloc]initWithImage:BTDKImage(@"icon5")];
    [self.view addSubview:peopleIcon];
    [peopleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(32);
        make.top.equalTo(topImg.mas_bottom).with.offset(40);
        make.size.mas_offset(CGSizeMake(19, 20));
    }];
    
    UITextField *people = [[UITextField alloc]init];
    people.textAlignment = NSTextAlignmentLeft;
    people.placeholder = @"请填写紧急联系人";
    people.font = BTDKFont(12);
    people.placeholderColor = BTDKHexColor(@"#a6a6a6");
    people.textColor = BTDKHexColor(@"#a6a6a6");
    self.name = people;
    [self.view addSubview:people];
    [people mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleIcon.mas_right).with.offset(16);
        make.right.equalTo(self.view).with.offset(-22);
        make.centerY.equalTo(peopleIcon);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BTDKHexColor(@"#cdcdcd");
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(22);
        make.right.equalTo(self.view).with.offset(-22);
        make.top.equalTo(people.mas_bottom).with.offset(12);
        make.height.mas_offset(@1);
    }];
    
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:BTDKImage(@"icon1")];
    [self.view addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(peopleIcon);
        make.top.equalTo(lineView.mas_bottom).with.offset(36);
        make.size.mas_offset(CGSizeMake(14, 22));
    }];
    
    UITextField *phone = [[UITextField alloc]init];
    phone.textAlignment = NSTextAlignmentLeft;
    phone.placeholder = @"请填写紧急联系人手机号码";
    phone.keyboardType = UIKeyboardTypeNumberPad;
    phone.font = BTDKFont(12);
    phone.placeholderColor = BTDKHexColor(@"#a6a6a6");
    phone.textColor = BTDKHexColor(@"#a6a6a6");
    self.phone = phone;
    [self.view addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(people);
        make.centerY.equalTo(phoneIcon);
        make.width.equalTo(people);
    }];
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = BTDKHexColor(@"#cdcdcd");
    [self.view addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(22);
        make.right.equalTo(self.view).with.offset(-22);
        make.top.equalTo(phoneIcon.mas_bottom).with.offset(12);
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

- (void)nextBtnClick {
    if (NULLString(self.name.text) || self.phone.text.length != 11) {
        [UIView hudWithMessage:@"请正确填写紧急联系人或手机号码"];
        return;
    }
    
    NSString *userId = [BTDKHandle shareHandle].userId;
    NSDictionary *param = @{@"userId":userId, @"type":@"0",@"name":self.name.text,@"phone":self.phone.text};
    [ApiManager requestWithTpye:nil path:s1_contacts_save parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            SesameViewController *vc = [[SesameViewController alloc]init];
            vc.moneyNum = self.moneyNum;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [UIView hudWithMessage:BTDKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView hudWithMessage:BTDKString(@"%@", error.domain)];
    }];
    
    
}

@end
