//
//  UnallowedView.m
//  BTDK
//
//  Created by xiaoning on 2018/12/5.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "UnallowedView.h"

@implementation UnallowedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return  self;
}

- (void)configView {
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = BTDKImage(@"bigds");
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(103+TopBarHeight);
        make.size.mas_offset(CGSizeMake(110, 131));
    }];
    
    UILabel *tit = [[UILabel alloc]init];
    tit.text = @"审核未通过";
    tit.font = BTDKFont(20);
    tit.textColor = BTDKHexColor(@"#afafaf");
    [self addSubview:tit];
    [tit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(img.mas_bottom).with.offset(25);
    }];
    
    UILabel *subTit = [[UILabel alloc]init];
    subTit.text = @"抱歉审核未通过，请七天后再来尝试哦~";
    subTit.font = BTDKFont(15);
    subTit.textColor = BTDKHexColor(@"#cecece");
    [self addSubview:subTit];
    [subTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(tit.mas_bottom).with.offset(15);
    }];
    
}

@end
