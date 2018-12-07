//
//  ApplyForView.m
//  BTDK
//
//  Created by xiaoning on 2018/12/5.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "ApplyForView.h"
#import "BTDKSlider.h"

#define Minimum 1000
#define Maximum 5000
#define Interval 100

@interface ApplyForView()

@end

@implementation ApplyForView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView {
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = BTDKHexColor(@"#14a0ff");
    topView.frame = CGRectMake(0, 0, ScreenWidth, StatusBarHeight);
    [self addSubview:topView];

    UIImageView *topImg = [[UIImageView alloc]initWithImage:BTDKImage(@"ellipse")];
    [self addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(@175);
    }];

    UIImageView *cardImg = [[UIImageView alloc]initWithImage:BTDKImage(@"kjje")];
    [self addSubview:cardImg];
    [cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(TopBarHeight+10);
        make.width.mas_offset(ScreenWidth-50);
        make.height.mas_equalTo(cardImg.mas_width).multipliedBy(0.62);
    }];

    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = BTDKFont(50);
    moneyLabel.text = @"5000";
    moneyLabel.textColor = BTDKHexColor(@"#000000");
    self.moneyLabel = moneyLabel;
    [self addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cardImg);
    }];

    UILabel *useMoneyLabel = [[UILabel alloc]init];
    useMoneyLabel.textAlignment = NSTextAlignmentCenter;
    useMoneyLabel.font = BTDKFont(15);
    useMoneyLabel.text = @"可借金额（元）";
    useMoneyLabel.textColor = BTDKHexColor(@"#939393");
    [self addSubview:useMoneyLabel];
    [useMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(moneyLabel);
        make.bottom.equalTo(moneyLabel.mas_top).with.offset(-10);
    }];

    NSMutableAttributedString *describeString = [[NSMutableAttributedString alloc] initWithString:@"期限3个月 服务费率0.05%"];
    [describeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:13.0f] range:NSMakeRange(0, 15)];
    [describeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:147.0f/255.0f green:147.0f/255.0f blue:147.0f/255.0f alpha:1.0f] range:NSMakeRange(0, 15)];
    [describeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:15.0f] range:NSMakeRange(2, 4)];
    [describeString addAttribute:NSForegroundColorAttributeName value:BTDKHexColor(@"#707070") range:NSMakeRange(2, 3)];
    [describeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:15.0f] range:NSMakeRange(10, 5)];
    [describeString addAttribute:NSForegroundColorAttributeName value:BTDKHexColor(@"#707070")  range:NSMakeRange(10, 5)];
    UILabel *describeLabel = [[UILabel alloc]init];
    describeLabel.textAlignment = NSTextAlignmentCenter;
    describeLabel.attributedText = describeString;
    [self addSubview:describeLabel];
    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(moneyLabel);
        make.top.equalTo(moneyLabel.mas_bottom).with.offset(10);
    }];

    UISlider *slider = [[BTDKSlider alloc]init];
    slider.continuous = YES;// 设置可连续变化
    [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    slider.minimumTrackTintColor = BTDKHexColor(@"#bbddff");
    [slider setMinimumValue:Minimum];
    [slider setMaximumValue:Maximum];
    [slider setValue:(Maximum+Minimum)/2];
    [slider addTarget:self action:@selector(sliderChangeAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(cardImg.mas_bottom).with.offset(20);
        make.width.mas_equalTo(ScreenWidth-88);
        make.height.mas_equalTo(@5);
    }];


    UILabel *startLabel = [[UILabel alloc]init];
    startLabel.font = BTDKFont(12);
    startLabel.textColor = BTDKHexColor(@"#939393");
    startLabel.text = @"1000";
    [self addSubview:startLabel];
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slider);
        make.top.equalTo(slider.mas_bottom).with.offset(15);
    }];
    UILabel *endLabel = [[UILabel alloc]init];
    endLabel.font = BTDKFont(12);
    endLabel.textColor = BTDKHexColor(@"#939393");
    endLabel.text = @"5000";
    endLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:endLabel];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(slider);
        make.top.equalTo(slider.mas_bottom).with.offset(15);
    }];
    
//    NSMutableAttributedString *applyForString = [[NSMutableAttributedString alloc] initWithString:@"立 即 申 请"];
//    [applyForString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:18.0f] range:NSMakeRange(0, 7)];
//    [applyForString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] range:NSMakeRange(0, 7)];
    UIButton *applyForBtn = [[UIButton alloc]init];
    [applyForBtn setBackgroundImage:BTDKImage(@"jx") forState:normal];
    applyForBtn.layer.cornerRadius = 4;
    applyForBtn.clipsToBounds = YES;
    applyForBtn.titleLabel.font = BTDKFont(18);
    [applyForBtn setTitle:@"立 即 申 请" forState:normal];
    self.applyForBtn = applyForBtn;
    [self addSubview:applyForBtn];
    [applyForBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(endLabel.mas_bottom).with.offset(40);
        make.width.equalTo(cardImg);
        make.height.mas_offset(@45);
    }];
    
    UIImageView *stepImg = [[UIImageView alloc]initWithImage:BTDKImage(@"steps")];
    [self addSubview:stepImg];
    [stepImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(applyForBtn);
        make.height.mas_equalTo(stepImg.mas_width).multipliedBy(0.28);
        make.top.equalTo(applyForBtn.mas_bottom).with.offset(20);
    }];
}

- (void)sliderChangeAction:(UISlider *)sender {
    self.moneyLabel.text = [NSString stringWithFormat:@"%0.f",sender.value];
}

@end
